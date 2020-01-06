//
//  SQMutableDownloadSubItem.swift
//  SheQu
//
//  Created by gm on 2019/12/4.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
import HandyJSON
fileprivate let ioQueue = DispatchQueue(label: "subDownload")
protocol SQMutableDownloadSubItemDelegate: class,HandyJSON {
    func downloadSubItemError(subItem: SQMutableDownloadSubItem, errorMessage: String?)
    func downloadSubItemSuccess(subItem: SQMutableDownloadSubItem)
    func downloadSubItemProgress(subItem: SQMutableDownloadSubItem, complateValue: Int64)
}
class SQMutableDownloadSubItem: SQBaseModel {
    /// status 状态0等待中 1暂停 2下载中 3完成 4重新下载 5删除 6失败 7合并中 8合并完成
    var status = 0
    
    ///总长度
    var totalValue: Int64    = 0
    ///完成长度
    var complateValue: Int64 = 0
    ///开始range
    var startRange: Int64    = 0
    ///结束range
    var endRange: Int64      = 0
    ///请求Url
    var requestStr = "" {
        didSet {
            let filePath = requestStr.toMD5String() + "/sub/"
            localPath = filePath + "\(startRange).temp"
            let docuLocalPath = downloadDocuPath + "/" + localPath
            if !FileManager.default.fileExists(atPath: docuLocalPath) {
                FileManager.default.createFile(atPath: docuLocalPath, contents: nil, attributes: nil)
            }
        }
    }
    /// 本地缓存地址
    var localPath  = ""
    var fileHandel: FileHandle?
    var task: URLSessionDataTask?
    weak var delegate: SQMutableDownloadSubItemDelegate?
    func Start() {
        TiercelLog("Start")
        let docuLocalPath = downloadDocuPath + "/" + localPath
        let pathUrl = URL.init(fileURLWithPath: docuLocalPath)
        do{
            fileHandel = try FileHandle.init(forWritingTo: pathUrl)
            startRequest()
        }catch{
            status = 4
            delegate?.downloadSubItemError(subItem: self, errorMessage: "打开文件流失败")
        }
        
    }
    
    func startRequest() {
         var startRangeTemp = startRange
         if complateValue > 0 {
             startRangeTemp += complateValue
         }
         
         if startRangeTemp >= endRange {
             status = 3
             delegate?.downloadSubItemSuccess(subItem: self)
             return
         }
        
         var urlRequest: URLRequest = URLRequest.init(url: URL.init(string: requestStr)!)
         urlRequest.setValue("bytes=\(startRangeTemp)-\(endRange)", forHTTPHeaderField: "Range")
        
        task = BrowserURLSessionManager.shareInstance().start(urlRequest) {[weak self] (statu, response) in
            if (self == nil) {
                return
            }
             switch statu {
                 
             case .respond:
                
                 break
             case .reciveData:
                
                let data: Data = response as! Data
                self?.complateValue = self!.complateValue + Int64(data.count)
                TiercelLog("download count = \(data.count)")
                 self?.fileHandel?.seekToEndOfFile()
                 self?.fileHandel?.write(data)
                if ((self?.delegate) != nil) {
                    self?.delegate?.downloadSubItemProgress(subItem: self!, complateValue: Int64(data.count))
                }
                
                
                 break
             case .finish:
                self?.fileHandel?.closeFile()
                if ((self?.delegate) != nil) {
                    self?.status = 3
                    self?.delegate?.downloadSubItemSuccess(subItem: self!)
                }
                
                self?.task?.cancel()
                self?.task = nil
                 break
             case .error:
                TiercelLog("download error = \(response!)")
                guard let error: URLError = response as? URLError else {
                    return
                }
                
                if error.code.rawValue == -999 {
                    return
                }
                
                if error.code.rawValue == -1005 || error.code.rawValue == -1009 || error.code.rawValue == -1001 {
                    if ((self?.delegate) != nil) {
                        self?.status = 4
                        self?.delegate?.downloadSubItemError(subItem: self!, errorMessage: "网络错误")
                    }
                    return
                }
                
                if ((self?.delegate) != nil) {
                    self?.status = 6
                    self?.delegate?.downloadSubItemError(subItem: self!, errorMessage: "网络错误")
                }
                 break
             @unknown default:
                break
            }
         }
    }
    
    func delete() {
        status = 5
    }
    
    func cancel() {
        task?.cancel()
    }
    
    func pause() {
        if status == 2 {
            status = 1
            delegate = nil
            task?.cancel()
        }
    }
    
    func cache() {
        
    }
}
