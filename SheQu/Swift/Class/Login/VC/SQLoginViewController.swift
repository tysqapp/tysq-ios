//
//  SQLoginViewController.swift
//  SheQu
//
//  Created by gm on 2019/4/22.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
import SnapKit
var login_emailText = ""
class SQLoginViewController: SQViewController {
    
    @discardableResult
    static func jumpLoginVC(vc: UIViewController?, state: Int32, handel:((Bool) ->())?) -> Bool{
        if state == 2999 || state == 2998 {
            let loginNav = SQLoginViewController.getLoginVC()
            let loginVC: SQLoginViewController  = loginNav.viewControllers.first as! SQLoginViewController
            loginVC.loginCallBack = handel
            loginVC.modalPresentationStyle = .fullScreen
            vc?.present(loginNav, animated: true, completion: nil)
            
            return true
        }
        
        return false
    }
    
    static func getLoginVC() -> UINavigationController{
        let loginSB  = UIStoryboard.init(name: "LoginStoryboard", bundle: Bundle.main)
        let loginNav = loginSB.instantiateInitialViewController()
        loginNav?.modalPresentationStyle = .fullScreen
        return loginNav as! UINavigationController
    }
    
    var loginCallBack: ((Bool) -> ())?
    //验证码
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var pwdTF: SQTextField!
    @IBOutlet weak var vfTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginBtnTop: NSLayoutConstraint!
    private  var pinImageView: UIImageView!
    private  var captcha_id: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        addLeftNav()
    }
    
    ///添加左边nav按钮
    func addLeftNav(){
        let btn = UIButton.init()
        btn.frame = CGRect.init(x: 20, y: k_status_bar_height + 10, width: 30, height: 30)
        btn.setImage(UIImage.init(named: "home_ac_close_sel"), for: .normal)
        btn.setTitleColor(k_color_black, for: .normal)
        btn.imageView?.contentMode = .left
        btn.addTarget(self, action: #selector(closeNav), for: .touchUpInside)
        view.addSubview(btn)
    }
    
    @objc func closeNav() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func loginBtnClick(_ sender: Any) {
        
        
        
        let vfEmail = SQLoginTool.validationEmail(emailTF.text!)
        if  !vfEmail.0{
            return
        }
        
        
        
        let vfPWD = SQLoginTool.validationPassword(pwdTF.text!)
        if  !vfPWD.0{
            return
        }
        
        var captcha = vfTF.text
        if !vfTF.isHidden {
            let vfPIN = SQLoginTool.validationPIN(vfTF.text!)
            if  !vfPIN.0{
                return
            }
        }else{
            captcha = nil
            captcha_id = nil
        }
        
        if (captcha != nil) {
            if (captcha_id == nil) {
                showToastMessage("请通过点击刷新获取验证码")
                return
            }
        }
        
        //showLoading()
        ///校验完三者格式之后,开始登录逻辑
        weak var weakSelf = self
        SQLoginNetWorkTool.login(account: emailTF.text!, password: pwdTF.text!, captcha_id: captcha_id, captcha: captcha) { (model, statu, errorMessage) in
            if errorMessage != nil {
                //需要添加验证码功能
                if statu == 2996 || statu == 2997 {
                    weakSelf!.loginBtnTop.constant = 80
                    weakSelf?.vfTF.isHidden = false
                    weakSelf?.getPinCodeImage()
                    UIView.animate(withDuration: 0.2, animations: {
                       weakSelf?.view.layoutIfNeeded()
                    })
                }
                //weakSelf!.showToastMessage("errorMessage")
                return
            }
            
            weakSelf?.dismiss(animated: true, completion: nil)
        }
    }
    
    /// 验证是否可以点击登录按钮
    override func tfChanged(tf: UITextField) {
        login_emailText = emailTF.text ?? ""
        let vfEmail: Bool = emailTF.text!.count  > 0
        let vfPW: Bool    = pwdTF.text!.count    > 0
        var vfPIN: Bool   = vfTF.text!.count     > 0
        if  vfTF.isHidden {
            vfPIN = true
        }
        
        let isVF          = vfEmail && vfPW && vfPIN
        
        if  loginBtn.isEnabled == isVF {
            return
        }
        
        loginBtn.isEnabled = isVF
        loginBtn.updateBGColor()
    }
    
    deinit {
        if (loginCallBack != nil) {
            let loginStr  = UserDefaults.standard.value(forKey: k_ud_user) as? String
            if (loginStr != nil) {
                loginCallBack!(true)
            }else{
                loginCallBack!(false)
            }
        }
    }
}

//MARK: -----------添加登录开关和登录逻辑--------------
extension SQLoginViewController {
    
    func initSubViews(){
        addChangeTarget(emailTF)
        addChangeTarget(pwdTF)
        addChangeTarget(vfTF)
        loginBtnTop.constant = 10
        vfTF.isHidden = true
        loginBtn.layer.cornerRadius  = 6
        loginBtn.layer.masksToBounds = true
        
        //获取密码显示图效果
        pwdTF.addRightSecretBtn()
        //添加验证码和刷新按钮
        addPINView()
    }
    
}


//MARK: -----------添加验证码逻辑--------------
extension SQLoginViewController {
    func addPINView(){
        let rightView = UIView()
        
        pinImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 10, width: 80, height: 30))
        rightView.addSubview(pinImageView)
        
        let refreshBtnX    = pinImageView.frame.maxX
        let refreshBtn     = UIButton.init(frame: CGRect.init(x: refreshBtnX, y: 0, width: 30, height: 50))
        refreshBtn.setImage(UIImage.init(named: "login_refresh"), for: .normal)
        refreshBtn.addTarget(self, action: #selector(refreshPinCodeBtnClick), for: .touchUpInside)
        rightView.addSubview(refreshBtn)
        
        rightView.frame.size = CGSize.init(width: 110, height: 50)
        
        vfTF.rightView     = rightView
        vfTF.rightViewMode = .always
        
    }
    
    @objc func refreshPinCodeBtnClick() {
        getPinCodeImage()
    }
    
    
    func getPinCodeImage(){
        weak var weakSelf = self
        //showLoading()
        SQLoginNetWorkTool.getCaptcha { (captcha,statu,errorMessage) in
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
