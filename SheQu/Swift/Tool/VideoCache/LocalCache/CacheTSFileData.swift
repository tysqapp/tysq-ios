//
//  CacheTSFileData.swift
//  SheQu
//
//  Created by gm on 2019/10/17.
//  Copyright © 2019 sheQun. All rights reserved.
//

/**
https://demo0.tysqapp.com/api/files/250/fcb08b0a1a9fa4b00e9e008e20604aa0a02afb8bb1c0428212e051aa9dfefe8b/240p00000.ts
 
 https://demo0.tysqapp.com/api/files/250/fcb08b0a1a9fa4b00e9e008e20604aa0a02afb8bb1c0428212e051aa9dfefe8b/240p00001.ts
 
 https://demo0.tysqapp.com/api/files/250/fcb08b0a1a9fa4b00e9e008e20604aa0a02afb8bb1c0428212e051aa9dfefe8b/480p00000.ts
 
ts 缓存策略 ts文件有多个分辨率类型
 1.以分辨率前面部分+md5为文件夹1
 2.以分辨率为文件夹二
 3.以分辨率后面部分为文件名
*/

import UIKit

class CacheTSFileData: NSObject, CacheFileDataProtocol{
    static let DPArray = [
        "1080",
        "720",
        "480",
        "240"
    ]
    
    static func cache(headerStr: String, cachePath: String) {
        let pathInfo = getHeaderFileNameAndFilePathFrom(path: cachePath)
        
        for (_, fileName) in DPArray.enumerated().reversed() {
            if fileName == pathInfo.secondPath {
                break
            }
            
            let filePath = pathInfo.filePath + "/" + fileName
            
            VideoFileManger.shareInstance
                .deleteDataFromLocalFolder(
                    filePath,
                    pathInfo.fileName
            )
        }
        
        VideoFileManger.shareInstance.saveDataToLocalFolder(
            pathInfo.filePath + "/" + pathInfo.secondPath,
            pathInfo.fileName,
            headerStr
        )
    }
    
    static func getHeaderStr(from requestPath: String) -> Data {
       let pathInfo = getHeaderFileNameAndFilePathFrom(path: requestPath)

       var data = Data()
       for index in 0..<DPArray.count {
           let secondPath = DPArray[index]
           let filePath = pathInfo.filePath + "/" + secondPath
           data = VideoFileManger.shareInstance.getDataFromCache(
           filePath,
           pathInfo.fileName
           ) as Data
           
           if data.count > 0 {
               break
           }
           
           if pathInfo.secondPath == secondPath {
               break
           }
       }
       
        return data
    }
    
    
    /// 获取缓存本地数据 ts文件从1080 720 480 240
    /// - Parameter requestPath: 请求接口
    static func getDataFrom(requestPath: String) -> Data {
        let pathInfo = getFileNameAndFilePathFrom(path: requestPath)
        
        var data = Data()
        for index in 0..<DPArray.count {
            let secondPath = DPArray[index]
            let filePath = pathInfo.filePath + "/" + secondPath
            data = VideoFileManger.shareInstance.getDataFromCache(
            filePath,
            pathInfo.fileName
            ) as Data
            
            if data.count > 0 {
                TiercelLog("从本地读取 \(pathInfo.fileName)")
                break
            }
            
            if pathInfo.secondPath == secondPath {
                break
            }
        }
        
        return data
    }
    
    static func cacheFileData(fileData: Data, cachePath: String) {
        let pathInfo = getFileNameAndFilePathFrom(path: cachePath)
        
        for (_, fileName) in DPArray.enumerated().reversed() {
            if fileName == pathInfo.secondPath {
                break
            }
            
            let filePath = pathInfo.filePath + "/" + fileName
            VideoFileManger.shareInstance
                .deleteDataFromLocalFolder(
                    filePath,
                    pathInfo.fileName
            )
        }
        
        VideoFileManger.shareInstance.saveVideoDataToLocal(
            fileData as NSData,
            pathInfo.filePath + "/" + pathInfo.secondPath,
            pathInfo.fileName
        )
    }
    
    private static func getHeaderFileNameAndFilePathFrom(path: String) -> (filePath: String,secondPath: String,fileName: String) {
        let pathInfo = getFileNameAndFilePathFrom(path: path)
        let headerFileName = pathInfo.fileName.replacingOccurrences(of: ".ts", with: ".txt")
        return (
            pathInfo.filePath,
            pathInfo.secondPath,
            headerFileName
        )
    }
    
    private static func getFileNameAndFilePathFrom(path: String) -> (filePath: String, secondPath: String, fileName: String) {
        
        /**
         处理负载均衡 把远端服务器地址全部切换为本地数据源地址
         eg. 负载均衡服务器有
         [
         https://www.baidu1.com,
         https://www.baidu2.com
         ]
         那么对应的请求地址则为
         [
         https://www.baidu1.com/search=md,
         https://www.baidu2.com/search=md
         ]
         
         负载均衡是指服务器根据算法优化 选择一个地址给到客户端
         假如返回为https://www.baidu1.com/search=md
         那么我们首先去除服务器
         得到/search=md
         然后拼接上我们的数据源进行保存
         假如我们的服务器地址是
         https://www.baidu.com
         那么
         我们的保存地址就是
         https://www.baidu.com/search=md
         
         这样做的好处是
         1.不管是https://www.baidu1.com 或者 https://www.baidu2.com
         请求缓存到的数据 都可以从本地获取到缓存问价
         2.这样也可以兼容本地的多数据源处理
         */
        let apiStr = VideoDataTool.urlStrRemoveServer(urlStr: path)
        let urlStr = SQHostStruct.getLoaclHost() + apiStr.1
        
        /**ts 缓存策略
         ts 缓存策略 ts文件有多个分辨率类型
         1.以分辨率前面部分+md5为文件夹1
         2.以分辨率为文件夹二
         3.以分辨率后面部分为文件名
         */
        let pathArray = urlStr.components(separatedBy: "/")
        let lastPath  = pathArray.last ?? ""
        
        var filePath = ""
        var fileName = ""
        
        let lastPathArray = lastPath.components(separatedBy: "p")
        fileName = lastPathArray.last ?? ""
        let secondFilePath = lastPathArray.first ?? ""
        
        let filePathTemp = urlStr.replacingOccurrences(of: "/" + lastPath, with: "")
        filePath = filePathTemp.toMD5String()
        return (filePath,secondFilePath,fileName)
    }
}
