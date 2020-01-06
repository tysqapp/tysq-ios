//
//  SQCircleProgressView.h
//  SheQu
//
//  Created by gm on 2019/6/14.
//  Copyright © 2019 sheQun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SQCircleProgressView : UIView
///进度条颜色
@property(nonatomic,strong) UIColor *progerssColor;
///进度条背景颜色
@property(nonatomic,strong) UIColor *progerssBackgroundColor;
///进度条的宽度
@property(nonatomic,assign) CGFloat progerWidth;
///进度数据字体大小
@property(nonatomic,assign)CGFloat percentageFontSize;
///进度数字颜色
@property(nonatomic,strong) UIColor *percentFontColor;
///进度条数据
@property(nonatomic,assign) CGFloat progress;
@end

NS_ASSUME_NONNULL_END
