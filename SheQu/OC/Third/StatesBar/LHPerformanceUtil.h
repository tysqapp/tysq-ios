//
//  QTPerformanceUtil.h
//  
//
//  Created by Leo on 2016/12/26.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LHPerformanceUtil : NSObject

+ (CGFloat)usedMemoryInMB;

+ (CGFloat)cpuUsage;

@end
