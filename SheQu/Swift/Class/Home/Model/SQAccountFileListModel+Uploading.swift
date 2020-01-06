//
//  SQAccountFileListModel+Uploading.swift
//  SheQu
//
//  Created by gm on 2019/6/14.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
import Alamofire

extension SQAccountFileItemModel {
    
    static let imageListType = ["JPG", "BMP", "EPS", "GIF", "MIF",
                                "MIFF", "PNG", "TIF", "TIFF", "SVG",
                                "WMF", "JPE", "JPEG", "DIB", "ICO",
                                "TGA", "CUT", "PIC"]
    
    static let audioListType = ["MP3", "AAC", "WAV", "WMA", "CDA",
                                "FLAC", "M4A", "MID", "MKA", "MP2",
                                "MPA", "MPC", "APE", "OFR", "OGG",
                                "RA", "WV", "TTA", "AC3", "DTS"]
    
    static let videoListType = ["AVI", "ASF", "WMV", "AVS", "FLV",
                                "MKV", "MOV", "3GP", "MP4", "MPG",
                                "MPEG", "DAT", "OGM", "VOB", "RM",
                                "RMVB", "TS", "TP", "IFO", "NSV"]
    static let totleThread = 3
    ///创建上传数据model
    class func createAccountFileListInfoModel(_ data: NSData,_ fileName: String,_ type: SQAccountFileListType) -> SQAccountFileItemModel{
        let model = SQAccountFileItemModel()
        model.create_at = Int64(Date().timeIntervalSince1970)
        
        if type == .image {
           ///为了处理长度造成的延时问题 获取 前一兆数据来作为名字
           var sha256 = ""
           if data.count <= 1048576 {
                sha256 = data.sha256()
           }else{
                let subData: NSData = data.subdata(with: NSRange.init(location: 0, length: 104856)) as NSData
                sha256 = subData.sha256()
            }
            let encodeUrlString = fileName.removingPercentEncoding
            let fileNameTemp    =  encodeUrlString ?? ""
           model.filename = "\(NSString(string: sha256).substring(to: 6))_\(fileNameTemp)"
        }else{
            let filaNameArray = fileName.components(separatedBy: "/")
            let encodeUrlString = (filaNameArray.last ?? "").removingPercentEncoding
            let fileNameTemp    =  encodeUrlString ?? ""
            model.filename = fileNameTemp
        }
       // model.sha256        = NSData(data: data).sha256()
        
        if model.type == "other" {
            let typeStr: String = model.filename.components(separatedBy: ".").last ?? ""
            let upStr  = typeStr.uppercased()
            if SQAccountFileItemModel.audioListType.contains(upStr) {
                model.type = "audio"
            }
            
            if SQAccountFileItemModel.imageListType.contains(upStr) {
                model.type = "image"
            }
            
            if SQAccountFileItemModel.videoListType.contains(upStr){
            model.type = "video"
            }
        }
        
        model.type     = type.rawValue
        if model.type  == SQAccountFileListType.image.rawValue {
            model.iconImage = UIImage.init(data: data as Data)
        }
        
        model.isUploadIng = true
        model.uploadData  = data
        model.size        = Int64(data.count)
        model.createAccountFileListFrame()
        return model
    }
    
    func createRangeArray(_ chunk_size: Int, uploadFile: [NSNumber]) {
        
        var firstSize     = 0
        chunkNumber       = chunk_size
        var   index       = 0
        while true {
            index += 1
            let rangeModel = SQAccountFileRangeInfoModel()
            if uploadFile.contains(NSNumber.init(value: index)) {
                rangeModel.isUploadIng = 2
                uploadValue += Int64(chunkNumber)
            }
            let lastSize = Int(size) - firstSize
            if lastSize < chunkNumber * 2 {
                let range = NSRange.init(location: firstSize, length: lastSize)
                rangeModel.range = range
                uploadRangeArray.append(rangeModel)
                break
            }else{
                let range = NSRange.init(location: firstSize, length: chunkNumber)
                rangeModel.range = range
                uploadRangeArray.append(rangeModel)
                firstSize += chunkNumber
            }
        }
        
        if uploadFile.count == uploadRangeArray.count {//数据上传完成 但是合并数据提交失败
            FileUploadManager.sharedInstance.combineFile(self)
            return
        }
        
        var tag = 0
        for index in 0..<uploadRangeArray.count {
           
            if tag == SQAccountFileItemModel.totleThread { ///控制最多三个线程
                break
            }
             let model = uploadRangeArray[index]
            if model.isUploadIng == 0 {
               tag += 1
               checkNeedUploadRange()
            }
        }
        
    }
    
    func checkNeedUploadRange() {
        if (chooseFileLock != nil) {
            chooseFileLock = NSLock()
        }
        chooseFileLock?.lock()
        let upLoadFileArray = uploadRangeArray.filter { (findModel) -> Bool in
            return findModel.isUploadIng == 1
        }
        let uploadModel = uploadRangeArray.first { (findModel) -> Bool in
            return findModel.isUploadIng == 0
        }
        
        if (uploadModel == nil) {//如果为nil 则表示没有需要上传的了
            chooseFileLock?.unlock()
            return
        }
        
        if upLoadFileArray.count < SQAccountFileItemModel.totleThread { //
            
            if (uploadModel != nil) {
                weak var weakSelf = self
                uploadModel?.isUploadIng = 1
                queueManagerModel?.uploadQueue.addOperation({
                    weakSelf?.uploadDataToNetWork(fileRangeInfoModel: uploadModel!)
                })
            }
            
        }
        
        chooseFileLock?.unlock()
    }
}



