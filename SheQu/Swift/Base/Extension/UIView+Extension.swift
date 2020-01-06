//
//  UIView+Extension.swift
//  SheQu
//
//  Created by gm on 2019/4/22.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

extension UIView {
    
    
    /**
     * Takes a screenshot of the view with the given size.
     */
    func screenshot(_ size: CGSize, offset: CGPoint? = nil, quality: CGFloat = 1) -> UIImage? {
        assert(0...1 ~= quality)
        
        let offset = offset ?? .zero
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale * quality)
        drawHierarchy(in: CGRect(origin: offset, size: frame.size), afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /**
     * Takes a screenshot of the view with the given aspect ratio.
     * An aspect ratio of 0 means capture the entire view.
     */
    func screenshot(_ aspectRatio: CGFloat = 0, offset: CGPoint? = nil, quality: CGFloat = 1) -> UIImage? {
        assert(aspectRatio >= 0)
        
        var size: CGSize
        if aspectRatio > 0 {
            size = CGSize()
            let viewAspectRatio = frame.width / frame.height
            if viewAspectRatio > aspectRatio {
                size.height = frame.height
                size.width = size.height * aspectRatio
            } else {
                size.width = frame.width
                size.height = size.width / aspectRatio
            }
        } else {
            size = frame.size
        }
        
        return screenshot(size, offset: offset, quality: quality)
    }
    
    
    /// 添加圆角
    ///
    /// - Parameters:
    ///   - corners: 圆角的边
    ///   - radii: 半径
    ///   - borderWidth: 圆边线宽度
    ///   - borderColor: 圆边线的颜色
    func addRounded(corners: UIRectCorner, radii: CGSize, borderWidth: CGFloat, borderColor: UIColor) {
        let rounded = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: radii)
        rounded.lineWidth = borderWidth
        rounded.lineJoinStyle = .round
        borderColor.setStroke()
        rounded.stroke()
        let shape = CAShapeLayer.init()
        shape.path = rounded.cgPath
        self.layer.mask = shape
    }
    
    /// 根据所给View 获取所属的ViewController
    ///
    /// - Returns: View所属的ViewController
    func getViewController() -> UIViewController? {
        var view: UIView? = self
        while view != nil {
            view = view?.superview
            let nextResponder = view?.next
            if nextResponder?.isKind(of: UIViewController.self) ?? false {
                return (nextResponder as! UIViewController)
            }
        }
        return nil
    }
    
    
    
    /// 添加颜色渐变
    ///
    /// - Parameters:
    ///   - gradientColors: 颜色渐变数组
    ///   - gradientLocations: 颜色渐变的位置
    ///   - startPoint: 开始渐变点
    ///   - endPoint: 结束渐变点
    ///   - cornerRadius: 渐变颜色半径
    func addGradientColor( gradientColors: [CGColor], gradientLocations: [NSNumber], startPoint: CGPoint = CGPoint.init(x: 0, y: 0), endPoint: CGPoint = CGPoint.init(x: 0, y: 1), cornerRadius: CGFloat = 0)
    {
        //assert(gradientColors.count == gradientLocations.count, "颜色数组和颜色位置数组个数必须一致")
        let gradientColor = CAGradientLayer()
        gradientColor.frame = self.bounds
        gradientColor.colors    = gradientColors
        gradientColor.locations = gradientLocations
        gradientColor.startPoint = startPoint
        gradientColor.endPoint = endPoint
        gradientColor.cornerRadius = cornerRadius
        self.layer.addSublayer(gradientColor)
    }
    
    func left() -> CGFloat {
        return self.frame.origin.x;
    }
    
    
    func setLeft(x: CGFloat) {
        var frame = self.frame;
        frame.origin.x = x;
        self.frame = frame;
    }
    
    func top() -> CGFloat {
        return self.frame.origin.y;
    }
    
