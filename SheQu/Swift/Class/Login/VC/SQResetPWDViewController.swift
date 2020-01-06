//
//  SQResetPWDViewController.swift
//  SheQu
//
//  Created by gm on 2019/4/23.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQResetPWDViewController: SQViewController {

    @IBOutlet weak var sureBtn: UIButton!
    @IBOutlet weak var VFPWDTF: SQLoginTextField!
    @IBOutlet weak var newPWDTF: SQLoginTextField!
    @IBOutlet weak var emailLabel: UILabel!
    var captcha = ""
    var captcha_id = ""
    var emai       = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
        addNavBtnByView()
        emailLabel.text = emai
    }
    
    @IBAction func sureBtnClick() {
        let vfPWD = SQLoginTool.validationPassword(newPWDTF.text!)
        let vfRepeatPWD = SQLoginTool.validationPassword(VFPWDTF.text!)
        
        if !vfPWD.0 {
            TiercelLog(vfPWD.1)
            return
        }
        
        if !vfRepeatPWD.0 {
            TiercelLog(vfRepeatPWD.1)
            return
        }
        
        if newPWDTF.text! != VFPWDTF.text! {
            TiercelLog("密码不一致")
            showToastMessage("密码不一致")
            return
        }
        
        weak var weakSelf = self
        SQLoginNetWorkTool.resetPassword(password: newPWDTF.text!, captcha: captcha, captcha_id: captcha_id, email: emai) { (account, statu, errorMessage) in
            if account == nil {
                TiercelLog("修改密码失败")
                return
            }
            
            weakSelf?.showToastMessage("修改密码成功")
            //两秒钟后返回登录界面
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 2), execute: {
                weakSelf?.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
    
    @objc override func tfChanged(tf: UITextField){
        vfCanClickBtn()
    }
    
    func vfCanClickBtn() {
        let vfNewPWDTF =  newPWDTF.text!.count > 0
        let vfVFPWDTF  =  VFPWDTF.text!.count > 0
        let isVF       =  vfNewPWDTF && vfVFPWDTF
        
        if sureBtn.isEnabled == isVF {
            return
        }
        
        sureBtn.isEnabled = isVF
        sureBtn.updateBGColor()
    }
    
    func initSubView() {
        addChangeTarget(VFPWDTF)
        addChangeTarget(newPWDTF)
        VFPWDTF.addRightSecretBtn()
        newPWDTF.addRightSecretBtn()
    }
}
