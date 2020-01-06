//
//  BrowserURLSessionManager.h
//  WebBrowser
//
//  Created by gm on 2018/9/20.
//  Copyright © 2018年 钟武. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,BrowserURLSessionState){
    BrowserURLSessionStateRespond,
    BrowserURLSessionStateReciveData,
    BrowserURLSessionStateFinish,
    BrowserURLSessionStateError
};
typedef  void (^ BrowserURLSessionCallBack)(BrowserURLSessionState state,id _Nullable  obj);
NS_ASSUME_NONNULL_BEGIN

@interface BrowserURLSessionManager : NSObject
+ (instancetype)shareInstance;
- (NSURLSessionDataTask *)startRequest:(NSURLRequest *)request callBack:(BrowserURLSessionCallBack)callBack;
@end

NS_ASSUME_NONNULL_END
