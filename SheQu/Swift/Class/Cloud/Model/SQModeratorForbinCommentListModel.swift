//
//  SQForbinCommentListModel.swift
//  SheQu
//
//  Created by iMac on 2019/9/5.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQModeratorForbinCommentListModel: SQBaseModel {
    
    var total_num = 0
    
    //禁止评论板块列表
    var forbid_comment = [SQModeratorForbinCommentItemModel]()
    
}

class SQModeratorForbinCommentItemModel: SQBaseModel {

    
    var account = ""
    var account_id: Int = 0
    var category_list = [SQModeratorForbinCommentSubItemModel]()
    
}

class SQModeratorForbinCommentSubItemModel: SQBaseModel {
    var category_id = 0
    var category_name = ""
    var position_id = 0
    var sub_category = [SQModeratorForbinCommentSubCategoryItemModel]()
    
}

class SQModeratorForbinCommentSubCategoryItemModel: SQBaseModel {
    var category_id = 6
    var category_name = ""
    var position_id = 0
    ///服务器假数据
//    var sub_category =
}
