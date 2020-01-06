//
//  SQAccountComment.swift
//  SheQu
//
//  Created by gm on 2019/5/27.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQAccountComment: SQBaseModel {
    var comment_info = [SQAccountCommentInfoModel]()
    var total_num    = 0
}

class SQAccountCommentInfoModel: SQBaseModel {
    var id = ""
    var content = ""
    var commented_id = 0
    var commented_name = ""
    var respond_content = ""
    var time: Int64     = 0
    var author_id       = 0
    var article_id      = ""
    var title           = ""
    var image_url       = [SQCommentModelImageUrlItem]()
    var itemFrame       = SQAccountCommentItemFrame()
    
    func creatItemFrame (){
        let marginX = k_margin_x
        let contntW = k_screen_width - marginX * 2
        
        let titleMaxH: CGFloat = 34
        var tempTitle = ""
        if commented_name.count > 0 {
           tempTitle  = "回复了\(commented_name)在《\(title)》的评论"
        }else{
            tempTitle = "评论了文章《\(title)》"
        }
        
        var titleH    = tempTitle.calcuateLabSizeHeight(font: SQAccountCommentItemFrame.titleFont, maxWidth: contntW)
        if titleH > titleMaxH {
            titleH = titleMaxH
        }
        
        itemFrame.titleLabelFrame = CGRect.init(x: marginX, y: 20, width: contntW, height: titleH)
        
        var repliedViewY = itemFrame.titleLabelFrame.maxY + 15
        if content.count > 0 {
            let contentY = itemFrame.titleLabelFrame.maxY  + 15
            let contentH = content.calcuateLabSizeHeight(font: SQAccountCommentItemFrame.contentFont, maxWidth: contntW)
            itemFrame.contentLabelFrame = CGRect.init(x: marginX, y: contentY, width: contntW, height: contentH)
            
            repliedViewY = itemFrame.contentLabelFrame.maxY + 15
        }
        
        
        
        if image_url.count > 0 {
            let num  = Int(contntW + 10) / Int(SQAccountCommentItemFrame.imageWidth + 10)
            var line =  image_url.count / num
            let rem  =  image_url.count % num
            if  rem == 0 {
                line = line - 1
            }
            let imageViewH: CGFloat = CGFloat((line + 1) * Int(SQAccountCommentItemFrame.imageHeight) + line * 10)
            let imagesViewWidth: CGFloat = CGFloat(num) * (SQAccountCommentItemFrame.imageWidth + 10)
            itemFrame.imagesViewFrame = CGRect.init(x: marginX, y: repliedViewY - 12, width: imagesViewWidth, height: imageViewH + 10)
            
            repliedViewY = itemFrame.imagesViewFrame.maxY + 10
        }else{
            itemFrame.imagesViewFrame = CGRect.zero
            repliedViewY = repliedViewY - 5
        }
        
        var timeLabelY  = repliedViewY
        if commented_name.count > 0 {
            let repliedStr  = "\(commented_name): \(respond_content)"
            let repliedW    = contntW - marginX * 2
            var repliedH    = repliedStr.calcuateLabSizeHeight(font: SQAccountCommentItemFrame.repliedFont, maxWidth: repliedW)
            repliedH       =  repliedH + 27 // 这里是默认三角高度
            itemFrame.repliedViewFrame = CGRect.init(x: marginX, y: repliedViewY, width: contntW, height: repliedH)
            timeLabelY = itemFrame.repliedViewFrame.maxY + 10
        }else{
            itemFrame.repliedViewFrame = CGRect.zero
        }
        
        itemFrame.timeLabelFrame = CGRect.init(x: marginX, y: timeLabelY, width: contntW, height: 11)
        
        let lineFrameY       = itemFrame.timeLabelFrame.maxY + 20
        itemFrame.lineFrame  = CGRect.init(x: 0, y: lineFrameY, width: k_screen_width, height: k_line_height)
        
    }
}


struct SQAccountCommentItemFrame {
    static let titleFont    = UIFont.systemFont(ofSize: 14)
    static let contentFont  = UIFont.systemFont(ofSize: 14)
    static let repliedFont  = UIFont.systemFont(ofSize: 12)
    static let imageWidth: CGFloat        = 90 * k_scale_iphone6_w
    static let imageHeight: CGFloat       = 70 * k_scale_iphone6_w
    var titleLabelFrame   = CGRect.zero
    var contentLabelFrame = CGRect.zero
    var imagesViewFrame   = CGRect.zero
    var timeLabelFrame    = CGRect.zero
    var repliedViewFrame  = CGRect.zero
    var lineFrame         = CGRect.zero
}
