//
//  SQLoginTool.swift
//  SheQu
//
//  Created by gm on 2019/4/23.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

struct SQLoginTool {
    
    static func validationPassword(_ pwd: String) -> (Bool, String){
        if pwd.count < 6 {
            SQToastTool.showToastMessage("最低不少于6位")
            return (false,"最低不少于6位")
        }
        return (true,"密码正确")
//        if pwd.count > 20 {
//            SQToastTool.showToastMessage("最多不超过")
//            return (false,"最多不超过20位")
//        }
//
//        let password = "^[A-Za-z0-9]+$"
//        let regexPassword = NSPredicate(format: "SELF MATCHES %@",password)
//        if regexPassword.evaluate(with: pwd) == true {
//            //SQToastTool.showToastMessage("密码正确")
//            return (true,"密码正确")
//        }else{
//            SQToastTool.showToastMessage("密码只能是字母和数字")
//            return (false,"密码只能是字母和数字")
//        }
    }
    
    static func validationEmail(_ email: String) -> (Bool, String){
        let eamil = "^([a-zA-Z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let regexeamil = NSPredicate(format: "SELF MATCHES %@",eamil)
        if regexeamil.evaluate(with: email) == true {
            return (true,"邮箱正确")
        }else
        {
            SQToastTool.showToastMessage("请输入正确的邮箱")
            return (false,"请输入正确的邮箱")
        }
    }
    
    static func validationPIN(_ PIN: String) -> (Bool, String){
        if PIN.count > 0 {
            return (true, "验证码正确")
        }else {
            SQToastTool.showToastMessage("请输入验证码")
            return (false, "请输入验证码")
        }
    }
}
