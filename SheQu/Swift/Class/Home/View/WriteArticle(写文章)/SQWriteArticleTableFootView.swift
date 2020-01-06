//
//  SQWriteArticleCell.swift
//  SheQu
//
//  Created by gm on 2019/7/1.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQWriteArticleTableFootView: UIView {
    
    lazy var textView: SQWriteArticleTextView = {
        let textView = SQWriteArticleTextView()
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textView)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textView.frame = CGRect.init(
            x: 20,
            y: 0,
            width: k_screen_width - 40,
            height: height()
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
