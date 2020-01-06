//
//  SQToastTool.swift
//  SheQu
//
//  Created by gm on 2019/4/25.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQToastTool: NSObject {
    
    static func showToastMessage(_ message: String,_ canClick: Bool = true) {
        DispatchQueue.main.async {
            let showTips = SQShowTips()
            showTips.initWithView(keywindowView: UIApplication.shared.keyWindow!, text: message, duration: 2.0, canClick: canClick)
        }
    }
    
    
    /// 显示loading
    ///
    /// - Returns:
    @discardableResult
    static func showLoading() -> SQShowTips{
        let showTips = SQShowTips()
        DispatchQueue.main.async {
            showTips.tag = 1000
            showTips.initWithIndicatorWithView(view: UIApplication.shared.keyWindow!, withText: "Loading....")
            showTips.startTheView()
        }
        
        return showTips
    }
    
    static func hiddenLoading(_ showTips: SQShowTips) {
        DispatchQueue.main.async {
            showTips.stopAndRemoveFromSuperView()
        }
    }
}
