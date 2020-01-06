//
//  DownloaderManger.swift
//  NetWorkDemo
//
//  Created by gm on 2018/6/19.
//  Copyright © 2018年 gm. All rights reserved.
//

import Foundation

class DownloaderManager: NSObject {
    var cacheDictM:[String:Downloader] = NSMutableDictionary.init() as! [String : Downloader]
    var fialedCallBack:FailedCallBack?
    var bytesStr:String?

    //创建下载管理器单例
    static let shareInstance:DownloaderManager = {
        let instance = DownloaderManager.init()
        return instance
    }()
    
    open func downLoadUrl(_ requestStr:String,_ request:URLRequest,_ failedcallBack:@escaping FailedCallBack,_ respondCallBack:@escaping RespondCallBack,_ completionCallBack:@escaping CompletionCallBack){
        
        self.fialedCallBack = failedcallBack
        
        let requestKey = requestStr.toMD5String()
//        //检查是否正在下载
//        if(self.cacheDictM.keys.contains(requestKey)){//说明正在下载
//            return
//        }
        
        let  downLoad = Downloader.init()
        cacheDictM.updateValue(downLoad, forKey: requestKey)
        weak var weakSelf = self
        weak var weakDownLoad = downLoad
        downLoad.downloadWithURL(requestStr, request, { (respond:URLResponse) in
            respondCallBack(respond)
        }, { (_ respondData:NSData,receiveData:NSData,_ callBackState:CallBackState) in
            completionCallBack(respondData,receiveData,callBackState)
            if(CallBackState.finish == callBackState){
                weakDownLoad?.pouse()
               // weakSelf?.cacheDictM.removeValue(forKey: requestKey)
            }
        }) { (_ error:Error) in
            weakSelf?.cacheDictM.removeValue(forKey: requestKey)
            if((self.fialedCallBack) != nil){
                weakSelf?.fialedCallBack!(error as NSError)
            }
            weakDownLoad?.pouse()
        }
        
    }
    
    open func pauseRequestByUrl(_ requestStr:String){
        var  downLoad:Downloader?
        //检查是否正在下载
        let strKey = requestStr.toMD5String()
        if(self.cacheDictM.keys.contains(strKey)){//说明正在下载
            downLoad = self.cacheDictM[strKey]
            downLoad?.pouse()
            if(self.cacheDictM.keys.contains(strKey)){
                self.cacheDictM.removeValue(forKey: strKey)
            }
        }
    }
}

