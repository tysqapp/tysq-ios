//
//  SQLabelModel.swift
//  SheQu
//
//  Created by gm on 2019/5/14.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQLabelModel: SQBaseModel {
    var label_infos = [SQLabelInfoModel]()
}

class SQLabelInfoModel: SQBaseModel {
    var label_id = 0
    var label_name = ""
    var note = ""
    var status = 0
}
