//
//  SQArticleInfoModel.swift
//  SheQu
//
//  Created by gm on 2019/5/21.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit


/// 文章详情model
class SQArticleInfoModel: SQBaseModel {
    var is_satisfy       = false
    var is_need_captcha  = false
    var limit_score      = 0
    var article_id       = ""
    var account_id       = 0
    var category_id      = 0
    var category_name    = ""
    var parent_category_name = ""
    var account          = ""
    var head_url         = ""
    var title            = ""
    var content          = ""
    var content_original = ""
    var videos           = [SQArticleVideoModel]()
    var audios           = [SQArticelItemModel]()
    var images           = [SQArticelItemModel]()
    var read_number      = 0
    var admire_number    = 0
    var admire_status    = 0
    var comment_number   = 0
    var created_time: Int64     = 0
    var status           = 0
    var label            = [SQLabelInfoModel]()
    var operation        = false
    var article_link     = ""
    var collect_status   = false
    var reason           = ""
    var top_position     = 0 //置顶排序
    var grade            = 0 //阅读需要等级
    var articelCallBack: ((SQArticleInfoModel) -> ())?
    
    ///这里添加通知的原因是 为了更改评论或者浏览数目的变化
    func addObserver(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reciveArticleModel(noti:)),
            name: NSNotification.Name.init(article_id),
            object: nil
        )
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
        
        if (articelCallBack != nil) {
            articelCallBack!(self)
        }
    }
    
    
    /// 通过内容路径(视频地址等)获取展示图片的路径(图片)
    ///
    /// - Parameters:
    ///   - type: 文件类型
    ///   - urlString:  内容路径
    /// - Returns: 返回 展示图片路径 和 id
    func getShowUrlAndId(type: SQAccountFileListType,urlString: String) -> SQAttachmentTransmitValue {
        var attachmentTransmitValue = SQAttachmentTransmitValue()
        switch type {
       
        case .image:
           let item = images.first { (model) -> Bool in
               return model.url == urlString
            }
           
           if (item != nil) {
                attachmentTransmitValue.originalUrl  = item!.original_url
                attachmentTransmitValue.filePath = urlString
                attachmentTransmitValue.showLink = item!.url
                attachmentTransmitValue.id       = item!.id
                attachmentTransmitValue.size     = CGSize.init(width: item!.width, height: item!.height)
           }
        case .video:
            let video = videos.first { (video) -> Bool in
               return video.video.url == urlString
            }
            
            if (video != nil) {
                let item = video!.getShowUrlAndID()
                attachmentTransmitValue.filePath = urlString
                attachmentTransmitValue.showLink = item.0
                attachmentTransmitValue.id       = video!.video.id
                attachmentTransmitValue.status   = video!.status
                attachmentTransmitValue.originalUrl  = item.1
            }
        case .music:
            let item = audios.first { (model) -> Bool in
                return model.url == urlString
            }
            
            if (item != nil) {
                attachmentTransmitValue.filePath = urlString
                attachmentTransmitValue.showLink = item!.url
                attachmentTransmitValue.id       = item!.id
                attachmentTransmitValue.fileName = item!.name
            }
            
        case .others:
            break
        }
        return attachmentTransmitValue
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

struct SQAttachmentTransmitValue {
    var filePath  = ""
    var showLink  = ""
    var originalUrl = ""
    var id        = 0
    var status    = 0
    var fileName  = ""
    var size      = CGSize.zero
}

class SQArticleVideoModel: SQBaseModel {
    var video        = SQArticelItemModel()
    var cover        = [SQArticelItemModel]()
    var screen_shot  = [SQArticelItemModel]()
    var status       = 0
    func getShowUrlAndID() -> (String,String,Int) {
        if cover.count > 0 {
            let item = cover.first
            return (item!.url,item!.original_url,video.id)
        }
        
        if screen_shot.count > 0 {
            let item = screen_shot.first
            return (item!.url,item!.original_url,video.id)
        }
        
        return ("","",0)
    }
}

class SQArticelItemModel: SQBaseModel {
    var id   = 0
    var url  = ""
    var name = ""
    var width: CGFloat  = 0
    var height: CGFloat = 0
    var original_url    = ""
}

extension Int {
    func toGradeName() -> String {
        var gradeName = "LV1"
        switch self {
        case 1:
            gradeName = "LV1"
        case 2:
            gradeName = "LV2"
        case 3:
            gradeName = "LV3"
        case 4:
            gradeName = "LV4"
        case 5:
            gradeName = "LV5"
        case 6:
            gradeName = "LV6"
        case 7:
            gradeName = "LV7"
        case 8:
            gradeName = "LV8"
        case 9:
            gradeName = "黄金1"
        case 10:
            gradeName = "黄金2"
        case 11:
            gradeName = "黄金3"
        case 12:
            gradeName = "铂金1"
        case 13:
            gradeName = "铂金2"
        case 14:
            gradeName = "铂金3"
        case 15:
            gradeName = "钻石1"
        case 16:
            gradeName = "钻石2"
        case 17:
            gradeName = "钻石3"
        default:
            gradeName = "皇冠"
        }
        
        return gradeName
    }
}

