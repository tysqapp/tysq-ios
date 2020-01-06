//
//  SQHomeLabelinfoModel.swift
//  SheQu
//
//  Created by gm on 2019/4/29.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit


class SQHomeLabelinfoModel: SQBaseModel {
    var label_infos = [SQHomeLabelinfoItemModel]()
}


class SQHomeLabelinfoItemModel: SQBaseModel {
    var id = 0
    var created_at = ""
    var updated_at = ""
    var name = ""
    var note = ""
    var sort = ""
    var accountId = ""
    var status = ""
}
