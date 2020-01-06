//
//  SQAccountCoinModel.swift
//  SheQu
//
//  Created by gm on 2019/7/17.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQAccountCoinModel: SQBaseModel {

    var details_count = 0
    var details_info  = [SQAccountCoinDetailModel]()
    var total_number  = 0

}

class SQAccountCoinDetailModel: SQBaseModel {
    var time: Int64 = 0
    var action = ""
    var change_number = 0
    var expired_at: Int64 = 0
}
