//
//  LHPerformanceStatusBar.m
//  
//
//  Created by Leo on 2016/12/26.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "LHPerformanceStatusBar.h"

@implementation LHPerformanceStatusBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (NSArray<LHPerformanceLabel *> *)subLabels{
    return @[_fpsLabel,_memoryLabel,_cpuLabel];
}
- (void)setup{
    self.backgroundColor = [UIColor whiteColor];
    _fpsLabel = [[LHPerformanceLabel alloc] initWithFrame:CGRectZero];
    _fpsLabel.font = [UIFont systemFontOfSize:10];
    _fpsLabel.textColor = [UIColor whiteColor];
    _fpsLabel.text = @"FPS: d-";
    _fpsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_fpsLabel];
    
    _memoryLabel = [[LHPerformanceLabel alloc] initWithFrame:CGRectZero];
    _memoryLabel.font = [UIFont systemFontOfSize:10];
    _memoryLabel.textColor = [UIColor whiteColor];
    _memoryLabel.text = @"Memory:-";
    _memoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_memoryLabel];
    
    _cpuLabel = [[LHPerformanceLabel alloc] initWithFrame:CGRectZero];
    _cpuLabel.font = [UIFont systemFontOfSize:10];
    _cpuLabel.textColor = [UIColor whiteColor];
    _cpuLabel.text = @"CPU:-";
    _cpuLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_cpuLabel];
    
    //Layout
    NSDictionary * subviews = NSDictionaryOfVariableBindings(_fpsLabel,_memoryLabel,_cpuLabel);
    //CenterY
    for (UIView * label in subviews.allValues) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0]];
    }
    //CenterX
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_memoryLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_fpsLabel]-8-[_memoryLabel]-8-[_cpuLabel]" options:0 metrics:nil views:subviews]];
}

@end