///这里是处理上传网络
extension SQAccountFileItemModel {
    
    func uploadDataToNetWork(fileRangeInfoModel: SQAccountFileRangeInfoModel) {
        weak var weakSelf = self
        var subData = uploadData.subdata(with: fileRangeInfoModel.range)
        let index: Int   = uploadRangeArray.firstIndex(of: fileRangeInfoModel)! + 1
        TiercelLog("请求了呀")
        fileRangeInfoModel.request = NetWorkManager.shared().uploadDataToNetWork(
            index,
            uploadRangeArray.count,
            chunkNumber,
            subData.count,
            uploadData.count,
            sha256,
            filename: filename,
            subData as NSData,
            urlStr: k_url_file_combine,
            handel: { (progressValue,respondData) in
                
                if progressValue == -100 {
                   TiercelLog("回调了呀")
                }
                
                if (weakSelf == nil) {
                    
                    return
                }
                
                if ((weakSelf?.combineFileLock) != nil) {
                    weakSelf?.combineFileLock = NSLock()
                }
                weakSelf?.combineFileLock?.lock()
                var uploadValue: Int64 = weakSelf?.uploadValue ?? 0
                if progressValue == -100 {
                    subData = Data()
                    fileRangeInfoModel.request?.cancel()
                    fileRangeInfoModel.request = nil
                    fileRangeInfoModel.isUploadIng = 2
                    
                    let rangeArray = weakSelf?.uploadRangeArray.filter({ (findModel) -> Bool in
                        return findModel.isUploadIng == 2
                    })
                    
                    
//                    if uploadValue < weakSelf!.size {  ///否的话说明这个文件上传成功
//                       
//                        return
//                    }
                    
                    if weakSelf!.uploadRangeArray.count == 1 {//当只有一个时 不需要发送组合按钮
                        
                        guard let respondValue: [String: Any] = respondData!.value as? [String : Any] else {
                            weakSelf?.combineFileLock?.unlock()
                            return
                        }
                        
                        let status: Int = respondValue["status"] as! Int
                        if status != 0 {
                            let errorMessage: String = respondValue["reason"] as! String
                            weakSelf?.uploadType = 3
                            weakSelf?.queueManagerModel?.isUsing = false
                            weakSelf?.progress       = 0
                            weakSelf?.uploadValue    = 0
                            weakSelf?.errorMessage   = errorMessage
                            FileUploadManager.sharedInstance.chooseUploadFile()
                            if ((weakSelf?.delegate) != nil) {
                                weakSelf?.delegate?.accountFileListInfoError(accountFileInfo: weakSelf!, errorStatus: status, errorMessage: errorMessage)
                            }
                            weakSelf?.combineFileLock?.unlock()
                            return
                        }

                        FileUploadManager.sharedInstance
                            .deleteUploadFile(weakSelf!, true)
                        let resultData: [String: Any] = respondValue["data"] as! [String : Any]
                        let resultModel: SQRespondFileModel? = SQRespondFileModel.deserialize(from: resultData);
                        resultModel?.file_info.sha256 = resultModel?.file_info.hash
                            ?? ""
                        if ((weakSelf?.delegate) != nil) {
                     weakSelf?.delegate?.accountFileListInfo(
                        accountFileInfo: weakSelf!,
                        isFinish: true,
                        resultModel: resultModel?.file_info)

                        }else {
                            if (FileUploadManager.sharedInstance
                                .successCallBak != nil) {
                                FileUploadManager.sharedInstance
                                    .successCallBak!(resultModel!.file_info)
                            }
                        }

                        weakSelf?.uploadType = 2
                        weakSelf?.queueManagerModel?.isUsing = false
                        weakSelf?.uploadData = NSData()
                        FileUploadManager.sharedInstance.chooseUploadFile()
                        weakSelf?.combineFileLock?.unlock()
                        return
                    }
                    
                
                    
                    TiercelLog("总条数\(rangeArray!.count),当前条数\(weakSelf!.uploadRangeArray.count)")
                    TiercelLog("上传数据\(uploadValue),总数据\(weakSelf!.size)")
                    
                    if rangeArray!.count == weakSelf!.uploadRangeArray.count {
                        FileUploadManager.sharedInstance
                            .combineFile(weakSelf!)
                    }else{
                         weakSelf?.checkNeedUploadRange()
                    }
                    
                }else{
                    uploadValue = uploadValue - fileRangeInfoModel.uploadValue
                    fileRangeInfoModel.uploadValue = progressValue
                    uploadValue = uploadValue + fileRangeInfoModel.uploadValue
                    weakSelf?.uploadValue = uploadValue
                }
                
                if ((weakSelf?.delegate) != nil) {
                    
                    if progressValue == -100 {
                        
                    }else{
                        let progressValue: CGFloat = CGFloat(uploadValue)
                        let progressSize: CGFloat = CGFloat(weakSelf?.size ?? INT64_MAX)
                        var progress: CGFloat = progressValue / progressSize
                        if progress >= 1 {
                            progress = 0.999
                        }
                        
                        weakSelf?.progress = progress
                        weakSelf!.delegate!.accountFileListInfo(accountFileInfo: weakSelf!, isFinish: false, resultModel: nil)
                    }
                    
                }
                weakSelf?.combineFileLock?.unlock()
        })
    }
    
}





///上传分片model
class SQAccountFileRangeInfoModel: NSObject {
    ///这里持有 是为后面做暂停这些操作做准备
    var request: Alamofire.UploadRequest?
    var range = NSRange.init(location: 0, length: 0)
    var isUploadIng = 0 //0是还未开始 1是正在网络请求 2是已经完成
    var uploadValue: Int64 = 0
}
