//
//  SQWZListModel.swift
//  SheQu
//
//  Created by gm on 2019/9/29.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQWZListModel: SQBaseModel {
    var articles_info = [SQWZListItemModel]()
    var total_num     = 0
}


class SQWZListItemModel: SQBaseModel {
    
    ///文章id
    var id = ""
    
    /// 文章标题
    var title = ""
    
    /// 文章创建时间
    var created_time: Int64 = 0
    
    ///评论数
    var comment_number = 0

    /// 阅读数
    var read_number = 0
    
    ///文章封面
    var cover_url = ""
    
    ///cover_type 封面类型    如:"video","image"
    var cover_type    = ""
    
    ///文章内容
    var content = ""
    
    ///标签名
    var labels  =  [String]()
    
    ///  文章状态
    var status  =  0
    
    ///文章状态名
    var status_name = ""
    
    ///文章驳回原因
    var reason  = ""
    
    var articelCallBack: ((SQWZListItemModel) -> ())?
    var isDeleted = false
    
    func toHomeArticleItemModel() -> SQHomeArticleItemModel {
        let homeArticleItemModel = SQHomeArticleItemModel()
        homeArticleItemModel.article_id     = id
        homeArticleItemModel.create_time    = created_time
        homeArticleItemModel.created_time   = created_time
        homeArticleItemModel.comment_number = comment_number
        homeArticleItemModel.title          = title
        homeArticleItemModel.reason         = reason
        homeArticleItemModel.read_number    = read_number
        homeArticleItemModel.status         = status
        homeArticleItemModel.content        = content
        homeArticleItemModel.createArticleFrame()
        return homeArticleItemModel
    }
    
}

