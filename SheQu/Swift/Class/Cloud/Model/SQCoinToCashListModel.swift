//
//  SQGoldToCashListModel.swift
//  SheQu
//
//  Created by gm on 2019/8/13.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQCoinToCashListModel: SQBaseModel {
    var withdraw_review_list = [SQCoinToCashItemModel]()
    var total_num            = 0
}


class SQCoinToCashItemModel: SQBaseModel {
    var id                   = 0
    
    /// 驳回原因
    var reason               = ""
    
    var created_at: Int64    = 0
    var coin_amount: Int = 0
    var btc_amount: CGFloat  = 0
    var address: String      = ""
    var note                 = ""
    var status: Int          = 0
    var itemFrame            = SQCoinToCashInfoItemFrame()
}

struct SQCoinToCashInfoItemFrame {
     var line1ViewFrame                = CGRect.zero
     var line2ViewFrame                = CGRect.zero
     var blueViewFrame                 = CGRect.zero
     var orderTitleLabelFrame          = CGRect.zero
     var orderLabelFrame               = CGRect.zero
     var orderStateLabelFrame          = CGRect.zero
     var coinAmountLabelFrame          = CGRect.zero
     var coinAmountValueLabelFrame     = CGRect.zero
     var btcAmountLabelFrame           = CGRect.zero
     var btcAmountValueLabelFrame      = CGRect.zero
     var addressLabelFrame             = CGRect.zero
     var addressValueLabelFrame        = CGRect.zero
     var noteLabelFrame                = CGRect.zero
     var noteValueLabelFrame           = CGRect.zero
     var rejectedLabelFrame            = CGRect.zero
     var rejectedValueLabelFrame       = CGRect.zero
     var timeLabelFrame                = CGRect.zero
     var timeValueLabelFrame           = CGRect.zero
}
