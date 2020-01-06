//
//  SQCoinOrderListModel.swift
//  SheQu
//
//  Created by iMac on 2019/11/6.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQCoinOrderListModel: SQBaseModel {
    var total = 0
    var coin_orders = [SQCoinOrderDetailModel]()
}

class SQCoinOrderDetailModel: SQBaseModel {
    var created_at: Int64 = 0
    var order_id          = ""
    var coin_amount       = 0
    var price: CGFloat    = 0
    var status            = 0
    
}
