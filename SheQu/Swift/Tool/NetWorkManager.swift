//
//  NetWorkManager.swift
//  SheQu
//
//  Created by gm on 2019/4/24.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON
import ToastSwiftFramework

enum NetWorkState {
    case wifi
    case wwan
    case dissconnect
}

class NetWorkManager: NSObject {
    static let instance: NetWorkManager = NetWorkManager()
    static func getUserAgent() -> String {
        guard let sysDict = Bundle.main.infoDictionary else {
            return ""
        }
        
        let version: String = sysDict["CFBundleShortVersionString"] as! String
        let bundleID: String = sysDict["CFBundleIdentifier"] as! String
        let deviceVersion = UIDevice.current.systemVersion
        let userAgent = "SheQu/\(version) (\(bundleID);iOS/\(deviceVersion)) iphone"
        return userAgent
    }
    var network: NetworkReachabilityManager?
    
    lazy var networkListener:  NetworkReachabilityManager = {
        let networkListener = NetworkReachabilityManager()
        return networkListener!
    }()
    
    public class func shared() -> NetWorkManager {
        return instance
    }
    
    lazy var sessionManager: Session = {
        return self.createSessionManager()
    }()
    
    func createSessionManager() -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        let sessionManager = Session.default
        ///如果需要验证才需要
//        sessionManager.delegate.sessionDidReceiveChallenge = {
//            session,challenge in
//            return  (URLSession.AuthChallengeDisposition.useCredential,
//                     URLCredential(trust:challenge.protectionSpace.serverTrust!))
//        }
        return sessionManager
    }
    
    /// 网络请求，返回数据统一处理
    ///
    /// - Parameters:
    ///   - path: 请求路径
    ///   - platform: 请求平台
    ///   - method: 请求方法。默认get
    ///   - needShowTips: 是否显示加载提示框
    ///   - responseClass: 请求返回数据的模型
    ///   - successHandler: 请求成功回调
    ///   - failureHandler: 请求失败回调
    public class func request<T: HandyJSON>(path: String, parameters: [String: Any]?, method: HTTPMethod = .get , needShowTips: Bool = true,responseClass: T.Type, successHandler: ((T?,[String: Any]? )->())?, failureHandler: ((Int32,String)->())? = nil) {
        var urlString = SQHostStruct.host + path
        if path == k_url_version {
            /**
             切换获取版本号为固定接口
             */
            //urlString = SQHostStruct.host.replacingOccurrences(of: SQHostStruct.apiVersion, with: "") + "/" + k_url_version
            
            urlString = "https://app.tysqapp.com/config/ios.json"
        }
        
        var parametersTemp = parameters
        if method == .get {
            if (parameters != nil) {
                urlString.append("?")
                for (index,key) in parameters!.keys.enumerated() {
                    let value: String = parameters![key] as! String
                    urlString.append(key)
                    urlString.append("=")
                    urlString.append(value)
                    
                    if (index+1) != parameters?.keys.count {
                        urlString.append("&")
                    }
                }
                parametersTemp = nil
            }
        }
    
        
        let tempString = urlString.encodeURLCodeStr()
        let url = URL.init(string: tempString)
        if url == nil {
            return
        }
        
        var showTpis: SQShowTips? = nil
        if needShowTips {
            DispatchQueue.main.async {
              showTpis = SQToastTool.showLoading()
            }
        }
        
        
        var headers = HTTPHeaders()
        headers.update(
            name: "user-agent",
            value: NetWorkManager.getUserAgent()
        )
        NetWorkManager.shared().sessionManager.request( url!, method: method, parameters: parametersTemp, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if needShowTips {
                if showTpis != nil {
                    SQToastTool.hiddenLoading(showTpis!)
                }
            }
            if response.value is Dictionary<String, Any> {
                let valueDict = response.value as! [String : Any]
                if path == k_url_version { //单独处理升级
                    successHandler!(responseClass.deserialize(from: valueDict), valueDict)
                    return
                }
                let state: Int32 = valueDict["status"] as! Int32
                ///3997 积分不够  2995 邮箱为校验 3998 文章被删除 2994 金币数额不足 3996等级不够 3995 等级够但积分不够
                if state == 0 || state == 3997 || state == 3995 || state == 3996 || state == 3998 || state == 2995 || state == 2994 {
                    guard var dataDict = valueDict["data"] as? [String : Any] else {
                        successHandler!(T(),valueDict["data"] as? [String : Any])
                        return
                    }
                    var model = T()
                    
                    if dataDict.values.count > 0 {
                        var isArray = false
                        for value in dataDict.values {
                            if value is Array<Any> {
                                isArray = true
                                break
                            }
                        }
                        
                        if isArray {//判断返回值是数组还是字典
                            model  = responseClass.deserialize(from: dataDict) ?? T()
                        }else{
                            
                            for value in dataDict.values {
                                let dictValue: [String: Any]? = value as? [String : Any]
                                if dictValue != nil {
                                    model  = responseClass.deserialize(from: dictValue) ?? T()
                                    break
                                }
                            }
                        }
                    }
                    
                    dataDict["statu_netWork"] = state
                    successHandler!(model, dataDict)
                }else{
                    let reason = valueDict["reason"] as! String
                    if (failureHandler != nil) {
                        failureHandler!(state,reason)
                    }
                    
                    if state == 3997 || state == 3996 || state == 3995{ ///这个是积分/等级 不够错误 不需要弹出toast
                        return
                    }
                    
                    if state == 2999 || state == 2998{ /// 未登录状态不需要弹出错误提示
                       SQAccountModel.updateAccountModel(nil)
                        return
                    }
                
                    let message = "错误码:\(state)  \(reason)"
                    SQToastTool.showToastMessage(message)
                }
            }else{
                SQToastTool.showToastMessage("网络连接错误")
                if (failureHandler != nil) {
                    failureHandler!(404,"网络连接错误")
                }
            }
        }
        
    }
    
    func downLoad(_ urlStr: String, handel:@escaping ((Data,Bool) ->())){
        let urlString = SQHostStruct.host.replacingOccurrences(of: SQHostStruct.apiVersion, with: "") + "/" + urlStr
        
        AF.download(URL.init(string: urlString)!).responseData { (respondData) in
            
//            guard let data = respondData.result.value else {
//                 handel(Data(), false)
//                return
//            }
//
//            handel(data, true)
        }
        
    }
    
    func uploadDataToNetWork(_ chunk_number: Int,_ total_chunks: Int,_ chunks_size: Int,_ current_chunk_size: Int,_ total_size: Int,_ hash: String, filename: String,_ uploadfile: NSData, urlStr: String, handel:@escaping ((Int64, Alamofire.DataResponse<Any>?) ->())) -> Alamofire.UploadRequest {
        let urlString = SQHostStruct.host + urlStr
        let tempString = urlString.encodeURLCodeStr()
        
       let uploadRequest = AF.upload(multipartFormData: { (formData) in
        formData.append(InputStream.init(data: uploadfile as Data), withLength: UInt64(uploadfile.count), name: "uploadfile", fileName: filename, mimeType: "application/octet-stream")
            formData.append(chunk_number.toData(), withName: "chunk_number")
            formData.append(total_chunks.toData(), withName: "total_chunks")
            formData.append(chunks_size.toData(), withName: "chunk_size")
            formData.append(current_chunk_size.toData(), withName: "current_chunk_size")
            formData.append(hash.data(using: .utf8)!, withName: "hash")
            formData.append(filename.data(using: .utf8)!, withName: "filename")
            formData.append(total_size.toData(), withName: "total_size")
        },  to: URL.init(string: tempString)!, method: .post).responseJSON { (respond) in
                TiercelLog("upload succcess")
                handel(-100,respond)
            }.uploadProgress { (progress) in
                handel(progress.completedUnitCount, nil)
        }
        
        return uploadRequest
    }
    
    
    func startListeningNetWork(_ handel: @escaping ((NetWorkState) -> ())) {
        networkListener.listener = { networkReachabilityStatus in
            if networkReachabilityStatus == .reachable(.ethernetOrWiFi) ||  networkReachabilityStatus == .reachable(.wwan){
                if networkReachabilityStatus == .reachable(.ethernetOrWiFi) {
                    handel(.wifi)
                }else{
                    handel(.wwan)
                }
            }else{
                handel(.dissconnect)
            }
        }
        
        networkListener.startListening()
    }
}
