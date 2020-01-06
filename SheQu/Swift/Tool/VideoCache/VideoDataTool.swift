//
//  VideoDataTool.swift
//  SheQu
//
//  Created by gm on 2019/10/15.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
import CocoaAsyncSocket
class VideoDataTool: NSObject {
    ///负载均衡域名
    static var LoadBalancingHost = ""
    
    static func startRequsetData(_ requestStr: String,_ request: URLRequest, localSocket: GCDAsyncSocket) {
        TiercelLog("VideoDataToolrequestStr \(requestStr)")
        if requestStr.lowercased().hasSuffix(".ts") {
            let tsData = CacheTSFileData.getDataFrom(requestPath: requestStr)
            ///判断本地是否有ts文件缓存
            if tsData.count > 1 {
                let headerData = CacheTSFileData.getHeaderStr(from: requestStr)
                
                respond(data: headerData, localSocket: localSocket)
                respond(data: tsData, localSocket: localSocket, isFinish: true)
                return
            }
        }
        
        if requestStr.lowercased().hasSuffix(".m3u8") {
            TiercelLog("从本地读取 \(requestStr)")
            let m3u8Data = CacheM3U8FileData.getDataFrom(requestPath: requestStr)
            ///判断本地是否有m3u8文件缓存
            if m3u8Data.count > 5 {
                let headerData = CacheM3U8FileData.getHeaderStr(from: requestStr)
                
                respond(data: headerData, localSocket: localSocket)
                
                //TiercelLog("\n\nheaderData = \(String.init(data: headerData, encoding: .utf8) ?? "") m3u8Data == \(String.init(data: m3u8Data, encoding: .utf8) ?? "")")
                respond(data: m3u8Data, localSocket: localSocket, isFinish: true)
               return
            }
            
        }
        
        
        startDownload(requestStr, request, localSocket: localSocket)
    }
    
   private static func startDownload(_ requestStr: String,_ request: URLRequest, localSocket: GCDAsyncSocket) {
        
        var responseStr = ""
        DownloaderManager.shareInstance.downLoadUrl(requestStr, request, { (error) in
            let httpStr = "HTTP/1.1 \(error.code) \(error.description)\r\n"
            let data = httpStr.data(using: .utf8)
            localSocket.write(data, withTimeout: -1, tag: LocalServer.State.readLocalSocket.rawValue)
        }, { (response) in
            guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse else {
                return
            }
            
            responseStr = getHeaderStr(httpResponse: httpResponse)
            let responseData = responseStr.data(using: .utf8) ?? Data()
            respond(data: responseData, localSocket: localSocket)
            cache(headerStr: responseStr, cachePath: requestStr)
        }) { (currentData, allData, state) in
            if state == .finish {
                cache(videoData: allData as Data, cachePath: requestStr)
                localSocket.readData(withTimeout: -1, tag: LocalServer.State.readLocalSocket.rawValue)
            }else{
                var valueStr = String.init(data: currentData as Data, encoding: .utf8) ?? ""
                
                var writeData: Data = currentData as Data
                if valueStr.hasPrefix("<a href=") && valueStr.hasSuffix("Found</a>.\n\n") {
                    valueStr = valueStr.replacingOccurrences(of: SQHostStruct.getLoaclHost(), with: LocalServer.getLocalServer())
                    writeData = valueStr.data(using: .utf8) ?? Data()
                }
                
                if responseStr.lowercased().contains("gzip") {
                    writeData = writeData.toZipData() ?? Data()
                }
                //TiercelLog("\n\nwriteData DataLength = \(writeData.count) currentDataValue = \(valueStr)")
                respond(data: writeData, localSocket: localSocket)
            }
        }
    }
    
