//
//  SQLoginNetWorkTool.swift
//  SheQu
//
//  Created by gm on 2019/4/24.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

//验证码用处,注册: register 登陆:login 修改密码:password 绑定邮箱：bindEmail，重置密码：resetPassword
enum EmailPinGetType: String{
    case login         = "login"
    case register      = "register"
    case password      = "password"
    case bindEmail     = "bindEmail"
    case resetPassword = "resetPassword"
    ///用户提币
    case drawCurrency  = "drawCurrency"
}

class SQLoginNetWorkTool: NSObject {
    
    class func login(account: String,
                     password: String,
                     captcha_id: String?,
                     captcha: String?,
                     _ handler: @escaping ((SQAccountModel?,Int32,String?)->())){
        var parameters = [
            "account":account,
            "password":password
        ]
        
        if (captcha_id != nil) {
            parameters["captcha_id"] = captcha_id!
        }
        
        if ((captcha) != nil) {
            parameters["captcha"] = captcha!
        }
        
        NetWorkManager.request(path: k_url_login, parameters: parameters, method: .post, responseClass: SQAccountModel.self,  successHandler: { (baseModel, dataDict) in
            ///保存用户信息
            SQAccountModel.updateAccountModel(baseModel)
            YYWebImageManager_AddCookie.addCookie()
            //AppDelegate.getAppDelegate().downLoadSessionManager.cache.update()
            handler(baseModel,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    class func getCaptcha(_ captcha_type: String = "login",_ handler: @escaping ((SQCaptchaStruct?,Int32,String?)->())){
        let parameters = ["captcha_type": captcha_type]
        NetWorkManager.request(path: k_url_base64_captcha, parameters: parameters, responseClass: SQCaptchaStruct.self, successHandler: { (captch, dataDict) in
            handler(SQCaptchaStruct.deserialize(from: dataDict),0,nil)
        })
    
   }
    
    
    /// 注册账号
    ///
    /// - Parameters:
    ///   - email: 注册邮箱
    ///   - pwd: 注册密码
    ///   - referral_code: 邀请码
    ///   - captcha_id: 服务器生成验证码id
    ///   - captcha: 验证码
    ///   - handler: 回调注册成功
    class func register(email: String,
                        pwd: String,
                        referral_code: String,
                        captcha_id: String,
                        captcha: String,
                        _ handler: @escaping ((SQBaseModel?,Int32,String?)->())){
        var type = 0
        if referral_code.count > 1 {
            type = 1
        }
        let parameters = [
            "password": pwd,
            "email": email,
            "referral_code": referral_code,
            "type": type,
            "captcha_id":captcha_id,
            "captcha":captcha
            ] as [String : Any]
        
        NetWorkManager.request(path: k_url_register, parameters: parameters, method: .post, responseClass: SQBaseModel.self,  successHandler: { (baseModel, dataDict) in
            handler(baseModel,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    
    /// 获取邮箱验证码
    ///
    /// - Parameters:
    ///   - email: 收到验证码到邮箱
    ///   - type: 表示是注册还是登录或者其它 EmailPinGetType
    ///   - handler: 回调回SQCaptchaStruct model
    class func getEmailPinCode(_ email: String,
                               type: EmailPinGetType,
                               _ handler: @escaping ((SQCaptchaStruct?,Int32,String?)->())){
        let parameters = [
            "email": email,
            "type": type.rawValue,
        ]
        
        NetWorkManager.request(path: k_url_email_pin, parameters: parameters, method: .get, responseClass: SQCaptchaStruct.self,  successHandler: { (baseModel, dataDict) in
            handler(SQCaptchaStruct.deserialize(from: dataDict),0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
        
    }
    
    class func resetPassword(password: String?, captcha: String, captcha_id: String, email: String, _ handler: @escaping ((SQAccountModel?,Int32,String?)->())) {
        var parameters = [
            "email": email,
            "captcha": captcha,
            "captcha_id": captcha_id,
        ]
        
        if (password != nil) {
            parameters["new_password"] = password
            parameters["repeat_password"] = password
        }
        
        NetWorkManager.request(path: k_url_reset_pwd, parameters: parameters, method: .put, responseClass: SQAccountModel.self,  successHandler: { (baseModel, dataDict) in
            handler(baseModel,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    class func verifyEmail(email: String, captcha: String, captcha_id: String, _ handler: @escaping ((SQBaseModel?,Int32,String?)->())){
        
        let parameters = [
            "email": email,
            "captcha": captcha,
            "captcha_id": captcha_id
        ]
        
        NetWorkManager.request(path: k_url_email_verify, parameters: parameters, method: .get, responseClass: SQBaseModel.self,  successHandler: { (baseModel, dataDict) in
            handler(baseModel,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    class func verifyEmailByPut(email: String, captcha: String, captcha_id: String, _ handler: @escaping ((SQBaseModel?,Int32,String?)->())){
        
        let parameters = [
            "email": email,
            "captcha": captcha,
            "captcha_id": captcha_id
        ]
        
        NetWorkManager.request(path: k_url_email_bind, parameters: parameters, method: .put, responseClass: SQBaseModel.self,  successHandler: { (baseModel, dataDict) in
            handler(baseModel,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
}
