//
//  SQAccountIntegralModel.swift
//  SheQu
//
//  Created by gm on 2019/7/18.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQAccountIntegralModel: SQBaseModel {
    var total_num = 0
    var scoredetail_list = [SQAccountIntegralDetailModel]()
    var score_sum = 0
}

class SQAccountIntegralDetailModel: SQBaseModel {
    var amount = 0
    var action = ""
    var created_at: Int64 = 0
    var expired_at: Int64 = 0
    
    func toCoinModel() -> SQAccountCoinDetailModel {
        let coinModel = SQAccountCoinDetailModel()
        coinModel.change_number = amount
        coinModel.action        = action
        coinModel.time          = created_at
        coinModel.expired_at    = expired_at
        
        return coinModel
    }
}
