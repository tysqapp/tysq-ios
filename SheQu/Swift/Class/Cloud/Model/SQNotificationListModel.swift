//
//  SQNotificationListModel.swift
//  SheQu
//
//  Created by iMac on 2019/9/10.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQNotificationListModel: SQBaseModel {
    //通知列表
    var notify_info = [SQNotificationListItemModel]()
    
    var total_number = 0
}


class SQNotificationListItemModel: SQBaseModel {
    var remind_type = ""
    var content     = ""
    var article_id  = ""
    var report_id = ""
    var notify_id = ""
    var title       = ""
    var sender = 0
    var time:Int64        = 0
    var sender_name = ""
    var avatar_url  = ""
    var action = ""
    var is_read     = false
    var report_number = ""
}
