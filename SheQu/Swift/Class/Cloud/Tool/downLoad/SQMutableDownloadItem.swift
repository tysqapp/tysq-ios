//
//  SQMutableDownloadItem.swift
//  SheQu
//
//  Created by gm on 2019/12/4.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
import HandyJSON
private let chunkSize: Int64 = 1024 * 1024 * 2
private let maxNum = 3
protocol SQMutableDownloadItemDelegate: class,HandyJSON {
    func downloadItemError(subItem: SQMutableDownloadItem, errorMessage: String?)
    
    func downloadItemSuccess(subItem: SQMutableDownloadItem)
    
    func downloadItemProgress(subItem: SQMutableDownloadItem, complateValue: Int64)
    func downloadItemState(subItem: SQMutableDownloadItem, status: Int64)
}

class SQMutableDownloadItem: SQBaseModel {
    
    var downloadPath: String = "" {
        didSet {
            let tempPath = downloadPath.decodeURLCodeStr()
            fileName = tempPath.components(separatedBy: "/").last ?? ""
            let filePath = downloadPath.toMD5String()
            localPath = filePath + "/" + fileName
            let subPath = downloadDocuPath + "/" + filePath + "/sub"
            if !FileManager.default.fileExists(atPath: subPath) {
               do{
                   try FileManager.default.createDirectory(atPath: subPath, withIntermediateDirectories: true, attributes: nil)
               }
               catch{
                
               }
            }
            
            let docuLocalPath = downloadDocuPath + "/" + localPath
            if !FileManager.default.fileExists(atPath: docuLocalPath) {
                FileManager.default.createFile(atPath: docuLocalPath, contents: nil, attributes: nil)
            }
        }
    }
    
    ///本地地址
    var localPath: String = ""
    ///文件名
    var fileName: String = ""
    ///完成长度
    var complateValue: Int64 = 0
     /// 总长度
    var totalValue: Int64    = 0
    ///  0等待中 1暂停 2下载中 3完成 4重新下载 5删除 6失败 7合并中 8合并完成
    var status: Int          = 0
    var createTime: Int64    = 0
    var timeStr           = ""
    var dispPath          = ""
    var mineType          = ""
    var errorMessage      = ""
    lazy var subItemArray = [SQMutableDownloadSubItem]()
    
    var downloadQueue: FileDownloadQueueManager?
    weak var delegate: SQMutableDownloadItemDelegate?
    var uploadLock:NSLock?
    var checkLock:NSLock?
    func startNow() {
        
        if uploadLock == nil {
            uploadLock = NSLock.init()
        }
        
        if checkLock == nil {
            checkLock = NSLock.init()
        }
        
        uploadLock?.lock()
        if totalValue == 0 {
            getTotalValue()
            uploadLock?.unlock()
            return
        }
        
        let downloadingSubItemArray = subItemArray.filter{$0.status == 2}
        if downloadingSubItemArray.count > maxNum {
            uploadLock?.unlock()
            return
        }
        
        let undownloadSubItemArray = subItemArray.filter{$0.status == 0}
        if undownloadSubItemArray.count > 0 {
            let subItem = undownloadSubItemArray.first!
            subItem.requestStr = downloadPath
            subItem.status = 2
            subItem.delegate = self
            downloadQueue?.downloadQueue.addOperation {
                subItem.Start()
            }
        }
        uploadLock?.unlock()
    }
    
    func totalStart() {
        status = 0
        subItemArray.forEach {
            if $0.status == 1 || $0.status == 4 || $0.status == 2 {
                $0.status = 0
            }
        }
        downloadQueue?.isUsing = false
        downloadQueue = nil
        delegate?.downloadItemState(subItem: self, status: 0)
        SQMutableDownloadManager.shareInstance.totalStart()
    }
    
    func totalDelete() {
        let subPath = downloadDocuPath + "/" + downloadPath.toMD5String()
        let removeUrl = URL.init(fileURLWithPath: subPath)
        do{
            try FileManager.default.removeItem(at: removeUrl)
        }catch{
            
        }
        
        SQMutableDownloadManager.shareInstance.itemArray.removeAll {
            $0.downloadPath == self.downloadPath
        }
        
        NotificationCenter.default.post(name: k_noti_download, object: nil)
    }
    
    func totalCancel() {
        
    }
    
    func totalPause() {
        if status == 2 {
            status = 1
            subItemArray.forEach {
                $0.pause()
            }
            delegate?.downloadItemState(subItem: self, status: 1)
        }
        
    }
    
