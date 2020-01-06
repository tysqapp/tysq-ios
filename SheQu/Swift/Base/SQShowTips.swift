//
//  SQShowTips.swift
//  SheQu
//
//  Created by gm on 2019/4/25.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQShowTips: UIView {

    //活动指示器
    var activity:UIActivityIndicatorView!
    //添加一个透明的View
    var activityView:UIView!
    
    var durationF:Double = 0.0
    
    
    //MARK: - 网络提示
    func initWithIndicatorWithView(view:UIView, withText:String){
        
        activityView = UIView(frame:CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.height))
        activityView.backgroundColor = UIColor.clear
        
        
        //配置
        self.frame = CGRect(x:(view.bounds.size.width/2 - 120/2), y:view.bounds.size.height/2 - 90/2, width:120,height:90)
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8
        self.alpha = 0
        
        
        //配置
        activity = UIActivityIndicatorView(style: .whiteLarge)
        activity.center = CGPoint(x:60, y: 30)
        activityView.addSubview(activity)
        self.addSubview(activity)
        
        
        //UILabel
        let label = UILabel(frame:CGRect(x:0, y:50, width:120,height:30))
        label.text = withText
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = UIColor.white
        self.addSubview(label)
        
        
        activityView.addSubview(self)
        view.addSubview(activityView)
        activityView.isHidden = true
    }
    
    //显示菊花
    func startTheView(){
        activityView.alpha    = 0.7
        activityView.isHidden = false
        activity.startAnimating()
        
        weak var weakSelf = self
        
        UIView.animate(withDuration: 0.3) {
            
            weakSelf?.alpha = 1
        }
    }
    
    
    //隐藏菊花
    func stopAndRemoveFromSuperView(){
        activityView.isHidden = true
        activity.stopAnimating()
        
        weak var weakSelf = self
        
        UIView.animate(withDuration: 0.3, animations: {
            
            weakSelf?.alpha = 0
            
        }) { (finish) in
            
            weakSelf?.activityView.isHidden = true
            weakSelf?.removeFromSuperview()
            
        }
        
        
    }
    
    
    
    //MARK: - 普通提示
    func initWithView(keywindowView: UIView, text: String ,duration: Double, canClick: Bool){
        if !canClick {
            activityView = UIView(frame:CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.height))
            activityView.backgroundColor = UIColor.clear
            activityView.isUserInteractionEnabled = true
            self.addSubview(activityView)
        }
        
        TiercelLog(text)
        
        durationF = duration
        
        //适配高度
        let size:CGRect =  text.boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width - 60, height: 400), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.attachment: UIFont.systemFont(ofSize: 13)] , context: nil);
        
        //配置
        self.frame = CGRect(x:(keywindowView.bounds.size.width/2 - (size.width + 50)/2), y:keywindowView.bounds.size.height/2 - 50/2, width:size.width + 50,height:50)
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        //self.layer.masksToBounds = true
        self.layer.cornerRadius = 8
        self.alpha = 0
        
        
        //UILabel
        let label = UILabel(frame:CGRect(x:0, y:0, width:self.frame.size.width,height:50))
        label.text = text
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.textColor = UIColor.white
        
        
        self.addSubview(label)
        keywindowView.addSubview(self)
        
        weak var weakSelf = self
        
        UIView.animate(withDuration: 0.3, animations: {
            
            weakSelf?.alpha = 1
            
        }) { (finish) in
            if ((weakSelf?.activityView) != nil) {
                weakSelf?.activityView.removeFromSuperview()
            }
            weakSelf?.perform(#selector(weakSelf?.closeCust), with: nil, afterDelay: (weakSelf?.durationF)!)
            
        }
        
        
    }
    
    //关闭
    @objc func closeCust(){
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.alpha = 0
            
        }) { (finished:Bool) in
            
            self.removeFromSuperview()
        }
    }
    
    deinit {
        
    }

}
