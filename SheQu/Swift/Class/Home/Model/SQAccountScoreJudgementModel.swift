//
//  SQAccountScoreJudgementModel.swift
//  SheQu
//
//  Created by gm on 2019/7/15.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQAccountScoreJudgementModel: SQBaseModel {
    enum action: String {
        ///发布文章：
        case create_article   = "create_article"
        ///,阅读文章
        case read_article    = "read_article"
        ///评论文章
        case comment_article = "comment_article"
        ///下载视频
        case download_video  = "download_video"
    }
    
    
    /// 是否满足积分需求
    var is_satisfy = false
    ///操作资源状态
    var resources_status = -1
    ///被扣除积分数
    var limit_score     = 0
}
