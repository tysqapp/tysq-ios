//
//  SQModeratorCategorysModel.swift
//  SheQu
//
//  Created by gm on 2019/9/2.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQModeratorCategoryListModel: SQBaseModel {
    
    var categorys = [SQModeratorCategoryItemModel]()
    
}


class SQModeratorCategoryItemModel: SQBaseModel {
    ///int    分类id
    var category_id = 0

    ///分类名称
    var category_name = ""
    
    
    /// 是否选中
    var isSel = false
    
    ///
    var position_id = 0
    
    /// 子列表是否展开
    var isUnwind = false
    
    /// 二级列表    具体见：板块实体详情
    var sub_category  = [SQModeratorSubCategoryItemModel]()
}

class SQModeratorSubCategoryItemModel: SQBaseModel {
    
    /// 是否选中
    var isSel = false
    
    ///int    分类id
    var category_id = 0
    
    var position_id = 0
    
    ///分类名称
    var category_name = ""
}
