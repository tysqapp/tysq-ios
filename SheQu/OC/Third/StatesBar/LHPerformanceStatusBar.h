//
//  LHPerformanceStatusBar.h
//  
//
//  Created by Leo on 2016/12/26.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHPerformanceLabel.h"

@interface LHPerformanceStatusBar : UIView

@property (strong, nonatomic) LHPerformanceLabel * fpsLabel;

@property (strong, nonatomic) LHPerformanceLabel * memoryLabel;

@property (strong, nonatomic) LHPerformanceLabel * cpuLabel;

- (NSArray<LHPerformanceLabel *> *)subLabels;
@end
