//
//  SQHomeArticlesListModel.swift
//  SheQu
//
//  Created by gm on 2019/4/29.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit


fileprivate struct SQItemStruct {
    static let rightImageViewW: CGFloat =  SQHomeInfoDetailCell.rightImageViewW
    static let rightImageViewH: CGFloat  = SQHomeInfoDetailCell.rightImageViewH
}

/// 首页网络返回文章列表数组
class SQHomeArticlesListModel: SQBaseModel {
    ///文章列表
    var articles_info = [SQHomeArticleItemModel]()
    ///收藏
    var collects      = [SQHomeArticleItemModel]()
    var total_num     = 0
}

enum SQArticleAuditStatus: Int {
    ///已发布
    case publish = 1
    
    ///已隐藏
    case hidden = -4
    
    ///草稿
    case draft = 2
    
    ///待审核
    case audit = -1
    
    ///审核失败
    case aduitFail = -2
    
    ///已删除
    case delete = -3
    
    ///拓展或者全部
    case expend = 0
    
    
}


///首页文章列表model
class SQHomeArticleItemModel: SQBaseModel {
    var article_id        = ""
    var account_id        = -1
    var category_id       = 0
    var account           = ""
    var head_url          = ""
    var title             = ""
    var content           = ""
    var video_url         = [SQHomeListVideoUrl()]
    var picture_url       = [String]()
    var read_number       = 0
    var check_status      = 0
    var admire_number     = 0
    var admire_status     = 0
    var comment_number    = 0
    var created_time: Int64 = 0
    var create_time: Int64  = 0
    var tatus             = 0
    var label             = [SQHomeInfoDetailLabel]()
    var operation         = false
    var status            = 0
    
    /// 首页的item Frame
    var itemFrame         = SQHomeInfoDetailItemFrame()
    
    /// 推荐文章列表的item frame
    var articleFrame      = SQArticleInfoItemFrame()
    var isFirstShow       = false
    var reason            = ""
    
    var articelCallBack: ((SQHomeArticleItemModel) -> ())?
    var isDeleted         = false
    
    ///这里添加通知的原因是 为了更改评论或者浏览数目的变化
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(reciveArticleModel(noti:)), name: NSNotification.Name.init(article_id), object: nil)
    }
    
    
    @objc func reciveArticleModel(noti: NSNotification){
        guard let dict: [String: Int] = noti.object as? [String : Int] else {
            return
        }
        
        if dict.keys.contains("comment_number") {
            comment_number = dict["comment_number"] ?? 0
        }
        
        if dict.keys.contains("read_number") {
            read_number = dict["read_number"] ?? 0
        }
        
        if dict.keys.contains("isDeleted") {
            isDeleted = true
        }
        
        if (articelCallBack != nil) {
            articelCallBack!(self)
        }
    }
    
    
    ///设置文章推荐列表 我的文章 item Frame
    func createArticleFrame() {
        
        var  top: CGFloat    = 15
        let marginX: CGFloat = 20
        let marginY: CGFloat = 15
        let contentW         = k_screen_width - marginX * 2
        if isFirstShow { ///推荐文件列表 判断是不是第一个展示
            articleFrame.line1ViewFrame = CGRect.init(x: 0, y: 0, width: k_screen_width, height: 10)
            
            let tipsLabelFrameY = articleFrame.line1ViewFrame.maxY + marginY
            articleFrame.tipsLabelFrame = CGRect.init(x: marginX, y: tipsLabelFrameY, width: contentW, height: 16)
            
            top = articleFrame.tipsLabelFrame.maxY + 20
        }
        
        var calcuateTitle = title
        if status == SQArticleAuditStatus.draft.rawValue {
            calcuateTitle = title + "  草稿  "
        }
        let titleH = calcuateTitle.calcuateLabSizeHeight(font: SQArticleInfoItemFrame.titleFont, maxWidth: contentW)
        articleFrame.titleLabelFrame = CGRect.init(x: marginX, y: top, width: contentW, height: titleH)
        
        let bottomY = articleFrame.titleLabelFrame.maxY
        articleFrame.bottomViewFrame = CGRect.init(x: marginX, y: bottomY, width: contentW, height: 50)
        
        
        
        if reason.count > 0 {
            reason = reason.replacingOccurrences(of: "驳回原因：", with: "")
            reason = "驳回原因：" + reason
            let line2ViewY = articleFrame.bottomViewFrame.maxY
            articleFrame.line2ViewFrame = CGRect.init(x: marginX, y: line2ViewY, width: contentW, height: k_line_height)
            
            let reasonLabelY = articleFrame.line2ViewFrame.maxY + 15
            let reasonLabelH = reason.calcuateLabSizeHeight(font: k_font_title_12, maxWidth: contentW)
            articleFrame.reasonLabelFrame = CGRect.init(x: marginX, y: reasonLabelY, width: contentW, height: reasonLabelH)
            
            let line3ViewY = articleFrame.reasonLabelFrame.maxY + 15
            articleFrame.line3ViewFrame = CGRect.init(x: 0, y: line3ViewY, width: k_screen_width, height: k_line_height)
        }else{
            let line2ViewY = articleFrame.bottomViewFrame.maxY
            articleFrame.line2ViewFrame = CGRect.init(x: 0, y: line2ViewY, width: k_screen_width, height: k_line_height)
            articleFrame.line3ViewFrame = articleFrame.line2ViewFrame
        }
        
        addObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

class SQHomeListVideoUrl: SQBaseModel {
    var video       = ""
    var cover       = ""
    var screen_shot = [String]()
    
    func getVedioLink() -> String {
        if cover.count > 1 {
            return cover
        }
        
        if screen_shot.count > 0 {
            return screen_shot.first!
        }
        
        return ""
    }
}

//struct SQHomeInfoDetailItemFrame{
//    var titleLabelFrame      = CGRect.zero
//    var marksViewFrame       = CGRect.zero
//    var contentLabelFrame    = CGRect.zero
//    var rightImageViewFrame   = CGRect.zero
//    var buttomViewFrame      = CGRect.zero
//    var rowH: CGFloat        = 60
//
//    //MARK: -----------自定义数据-------------
//    fileprivate static let margin: CGFloat = 20
//    fileprivate static let leftImageViewRadius: CGFloat = 4
//    fileprivate static let titleLabelFont = k_font_title_weight_16
//}


struct SQArticleInfoItemFrame{
    static let titleFont = k_font_title_weight
    var tipsLabelFrame   = CGRect.zero
    var line1ViewFrame   = CGRect.zero
    var line2ViewFrame   = CGRect.zero
    var line3ViewFrame   = CGRect.zero
    var titleLabelFrame  = CGRect.zero
    var bottomViewFrame  = CGRect.zero
    var reasonLabelFrame = CGRect.zero
}

class SQHomeInfoDetailLabel: SQBaseModel {
    var label_id = 0
    var label_name = ""
}
