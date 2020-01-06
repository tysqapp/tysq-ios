//
//  Downloader.swift
//  NetWorkDemo
//
//  Created by gm on 2018/6/19.
//  Copyright © 2018年 gm. All rights reserved.
// 网络下载类

import Foundation

enum CallBackState{
    case recive
    case finish
};
typealias RespondCallBack = (URLResponse)->()
typealias CompletionCallBack = (NSData,NSData,CallBackState)->()
typealias FailedCallBack     = (NSError)->()
typealias reciveDataCallBack = (NSData)->()
class Downloader:NSObject,URLSessionDelegate,URLSessionTaskDelegate,URLSessionDataDelegate{
    
    var sessionTask:URLSessionTask?
    var respondData:NSMutableData?
    var session:URLSession?
    var respondCallBack:RespondCallBack?
    var completionCallBack:CompletionCallBack?
    var faildCallBack:FailedCallBack?
    
    open func downloadWithURL(_ downLoadUrl:String,_ request:URLRequest,_ respondCallBack:@escaping RespondCallBack,_ completionCallBack:@escaping CompletionCallBack,_ faildCallBack:@escaping FailedCallBack){
        self.faildCallBack = faildCallBack
        self.completionCallBack = completionCallBack
        self.respondCallBack    = respondCallBack
        netWorkRequest(request)
    }
    
    
    
    func respond(_ obj:Any?){
        let response:URLResponse? = obj as? URLResponse
        if((self.respondCallBack) != nil){
            if((response) != nil){
                self.respondCallBack!(response!)
            }
        }
        self.respondData = NSMutableData.init()
    }
    
    func receiveData(_ obj:Any?){
        let data:Data = obj as! Data
        if((self.completionCallBack) != nil){
            self.completionCallBack!(data as NSData,self.respondData!,CallBackState.recive)
            self.respondData?.append(data)
        }
    }
    
    func complate(_ obj:Any?){
        let error:Error? = obj as? Error
        if(error != nil){
            if((self.faildCallBack) != nil){
                self.faildCallBack!(error! as NSError)
            }
        }else{
            if((self.completionCallBack) != nil){
                self.completionCallBack!(self.respondData!,self.respondData!,CallBackState.finish)
            }
        }
    }
    
    func netWorkRequest(_ request:URLRequest){
        
        weak var weakSelf = self;
        let manager = BrowserURLSessionManager.shareInstance()
        self.sessionTask = manager.start(request, callBack: { (state, obj) in
            switch(state){
            case .respond:
                 weakSelf?.respond(obj)
                break;
            case .reciveData:
                 weakSelf?.receiveData(obj)
                break;
            case .finish:
                weakSelf?.complate(obj)
                break;
            case .error:
                weakSelf?.complate(obj)
                break;
            @unknown default:
                break
            }
        })
    }
    
    deinit {
        debugPrint("网络下载释放了")
    }
    
    open func pouse(){
      
        if (self.sessionTask != nil) {
            self.sessionTask?.cancel()
            self.sessionTask = nil
        }
        self.respondData = nil
    }
}
