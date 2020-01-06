//
//  GCDStream.h
//  GCDStream
//
//  Created by AquaJava on 2017. 04. 07..
//  Copyright © 2017. IDJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GCDStreamDelegate;

@interface GCDStream : NSObject

@property id<GCDStreamDelegate> delegate;
@property dispatch_queue_t delegate_queue;

@property (readonly) NSInputStream* inStream;
@property (readonly) NSOutputStream* outStream;

+ (GCDStream*)gcdStreamWithInputStream:(NSInputStream*)inStream;
+ (GCDStream*)gcdStreamWithOutputStream:(NSOutputStream*)outStream;
+ (GCDStream*)gcdStreamWithInputStream:(NSInputStream*)inStream outputStream:(NSOutputStream*)outStream;

- (void)open;
- (void)writeData:(NSData*)data;
- (void)close;

@end

@protocol GCDStreamDelegate <NSObject>

@optional
- (void) gcdStream:(GCDStream*)gcdstream didReceiveData:(NSData*)data;
- (void) gcdStream:(GCDStream*)gcdstream didOpenStream:(NSStream*)stream;
- (void) gcdStream:(GCDStream*)gcdstream streamEndEncountered:(NSStream*)stream;
- (void) gcdStream:(GCDStream*)gcdstream errorOccured:(NSError*)error withStream:(NSStream*)stream;

@end
