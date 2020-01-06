//
//  SQHomeSearchLIstModel.swift
//  SheQu
//
//  Created by iMac on 2019/10/18.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQHomeSearchListModel: SQBaseModel {
    var type = ""
    var keyword = ""
    var articles = [SQHomeInfoDetailItemModle]()
    var users = [SQBriefUserInfo]()
    var count = 0
    
    
}

///用户简要信息实体
class SQBriefUserInfo: SQBaseModel {
    var id = 0
    var name = ""
    var grade = 0
    var head_url = ""
    var personal_profile = ""
    var trade = ""
    var career = ""
    var home_address = ""
    
}


