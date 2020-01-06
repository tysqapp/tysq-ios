//
//  SQBaseScoreModel.swift
//  SheQu
//
//  Created by gm on 2019/10/22.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQBaseScoreModel: SQBaseModel {
    ///最低扣除积分
    var limit_score = 0
    
    ///是否审核接口
    var is_review    = false
    
    var article_id   = ""
    
    var statu_netWork = 0
}
