//
//  LocalServer.swift
//  SheQu
//
//  Created by gm on 2019/10/15.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

private class LocalSocketData: NSObject {
    var localScocket: GCDAsyncSocket?
    lazy var requestData = NSMutableData()
}


class LocalServer: NSObject {
    
    enum State: Int {
        ///从本地socket读取数据
        case readLocalSocket = 1
        ///拓展时使用
        case expand = 2
    }
    
    ///本地服务器地址
    let localServer = "127.0.0.1"
    private(set) var localPort: UInt16 = 8888
    var isLocalServerOpen = false
    ///本地服务器
    private var localSocket: GCDAsyncSocket?
    private lazy var socketDataArray = [LocalSocketData]()
    
    
    static let shareInstance:LocalServer = {
        let instance = LocalServer()
        return instance
    }()
    
    func startLocaLServer(_ localPort: UInt16 = 8888) {
        localSocket = GCDAsyncSocket.init(delegate: self, delegateQueue: DispatchQueue.init(label: "localServer"))
        localSocket?.isIPv4Enabled = true
        localSocket?.isIPv6Enabled = true
        self.localPort = localPort
        startOpenLocalServer()
    }
    
    
    /// 开启本地服务器
    private func startOpenLocalServer() {
        do {
            try localSocket?.accept(onInterface: localServer, port: localPort)
            isLocalServerOpen = true
        }catch{
            ///处理端口被占用情况
            localPort += 1
            startOpenLocalServer()
        }
    }
    
}



extension LocalServer: GCDAsyncSocketDelegate {
    
    
    /// 本地服务器收到新的socket请求
    /// - Parameter sock: 本地服务器sock
    /// - Parameter newSocket: 请求的sock
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        let sockData = LocalSocketData()
        sockData.localScocket = newSocket
        socketDataArray.append(sockData)
        newSocket.readData(
            withTimeout: -1,
            tag: LocalServer.State.readLocalSocket.rawValue
        )
    }
    
    
    /// 读取数数
    /// - Parameter sock: 返回数据socket
    /// - Parameter data: 读取数据
    /// - Parameter tag: 标记
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
    
        if data.count < 1 {
            return
        }
        
        guard let socketData = (socketDataArray.first { $0.localScocket == sock}) else {
            return
        }
        
        let state = LocalServer.State.init(rawValue: tag) ?? .expand
        if state == .readLocalSocket {
            socketData.requestData.append(data)
            let headerStr = String.init(data: socketData.requestData as Data, encoding: .utf8) ?? ""
            ///结束
            if headerStr.hasSuffix("\r\n\r\n") {
                let headerArray = headerStr.components(separatedBy: "\r\n")
                var headerDict  = [String: String]()
                var apiStr  = ""
                for subStr in headerArray {
                    if subStr.count < 1 {
                        continue
                    }
                    
                    if !subStr.contains(": ") {
                        let hostArray = subStr.components(separatedBy: " ")
                        apiStr.append(contentsOf: hostArray[1])
                        continue
                    }
                    
                
                    
                    let subStrArray = subStr.components(separatedBy: ": ")
                    let key: String   = subStrArray.first ?? ""
                    
                    var value: String = subStrArray.last ?? ""
                    if key.lowercased() == "host" {
                        value = SQHostStruct.getLoaclHostHostWithoutHTTP()
                    }
                    
                    headerDict[key] = value
                }
                
                let hostArray = apiStr.components(separatedBy: "?=host")
                if hostArray.count > 1 {
                    VideoDataTool.LoadBalancingHost = hostArray.last ?? ""
                    let realthPath = hostArray.first ?? ""
                    apiStr = VideoDataTool.LoadBalancingHost + realthPath
                }else{
                    apiStr = VideoDataTool.LoadBalancingHost + apiStr
                }
                
                let request = NSMutableURLRequest.init(url: URL.init(string: apiStr)!)
                request.allHTTPHeaderFields = headerDict
                request.setValue(NetWorkManager.getUserAgent(), forHTTPHeaderField: "user-agent")
                VideoDataTool.startRequsetData(apiStr, request as URLRequest, localSocket: sock)
                socketData.requestData = NSMutableData()
            }
        }
        
    }
    
    
    
    /// 本地服务器失败
    /// - Parameter sock: 断开连接socket
    /// - Parameter err: 失败原因
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        if sock == localSocket {
            isLocalServerOpen = false
        }
    }
    
    static func getLocalServerWithoutHttp() -> String {
        return LocalServer.shareInstance.localServer + ":\(LocalServer.shareInstance.localPort)"
    }
    
    static func getLocalServer() -> String {
        return "http://" + getLocalServerWithoutHttp()
    }
}
