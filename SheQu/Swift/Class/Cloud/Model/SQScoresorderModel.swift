//
//  SQScoresorderModel.swift
//  SheQu
//
//  Created by gm on 2019/7/18.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQScoresorderModel: SQBaseModel {
    var scoresorder_list = [SQScoresorderDetailModel]()
    var total_num        = 0
}

class SQScoresorderDetailModel: SQBaseModel {
    var created_at: Int64 =  0
    var order_id: Int     = 0
    var amount            = 0
    var price: CGFloat    = 0
    var mark              = ""
    var status            = 0
}
