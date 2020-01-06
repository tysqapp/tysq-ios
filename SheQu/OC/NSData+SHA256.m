//
//  NSData+SHA256.m
//  SheQu
//
//  Created by gm on 2019/6/12.
//  Copyright © 2019 sheQun. All rights reserved.
//

#import "NSData+SHA256.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSData (SHA256)
- (NSString *)sha256 {
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(self.bytes, (CC_LONG)self.length, digest);
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH *2];
    for(int i =0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}
@end
