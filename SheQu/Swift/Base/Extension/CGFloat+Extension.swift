//
//  CGFloat+Extension.swift
//  SheQu
//
//  Created by gm on 2019/8/26.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

extension CGFloat {
    
    ///科学计数转化为浮点数
    func scientificCountsToFloat() -> String {
        var valueStr = "\(self)"
        if valueStr.contains("e") {
           valueStr = String.init(format: "%.f", self)
            if valueStr == "0" {
                valueStr = String.init(format: "%.8f", self)
            }
        }
        
        return valueStr
    }
}