    private static func getHeaderStr(httpResponse: HTTPURLResponse)-> String {
        var httpStr = "HTTP/1.1 \(httpResponse.statusCode) OK\r\n"
        var contentLength = ""
        var location      = ""
       for key in httpResponse.allHeaderFields.keys {
           
           guard let keyStr: String = key as? String else {
               continue
           }
           
           guard var valueStr: String = httpResponse.allHeaderFields[keyStr] as? String else {
               continue
           }
           
            if keyStr.lowercased().contains("content-encoding") {
                continue
            }
        
           if keyStr.lowercased() == "location" {
            /**
             处理负载均衡逻辑
             eg. https://www.baidu.com/search=md
             1. 先去除服务器
             变为/search=md
             2.切换为本地服务器
             变为http://127.0.0.1/search=md
             */
            let httpServer = VideoDataTool.urlStrRemoveServer(urlStr: valueStr)
            VideoDataTool.LoadBalancingHost = httpServer.0
            valueStr = httpServer.1
            valueStr = LocalServer.getLocalServer() + valueStr
            location = valueStr
           }
           
           httpStr.append(keyStr)
           httpStr.append(": ")
           httpStr.append(valueStr)
           httpStr.append("\r\n")
           if keyStr.lowercased().contains("content-length"){
               contentLength.append(keyStr)
               contentLength.append(": ")
               contentLength.append(contentsOf: valueStr)
           }
       }
       
       httpStr.append("\r\n")
       
       if httpResponse.statusCode == 302 || httpResponse.statusCode == 301 {
           var contentLengthTemp = "Content-Length"
           let contentValue = location.count + 23
           contentLengthTemp.append(": \(contentValue)")
           httpStr = httpStr.replacingOccurrences(of: contentLength, with: contentLengthTemp)
       }
        
       //TiercelLog("\n\nrespondHeaderStr = \(httpStr)")
       return httpStr
    }
    
    private static  func respond(data: Data, localSocket: GCDAsyncSocket, isFinish: Bool = false) {
        localSocket.write(
            data,
            withTimeout: -1,
            tag: LocalServer.State.expand.rawValue
        )
        
        if isFinish  {
            localSocket.readData(withTimeout: -1, tag: LocalServer.State.readLocalSocket.rawValue)
        }
    }
    
    private static func cache(headerStr: String, cachePath: String) {
        if cachePath.hasSuffix(".ts") {
            CacheTSFileData.cache(headerStr: headerStr, cachePath: cachePath)
        }
        
        if cachePath.hasSuffix(".m3u8") {
            CacheM3U8FileData.cache(headerStr: headerStr, cachePath: cachePath)
        }
    }
    
    private static func cache(videoData: Data, cachePath: String) {
        if cachePath.hasSuffix(".ts") {
            CacheTSFileData.cacheFileData(fileData: videoData, cachePath: cachePath)
        }
        
        if cachePath.hasSuffix(".m3u8") {
            CacheM3U8FileData.cacheFileData(fileData: videoData, cachePath: cachePath)
        }
    }
    
    
    ///url路径去掉服务器
    static func urlStrRemoveServer(urlStr: String) -> (String , String) {
        /**
         url路径去掉服务器
         逻辑
         eg. https://www.baidu.com/search=md
         变为 /search=md
         */
        
        let removeHttpArray = urlStr.components(separatedBy: "//")
        let httpStr = removeHttpArray.first ?? ""
        var  server = ""
        if httpStr.count > 0 {
            server.append(contentsOf: httpStr)
            server.append(contentsOf: "//")
        }
        
        /**
         domainStr 逻辑
         eg. https://www.baidu.com/search=md
         变为 www.baidu.com/search=md
         */
        let apiStr = removeHttpArray.last ?? ""
        let domainArray = apiStr.components(separatedBy: "/")
        let domain = domainArray.first ?? ""
        server.append(contentsOf: domain)
        
        if server != SQHostStruct.getLoaclHost() {
          TiercelLog("负载均衡地址 \(server)")
        }
        
        return (server,urlStr.replacingOccurrences(of: server, with: ""))
    }
}
