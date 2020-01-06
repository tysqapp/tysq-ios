//
//  NSData+SHA256.h
//  SheQu
//
//  Created by gm on 2019/6/12.
//  Copyright © 2019 sheQun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (SHA256)
- (NSString *)sha256;
@end

NS_ASSUME_NONNULL_END