    func setTop(y: CGFloat) {
        var frame = self.frame;
        frame.origin.y = y;
        self.frame = frame;
    }
    
    func right() -> CGFloat {
        return self.frame.origin.x + self.frame.size.width;
    }
    
    func setRight(right: CGFloat) {
        var frame = self.frame;
        frame.origin.x = right - frame.size.width;
        self.frame = frame;
    }

    func bottom() -> CGFloat {
        return self.frame.origin.y + self.frame.size.height;
    }
    
    func setBottom(bottom: CGFloat) {
        var frame = self.frame;
        frame.origin.y = bottom - frame.size.height;
        self.frame = frame;
    }
    
    func centerX() -> CGFloat {
        return self.center.x;
    }
    
    func setCenterX(centerX: CGFloat){
        self.center = CGPoint.init(x: centerX, y: self.center.y)
    }
    
    func centerY() -> CGFloat {
        return self.center.y;
    }
    
    func setCenterY(centerY: CGFloat) {
        self.center = CGPoint.init(x: self.center.x, y: centerY);
    }

    func width() -> CGFloat {
    return self.frame.size.width;
    }
    
    func setWidth(width: CGFloat) {
        var frame = self.frame;
        frame.size.width = width;
        self.frame = frame;
    }
    
    func height() -> CGFloat {
        return self.frame.size.height;
    }

    func setHeight(height: CGFloat) {
        var frame = self.frame;
        frame.size.height = height;
        self.frame = frame;
    }
    
    func maxX() -> CGFloat {
        return self.frame.maxX
    }
    
    func maxY() -> CGFloat {
        return self.frame.maxY
    }
    
//    func ttScreenX() -> CGFloat {
//        let x: CGFloat = 0;
//        for (UIView* view = self; view; view = view.superview) {
//            x += view.left;
//        }
//        return x;
//    }
//
//
//    ///////////////////////////////////////////////////////////////////////////////////////////////////
//    - (CGFloat)ttScreenY {
//    CGFloat y = 0;
//    for (UIView* view = self; view; view = view.superview) {
//    y += view.top;
//    }
//    return y;
//    }
//
//
//    ///////////////////////////////////////////////////////////////////////////////////////////////////
//    - (CGFloat)screenViewX {
//    CGFloat x = 0;
//    for (UIView* view = self; view; view = view.superview) {
//    x += view.left;
//
//    if ([view isKindOfClass:[UIScrollView class]]) {
//    UIScrollView* scrollView = (UIScrollView*)view;
//    x -= scrollView.contentOffset.x;
//    }
//    }
//
//    return x;
//    }
//
//
//    ///////////////////////////////////////////////////////////////////////////////////////////////////
//    - (CGFloat)screenViewY {
//    CGFloat y = 0;
//    for (UIView* view = self; view; view = view.superview) {
//    y += view.top;
//
//    if ([view isKindOfClass:[UIScrollView class]]) {
//    UIScrollView* scrollView = (UIScrollView*)view;
//    y -= scrollView.contentOffset.y;
//    }
//    }
//    return y;
//    }
    
    
//    func screenFrame() -> CGRect {
//    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
//    }
    
    
    func origin() -> CGPoint{
    return self.frame.origin;
    }
    
    
    func setOrigin(origin: CGPoint) {
        var frame = self.frame;
        frame.origin = origin;
        self.frame = frame;
    }
    
    
    func size() -> CGSize {
        return self.frame.size;
    }
    
    
    func setSize(size: CGSize) {
        var frame = self.frame;
        frame.size = size;
        self.frame = frame;
    }
    
    func addShadowColor(
        shadowColor: UIColor,
        shadowOpacity: Float   = 0.5,
        shadowOffset: CGSize   = CGSize(width: -1, height: 4),
        shadowRadius: CGFloat  = 5) {
        layer.shadowColor   = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset  = shadowOffset
        layer.shadowRadius  = shadowRadius
    }
}
