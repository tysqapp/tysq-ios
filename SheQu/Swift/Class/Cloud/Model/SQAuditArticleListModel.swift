//
//  SQAuditArticleListModel.swift
//  SheQu
//
//  Created by gm on 2019/9/4.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQAuditArticleListModel: SQBaseModel {
    var review_articles = [SQAuditArticleItemModel]()
    var articles_num       = 0
}

class SQAuditArticleItemModel: SQBaseModel {
    
    /// 文章标题
    var title = ""
    
    /// 文章ID
    var article_id = ""
    
    /// 一级板块名称
    var first_category = ""
    
    ///二级板块名称
    var sub_category = ""
    
    /// 审核时间
    var updated_at: Int64 = 0
    
    /// 审核人名称
    var operator_name = ""
    
    /// 发布人名称
    var author   = ""
    
    ///状态
    var status_name = ""
}

