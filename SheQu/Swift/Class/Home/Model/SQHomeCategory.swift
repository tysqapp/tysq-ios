//
//  SQHomeCategory.swift
//  SheQu
//
//  Created by gm on 2019/4/28.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQHomeCategory: SQBaseModel {
   var category_info = [SQHomeCategoryInfo]()
}

class SQHomeCategoryInfo: SQBaseModel {
    var id:Int =  0
    //var parent_id = 0
    var name = ""
    var note = ""
    var sort = 3
    var status = 1
    var icon_url = ""
    var subcategories = [SQHomeCategorySubInfo]()
    
   func createAllCategorySubInfo() -> SQHomeCategorySubInfo{
        let model = SQHomeCategorySubInfo()
        model.id  = 0
        model.parent_id = self.id
        model.name      = "全部"
        return model
    }
}
    
class SQHomeCategorySubInfo: SQBaseModel {
    var id:Int =  0
    var parent_id = -100
    var name = ""
    var note = ""
    var sort = 3
    var status = 1
    var icon_url = ""
}
