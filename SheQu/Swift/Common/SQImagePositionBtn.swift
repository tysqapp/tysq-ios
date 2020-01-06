//
//  SQImagePositionBtn.swift
//  SheQu
//
//  Created by gm on 2019/7/24.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQImagePositionBtn: UIButton {
    enum ImagePosition {
        case top
        case left
        case right
        case bottom
    }
    
    lazy var customPosition = SQImagePositionBtn.ImagePosition.left
    lazy var customSize     = CGSize.zero
    
    private var ritghtMargin: CGFloat = 0
    
    init(frame: CGRect, position: ImagePosition = SQImagePositionBtn.ImagePosition.left, imageViewSize: CGSize = CGSize.zero, ritghtMargin: CGFloat = 0) {
        super.init(frame: frame)
        self.ritghtMargin = ritghtMargin
        customPosition = position
        customSize     = imageViewSize
        switch customPosition {
        
        case .top:
            break
        case .left:
            break
        case .right:
            contentHorizontalAlignment = .right
            break
        case .bottom:
            break
        
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch customPosition {
            
        case .top:
            break
        case .left:
            break
        case .right:
            layoutRight()
            break
        case .bottom:
            break
            
        }
    }
    
    func layoutRight() {
       
       let imageViewX   = width() - customSize.width
       imageView?.frame = CGRect.init(x: imageViewX, y: 0, width: customSize.width, height: height())
       titleLabel?.frame = CGRect.init(x: 0, y: 0, width: imageViewX - ritghtMargin, height: height())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
