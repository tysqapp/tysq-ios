//
//  GCDStream.m
//  GCDStream
//
//  Created by AquaJava on 2017. 04. 07..
//  Copyright © 2017. IDJ. All rights reserved.
//

#import "GCDStream.h"

@interface GCDStream()<NSStreamDelegate>

@property NSInputStream* inStream;
@property NSOutputStream* outStream;

@end

@implementation GCDStream {
    dispatch_queue_t readQueue;
    dispatch_queue_t writeQueue;
    
    NSMutableData* writeData;
    
    long byteIndex;
}

+ (GCDStream*)gcdStreamWithInputStream:(NSInputStream*)inStream {
    GCDStream* stream = [[GCDStream alloc] init];
    stream.inStream = inStream;
    
    return stream;
}

+ (GCDStream*)gcdStreamWithOutputStream:(NSOutputStream*)outStream {
    GCDStream* stream = [[GCDStream alloc] init];
    stream.outStream = outStream;
    
    return stream;
}

+ (GCDStream*)gcdStreamWithInputStream:(NSInputStream*)inStream outputStream:(NSOutputStream*)outStream {
    GCDStream* stream = [[GCDStream alloc] init];
    stream.inStream = inStream;
    stream.outStream = outStream;
    
    return stream;
}

- (id)init {
    if (self = [super init]) {
        readQueue = dispatch_queue_create("hu.idj.gcdstream.read", DISPATCH_QUEUE_SERIAL);
        writeQueue = dispatch_queue_create("hu.idj.gcdstream.write", DISPATCH_QUEUE_SERIAL);
        
        writeData = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (void)open {
    byteIndex = 0;
    
    if (self.inStream) {
        [self.inStream setDelegate:self];
        [self.inStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [self.inStream open];
    }
    
    if (self.outStream) {
        [self.outStream setDelegate:self];
        [self.outStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [self.outStream open];
    }
}

- (void)writeData:(NSData*)data {
    if (self.outStream) {
        dispatch_async(writeQueue, ^{
            [writeData appendData:data];
            
            if ([self.outStream hasSpaceAvailable]) {
                [self writeToOutStream];
            }
        });
    }
}

- (void)close {
    if (self.inStream) {
        [self closeStream:self.inStream];
    }
    
    if (self.outStream) {
        [self closeStream:self.outStream];
    }
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch(eventCode) {
        case NSStreamEventHasSpaceAvailable:
        {
            dispatch_async(writeQueue, ^{
                [self writeToOutStream];
            });
            
            break;
        }
            
        case NSStreamEventHasBytesAvailable:
        {
            dispatch_async(readQueue, ^{
                uint8_t buf[1024];
                NSInteger len = 0;
                len = [(NSInputStream *)self.inStream read:buf maxLength:1024];
                
                if (len) {
                    NSData* data = [NSData dataWithBytes:(const void *)buf length:len];
                    
                    dispatch_async([self getDelegateQueue], ^{
                        [self.delegate gcdStream:self didReceiveData:data];
                    });
                }
            });
            
            break;
        }
            
        case NSStreamEventErrorOccurred:
        {
            dispatch_async([self getDelegateQueue], ^{
                [self.delegate gcdStream:self errorOccured:aStream.streamError withStream:aStream];
            });
            
            [self closeStream:aStream];
            
            break;
        }
            
        case NSStreamEventOpenCompleted:
        {
            dispatch_async([self getDelegateQueue], ^{
                [self.delegate gcdStream:self didOpenStream:aStream];
            });
            
            break;
        }
            
        case NSStreamEventEndEncountered:
        {
            [self closeStream:aStream];
            
            dispatch_async([self getDelegateQueue], ^{
                [self.delegate gcdStream:self streamEndEncountered:aStream];
            });
            break;
        }
            
        case NSStreamEventNone:
        {
            break;
        }
    }
}

- (void)closeStream:(NSStream*)stream {
    [stream close];
    [stream removeFromRunLoop:[NSRunLoop currentRunLoop]
                       forMode:NSDefaultRunLoopMode];
    
    // clean up data
    if (stream == self.outStream) {
        [writeData setLength:0];
    }
}

- (void) writeToOutStream {
    if (byteIndex < writeData.length) {
        uint8_t *readBytes = (uint8_t *)[writeData mutableBytes];
        readBytes += byteIndex; // instance variable to move pointer
        long data_len = [writeData length];
        long len = ((data_len - byteIndex >= 1024) ?
                    1024 : (data_len-byteIndex));
        uint8_t buf[len];
        (void)memcpy(buf, readBytes, len);
        len = [self.outStream write:(const uint8_t *)buf maxLength:len];
        byteIndex += len;
    }
}

- (dispatch_queue_t)getDelegateQueue {
    if (self.delegate_queue) {
        return self.delegate_queue;
    } else {
        return dispatch_get_main_queue();
    }
}

@end
