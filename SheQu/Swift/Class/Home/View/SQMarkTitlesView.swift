//
//  SQMarkTitlesView.swift
//  SheQu
//
//  Created by gm on 2019/4/26.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
typealias Level2SelCallBack = (_ needRefresh: Bool,_ selIndex: Int, _ modelArray: [SQHomeCategorySubInfo]) -> ()
class SQMarkTitlesView: UIView {
    private static let navPageViewH: CGFloat = 45
    lazy var navPageView: SQNavPageView = {
        let navPageView = SQNavPageView()
        return navPageView
    }()
    
    lazy var cacheContainerTool: SQCacheContainerTool = {
        let cacheContainerTool = SQCacheContainerTool()
        return cacheContainerTool
    }()
    
    var callback:Level2SelCallBack?
    var needRefresh: Bool = true
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.colorRGB(0xcccccc)
        return lineView
    }()
    
    var categoryInfoArray: [SQHomeCategoryInfo]? {
        didSet{
            if categoryInfoArray == nil {
                return
            }
            
            navPageView.titleArray = categoryInfoArray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(navPageView)
        addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        navPageView.frame = CGRect.init(x: 0, y: 0, width: width(), height: SQMarkTitlesView.navPageViewH)
        lineView.frame  = CGRect.init(x: 0, y: navPageView.maxY(), width: width(), height: k_line_height)
    }
}

