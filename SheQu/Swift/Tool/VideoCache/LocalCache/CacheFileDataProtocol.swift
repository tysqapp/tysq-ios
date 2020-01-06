//
//  CacheFileDataProtocol.swift
//  SheQu
//
//  Created by gm on 2019/10/17.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

protocol CacheFileDataProtocol: class {
    
    /// 从请求路径获取数据
    /// - Parameter requestPath: 文件数据
    static func getDataFrom(requestPath: String) -> Data;
    
    
    /// 缓存数据到缓存路径
    /// - Parameter fileData: 需要缓存的数据
    /// - Parameter path: 缓存路径
    static func cacheFileData(fileData: Data, cachePath: String);
    
    
    /// 缓存头部信息到缓存路径
    /// - Parameter headerStr: 请求头部
    /// - Parameter cachePath: 缓存路径
    static func cache(headerStr: String, cachePath: String);
    
    
    /// 通过请求路径获取头部字符串
    /// - Parameter requestPath: 请求路径
    static func getHeaderStr(from requestPath: String) -> Data;
}
