//
//  SQRewardListModel.swift
//  SheQu
//
//  Created by iMac on 2019/11/8.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQRewardListModel: SQBaseModel {
    var reward_list = [SQRewardItemModel]()
    var total_num = 0
}


class SQRewardItemModel: SQBaseModel {
    var rewarder_id = 0
    var head_url = ""
    var amount = 0
    var rewarded_at: Int64 = 0
    
}
