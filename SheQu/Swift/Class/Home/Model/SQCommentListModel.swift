//
//  SQCommentListModel.swift
//  SheQu
//
//  Created by gm on 2019/5/22.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit


/// 评论详情列表
class SQCommentListModel: SQBaseModel {
    
    var article_comments = [SQCommentModel]()
    var total_number     = 0
    var first_number     = 0
}


/// 评论详情
class SQCommentModel: SQBaseModel {
    
    
    /// 评论id
    var id                 = ""
    
    /// 内容
    var content            = ""
    
    /// 发布评论id
    var commentator_id     = 0
    
    /// 发布评论名字
    var commentator_name   = ""
    
    /// 发布评论人vip等级
    var commentator_grade   = 1
    
    /// 发布时间
    var time: Int64        = 0
    
    /// 头像路径
    var icon_url           = ""
    
    /// 文章id
    var article_id         = ""
    var image_url          = [SQCommentModelImageUrlItem]()
    var reply              = [SQCommentReplyModel]()
    var isFirstView        = false
    var isHeaderView       = false
    var rowH: CGFloat      = 0
    var commentFrame       = SQCommentFrame()
    var updated_at: Int64  = 0
    
    
    ///后面添加
    
//    ///能够被删除
//    var canDelete          = false
//    ///能够被禁止评论
//    var canForbin          = false
    
    var totleNum           = 0 {
        didSet {
            ///更新文章的评论数
            NotificationCenter.default.post(
                name: Notification.Name.init(
                    rawValue: article_id),
                object: ["comment_number": totleNum]
            )
        }
    }
    
    func getCommentFrame(){
        
        let marginX: CGFloat = 20
        let viewW        = k_screen_width
        let contentViewW = k_screen_width - marginX * 2
        
        var iconViewFrameY: CGFloat = 25
        if isFirstView {
           commentFrame.line1ViewFrame = CGRect.init(x: 0, y: 0, width: viewW, height: 10)
           
            let totleCommentLabelX     = commentFrame.line1ViewFrame.maxY + 15
           commentFrame.totleCommentLabelFrame = CGRect.init(x: marginX, y: totleCommentLabelX, width: contentViewW, height: 16)
           iconViewFrameY += commentFrame.totleCommentLabelFrame.maxY
        }else {
            commentFrame.line1ViewFrame         = CGRect.zero
            commentFrame.totleCommentLabelFrame = CGRect.zero
        }
        
        commentFrame.iconImageViewFrame = CGRect.init(
            x: marginX,
            y: iconViewFrameY,
            width: SQReplyViewFrame.iconWH,
            height: SQReplyViewFrame.iconWH
        )
        
        let nameLabelFrameX = commentFrame.iconImageViewFrame.maxX + 10
        let nameLabelFrameW = contentViewW - nameLabelFrameX + marginX
        commentFrame.nameLabelFrame     = CGRect.init(
            x: nameLabelFrameX,
            y: iconViewFrameY,
            width: nameLabelFrameW,
            height: 14
        )
        
        var bottomViewY = commentFrame.nameLabelFrame.maxY + 5
        if content.count > 0 {
            var contentLabelFrameH: CGFloat = 14
                let contentLabelFrameY =  bottomViewY + 10
                let contentLabelFrameHTemp = content.calcuateLabSizeHeight(
                    font: SQCommentFrame.contentLabelFont,
                    maxWidth: nameLabelFrameW
                )
                
                if  contentLabelFrameHTemp > contentLabelFrameH {
                    contentLabelFrameH = contentLabelFrameHTemp
                }
                
            
                
                commentFrame.contentLabelFrame = CGRect.init(
                    x: nameLabelFrameX,
                    y: contentLabelFrameY,
                    width: nameLabelFrameW,
                    height: contentLabelFrameH
                )
            
            bottomViewY = commentFrame.contentLabelFrame.maxY + 5
        }
        
        

        if image_url.count > 0 {
            let num  = Int(nameLabelFrameW + 10) / Int(SQCommentFrame.imageWidth + 10)
            var line =  image_url.count / num
            let rem  =  image_url.count % num
            if  rem == 0 {
                line = line - 1
            }
            let imageViewH: CGFloat = CGFloat((line + 1) * Int(SQCommentFrame.imageHeight) + line * 10)
            let imagesViewWidth: CGFloat = CGFloat(num) * (SQCommentFrame.imageWidth + 10)
            commentFrame.imagesViewFrame = CGRect.init(
                x: nameLabelFrameX,
                y: bottomViewY + 5,
                width: imagesViewWidth,
                height: imageViewH + 10
            )
            
            bottomViewY = commentFrame.imagesViewFrame.maxY + 5
        }
        
        
        commentFrame.bottomViewFrame   = CGRect.init(x: nameLabelFrameX, y: bottomViewY, width: nameLabelFrameW, height: 35)
        
        var lineY = commentFrame.bottomViewFrame.maxY + 4
        if !isHeaderView {
            if reply.count > 0 {
                var replyH: CGFloat = 0
                for replyModel in reply {
                    replyModel.createReplayViewFrame(isHeaderView)
                    replyH += replyModel.replayViewFrame.lineViewFrame.maxY
                }
                
                if reply.count >= 3 {
                    replyH += 42
                }
                
                commentFrame.replyViewFrame = CGRect.init(x: nameLabelFrameX, y: lineY, width: nameLabelFrameW, height: replyH)
                
                lineY = commentFrame.replyViewFrame.maxY + 10
            }else{
                commentFrame.replyViewFrame = CGRect.zero
            }
        }
        
        
        commentFrame.line2ViewFrame = CGRect.init(
            x: 0,
            y: lineY,
            width: k_screen_width,
            height: k_line_height
        )
    }
}

