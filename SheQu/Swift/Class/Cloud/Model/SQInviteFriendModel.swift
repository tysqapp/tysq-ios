//
//  SQInviteFriendModel.swift
//  SheQu
//
//  Created by gm on 2019/7/18.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQInviteFriendModel: SQBaseModel {
    var referral_code = ""
    var referral_link = ""
    var domain_name   = ""
    var score_number  = 0
    var referral_list = [SQInviteFriendItemModel]()
    var total_num     = 0
}

class SQInviteFriendItemModel: SQBaseModel {
    var email = ""
    var created_at: Int64 = 0
}
