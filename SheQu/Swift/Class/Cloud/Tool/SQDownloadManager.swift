//
//  SQDownloadManager.swift
//  SheQu
//
//  Created by gm on 2019/10/30.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQDownloadManager: NSObject {
    static var sourceIndex = 0
    static let sourceArray = [
    "http://47.52.203.206:9000/video/87a.mp4","http://api.gfs100.cn/upload/20180201/201802011545189269.mp4"
    
    ]
    
    static func appendDownload(filePath: String, dispPath: String, mineType: String) {
        SQToastTool.showToastMessage("已添加至下载列表")
        SQMutableDownloadManager.shareInstance.appendDownLoadPath( filePath, mineType: mineType, dispPath: dispPath)
    }
        
//        let downloadSessionManager =
//        AppDelegate.getAppDelegate().downLoadSessionManager
//        var tempString = filePath.encodeURLCodeStr()
//        if downloadSessionManager.tasks.contains(where: { $0.url.absoluteString.decodeURLCodeStr().encodeURLCodeStr() == tempString
//        }) {
//            return
//        }
//        tempString = SQDownloadManager.sourceArray[SQDownloadManager.sourceIndex]
//        SQDownloadManager.sourceIndex += 1
//        guard let requestUrl = URL.init(string: tempString) else {
//            return
//        }
//
//        ///
//
//
//        var urlRequest = URLRequest.init(url: requestUrl)
//        urlRequest.setValue("bytes=0-1", forHTTPHeaderField: "range")
//        DownloaderManager.shareInstance.downLoadUrl(tempString, urlRequest, { (error) in
//
//        }, { (response) in
//
//            guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse else {
//                return
//            }
//
//            for key in httpResponse.allHeaderFields.keys {
//                if key is String {
//                    let keyStr: String = key as! String
//                    if keyStr.lowercased() == "content-range" {
//                        let contentRange: String = httpResponse.allHeaderFields[keyStr] as! String
//                        let value: Int64 = Int64(contentRange.replacingOccurrences(of: "bytes 0-1/", with: "")) ?? 0
//                        TiercelLog(value)
//                        var chunkNum: Int64 = 2
//                        var chunkSize: Int64 = value
//                        if value < 1024 * 1024 * 2 {
//                            chunkNum = 1
//                            chunkSize = INT64_MAX
//                        }else{
//                            ///当>50兆 分四片线程下载
//                            if value > 1024 * 1024 * 50 {
//                                chunkNum = 4
//                            }
//
//                            chunkSize = Int64((value + 1) / chunkNum)
//                        }
//
//
//                        var end   =  chunkSize - 1
//                        var start: Int64 = 0
//                        var headerArray = [[String: String]]()
//                        var requestStrArray = [String]()
//                        while true {
//                            requestStrArray.append(tempString)
//                            if value <= end {
//                                let bytesStr = ["range": "bytes=\(start)-\(value)"]
//                                headerArray.append(bytesStr)
//                                break
//                            }else {
//                                let bytesStr = ["range": "bytes=\(start)-\(end)"]
//                                headerArray.append(bytesStr)
//                                start = end + 1
//                                end += chunkSize
//                            }
//                        }
//
//                    downloadSessionManager.multiDownload(
//                        requestStrArray,
//                        headers: headerArray,
//                        dispLink: dispPath,
//                        mineType: mineType, totalValue: value)
//
//                        ///发送通知 刷新下载界面
//                        NotificationCenter.default.post(name: k_noti_download, object: nil)
//                    }
//                }
//            }
//        }) { (_, _, _) in
//        }
//    }
}
