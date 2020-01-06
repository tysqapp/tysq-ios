//
//  SQAccountModel.swift
//  SheQu
//
//  Created by gm on 2019/4/24.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
enum SexType: Int8 {
    case defalut = 0
    case mal     = 1
    case femal   = 2
}

class SQAccountModel: SQBaseModel {
    var account_id: Int = -1
    var account: String = ""
    var sex: SexType = .defalut
    var age: UInt32  = 0
    var icon_id: Int = 0
    ///版主
    var is_moderator     = false
    var nickname: String = ""
    var email: String    = ""
    var phone: String    = ""
    var head_url: String    = ""
    
    /// 签名
    var signature: String    = ""

    /// 个人信息
    var personal_profile: String    = ""
    
    /// 公司
    var trade: String    = ""
    
    /// 学校
    var education_institution: String    = ""
    
    ///教育等级
    var education: String    = ""
    
    /// 家庭地址
    var home_address: String    = ""
    var email_status: Int       = 0
    
    /// 职业
    var career: String = ""
    
    /// 被收藏数
    var collected_num = 0
    
    /// 被阅读数
    var readed_num = 0
    
    /// 是否关注
    var is_follow = false
    
    var asset = SQAccountScore()
    static func getAccountModel() -> SQAccountModel {
        guard let userStr: String = UserDefaults.standard.value(forKey: k_ud_user) as? String else {
            return SQAccountModel()
        }
        
        return SQAccountModel.deserialize(from: userStr)!
    }
    
    static func updateAccountModel(_ accountModel: SQAccountModel?) {
        let accountStr = accountModel?.toJSONString()
        UserDefaults.standard.setValue(accountStr, forKey: k_ud_user)
        UserDefaults.standard.synchronize()
    }
    
    static func clearLoginCache() {
        SQAccountModel.updateAccountModel(nil)
        ///删除登录cookies
        let cookies = HTTPCookieStorage.shared.cookies
        if (cookies != nil) {
            for cookie in cookies! {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    
    static func getAccountAndHostValue() -> String{
        return ("\(SQAccountModel.getAccountModel().account_id)" + SQHostStruct.getLoaclHost()).toMD5String()
    }
}

class SQAccountScore: SQBaseModel {
    var score = 0
    var hot_coin = 0
    var grade    = 1
    var invited  = 0
    var article_num = 0
    var comment_num = 0
    var collect_num = 0
    var fan_num = 0
    var attention_num = 0
}
