//
//  SQTopArticleListModel.swift
//  SheQu
//
//  Created by iMac on 2019/11/7.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQTopArticleListModel: SQBaseModel {
    var articles = [SQTopArticleModel]()
}

class SQTopArticleModel: SQBaseModel {
    var article_id = ""
    var title = ""
    var fatherID: Int = -1
    var id: Int = -1
}