    func totalCache() {
        
    }
    
    func totalCombine() {
        TiercelLog("totalCombine")
        do{
            let fileLocalPath = downloadDocuPath + "/" + localPath
            let urlPath = URL.init(fileURLWithPath: fileLocalPath)
            let fileHandel = try FileHandle.init(forWritingTo: urlPath)
            for (_, item) in subItemArray.enumerated() {
                let subFileLocalPath = downloadDocuPath + "/" + item.localPath
                let dataUrl = URL.init(fileURLWithPath:  subFileLocalPath)
                let data = try Data.init(contentsOf: dataUrl, options: .mappedIfSafe)
                fileHandel.write(data)
                fileHandel.seekToEndOfFile()
                item.delete()
            }
            fileHandel.closeFile()
            subItemArray.removeAll()   
            let subPath = downloadDocuPath + "/" + downloadPath.toMD5String() + "/sub"
            let removeUrl = URL.init(fileURLWithPath: subPath)
            do{
                try FileManager.default.removeItem(at: removeUrl)
            }catch{
                
            }
            
            status = 8
            delegate?.downloadItemSuccess(subItem: self)
            SQMutableDownloadManager.shareInstance.totalStart()
        }catch {
            TiercelLog("combine \(error.localizedDescription)")
            status = 4
            delegate?.downloadItemError(subItem: self, errorMessage: "写入失败")
        }
    }
    
    private func getTotalValue() {
        let downloadUrl = URL.init(string: downloadPath)
        var urlRequest = URLRequest.init(url: downloadUrl!)
        urlRequest.setValue("bytes=0-1", forHTTPHeaderField: "range")
        weak var weakSelf = self
        DownloaderManager.shareInstance.downLoadUrl(downloadPath, urlRequest, { (error) in
            
        }, { (response) in
            
            guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse else {
                weakSelf?.uploadLock?.unlock()
                return
            }
            
            for key in httpResponse.allHeaderFields.keys {
                if key is String {
                    let keyStr: String = key as! String
                    if keyStr.lowercased() == "content-range" {
                        let contentRange: String = httpResponse.allHeaderFields[keyStr] as! String
                        let value: Int64 = Int64(contentRange.replacingOccurrences(of: "bytes 0-1/", with: "")) ?? 0
                        TiercelLog(value)
                        weakSelf?.totalValue = value
                        var end   =  chunkSize - 1
                        var start: Int64 = 0
                        while true {
                            let subItem = SQMutableDownloadSubItem()
                            if value <= end {
                                subItem.startRange = start
                                subItem.endRange   = value
                                weakSelf?.subItemArray
                                    .append(subItem)
                                break
                            }else {
                                subItem.startRange = start
                                subItem.endRange   = end
                                start = end + 1
                                end += chunkSize
                                weakSelf?.subItemArray
                                    .append(subItem)
                            }
                        }
                        
                        for _ in 0..<maxNum {
                            weakSelf?.startNow()
                        }
                    }
                }
            }
        }) { (_, _, _) in
        }
    }
}


extension SQMutableDownloadItem: SQMutableDownloadSubItemDelegate {
    func downloadSubItemError(subItem: SQMutableDownloadSubItem, errorMessage: String?) {
        status = subItem.status
        ///如果是重新下载状态 则切换成为等待下载
        if subItem.status == 4 {
            subItem.status = 0
        }
        totalCancel()
        delegate?.downloadItemError(subItem: self, errorMessage: errorMessage)
        SQMutableDownloadManager.shareInstance.totalStart()
    }
    
    func downloadSubItemSuccess(subItem: SQMutableDownloadSubItem) {
        checkLock?.lock()
        let successSubItem = subItemArray.filter {$0.status == 3}
        TiercelLog("successSubItem count = \(successSubItem.count) \(subItemArray.count)")
        if successSubItem.count == subItemArray.count {
            downloadQueue?.isUsing = false
            downloadQueue = nil
            SQMutableDownloadManager.shareInstance.totalStart()
            subItem.status = 7
            delegate?.downloadItemSuccess(subItem: self)
            totalCombine()
        }else{
            startNow()
        }
        checkLock?.unlock()
    }
    
    func downloadSubItemProgress(subItem: SQMutableDownloadSubItem, complateValue: Int64) {
        checkLock?.lock()
        self.complateValue += complateValue
        TiercelLog("complateValue = \(self.complateValue) \(totalValue)")
        delegate?.downloadItemProgress(subItem: self, complateValue: self.complateValue)
        checkLock?.unlock()
    }
    
    
}

