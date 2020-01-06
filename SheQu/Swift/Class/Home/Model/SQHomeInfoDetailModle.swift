//
//  SQHomeInfoDetailModle.swift
//  SheQu
//
//  Created by gm on 2019/9/6.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQHomeInfoDetailListModel: SQBaseModel {
    var articles = [SQHomeInfoDetailItemModle]()
    var total_num = 0
}

class SQHomeInfoDetailItemModle: SQBaseModel {
    enum CoverType: String {
        case image = "image"
        case video = "video"
    }
    
    enum CellType: Int {
        case normal = 0
        case advertisement = 1
    }
    //广告是否需要重新加载
    var needRefresh: Bool = true
    var cellType: CellType = .normal
    var id = ""
    var title = ""
    var author_id           = 0
    var author_name         = ""
    var created_time: Int64 = 0
    var comment_number      = 0
    var read_number         = 0
    var cover_url           = ""
    var original_url        = ""
    /// image video
    var cover_type          = ""
    var content             = ""
    var labels          = [String]()
    var itemFrame         = SQHomeInfoDetailItemFrame()
    
    var articelCallBack: ((SQHomeInfoDetailItemModle) -> ())?
    
    var isDeleted         = false
    //搜索关键词变红
    var keyword = ""
    ///这里添加通知的原因是 为了更改评论或者浏览数目的变化
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(reciveArticleModel(noti:)), name: NSNotification.Name.init(id), object: nil)
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
    
    func createItemFrame(){
        let margin = SQHomeInfoDetailItemFrame.margin
        
        ///标注左边垂直方向 为了好设置frame
        var vertical: CGFloat       = 0
        let top: CGFloat            = 18
        ///计算好imageView的高度
        var rightImageViewW: CGFloat = 0
        if cover_type != SQHomeInfoDetailItemModle.CoverType.image.rawValue && cover_type != SQHomeInfoDetailItemModle.CoverType.video.rawValue   {
            itemFrame.rightImageViewFrame = CGRect.zero
            rightImageViewW = 0
        }else{
            rightImageViewW = SQHomeInfoDetailItemFrame.rightImageViewW
            let rightImageViewFrameX      = k_screen_width - rightImageViewW - margin
            itemFrame.rightImageViewFrame = CGRect.init(
                x: rightImageViewFrameX,
                y: top,
                width: rightImageViewW,
                height: SQHomeInfoDetailItemFrame.rightImageViewH
            )
            
            rightImageViewW = rightImageViewW + 10
            itemFrame.rowH = itemFrame.rightImageViewFrame.maxY
        }
        
        ///计算好titleView的高度
        let titleViewW = k_screen_width - rightImageViewW - margin * 2
        let titleViewH = title.calcuateLabSizeHeight(font: SQHomeInfoDetailItemFrame.titleLabelFont, maxWidth: titleViewW)
        itemFrame.titleLabelFrame = CGRect.init(x: margin, y: top, width: titleViewW, height: titleViewH)
        vertical = itemFrame.titleLabelFrame.maxY
        
        ///计算标签的高度
        if labels.count > 0 {
            let maskViewH: CGFloat = 35
            itemFrame.marksViewFrame = CGRect.init(
                x: margin,
                y: vertical,
                width: titleViewW,
                height: maskViewH
            )
            
            vertical = itemFrame.marksViewFrame.maxY
        }
        
        ///计算正文的高度
        if content.count >= 1 {
            vertical += 15
            let contentLabelMaxH: CGFloat = 36
            var contentLabelH = content.calcuateLabSizeHeight(font: k_font_title, maxWidth: titleViewW)
            if contentLabelMaxH < contentLabelH {
                contentLabelH = contentLabelMaxH
            }
            
            itemFrame.contentLabelFrame = CGRect.init(x: margin, y: vertical, width: titleViewW, height: contentLabelH)
            vertical = itemFrame.contentLabelFrame.maxY
        }
        
        itemFrame.rowH = vertical
        var buttomViewW = k_screen_width - SQHomeInfoDetailItemFrame.rightImageViewW - 10 - margin * 2
        if keyword.count > 0 {
            buttomViewW = k_screen_width - margin * 2
        }
        itemFrame.buttomViewFrame = CGRect.init(x: margin, y: itemFrame.rowH, width: buttomViewW, height: 50)
        itemFrame.rowH = itemFrame.buttomViewFrame.maxY
        
        ///判断图片和底部bottom的高度
        if itemFrame.rowH < itemFrame.rightImageViewFrame.maxY {
            itemFrame.rowH = itemFrame.rightImageViewFrame.maxY
            itemFrame.rowH += 10
        }
        
        addObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}


struct SQHomeInfoDetailItemFrame{
    var titleLabelFrame      = CGRect.zero
    var marksViewFrame       = CGRect.zero
    var contentLabelFrame    = CGRect.zero
    var rightImageViewFrame   = CGRect.zero
    var buttomViewFrame      = CGRect.zero
    var rowH: CGFloat            = 60
    
    //MARK: -----------自定义数据-------------
    fileprivate static let margin: CGFloat = 20
    fileprivate static let rightImageViewW: CGFloat = 80
    fileprivate static let rightImageViewH: CGFloat = 114
    fileprivate static let rightImageViewRadius: CGFloat = 4
    fileprivate static let titleLabelFont = k_font_title_16_weight
} 
