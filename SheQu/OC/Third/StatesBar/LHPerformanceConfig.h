//
//  LHPerformanceConfig.h
//  LHPerformanceStatusBar
//
//  Created by huangwenchen on 2016/12/26.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LHPerformanceTypes.h"

@interface LHPerformanceConfig : NSObject

@property (assign,nonatomic)CGFloat goodThreshold;

@property (assign,nonatomic)CGFloat warningThreadhold;


/**
 Default is NO. So,if value is greater than goodThreshold,then it is good.Just like FPS，the higher,the better.
 */
@property (assign,nonatomic)BOOL lessIsBetter;

+ (instancetype)defaultConfigForAttribtue:(LHPerformanceMonitorAttributes)attribute;

+ (instancetype)configWithGood:(CGFloat)good warning:(CGFloat)warning lessIsBetter:(BOOL)lessIsBetter;

@end
