//
//  MSLog.swift
//  YueWan
//
//  Created by gm on 2019/11/26.
//  Copyright © 2019 SmartInspection. All rights reserved.
//

import Foundation

public enum LogLevel: Int {
    ///常规调试使用 比如 在某段代码后面 添加某段信息 看该段代码是否执行
    case debug      = 0
    ///数据信息返回使用 比如网络信息返回数据的打印
    case message    = 1
    ///错误信息log
    case error      = 2
    /// 特定调试的log 调试完后请删除
    case debugOnly  = 3
    /// 不需要打印log
    case none       = 4
}

/// 需要打印的log
public var outputLogs: [LogLevel] = [.debug,.message,.error]

public func MSLogMessage<T>(_ message: T, identifier: String? = nil,file: String = #file, line: Int = #line) {
    TiercelLog(message, identifier: identifier, logLevel: .message,file: file, line: line)
}

public func MSLogError<T>(_ message: T, identifier: String? = nil,file: String = #file, line: Int = #line) {
    TiercelLog(message, identifier: identifier, logLevel: .error,file: file, line: line)
}

public func MSLogDebugOnly<T>(_ message: T, identifier: String? = nil,file: String = #file, line: Int = #line) {
    TiercelLog(message, identifier: identifier, logLevel: .debugOnly,file: file, line: line)
}


public func TiercelLog<T>(_ message: T, identifier: String? = nil, logLevel: LogLevel = .debug,file: String = #file, line: Int = #line) {
    
    ///不需要log打印时
    if outputLogs.contains(.none) {
        return
    }
    
    ///如果包涵了要打印的log
    if outputLogs.contains(logLevel) {
        print("***************iOSDebug****************")
        
        let threadNum = (Thread.current.description as NSString).components(separatedBy: "{").last?.components(separatedBy: ",").first ?? ""
    
            var log =  "Source     :  \((file as NSString).lastPathComponent)[\(line)]\n" +
                       "Thread     :  \(threadNum)\n"
            if let identifier = identifier {
                log += "identifier :  \(identifier)\n"
            }
            log +=     "Info       :  \(message)"
            print(log)
            print("")
    }
}
