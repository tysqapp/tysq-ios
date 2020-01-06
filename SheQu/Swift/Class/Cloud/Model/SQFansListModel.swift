//
//  SQFansListModel.swift
//  SheQu
//
//  Created by iMac on 2019/9/10.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit


class SQFansListModel: SQBaseModel {
    var account_follower_infos = [SQFanModel]()
    var total_num = 0
}

class SQFanModel: SQBaseModel {
    var account_id = 0
    var head_url = ""
    var account_name = ""
    var grade = 0
    var personal_profile = ""
    var collected_num = 0
    var readed_num = 0
    var article_num = 0
    var is_follow = false
}
