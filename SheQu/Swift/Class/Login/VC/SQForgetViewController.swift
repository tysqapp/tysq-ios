//
//  SQForgetViewController.swift
//  SheQu
//
//  Created by gm on 2019/4/22.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQForgetViewController: SQViewController {

    @IBOutlet weak var emailTF: SQLoginTextField!
    @IBOutlet weak var pinTF: SQLoginTextField!
    @IBOutlet weak var nextStepBtn: UIButton!
    lazy var gcdTimer    = SQGCDTimer() //gcd定时器，处理验证码时间
    var getVerificationCodeBtn: UIButton!
    var isTheTiming = false
    var captcha_id: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
        addNavBtnByView()
        emailTF.text = login_emailText
    }
    
    @objc override func tfChanged(tf: UITextField){
        vfCanClickBtn()
    }
    
    func vfCanClickBtn() {
        let vfEmailTF =  emailTF.text!.count > 0
        let vfPinTF   =  pinTF.text!.count > 0
        let isVF      =  vfPinTF && vfEmailTF
        
        if nextStepBtn.isEnabled == isVF {
            return
        }
        
        nextStepBtn.isEnabled = isVF
        nextStepBtn.updateBGColor()
    }
    
    func initSubView() {
        addChangeTarget(emailTF)
        addChangeTarget(pinTF)
        nextStepBtn.layer.cornerRadius  = k_corner_radiu
        nextStepBtn.layer.masksToBounds = true
        
        getVerificationCodeBtn = UIButton()
        getVerificationCodeBtn.setTitle("发送验证码", for: .normal)
        getVerificationCodeBtn.setTitleColor(k_color_normal_blue, for: .normal)
        getVerificationCodeBtn.titleLabel?.font = k_font_title
        getVerificationCodeBtn.addTarget(self, action: #selector(getVerificationCodeBtnClick), for: .touchUpInside)
        getVerificationCodeBtn.frame = CGRect.init(x: 0, y: 0, width: 80, height: 50)
        let rightV = UIView(frame: CGRect.init(x: 0, y: 0, width: 80, height: 50))
        rightV.addSubview(getVerificationCodeBtn)
        
        pinTF.rightViewMode = .always
        pinTF.rightView     = rightV
    }
    
    ///获取邮箱验证码
    @objc func getVerificationCodeBtnClick(){
        let vfEmail = SQLoginTool.validationEmail(emailTF.text!)
        if !vfEmail.0 {
            TiercelLog(vfEmail.1)
            return
        }
        
        if isTheTiming {
            return
        }
        
        isTheTiming = true
        weak var weakSelf = self
        SQLoginNetWorkTool.getEmailPinCode(emailTF.text!, type: .resetPassword) { (model, statu, errorMessage) in
            if model == nil {
                weakSelf!.isTheTiming = false
                TiercelLog(errorMessage)
                return
            }
            
            weakSelf!.captcha_id = model!.captcha_id
            weakSelf!.getVerificationCodeSuccess()
        }
    }
    
    @IBAction func nextBtnClick() {
        let vfEmail = SQLoginTool.validationEmail(emailTF.text!)
        if  !vfEmail.0 {
            TiercelLog(vfEmail.1)
            return
        }
        
        let vfPIN = SQLoginTool.validationPIN(pinTF.text!)
        if  !vfPIN.0{
            TiercelLog(vfPIN.1)
            return
        }
        
        if captcha_id.count < 1 {
            TiercelLog("请通过邮箱获取验证码")
            showToastMessage("请通过邮箱获取验证码")
            return
        }
        
        weak var weakSelf = self
        SQLoginNetWorkTool.verifyEmail(email: emailTF.text!, captcha: pinTF.text!, captcha_id: captcha_id) { (model, statu, errorMessage) in
            if errorMessage != nil {
                TiercelLog(errorMessage)
                return
            }
            
            let loginSB = UIStoryboard.init(name: "LoginStoryboard", bundle: Bundle.main)
            let vc: SQResetPWDViewController = loginSB.instantiateViewController(withIdentifier: "resetPWDID") as! SQResetPWDViewController
            vc.captcha = weakSelf!.pinTF.text!
            vc.captcha_id = weakSelf!.captcha_id
            vc.emai       = weakSelf!.emailTF.text!
            weakSelf?.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    func getVerificationCodeSuccess() {
        isTheTiming  = true
        weak var weakSelf = self
        gcdTimer.startTimer(1.0, 60) { (count) in
            if(count == 0){//当时间为零时1
                weakSelf?.isTheTiming = false
                weakSelf?.getVerificationCodeBtn.setTitle("发送验证码", for: .normal)
            }else{
                weakSelf?.getVerificationCodeBtn.setTitle(String.init(format: "%d 秒", count), for: .normal)
            }
        }
        
    }
    
}
