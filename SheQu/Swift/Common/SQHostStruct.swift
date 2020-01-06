//
//  SQHostStruct.swift
//  SheQu
//
//  Created by gm on 2019/8/14.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit


/// 域名详情
class SQHostStruct: NSObject {
    
    ///本地测试
    #if DEBUG_LOCAL
    static let httpHead    = "http://"
    static let apiVersion  = "/api/"
    #else
    #if DEBUG
    static let httpHead   = "https://"
    static let apiVersion = "/api/v5/"
    #else
    static let httpHead   = "https://"
    static let apiVersion = "/api/v5/"
    #endif
    #endif
    
    
    static let localHostUD = "localHostUD"
    
    static let downloadApi = "/api/file/download/"
    ///域名
    static var host = ""
    
    static func getLoaclHost() -> String {
        guard let host: String  = UserDefaults.standard.object(forKey: SQHostStruct.localHostUD) as? String else { return "" }
        return host
    }
    
    static func updateLocalHost(_ localHost: String) {
        SQHostStruct.appendVersion(localHost)
        UserDefaults.standard.setValue(localHost, forKeyPath: SQHostStruct.localHostUD)
        UserDefaults.standard.synchronize()
    }
    
    static func appendVersion(_ host: String) {
        SQHostStruct.host = host + SQHostStruct.apiVersion
    }
    
    static func getLoaclHostHostWithoutHTTP() -> String {
        
        return getLoaclHost().replacingOccurrences(of: httpHead, with: "")
    }
    
    /// 切换远程url为本地url
    /// - Parameter remoteUrl: 远程url
    static func toLocalUrl(remoteUrl: String) -> String {
        return remoteUrl.replacingOccurrences(
            of: getLoaclHost(),
            with: "http://" + LocalServer.getLocalServerWithoutHttp()
        )
    }
}
