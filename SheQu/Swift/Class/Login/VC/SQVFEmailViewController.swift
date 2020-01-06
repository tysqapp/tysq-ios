//
//  SQVFEmailViewController.swift
//  SheQu
//
//  Created by gm on 2019/7/11.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQVFEmailViewController: SQViewController {

    @IBOutlet weak var sureBtn: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var vfEmailTF: SQLoginTextField!
    var callBack: ((Bool) -> ())?
    lazy var gcdTimer    = SQGCDTimer() //gcd定时器，处理验证码时间
    /// 获取短信时需要用到的id
    var captcha_id: String = ""
    var getVerificationCodeBtn:UIButton!
    var isTheTiming:Bool = false
    var email: String!
    lazy var isRegister  = false
    
    static func getVFEmailViewController(_ email: String,_ isRegister: Bool,_ handel: ((Bool) -> ())?) -> SQVFEmailViewController {
        let loginSB  = UIStoryboard.init(name: "LoginStoryboard", bundle: Bundle.main)
        let vc: SQVFEmailViewController = loginSB.instantiateViewController(withIdentifier: "vfEmailVC") as! SQVFEmailViewController
        vc.email      = email
        vc.isRegister = isRegister
        vc.callBack   = handel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
        if isRegister {
           addNavBtnByView()
        }else{
           addNavBtn()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isRegister {
           navigationController?.interactivePopGestureRecognizer?.delegate = self
        }
    }
    
    func initSubView() {
        emailLabel.text = email
        
        
        
        sureBtn.isEnabled = false
        sureBtn.layer.cornerRadius  = k_corner_radiu
        sureBtn.layer.masksToBounds = true
        
        addChangeTarget(vfEmailTF)
        getVerificationCodeBtn = UIButton()
        getVerificationCodeBtn.setTitle("发送验证码", for: .normal)
        getVerificationCodeBtn.setTitleColor(k_color_normal_blue, for: .normal)
        getVerificationCodeBtn.titleLabel?.font = k_font_title
        getVerificationCodeBtn.addTarget(self, action: #selector(getVerificationCodeBtnClick), for: .touchUpInside)
        getVerificationCodeBtn.frame = CGRect.init(x: 0, y: 0, width: 80, height: 50)
        let rightV = UIView(frame: CGRect.init(x: 0, y: 0, width: 80, height: 50))
        rightV.addSubview(getVerificationCodeBtn)
        vfEmailTF.rightViewMode = .always
        vfEmailTF.rightView     = rightV
    }
    
    override func tfChanged(tf: UITextField) {
        let isVF = vfEmailTF.text!.count > 0
        if isVF == sureBtn.isEnabled {
            return
        }
        
        sureBtn.isEnabled = isVF
        sureBtn.updateBGColor()
    }
    
    override func navPop() {
        if isRegister {
            dismiss(animated: true, completion: nil)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func getVerificationCodeBtnClick() {
        
        if isTheTiming {
            return
        }
        
        isTheTiming = true
        weak var weakSelf = self
        SQLoginNetWorkTool.getEmailPinCode(emailLabel.text!, type: .bindEmail) { (model, statu, errormessage) in
            if model == nil {
                weakSelf!.isTheTiming = false
                return
            }
            
            weakSelf?.captcha_id = model!.captcha_id
            weakSelf?.getVerificationCodeSuccess()
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
    
    @IBAction func submitBtnClick(_ sender: Any) {
        if captcha_id.count < 1 {
            return
        }
        
        weak var weakSelf = self
        SQLoginNetWorkTool.verifyEmailByPut(
        email: emailLabel.text!,
        captcha: vfEmailTF.text!,
        captcha_id: captcha_id) { (model, statu, errorMessage) in
            if (errorMessage != nil) {
                return
            }
            
            ///邮箱绑定成功后 更新邮箱的绑定状态
            let model = SQAccountModel.getAccountModel()
            model.email_status = 1
            SQAccountModel.updateAccountModel(model)
            if ((weakSelf?.callBack) != nil) {
                weakSelf!.callBack!(true)
            }
            
            weakSelf?.navPop()
        }
    }
    
    
    deinit {
        gcdTimer.stopTimer()
    }
}
