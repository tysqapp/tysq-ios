//
//  SQAnnouncementListModel.swift
//  SheQu
//
//  Created by gm on 2019/8/19.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQAnnouncementListModel: SQBaseModel {
    var announcement_list = [SQAnnouncementItemModel]()
    var total_num         = 0
}


class SQAnnouncementItemModel: SQBaseModel {
    /// 标题
    var title   = ""
    
    /// 1:公告栏显示 2:弹窗显示 3:都显示
    var position    = 0
    
    ///网络链接
    var url     = ""
}
