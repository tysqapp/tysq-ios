//
//  LHPerformanceTypes.h
//  LHPerformanceStatusBar
//
//  Created by huangwenchen on 2016/12/26.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,LHPerformanceLabelState){
    LHPerformanceStateGood,
    LHPerformanceStateWarning,
    LHPerformanceStateBad,
};

typedef NS_ENUM(NSInteger,LHPerformanceMonitorAttributes){
    LHPerformanceMonitorMemory,
    LHPerformanceMonitorCPU,
    LHPerformanceMonitorFPS,
};
