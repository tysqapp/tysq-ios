//
//  LHPerformanceConfig.m
//  LHPerformanceStatusBar
//
//  Created by huangwenchen on 2016/12/26.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "LHPerformanceConfig.h"

@implementation LHPerformanceConfig

+ (instancetype)defaultConfigForAttribtue:(LHPerformanceMonitorAttributes)attribute{
    if (attribute == LHPerformanceMonitorMemory) {
        return [self configWithGood:150.0 warning:200.0 lessIsBetter:YES];
    }
    if (attribute == LHPerformanceMonitorFPS) {
        return [self configWithGood:55.0 warning:40.0 lessIsBetter:NO];
    }
    if (attribute == LHPerformanceMonitorCPU) {
        return [self configWithGood:70.0 warning:90.0 lessIsBetter:YES];;
    }
    return nil;
}

+ (instancetype)configWithGood:(CGFloat)good warning:(CGFloat)warning lessIsBetter:(BOOL)lessIsBetter{
    LHPerformanceConfig * config = [[LHPerformanceConfig alloc] init];
    config.lessIsBetter = lessIsBetter;
    config.goodThreshold = good;
    config.warningThreadhold = warning;
    return config;
}
@end
