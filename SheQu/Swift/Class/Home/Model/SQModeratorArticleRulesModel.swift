//
//  SQModeratorArticleRulesModel.swift
//  SheQu
//
//  Created by gm on 2019/8/30.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

///版主对于文章的权限
class SQModeratorArticleRulesModel: SQBaseModel {
    var can_review: Bool         = false
    var can_delete_article: Bool = false
    var can_forbid_comment: Bool = false
    var can_delete_comment: Bool = false
    var can_hide_article: Int    = 0
    var can_set_article_top: Bool = false
}
