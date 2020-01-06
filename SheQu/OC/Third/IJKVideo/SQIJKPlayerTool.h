//
//  SQIJKPlayerTool.h
//  SheQu
//
//  Created by gm on 2019/6/18.
//  Copyright © 2019 sheQun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
NS_ASSUME_NONNULL_BEGIN
typedef void (^SQIJKPlayerToolCallBack)(id<IJKMediaPlayback> player);

@interface SQIJKPlayerTool : NSObject
@property(atomic, retain) id<IJKMediaPlayback> player;
@property(nonatomic, assign) BOOL isPlayError;
- (instancetype)initWithURL:(NSURL *)url callBack:(SQIJKPlayerToolCallBack) callBack;
- (void)removePlayer;
-(void)removeMovieNotificationObservers;
- (void)play;
- (void)pause;
@end

NS_ASSUME_NONNULL_END
