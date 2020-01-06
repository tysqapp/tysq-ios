//
//  SQRespondFileModel.swift
//  SheQu
//
//  Created by gm on 2019/6/12.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQRespondFileModel: SQBaseModel {
    var status     = 0
    var url        = ""
    var file_slice = [NSNumber]()
    var file_chunk_size = 0 /// 1存在 -1部分存在 -2 完全存在
    var file_info  = SQAccountFileItemModel()
}
