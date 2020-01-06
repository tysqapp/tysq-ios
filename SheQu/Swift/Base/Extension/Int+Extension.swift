//
//  Int+Extension.swift
//  SheQu
//
//  Created by gm on 2019/5/19.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

extension Int {
    /// 根据规则显示需要展示的数据信息
    ///
    /// - Parameter num: 需要展示的数据
    /// - Returns: 根据规则返回的字符串
    func getShowString() -> String{
        if self == 0 {
            return "0"
        }
        
        if self < 10000 {
            return "\(self)"
        }
        
        let showNum: CGFloat = CGFloat(self) / 10000.0
        return String.init(format: "%.1fW", showNum)
    }
    
     func toData()->Data {
        let myIntData = "\(self)".data(using: .utf8)
        return myIntData!
    }
    
    ///10000 1,00,00
    func toEuropeanType(_ number: Int) -> String {
        var tempValueStr: NSString = "\(self)" as NSString
        var valueStr  = ""
        
        while true {
            if tempValueStr.length <= number {
                valueStr = (tempValueStr as String) + valueStr
                break
            }else{
                let location = tempValueStr.length - number
                let range = NSRange.init(location: location, length: number)
                let subStr = tempValueStr.substring(with: range)
                valueStr = "," + subStr + valueStr
                tempValueStr = tempValueStr.substring(to: location) as NSString
            }
        }
        
        return valueStr
    }
}
