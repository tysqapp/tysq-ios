//
//  BrowserURLSessionManager.m
//  WebBrowser
//
//  Created by gm on 2018/9/20.
//  Copyright © 2019 sheQun. All rights reserved.
//

#import "BrowserURLSessionManager.h"
#import "SheQu-Swift.h"

@interface BrowserURLSessionModel:NSObject

@property (nonatomic, copy) BrowserURLSessionCallBack callBack;

@end

@implementation BrowserURLSessionModel
- (void)dealloc{
    //DDLogDebug(@"BrowserURLSessionModel 释放了");
}
@end

@interface BrowserURLSessionManager ()<NSURLSessionTaskDelegate,NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) NSMutableDictionary *models;

@end
@implementation BrowserURLSessionManager
static BrowserURLSessionManager * _sessionManager = nil;

- (NSMutableDictionary *)models{
    if (!_models) {
        _models = [[NSMutableDictionary alloc] init];
    }
    
    return _models;
}

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sessionManager) {
            _sessionManager = [[BrowserURLSessionManager alloc] init];
        }
    });
    
    return _sessionManager;
}

- (instancetype)init{
    
    static dispatch_once_t onceToken;
    __block BrowserURLSessionManager * blockSelf = self;
    dispatch_once(&onceToken, ^{
        blockSelf = [super init];
        blockSelf.session = [NSURLSession
        sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                             delegate:blockSelf
                             delegateQueue:[NSOperationQueue currentQueue]];
    });
    
    return blockSelf;
}

- (NSURLSessionDataTask *)startRequest:(NSURLRequest *)request callBack:(BrowserURLSessionCallBack)callBack{
    
    BrowserURLSessionModel *model  = [[BrowserURLSessionModel alloc] init];
    model.callBack = callBack;
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request];
    [self.models setObject:model forKey:dataTask];
    [dataTask resume];
    return dataTask;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    BrowserURLSessionModel *model = nil;
    if ([self.models.allKeys containsObject:task]) {
        model = self.models[task];
        [self.models removeObjectForKey:task];
    }
    if (model) {
        if (error) {
//            NSLog(@"URLSession:->%@",error);
            model.callBack(BrowserURLSessionStateError, error);
            return;
        }
        model.callBack(BrowserURLSessionStateFinish, error);
    }
    [task cancel];
    task = nil;
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    BrowserURLSessionModel *model = nil;
    if ([self.models.allKeys containsObject:dataTask]) {
        model = self.models[dataTask];
    }
    if (model) {
        model.callBack(BrowserURLSessionStateRespond, response);
    }
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    BrowserURLSessionModel *model = nil;
    if ([self.models.allKeys containsObject:dataTask]) {
        model = self.models[dataTask];
    }
    if (model) {
        model.callBack(BrowserURLSessionStateReciveData, data);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    completionHandler(nil);
}

//- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
//    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){//服务器信任证书
//        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];//服务器信任证书
//        if(completionHandler)
//            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
//    }
//}


@end
