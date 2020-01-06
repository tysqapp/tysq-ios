//
//  UITextField+Extension.swift
//  SheQu
//
//  Created by gm on 2019/4/23.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

extension SQTextField {
    
    static let noti_secret  = "noti_secret"
    static let ud_tf_secret = "ud_tf_secret"
    
    func addRightSecretBtn(_ isNeedNotiSecret: Bool = true) {
      self.isNeedNotiSecret = isNeedNotiSecret
      let btn = UIButton()
      btn.setImage(UIImage.init(named: "login_can_see"), for: .normal)
      btn.setImage(UIImage.init(named: "login_un_see"), for: .selected)
      btn.frame.size = CGSize.init(width: 33, height: 25)
      btn.addTarget(self,
                      action: #selector(secretBtnClick(btn:)),
                      for: .touchUpInside)
      rightViewMode = .always
      let rightV = UIView(frame: CGRect.init(x: 0, y: 0, width: 33, height: 25))
      rightV.addSubview(btn)
      rightView     = rightV
      
      if !isNeedNotiSecret {
        isSecureTextEntry = true
        btn.isSelected    = true
        return
      }
      
      let isSecure  = UserDefaults.standard.bool(forKey: SQTextField.ud_tf_secret)
      isSecureTextEntry = !isSecure
      btn.isSelected    = !isSecure
      //添加右边秘密点击按钮的监听
      let notiName  = Notification.Name.init(rawValue: SQTextField.noti_secret)
      NotificationCenter.default.addObserver(
            self,
            selector: #selector(reciveSecretNoti(noti:)),
            name: notiName,
            object: nil)
    }
    
    
    
    /// 接受到修改通知
    ///
    /// - Parameter noti: (objc: Bool)
    @objc func reciveSecretNoti(noti: NSNotification) {
        let obj: [String: Bool] = noti.object as! [String : Bool]
        let isSecure: Bool      = obj["isSelected"]!
        let btn: UIButton       = rightView?.subviews.first as! UIButton
        if  btn.isSelected == isSecure {
            return
        }
        
        UserDefaults.standard.set(!isSecure, forKey: SQTextField.ud_tf_secret)
        UserDefaults.standard.synchronize()
        btn.isSelected     = isSecure
        isSecureTextEntry  = btn.isSelected
        
    }
    
    @objc func secretBtnClick(btn: UIButton) {
        
        if !isNeedNotiSecret {
            btn.isSelected     = !btn.isSelected
            isSecureTextEntry  = btn.isSelected
            return
        }
        ///发出秘密的通知
        let notiName  = Notification.Name.init(rawValue: SQTextField.noti_secret)
        let obj = [
            "isSelected": !btn.isSelected
        ]
        
        NotificationCenter.default.post(name: notiName, object: obj)
    }
    
   
}
