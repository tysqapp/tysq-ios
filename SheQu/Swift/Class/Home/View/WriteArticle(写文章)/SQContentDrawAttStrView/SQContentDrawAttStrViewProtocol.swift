//
//  SQContentDrawAttStrViewProtocol.swift
//  SheQu
//
//  Created by gm on 2019/6/26.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

let draw_stt_str_default_height = k_screen_width - 40
public protocol SQContentDrawAttStrViewProtocol {
    var aniImageView: SQAniImageView! { get set }
    
    /// 附件文件id
    var idStr: String! { get set}
    
    /// 显示展示链接
    var dispLink: String! { get set}
    
    /// 远程文件存放地址
    var fileLink: String! { get set}
    
    ///返回
    var callBack: SQContentDrawAttStrViewCallBack? { get set }
    
    func toMutableAttributedString()
    -> NSMutableAttributedString
}