class SQCommentReplyResponse: SQBaseModel {
    var limit_score = 0
    var top_comment = SQCommentReplyModel()
    var sub_comment = SQCommentReplyModel()
}

class SQCommentReplyModel: SQBaseModel {
    var id                   = ""
    var content              = ""
    var commentator_id       = 0
    ///评论人等级
    var commentator_grade    = 1
    ///评论人名字
    var commentator_name     = ""
    var time: Int64          = 0
    var updated_at: Int64    = 0
    var icon_url             = ""
    var parent_id            = ""
    var father_id            = ""
    var image_url            = [SQCommentModelImageUrlItem]()
    var commented_id         = 0
    ///被评论人名字
    var commented_name       = ""
    var commented_icon       = ""
    
    ///被评论人等级
    var commented_grade      = 1
    var replayViewFrame      = SQReplyViewFrame()
//    ///能够被删除
//    var canDelete          = false
//    ///能够被禁止评论
//    var canForbin          = false
    
    func toCommentModel(_ article_id: String) -> SQCommentModel {
        let model = SQCommentModel()
        model.article_id = article_id
        model.commentator_id = commentator_id
        model.commentator_name = commentator_name
        model.icon_url         = icon_url
        model.image_url        = image_url
        model.time             = time
        model.content          = content
        model.isFirstView      = true
        model.id               = id
        model.getCommentFrame()
        return model
    }
    
    func copyReplyCommentModel() -> SQCommentReplyModel {
        let tempModel = SQCommentReplyModel()
        tempModel.commentator_id = commentator_id
        tempModel.id             = id
        tempModel.image_url      = image_url
        tempModel.commented_icon = commented_icon
        tempModel.commented_name = commented_name
        tempModel.father_id      = father_id
        tempModel.parent_id      = parent_id
        tempModel.time           = time
        tempModel.content        = content
        tempModel.commented_id   = commented_id
        tempModel.commentator_name = commentator_name
        return tempModel
    }
    
