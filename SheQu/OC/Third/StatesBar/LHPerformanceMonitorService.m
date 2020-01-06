//
//  QTFPSMonitor.m
//  
//
//  Created by Leo on 2016/12/26.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "LHPerformanceMonitorService.h"
#import "LHPerformanceStatusBar.h"
#import "LHPerformanceUtil.h"
#import "LHPerformanceConfig.h"

@interface LHPerformanceMonitorService()

@property (strong, nonatomic) CADisplayLink * displayLink;

@property (assign, nonatomic) NSTimeInterval lastTimestamp;

@property (assign, nonatomic) NSInteger countPerFrame;

@property (strong, nonatomic) LHPerformanceStatusBar * fpsStatusBar;

@property (strong, nonatomic) UIWindow * statusBarWindow;

@property (strong, nonatomic) NSMutableDictionary * configDictionary;

@end

@implementation LHPerformanceMonitorService

#pragma mark - Init
+ (instancetype)sharedService{
    static LHPerformanceMonitorService * sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LHPerformanceMonitorService alloc] init];
    });
    return sharedInstance;
}

- (NSMutableDictionary *)configDictionary{
    if (_configDictionary == nil) {
        _configDictionary = [NSMutableDictionary new];
        [_configDictionary setObject:[LHPerformanceConfig defaultConfigForAttribtue:LHPerformanceMonitorCPU]
                              forKey:@(LHPerformanceMonitorCPU)];
        [_configDictionary setObject:[LHPerformanceConfig defaultConfigForAttribtue:LHPerformanceMonitorFPS]
                              forKey:@(LHPerformanceMonitorFPS)];
        [_configDictionary setObject:[LHPerformanceConfig defaultConfigForAttribtue:LHPerformanceMonitorMemory]
                              forKey:@(LHPerformanceMonitorMemory)];
    }
    return _configDictionary;
}
- (instancetype)init{
    if (self = [super init]) {
        _lastTimestamp = -1;
        __weak LHPerformanceMonitorService * weakSelf = self;
        _displayLink = [CADisplayLink displayLinkWithTarget:weakSelf selector:@selector(envokeDisplayLink:)];
        _displayLink.paused = YES;
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        CGFloat fpsStatusBarY = [UIScreen mainScreen].bounds.size.height < 800 ? 0:30;
        
        _fpsStatusBar = [[LHPerformanceStatusBar alloc] initWithFrame:CGRectMake(0, fpsStatusBarY, [UIScreen mainScreen].bounds.size.width, 20.0)];
        //Notification
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationDidBecomeActiveNotification)
                                                     name: UIApplicationDidBecomeActiveNotification
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationWillResignActiveNotification)
                                                     name: UIApplicationWillResignActiveNotification
                                                   object: nil];
        self.statusBarWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20.0)];
        self.statusBarWindow.hidden = YES;
        self.statusBarWindow.windowLevel = UIWindowLevelAlert + 1;
        [self.statusBarWindow addSubview:self.fpsStatusBar];
    }
    return self;
}
- (void)dealloc{
    _displayLink.paused = YES;
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark - Private

- (void)_run{
    _displayLink.paused = NO;
    self.statusBarWindow.hidden = NO;
}

- (void)_stop{
    _displayLink.paused = YES;
    self.statusBarWindow.hidden = YES;
}

#pragma mark - DisplayLink hander

- (void)envokeDisplayLink:(CADisplayLink *)displayLink{
    if (_lastTimestamp == -1) {
        _lastTimestamp = displayLink.timestamp;
        return;
    }
    _countPerFrame ++;
    NSTimeInterval interval = displayLink.timestamp - _lastTimestamp;
    if (interval < 1) {
        return;
    }
    _lastTimestamp = displayLink.timestamp;
    CGFloat fps = _countPerFrame / interval;
    _countPerFrame = 0;
    self.fpsStatusBar.fpsLabel.text = [NSString stringWithFormat:@"FPS:%d",(int)round(fps)];
    self.fpsStatusBar.fpsLabel.state = [self labelStateWith:LHPerformanceMonitorFPS value:fps];
    
    CGFloat memory = [LHPerformanceUtil usedMemoryInMB];
    self.fpsStatusBar.memoryLabel.text = [NSString stringWithFormat:@"Memory:%.2fMB",memory];
    self.fpsStatusBar.memoryLabel.state = [self labelStateWith:LHPerformanceMonitorMemory value:memory];
    
    CGFloat cpu = [LHPerformanceUtil cpuUsage];
    self.fpsStatusBar.cpuLabel.text = [NSString stringWithFormat:@"CPU:%.2f%%",cpu];
    self.fpsStatusBar.cpuLabel.state = [self labelStateWith:LHPerformanceMonitorCPU value:cpu];
}

#pragma mark - Calculator

- (LHPerformanceLabelState)labelStateWith:(LHPerformanceMonitorAttributes)attribtue value:(CGFloat)currentValue{
    LHPerformanceConfig * config = [self.configDictionary objectForKey:@(attribtue)];
    if (!config.lessIsBetter) {
        if (currentValue > config.goodThreshold) {
            return LHPerformanceStateGood;
        }else if(currentValue > config.warningThreadhold){
            return LHPerformanceStateWarning;
        }else{
            return LHPerformanceStateBad;
        }
    }else{
        if (currentValue < config.goodThreshold) {
            return LHPerformanceStateGood;
        }else if(currentValue < config.warningThreadhold){
            return LHPerformanceStateWarning;
        }else{
            return LHPerformanceStateBad;
        }
    }
}
#pragma mark - Notification

- (void)applicationDidBecomeActiveNotification {
    _displayLink.paused = NO;
}

- (void)applicationWillResignActiveNotification {
    _displayLink.paused = YES;
}

#pragma mark - API

+ (void)run{
    [[LHPerformanceMonitorService sharedService] _run];
}

+ (void)stop{
    [[LHPerformanceMonitorService sharedService] _stop];
}

+ (void)setTextColor:(id)textColor forState:(LHPerformanceLabelState)state{
    [[LHPerformanceMonitorService sharedService].fpsStatusBar.subLabels enumerateObjectsUsingBlock:^(LHPerformanceLabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTextColor:textColor forState:state];
    }];
}

+ (void)setConfig:(LHPerformanceConfig *)config forAttribte:(LHPerformanceMonitorAttributes)attribtue{
    [[LHPerformanceMonitorService sharedService].configDictionary setObject:config forKey:@(attribtue)];
}
@end
