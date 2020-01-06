//
//  UIButton+Login.swift
//  SheQu
//
//  Created by gm on 2019/4/23.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit


/// 处理Uibutton 的拓展
extension UIButton{
    private static let gradientColors = [
        UIColor.colorRGB(0x36b6f9).cgColor,
        k_color_normal_blue.cgColor
    ]
    
    func updateBGColor(_ cornerRadius: CGFloat = 10){
        if isEnabled {
            let subView = UIView.init(frame: self.bounds)
            subView.tag = 100
            addSubview(subView)
            subView.addGradientColor(
                gradientColors: UIButton.gradientColors,
                gradientLocations: [(0),(1)],
                startPoint: CGPoint.init(x: 0, y: 0),
                endPoint: CGPoint.init(x: 1, y: 1),
                cornerRadius: cornerRadius)
            subView.isUserInteractionEnabled = false
            bringSubviewToFront(self.titleLabel!)
        }else{
          let view = viewWithTag(100)
          view?.removeFromSuperview()
        }
    }
    
}