    func createReplayViewFrame(_ isHeaderView: Bool = false) {
        var subtractNum: CGFloat       = 60
        if isHeaderView {
            subtractNum = 0
        }
        let viewW             = k_screen_width - 20 - subtractNum
        let margin: CGFloat   = 10
        let contentW          = viewW - margin * 2
        let iconY: CGFloat    = 10
        
        replayViewFrame.iconImageViewFrame = CGRect.init(x: margin, y: iconY, width: 40, height: 40)
        
        let nameX = replayViewFrame.iconImageViewFrame.maxX + 10
        let nameLabelW = commentator_name.calcuateLabSizeWidth(font: k_font_title_weight, maxHeight: 17) + 24
        replayViewFrame.nameLabelFrame = CGRect.init(x: nameX, y: iconY, width: nameLabelW, height: 17)
        
        let contentViewW = contentW - nameX + margin
        let commentedNameLabelX = replayViewFrame.nameLabelFrame.maxX
        let commentedNameLabelW = contentW - commentedNameLabelX
        replayViewFrame.commentedNameLabelFrame = CGRect.init(x: commentedNameLabelX, y: iconY, width: commentedNameLabelW, height: 17)
        
        var bottomViewY = replayViewFrame.nameLabelFrame.maxY + 5
        if content.count > 0 {
            let contentY  = replayViewFrame.nameLabelFrame.maxY + 13
            let contentH  = content.calcuateLabSizeHeight(font: SQCommentFrame.contentLabelFont, maxWidth: contentViewW)
            replayViewFrame.contentLabelFrame = CGRect.init(x: nameX, y: contentY, width: contentViewW, height: contentH)
            bottomViewY = replayViewFrame.contentLabelFrame.maxY + 5
        }
        
        
        
        
        if image_url.count > 0 {
            
            let num  = Int(contentViewW + 10) / Int(SQCommentFrame.imageWidth + 10)
            var line =  image_url.count / num
            let rem  =  image_url.count % num
            if  rem == 0 {
                line = line - 1
            }
            
            let imageViewH: CGFloat = CGFloat((line + 1) * Int(SQCommentFrame.imageHeight) + line * 10)
            
            let imagesViewWidth: CGFloat = CGFloat(num) * (SQCommentFrame.imageWidth + 10)
            replayViewFrame.imagesViewFrame = CGRect.init(x: nameX, y: bottomViewY + 5, width: imagesViewWidth, height: imageViewH + 10)
            
            bottomViewY = replayViewFrame.imagesViewFrame.maxY + 5
        }
        
        replayViewFrame.bottomViewFrame = CGRect.init(x: nameX, y: bottomViewY, width: contentViewW, height: 35)
        
        let lineViewY = replayViewFrame.bottomViewFrame.maxY + 10
        replayViewFrame.lineViewFrame = CGRect.init(x: nameX, y: lineViewY, width: contentViewW, height: k_line_height)
    }
}

class SQCommentModelImageUrlItem: SQBaseModel {
    var url = ""
    var original_url = ""
}


struct SQCommentFrame{
    static let iconWH = SQReplyViewFrame.iconWH
    static let contentLabelFont  = k_font_title
    static let imageWidth: CGFloat        = 90
    static let imageHeight: CGFloat       = 70
    var line1ViewFrame           = CGRect.zero
    var totleCommentLabelFrame   = CGRect.zero
    var iconImageViewFrame       = CGRect.zero
    var nameLabelFrame           = CGRect.zero
    var contentLabelFrame        = CGRect.zero
    var imagesViewFrame              = CGRect.zero
    var bottomViewFrame          = CGRect.zero
    var line2ViewFrame           = CGRect.zero
    var replyViewFrame           = CGRect.zero
    
}

struct SQReplyViewFrame {
    static let iconWH: CGFloat   = 40
    var iconImageViewFrame           = CGRect.zero
    var nameLabelFrame               = CGRect.zero
    var commentedNameLabelFrame      = CGRect.zero
    var contentLabelFrame            = CGRect.zero
    var imagesViewFrame              = CGRect.zero
    var bottomViewFrame              = CGRect.zero
    var lineViewFrame                = CGRect.zero
}
