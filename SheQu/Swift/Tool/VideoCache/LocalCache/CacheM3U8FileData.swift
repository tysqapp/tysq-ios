//
//  CacheM3U8FileData.swift
//  SheQu
//
//  Created by gm on 2019/10/17.
//  Copyright © 2019 sheQun. All rights reserved.
//
/**
 A:索引的索引
 https://demo0.tysqapp.com/api/files/250/fcb08b0a1a9fa4b00e9e008e20604aa0a02afb8bb1c0428212e051aa9dfefe8b.m3u8

 B:索引
 https://demo0.tysqapp.com/api/files/250/fcb08b0a1a9fa4b00e9e008e20604aa0a02afb8bb1c0428212e051aa9dfefe8b/240p.m3u8
  
 m3u8 缓存策略
 1.m3u8有两种文件格式 一种是不带分辨率类型如A 一种是带分辨率类型B
 A类型缓存以.m3u8前部分.md5为文件夹 all.m3u8为文件名
 B类型缓存以240p.m3u8前为1文件夹 240为二文件夹 240p.m3u8为文件名
 */


import UIKit

class CacheM3U8FileData: NSObject, CacheFileDataProtocol {
    static func cache(headerStr: String, cachePath: String) {
        let pathInfo = getHeaderFileNameAndFilePathFrom(path: cachePath)
        VideoFileManger.shareInstance.saveDataToLocalFolder(
            pathInfo.filePath,
            pathInfo.fileName,
            headerStr
        )
    }
    
    static func getHeaderStr(from requestPath: String) -> Data {
        let pathInfo = getHeaderFileNameAndFilePathFrom(path: requestPath)
        let headerData = VideoFileManger.shareInstance.getDataFromCache(
            pathInfo.filePath,
            pathInfo.fileName
        )
        
        return headerData as Data
    }
    
    static func getDataFrom(requestPath: String) -> Data {
        let pathInfo = getFileNameAndFilePathFrom(path: requestPath)
        return VideoFileManger.shareInstance.getDataFromCache(
            pathInfo.filePath,
            pathInfo.fileName
            ) as Data
    }
    
    static func cacheFileData(fileData: Data, cachePath: String) {
        let pathInfo = getFileNameAndFilePathFrom(path: cachePath)
        VideoFileManger.shareInstance.saveVideoDataToLocal(
            fileData as NSData,
            pathInfo.filePath,
            pathInfo.fileName
        )
    }
    
    private static func getHeaderFileNameAndFilePathFrom(path: String) -> (filePath: String,fileName: String) {
        let pathInfo = getFileNameAndFilePathFrom(path: path)
        let headerFileName = pathInfo.fileName.replacingOccurrences(of: ".m3u8", with: ".txt")
        return (pathInfo.filePath, headerFileName)
    }
    
    private static func getFileNameAndFilePathFrom(path: String) -> (filePath: String,fileName: String) {
        
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
        
        
        /**m3u8 缓存策略
         
         A:索引的索引
         https://demo0.tysqapp.com/api/files/250/fcb08b0a1a9fa4b00e9e008e20604aa0a02afb8bb1c0428212e051aa9dfefe8b.m3u8

         B:索引
         https://demo0.tysqapp.com/api/files/250/fcb08b0a1a9fa4b00e9e008e20604aa0a02afb8bb1c0428212e051aa9dfefe8b/240p.m3u8
         
        1.m3u8有两种文件格式 一种是不带分辨率类型如A 一种是带分辨率类型B
        A类型缓存以.m3u8前部分.md5为文件夹 all.m3u8为文件名
        B类型缓存以/240p.m3u8前前部分.md5文件夹  240p.m3u8为文件名
    
         */
        let pathArray = urlStr.components(separatedBy: "/")
        let lastPath  = pathArray.last ?? ""
        
        ///b类型最长为1080p.m3u8 如果长度小于15 则为b类型 反则为A类型
        var filePath = ""
        var fileName = ""
        if lastPath.count < 15 {
            fileName = lastPath
            let filePathTemp = urlStr.replacingOccurrences(of: "/" + lastPath, with: "")
            filePath = filePathTemp.toMD5String()
        }else{
            let fileNameTemp = lastPath.components(separatedBy: ".").last ?? ""
            fileName = "all." + fileNameTemp
            
            let filePathTemp = urlStr.replacingOccurrences(of: "." + fileNameTemp, with: "")
            filePath = filePathTemp.toMD5String()
        }
        
        return (filePath,fileName)
    }
    
}
