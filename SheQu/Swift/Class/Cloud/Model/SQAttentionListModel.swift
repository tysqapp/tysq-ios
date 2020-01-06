//
//  SQAttentionListModel.swift
//  SheQu
//
//  Created by iMac on 2019/9/11.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQAttentionListModel: SQBaseModel {
    var account_follower_infos = [SQFanModel]()
    var total_num = 0
}
class SQAttentionListItemModel: SQBaseModel {
    var account_id = 0
    var head_url = ""
    var account_name = ""
    var grade = 0
    var personal_profile = ""
    var collection_num = ""
    var readed_num = 0
    var article_num = 0
}
