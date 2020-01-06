//
//  SQMutableDownloadManager.swift
//  SheQu
//
//  Created by gm on 2019/12/4.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
private var chunckSize = 1024 * 1024 * 2

let downloadDocuPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! + "/download"
private var _mutableDownloadManager: SQMutableDownloadManager?
class SQMutableDownloadManager: SQBaseModel {
     
    static let shareInstance: SQMutableDownloadManager = {
        if (_mutableDownloadManager == nil) {
            let jsonDict: [String: Any]? = NSKeyedUnarchiver.unarchiveObject(withFile: SQMutableDownloadManager.getDownloadPlistPath()) as? [String : Any]
            if jsonDict != nil {
                _mutableDownloadManager = SQMutableDownloadManager.deserialize(from: jsonDict!)
                _mutableDownloadManager?.totalStart()
            }else{
                _mutableDownloadManager = SQMutableDownloadManager()
            }
        }
        
        return _mutableDownloadManager!
    }()
    
    var itemLock: NSLock?
    
    var itemArray = [SQMutableDownloadItem]()
    
    var queueManagerArray: [FileDownloadQueueManager]?
    
    /// 添加下载列表
    /// - Parameters:
    ///   - downloadPath: 需要下载的链接
    ///   - mineType: 下载文件类型
    ///   - dispPath: 下载文件显示类型
    func appendDownLoadPath(_ downloadPath: String, mineType: String, dispPath: String) {
        
        let tempDownloadpath = downloadPath.encodeURLCodeStr()
        if itemArray.contains(where: {$0.downloadPath == tempDownloadpath}) {
            TiercelLog("repeat download")
            return
        }
        
        if itemLock == nil {
            itemLock = NSLock.init()
        }
        
        itemLock!.lock()
        let downLoadItem = SQMutableDownloadItem.init()
        downLoadItem.downloadPath = tempDownloadpath
        downLoadItem.createTime   = Int64(Date.init().timeIntervalSince1970)
        downLoadItem.timeStr =  downLoadItem.createTime.formatStr("yyyy-MM-dd HH:mm")
        downLoadItem.mineType     = mineType
        downLoadItem.dispPath     = dispPath
        itemArray.append(downLoadItem)
        ///发送通知 刷新下载界面
        NotificationCenter.default.post(name: k_noti_download, object: nil)
        itemLock!.unlock()
        totalStart()
    }
    
    func totalStart() {
        if itemLock == nil {
            itemLock = NSLock.init()
        }
        
        itemLock?.lock()
        
        if queueManagerArray == nil {
            queueManagerArray = [FileDownloadQueueManager]()
        }
        
        if queueManagerArray!.count < 2 {
            let queueManager = FileDownloadQueueManager()
            queueManager.isUsing = false
            queueManagerArray!.append(queueManager)
        }
        
        let unuseQueueArray = queueManagerArray!.filter {!$0.isUsing}
        let queueAccount: Int = unuseQueueArray.count
        if queueAccount == 0 {
            itemLock?.unlock()
            return
        }
        
        let queueManager = unuseQueueArray.first!
        let runItemArray = itemArray.filter {$0.status == 2}
        if runItemArray.count < 2 {
            ///获取正在等待下载中的
            let noneRunItemArray = itemArray.filter {$0.status == 0}
            guard let noneRunItem = noneRunItemArray.first else {
                itemLock!.unlock()
                return
            }
            noneRunItem.status = 2
            noneRunItem.downloadQueue = queueManager
            queueManager.isUsing     = true
            noneRunItem.startNow()
            noneRunItem.delegate?.downloadItemState(subItem: noneRunItem, status: 2)
        }
        
        itemLock?.unlock()
    }
    
    func totalDelete() {
        
    }
    
    func totalCancel() {
        
    }
    
    func totalPause() {
        
    }
    
    func totalCache() {
        queueManagerArray = nil
        itemLock          = nil
        itemArray.forEach {
            $0.delegate = nil
            $0.downloadQueue = nil
            $0.checkLock     = nil
            $0.uploadLock    = nil
            if $0.status == 2 {
                $0.status = 0
            }
            
            $0.subItemArray.forEach {
                $0.delegate = nil
                $0.task     = nil
                $0.fileHandel = nil
                if $0.status == 2 {
                    $0.status = 0
                }
            }
        }
        
        if let jsonDict = self.toJSON() {
            NSKeyedArchiver.archiveRootObject(jsonDict, toFile: SQMutableDownloadManager.getDownloadPlistPath())
        }
    }
    
    static func getDownloadPlistPath() -> String {
        return downloadDocuPath + "/download.plist"
    }
}

class FileDownloadQueueManager: SQBaseModel {
    var isUsing = false
    var downloadQueue: OperationQueue = {
        let uploadQueue = OperationQueue.init()
        uploadQueue.name = "handelQueue"
        uploadQueue.qualityOfService = .background
        uploadQueue.maxConcurrentOperationCount = 2
        return uploadQueue
    }()
}
