//
//  LHPerformanceLabel.m
//  
//
//  Created by Leo on 2016/12/26.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "LHPerformanceLabel.h"
@interface LHPerformanceLabel()

@property (strong,nonatomic)NSMutableDictionary * configCache;

@end

@implementation LHPerformanceLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    [self setTextColor:[UIColor colorWithRed:244.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] forState:LHPerformanceStateBad];
    [self setTextColor:[UIColor orangeColor] forState:LHPerformanceStateWarning];
    [self setTextColor:[UIColor colorWithRed:66.0/255.0 green:244.0/255.0 blue:89.0/255.0 alpha:1.0] forState:LHPerformanceStateGood];
    self.state = LHPerformanceStateGood;
}

- (NSMutableDictionary *)configCache{
    if (_configCache == nil) {
        _configCache = [[NSMutableDictionary alloc] init];
    }
    return _configCache;
}
- (void)setTextColor:(UIColor *)textColor forState:(LHPerformanceLabelState)state{
    if (textColor) {
        [self.configCache setObject:textColor forKey:@(state)];
    }else{
        [self.configCache removeObjectForKey:@(state)];
    }
}

- (UIColor *)textColorForState:(LHPerformanceLabelState)state{
    return [self.configCache objectForKey:@(state)];
}

- (void)setState:(LHPerformanceLabelState)state{
    _state = state;
    UIColor * color = [self textColorForState:state];
    self.textColor = color;
}

@end
