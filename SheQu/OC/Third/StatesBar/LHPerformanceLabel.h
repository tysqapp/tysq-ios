//
//  LHPerformanceLabel.h
//  
//
//  Created by Leo on 2016/12/26.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHPerformanceMonitorService.h"

@interface LHPerformanceLabel : UILabel

@property (assign, nonatomic)LHPerformanceLabelState state;

- (void)setTextColor:(UIColor *)textColor forState:(LHPerformanceLabelState)state;

- (UIColor *)textColorForState:(LHPerformanceLabelState)state;

@end
