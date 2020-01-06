//
//  HGOrientationLabel.h
//  HGOrientationLabel
//
//  Created by Arch on 2018/4/11.
//  Copyright © 2018年 Arch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HGMaker;

typedef NS_ENUM(NSUInteger,textAlignType)
{
    textAlignType_top = 10,   // 顶部对齐
    textAlignType_left,       // 左边对齐
    textAlignType_bottom,     // 底部对齐
    textAlignType_right,      // 右边对齐
    textAlignType_center      // 水平/垂直对齐（默认中心对齐）
};

@interface HGOrientationLabel : UILabel

/**
 *  根据对齐方式进行文本对齐
 *
 *  @param alignType 对齐block
 */
- (void)textAlign:(void(^)(HGMaker *make))alignType;

@end


//工具类
@interface HGMaker : NSObject

/* 存放对齐样式 */
@property(nonatomic, strong) NSMutableArray *typeArray;

/**
 *  添加对齐样式
 */
- (HGMaker *(^)(textAlignType type))addAlignType;

@end
