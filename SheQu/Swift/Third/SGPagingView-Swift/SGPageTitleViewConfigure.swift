//
//  SGPagingViewSwift
//  Version 0.0.6
//  GitHub：https://github.com/kingsic/SGPagingView-Swift
//
//  SGPageTitleViewConfigure.swift
//  SGPagingViewSwiftExample
//
//  Created by kingsic on 2018/9/12.
//  Copyright © 2018年 kingsic. All rights reserved.
//

import UIKit

enum IndicatorStyle : Int {
    case Default = 0    /// 下划线样式
    case Cover = 1      /// 遮盖样式
    case Fixed = 2      /// 固定样式
    case Dynamic = 3    /// 动态样式（仅在 IndicatorScrollStyle.Default 样式下支持）
}

enum IndicatorScrollStyle : Int {
    case Default = 0    /// 指示器位置跟随内容滚动而改变
    case Half = 1       /// 内容滚动一半时指示器位置改变
    case End = 2        /// 内容滚动结束时指示器位置改变
}

class SGPageTitleViewConfigure: NSObject {
    var selLineViewColor = UIColor.clear
    // MARK: - SGPageTitleView 属性
    /// SGPageTitleView 是否需要弹性效果，默认为 true
    var needBounces: Bool = true
    /// 是否显示底部分割线，默认为 true
    var showBottomSeparator: Bool = true
    /// SGPageTitleView 底部分割线颜色，默认为 lightGray
    var bottomSeparatorColor: UIColor = k_color_line_light
    
    // MARK: - 标题属性
    /// 标题文字字号大小，默认 15 号字体
    var titleFont: UIFont = UIFont.systemFont(ofSize: 15)
    /// 标题文字选中字号大小，默认 15 号字体。一旦设置此属性，titleTextZoom 属性将不起作用
    var titleSelectedFont: UIFont = UIFont.systemFont(ofSize: 15)
    /// 普通状态下标题文字的颜色，默认为黑色
    var titleColor: UIColor = .black
    /// 选中状态下标题文字的颜色，默认为红色
    var titleSelectedColor: UIColor = .white
    /// 选中状态下背景图片
    var titleSelectedBGImageName = "home_btn_title_sel"
    /// 选中状态下未选中背景图片
    var titleUnSelectedBGImageName = "home_btn_title_unsel"
    /// 是否让标题文字具有渐变效果，默认为 false
    var titleGradientEffect: Bool = false
    /// 是否让标题文字具有缩放效果，默认为 false
    var titleTextZoom: Bool = false
    /// 标题文字缩放比，默认为 0.1f，取值范围 0.0 ～ 1.0f
    var titleTextZoomRatio: CGFloat = 0.1
    /// 标题额外增加的宽度，默认为 20.0f
    var titleAdditionalWidth: CGFloat = 20.0
    /// 标题之间的间距
    var titleMarginWidth:     CGFloat = 20.0
    ///btn宽度 如果btnWidth宽度不为-1 宽度为等宽 间距为0
    var btnWidth:     CGFloat = -1
    
    //MARK: - 指示器属性
    /// 是否显示指示器，默认为 true
    var showIndicator: Bool = false
    /// 指示器颜色，默认为红色
    var indicatorColor: UIColor = .red
    /// 指示器高度，默认为 2.0f
    var indicatorHeight: CGFloat = 2.0
    /// 指示器动画时间，默认为 0.1f，取值范围 0 ～ 0.3f
    var indicatorAnimationTime: TimeInterval = 0.1
    /// 指示器样式，默认为 Default
    var indicatorStyle: IndicatorStyle = .Default
    /// 指示器圆角大小，默认为 0.0f
    var indicatorCornerRadius: CGFloat = 0.0
    /// 指示器遮盖样式外的其他样式下指示器与底部之间的距离，默认为 0.0f
    var indicatorToBottomDistance: CGFloat = 0.0
    /// 指示器遮盖样式下的边框宽度，默认为 0.0f
    var indicatorBorderWidth: CGFloat = 0.0
    /// 指示器遮盖样式下的边框颜色，默认为 clear
    var indicatorBorderColor: UIColor = .clear
    /// 指示器遮盖、下划线样式下额外增加的宽度，默认为 0.0f；介于标题文字宽度与按钮宽度之间
    var indicatorAdditionalWidth: CGFloat = 0.0
    /// 指示器固定样式下宽度，默认为 20.0f；最大宽度并没有做限制，请根据实际情况妥善设置
    var indicatorFixedWidth: CGFloat = 20.0
    /// 指示器动态样式下宽度，默认为 20.0f；最大宽度并没有做限制，请根据实际情况妥善设置
    var indicatorDynamicWidth: CGFloat = 20.0
    /// 指示器滚动位置改变样式，默认为 Default
    var indicatorScrollStyle: IndicatorScrollStyle = .Default
    
    // MARK: - 标题间分割线属性
    /// 是否显示标题间分割线，默认为 false
    var showVerticalSeparator: Bool = false
    /// 标题间分割线颜色，默认为红色
    var verticalSeparatorColor: UIColor = .red
    /// 标题间分割线额外减少的高度，默认为 0.0f
    var verticalSeparatorReduceHeight: CGFloat = 0.0
    
    // MARK: - badge 相关属性
    /// badge 颜色，默认红色
    var badgeColor: UIColor = .red
    /// badge 尺寸大小，默认为 7.0f
    var badgeSize: CGFloat = 7.0
    /// badge 偏移量，默认（0，0）
    var badgeOff: CGPoint = .zero
}

