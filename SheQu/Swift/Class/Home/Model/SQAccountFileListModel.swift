//
//  SQAccountFileListModel.swift
//  SheQu
//
//  Created by gm on 2019/5/13.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit


enum SQAccountFileListType: String {
    case image = "image"
    case video = "video"
    case music = "audio"
    case others = "other"
}

class SQAccountFileListModel: SQBaseModel {
    var file_info = [SQAccountFileItemModel]()
    var total_number = 0
}

protocol SQAccountFileListInfoDelegate: NSObject {
    func accountFileListInfo(accountFileInfo: SQAccountFileItemModel,isFinish: Bool,resultModel: SQAccountFileItemModel?)
    
    func accountFileListInfoError(accountFileInfo: SQAccountFileItemModel,errorStatus: Int,errorMessage: String)
}

class SQAccountFileItemModel: SQBaseModel {
    var id: Int32 = 0
    var account_id: Int = 0
    var filename = ""
    var type = ""
    var covers = [SQAccountCoversModel]()
    var duration: Int64 = 0
    var screenshots = [SQAccountScreenShotsModel]()
    var create_at: Int64 = 0
    var size:Int64 = 0
    var hash = ""
    var url = ""
    var isSelected = false
    var accountFileListFrame = SQAccountFileListFrame()
    var download_url         = ""
    var width: CGFloat       = 0
    var height: CGFloat      = 0
    ///1:本地存储,2:阿里云存储,3:aws存储
    var storage: Int         = 0
    weak var delegate: SQAccountFileListInfoDelegate?
    ///下面部分是为了适配 上传数据添加的
    
    /// 判断是否正在上传中 0是未上传 1 正在上传 2 已经上传 3 失败
    var uploadType = 0
    ///判断是否上传
    var isUploadIng = false
    ///上传数据
    var uploadData  = NSData()
    ///上传range
    var uploadRangeArray = [SQAccountFileRangeInfoModel]()
    ///服务器需要的hash
    var sha256        = ""
    var iconImage: UIImage?
    var uploadPath  = ""
    var chunkNumber = 0
    var uploadValue: Int64 = 0
    var progress: CGFloat = 0
    var errorMessage =  ""
    var localUrl: URL?
    weak var queueManagerModel: FileUploadIngQueueManager?
    var chooseFileLock: NSLock?
    var combineFileLock: NSLock?
    ///创建Frame
    func createAccountFileListFrame() {
        
        var contentW = k_screen_width
        var sizeLabelFrameRight: CGFloat = 20
        if isUploadIng {
            accountFileListFrame.progressViewFrame = CGRect.init(x: k_screen_width - 60, y: 20, width: 40, height: 40)
            contentW = accountFileListFrame.progressViewFrame.minX
            sizeLabelFrameRight = 60
        }else{
            accountFileListFrame.progressViewFrame = CGRect.zero
        }
        
        let titleLabelX = accountFileListFrame.iconImageViewFrame.maxX + 10
        let titleLabelY = accountFileListFrame.iconImageViewFrame.minY
        let titleLabelW = contentW - titleLabelX - 10
        let titleLabelH = filename.calcuateLabSizeHeight(font: SQAccountFileListFrame.titleLabelFont, maxWidth: titleLabelW)
        
        accountFileListFrame.titleLabelFrame = CGRect.init(
            x: titleLabelX,
            y: titleLabelY,
            width: titleLabelW,
            height: titleLabelH
        )
        
        let timeLabelY = accountFileListFrame.titleLabelFrame.maxY + 10
        accountFileListFrame.timeLabelFrame = CGRect.init(x: titleLabelX, y: timeLabelY, width: 120, height: 12)
        
        let sizeLabelX = accountFileListFrame.timeLabelFrame.maxX + 10
        let sizeLabelW = k_screen_width - sizeLabelX - sizeLabelFrameRight
        accountFileListFrame.sizeLabelFrame = CGRect.init(x: sizeLabelX, y: timeLabelY, width: sizeLabelW, height: 12)
        
        var  height = accountFileListFrame.iconImageViewFrame.maxY
        if height < accountFileListFrame.timeLabelFrame.maxY {
            height = accountFileListFrame.timeLabelFrame.maxY
        }
        
        let uploadingLabelFrameWidth: CGFloat = 100
        let uploadingLabelX = k_screen_width - uploadingLabelFrameWidth - 20
        accountFileListFrame.uploadingLabelFrame = CGRect.init(x: uploadingLabelX, y: timeLabelY, width: uploadingLabelFrameWidth, height: 12)
        
        accountFileListFrame.lineViewFrame = CGRect.init(x: 20, y: height + 20, width: k_screen_width - 20, height: k_line_height)
    }
    
    ///获取占位图片
    static func getPlaceHolderName(type: String, filename: String) -> String {
        var name = ""
        
        if type == "image" {
            name = "sq_cloud_image"
        }
        
        if type == "audio" {
            name = "sq_cloud_music"
        }
        
        if type == "video" {
            name = "sq_cloud_video"
        }
        
        if type == "other" {
            if filename.hasSuffix(".xls") || filename.hasSuffix("xlsx") {
                name = "sq_cloud_excel"
            }
            
            if filename.hasSuffix(".ppt") || filename.hasSuffix(".pptx") {
                name = "sq_cloud_ppt"
            }
            
            if filename.hasSuffix(".doc") || filename.hasSuffix(".docx") {
                name = "sq_cloud_word"
            }
            
            if filename.hasSuffix(".rar") || filename.hasSuffix(".zip") || filename.hasSuffix(".arj") {
                name = "sq_cloud_zip"
            }
            
            if name.count < 1 {
                name = "sq_cloud_other"
            }
        }
        
        return name
    }
    
    func getShowImageLink() -> String {
        var urlString = url
        if type == SQAccountFileListType.others.rawValue {
            return ""
        }
        if type == SQAccountFileListType.video.rawValue {
            if covers.count > 0 {
                urlString = covers[0].cover_url
            }else{
                if screenshots.count > 0 {
                    urlString = screenshots[0].screenshots_url
                }
            }
        }
        
        return urlString
    }
    
    
    deinit {
        TiercelLog("SQAccountFileListType fileName =\(filename),uploadType:\(uploadType)")
    }
}




class SQAccountCoversModel: SQBaseModel {
    var id: UInt64 = 0
    var cover_url  = ""
}

class SQAccountScreenShotsModel: SQBaseModel {
    var id: UInt64 = 0
    var screenshots_url = ""
}


struct SQAccountFileListFrame {
    static let titleLabelFont = k_font_title
    var iconImageViewFrame = CGRect.init(x: 20, y: 20, width: 40, height: 40)
    var titleLabelFrame    = CGRect.zero
    var timeLabelFrame     = CGRect.zero
    var sizeLabelFrame     = CGRect.zero
    var lineViewFrame      = CGRect.zero
    var progressViewFrame  = CGRect.zero
    var uploadingLabelFrame  = CGRect.zero
}
