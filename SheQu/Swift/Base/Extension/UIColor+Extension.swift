//
//  UIColor+Extension.swift
//  SheQu
//
//  Created by gm on 2019/4/22.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// 通过rgb设置颜色
    ///
    /// - Parameters:
    ///   - red: 红色
    ///   - green: 绿色
    ///   - blue: 蓝色
    /// - Returns: 由传入红绿蓝组合的颜色
    class func colorWithRGB(_ red: CGFloat,_ green: CGFloat,_ blue: CGFloat) -> (UIColor) {
        let color = UIColor.init(red: (red/255), green: (green/255), blue: (blue/255), alpha: 1)
        return color
    }
    
    
    /// 通过传入的红绿蓝位数组合成的数据，返回组合成的颜色
    ///
    /// - Parameter value: 16进制的w红绿蓝数据
    /// - Returns: 组合成的颜色
    class func colorRGB(_ value:UInt32) -> (UIColor) {
        let color = UIColor.init(red: (((CGFloat)((value & 0xFF0000) >> 16)) / 255.0), green: (((CGFloat)((value & 0xFF00) >> 8)) / 255.0), blue: ((CGFloat)(value & 0xFF) / 255.0), alpha: 1)
        return color
    }
    
    
}
