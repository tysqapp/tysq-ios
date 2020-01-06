//
//  SQRegisteViewController.swift
//  SheQu
//
//  Created by gm on 2019/4/23.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQRegisteViewController: SQViewController {

    @IBOutlet weak var pinTF: SQLoginTextField!
    @IBOutlet weak var pwdTF: SQLoginTextField!
    @IBOutlet weak var emailTF: SQLoginTextField!
    @IBOutlet weak var captchaTF: SQLoginTextField!
    
    /// 已读按钮
    @IBOutlet weak var chooseBtn: UIButton!
    ///注册按钮
    @IBOutlet weak var rigsterBtn: UIButton!
    private  var pinImageView: UIImageView!
    private  var captcha_id: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
        addNavBtnByView()
        getPinCodeImage()
    }
    
    func initSubView() {
        addChangeTarget(pwdTF)
        addChangeTarget(emailTF)
        addChangeTarget(pinTF)
        addChangeTarget(captchaTF)
        pwdTF.addRightSecretBtn()
        rigsterBtn.isEnabled = false
        rigsterBtn.layer.cornerRadius  = k_corner_radiu
        rigsterBtn.layer.masksToBounds = true
        chooseBtn.setImage(UIImage.init(named: "login_un_sel"), for: .normal)
        chooseBtn.setImage(UIImage.init(named: "login_sel"), for: .selected)
        addPINView()
    }
    
    func addPINView(){
        let rightView = UIView()
        
        pinImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 10, width: 80, height: 30))
        rightView.addSubview(pinImageView)
        
        let refreshBtnX    = pinImageView.frame.maxX
        let refreshBtn     = UIButton.init(frame: CGRect.init(x: refreshBtnX, y: 0, width: 30, height: 50))
        refreshBtn.setImage(UIImage.init(named: "login_refresh"), for: .normal)
        refreshBtn.addTarget(self, action: #selector(refreshPinCodeBtnClick), for: .touchUpInside)
        rightView.addSubview(refreshBtn)
        
        rightView.frame.size    = CGSize.init(width: 110, height: 50)
        captchaTF.rightView     = rightView
        captchaTF.rightViewMode = .always
        
    }
    override func tfChanged(tf: UITextField) {
        let vfEmail = emailTF.text!.count > 0
        let vfPWD   = pwdTF.text!.count > 0
        let vfCaptchaTF = captchaTF.text!.count > 0
        
        let isVF = vfEmail && vfPWD && vfCaptchaTF
        
        if isVF == rigsterBtn.isEnabled {
            return
        }
        
        rigsterBtn.isEnabled = isVF
        rigsterBtn.updateBGColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.navigationBar.isHidden = true
    }
    
    ///已读按钮点击
    @IBAction func readBtnClick() {
        chooseBtn.isSelected = !chooseBtn.isSelected
    }
    
    ///注册信息按钮点击
    @IBAction func submitBtnClick() {
        let vfEmail = SQLoginTool.validationEmail(emailTF.text!)
       let vfPWD   = SQLoginTool.validationPassword(pwdTF.text!)
       

       
        if !vfPWD.0 {
            TiercelLog(vfPWD.1)
            return
        }
        
        if !vfEmail.0 {
            TiercelLog(vfEmail.1)
            return
        }
        
        if !chooseBtn.isSelected {
            showToastMessage("请勾选用户注册协议")
            TiercelLog("请选择按钮")
            return
        }
        
        if captcha_id?.count ?? 0 < 1 {
            showToastMessage("请通过邮箱获取验证码")
            return
        }
        
        
        weak var weakSelf = self
        SQLoginNetWorkTool.register(email: emailTF.text!,
                                    pwd: pwdTF.text!,
                                    referral_code: pinTF.text!, captcha_id: captcha_id!, captcha: captchaTF.text!
                                    ) { (model, statu, errorMessage) in
            if errorMessage != nil {
                TiercelLog(errorMessage)
                return
            }
            
            //注册成功后，请求登录接口 直接登录
            weakSelf?.login()
            ///注册成功进首页
            TiercelLog("register success 注册成功进首页")
        }
    }
    
    func login(){
        weak var weakSelf = self
        SQLoginNetWorkTool.login(account: emailTF.text!, password: pwdTF.text!, captcha_id: nil, captcha: nil) { (model, statu, errorMessage) in
            if errorMessage != nil {
                return
            }
            weakSelf?.showVCAlertView()
        }
    }
    
    ///显示验证邮箱积分的界面
    func showVCAlertView() {
        weak var weakSelf  = self
        let alertView = UIAlertController.init(title: "注册成功", message: "验证邮箱可获得500积分哦!", preferredStyle: .alert)
        let jumpAction = UIAlertAction.init(title: "跳过", style: .default, handler: { (action) in
            weakSelf?.dismiss(animated: true, completion: nil)
        })
        jumpAction.setValue(k_color_title_gray_blue, forKey: "titleTextColor")
        
        let emailAction = UIAlertAction.init(title: "去验证", style: .default, handler: { (action) in
            let vc  = SQVFEmailViewController.getVFEmailViewController(
                weakSelf!.emailTF.text!,
                true,
                nil)
            
            weakSelf?.navigationController?.pushViewController(
                vc,
                animated: true
            )
        })
        
        alertView.addAction(jumpAction)
        alertView.addAction(emailAction)
        present(alertView, animated: true, completion: nil)
    }
    
    ///跳到登录界面
    @IBAction func goLoginInterface() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func refreshPinCodeBtnClick() {
        getPinCodeImage()
    }
    
    func getPinCodeImage(){
        weak var weakSelf = self
        //showLoading()
        SQLoginNetWorkTool.getCaptcha("register") { (captcha,statu,errorMessage) in
            if (captcha != nil) {
                let imageStr =  captcha!.captcha_base64.replacingOccurrences(of: "data:image/png;base64,", with: "")
                guard let imageData = Data(base64Encoded: imageStr, options: .ignoreUnknownCharacters) else {
                    return
                }
                
                weakSelf!.captcha_id = captcha?.captcha_id
                weakSelf!.pinImageView.image = UIImage.init(data: imageData)
            }
        }
    }
}







extension SQRegisteViewController {
    //MARK: ----------这里是预留的读取协议按钮 --------------
    @IBAction func readSheQuMessageBtnClick() {
        let vc = SQWebViewController()
        vc.urlPath = WebViewPath.agreement
        vc.isReadSheQuMessage = true
        let nav = UINavigationController.init(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}
