//
//  FileUploadManager.swift
//  SheQu
//
//  Created by gm on 2019/6/12.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class FileUploadManager: NSObject {
    static var queueManagerArray = [FileUploadIngQueueManager]()
    lazy var uploadIngFileListInfoArray = [SQAccountFileItemModel]()
    
    static let sharedInstance: FileUploadManager = {
        let instance = FileUploadManager()
        return instance
    }()
    
    var chooseUploadFileLock: NSLock?
    
    ///处理成功回调
    var successCallBak: ((_ successModel: SQAccountFileItemModel) -> ())?
    
    func addUploadFile(_ model: SQAccountFileItemModel) {
        
        let isHave = uploadIngFileListInfoArray.contains { (findModel) -> Bool in
            return model.filename == findModel.filename
        }
        
        if isHave { //去掉重复上传的
            return
        }
        
        uploadIngFileListInfoArray.append(model)
        if FileUploadManager.queueManagerArray.count < 4  {
            let queueManager = FileUploadIngQueueManager()
            queueManager.isUsing = false
            FileUploadManager.queueManagerArray.append(queueManager)
        }
        chooseUploadFile()
    }
    
    ///删除已经上传的图片
    func deleteUploadFile(_ model: SQAccountFileItemModel,_ isFinish: Bool) {
        
        if !isFinish {
            if model.uploadType != 0 { //如果是正在上传的数据的话 取消网络请求
                for rangeModel in model.uploadRangeArray {
                    rangeModel.request?.cancel()
                }
                model.queueManagerModel?.isUsing = false
            }
            model.uploadData = NSData()
            uploadIngFileListInfoArray.removeAll { (resultModel) -> Bool in
                return resultModel.filename == model.filename
            }
        }else{
            model.uploadData = NSData()
            model.queueManagerModel?.isUsing = false
            uploadIngFileListInfoArray.removeAll { (findModel) -> Bool in
                return findModel.sha256 == model.sha256
            }
        }
    }
    
    ///选择上传图片
    func chooseUploadFile() {
        if (chooseUploadFileLock != nil) {
            chooseUploadFileLock = NSLock()
        }
        chooseUploadFileLock?.lock()
        
        ///获取未上传的model
        let infoModel = uploadIngFileListInfoArray.first { (findModel) -> Bool in
            return findModel.uploadType == 0
        }
        
        let queueModel = FileUploadManager.queueManagerArray.first { (findModel) -> Bool in
            return !findModel.isUsing
        }
        
        
        if (infoModel != nil) && (queueModel != nil){
            infoModel?.uploadType = 1 ///正在上传
            infoModel?.queueManagerModel = queueModel
            queueModel?.isUsing          = true
            weak var weakSelf = self
            queueModel!.uploadQueue.addOperation {
                weakSelf?.checkFileIsUpload(infoModel!)
            }
        }
        
        chooseUploadFileLock?.unlock()
    }
    
    func checkFileIsUpload(_ model: SQAccountFileItemModel) {
        
        if model.uploadData.length < 1 && (model.localUrl != nil) {
            
            //_ = autoreleasepool{ ///自动释放池
            do {
                model.uploadData = try NSData.init(contentsOf: model.localUrl!, options: [.alwaysMapped,.uncached])
                
            }catch{
                TiercelLog(error.localizedDescription)
                model.delegate?.accountFileListInfoError(
                    accountFileInfo: model,
                    errorStatus: 0,
                    errorMessage: "您没有查看它的权限"
                )
                return
            }
           
            
            model.size       = Int64(model.uploadData.count)
        }
        
        if model.uploadData.count == 0 {
            deleteUploadFile(model, false)
            model.uploadType = 3
            model.queueManagerModel?.isUsing = false
            model.progress       = 0
            model.uploadValue    = 0
            model.errorMessage   = "上传数据不能为0"
            FileUploadManager.sharedInstance.chooseUploadFile()
            var errorMessage = "获取文件权限失败"
            if model.uploadData.count != 0 {
                errorMessage = "上传数据不能超过1G"
            }
            
            model.delegate?.accountFileListInfoError(accountFileInfo: model, errorStatus: 0, errorMessage: errorMessage)
            return
        }
        
        model.sha256 = model.uploadData.sha256()
        weak var weakSelf = self
        SQCloudNetWorkTool.checkAccountFile(model.sha256, model.filename) { (respondFile, statu, errorMessage) in
            
            if (errorMessage != nil) {
                model.uploadType = 3
                model.queueManagerModel?.isUsing = false
                model.progress       = 0
                model.uploadValue    = 0
                model.errorMessage   = errorMessage!
                FileUploadManager.sharedInstance.chooseUploadFile()
                model.delegate?.accountFileListInfoError(
                    accountFileInfo: model,
                    errorStatus: Int(statu),
                    errorMessage: errorMessage!
                )
                
                TiercelLog("\(errorMessage ?? ""),\(model.sha256)")
                return
            }
            ///已经存在 就不需要重复上传了
            if respondFile!.status == 1 {
                FileUploadManager.sharedInstance.deleteUploadFile(model, true)
                respondFile?.file_info.sha256 = respondFile?.file_info.hash ?? "error"
                if (model.delegate != nil) {
                  model.delegate!.accountFileListInfo(accountFileInfo: model, isFinish: true, resultModel: respondFile?.file_info)
                }else{
                    if (FileUploadManager.sharedInstance.successCallBak != nil) {
                        FileUploadManager.sharedInstance.successCallBak!(respondFile!.file_info)
                    }
                }
                
                model.uploadType = 2
                model.queueManagerModel?.isUsing = false
                model.uploadData = NSData()
                weakSelf?.chooseUploadFile()
                return
            }
            ///部分存在 根据未上传的上传 status == -1 status == -2
            model.createRangeArray(respondFile!.file_chunk_size, uploadFile: respondFile!.file_slice)
        }
    }
    
    func combineFile(_ infoModel: SQAccountFileItemModel) {
        weak var weakSelf = self
        TiercelLog("合并数据")
        SQCloudNetWorkTool.combineFile(infoModel.sha256, infoModel.uploadRangeArray.count) { (respond, statu, error) in
            if (error != nil) {
                infoModel.uploadType = 3
                infoModel.queueManagerModel?.isUsing = false
                infoModel.progress       = 0
                infoModel.uploadValue    = 0
                infoModel.errorMessage   = error!
                FileUploadManager.sharedInstance.chooseUploadFile()
               infoModel.delegate?.accountFileListInfoError(accountFileInfo: infoModel, errorStatus: Int(statu), errorMessage: error!)
               return
            }
            
            if respond?.hash.count ?? 0 > 0 {
                respond?.sha256 = respond?.hash ?? ""
            }
            FileUploadManager.sharedInstance.deleteUploadFile(infoModel, true)
            if (infoModel.delegate != nil) {//返回成功处理
                
                infoModel.delegate!.accountFileListInfo(
                accountFileInfo: infoModel,
                isFinish: true,
                resultModel: respond
                )
            }else{
                if (FileUploadManager.sharedInstance.successCallBak != nil) {
                    FileUploadManager.sharedInstance.successCallBak!(respond!)
                }
            }
            
            infoModel.uploadType = 2
            infoModel.queueManagerModel?.isUsing = false
            infoModel.uploadData = NSData()
            weakSelf?.chooseUploadFile()
        }
    }
    
    func stopUploading(){
        let uploadArray = uploadIngFileListInfoArray.filter { (findModel) -> Bool in
            return findModel.uploadType == 1
        }
        
        for uploadInfo in uploadArray {
            let uploadRangeArray = uploadInfo.uploadRangeArray.filter { (findModel) -> Bool in
                return findModel.isUploadIng == 1
            }
            for uploadRange in uploadRangeArray {
                uploadRange.request?.suspend()
            }
        }
    }
    
    func continueUploading() {
        let uploadArray = uploadIngFileListInfoArray.filter { (findModel) -> Bool in
            return findModel.uploadType == 1
        }
        
        for uploadInfo in uploadArray {
            let uploadRangeArray = uploadInfo.uploadRangeArray.filter { (findModel) -> Bool in
                return findModel.isUploadIng == 1
            }
            for uploadRange in uploadRangeArray {
                uploadRange.request?.resume()
            }
        }
    }
}

class FileUploadIngQueueManager: NSObject {
    var isUsing = false
    var uploadQueue: OperationQueue = {
        let uploadQueue = OperationQueue.init()
        uploadQueue.name = "handelQueue"
        uploadQueue.qualityOfService = .background
        uploadQueue.maxConcurrentOperationCount = 2
        return uploadQueue
    }()
}
