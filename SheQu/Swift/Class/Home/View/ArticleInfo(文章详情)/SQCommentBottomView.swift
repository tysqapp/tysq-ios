//
//  SQCommentBottomView.swift
//  SheQu
//
//  Created by gm on 2019/5/22.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQCommentBottomView: UIView {

    lazy var timeValueLabel: UILabel = {
        let timeValueLabel = UILabel()
        timeValueLabel.textColor = k_color_title_gray_blue
        timeValueLabel.font      = k_font_title_11
        return timeValueLabel
    }()
    
    lazy var deleteBtn: UIButton = {
        let deleteBtn = UIButton()
        deleteBtn.titleLabel?.textColor      = UIColor.clear
        deleteBtn.titleLabel?.font           = UIFont.systemFont(ofSize: 0)
        deleteBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        deleteBtn.setImage(UIImage.init(named: "sq_ai_delete"), for: .normal)
        return deleteBtn
    }()
    
    lazy var replayBtn: UIButton = {
        let replayBtn = UIButton()
        replayBtn.titleLabel?.textColor      = UIColor.clear
        replayBtn.titleLabel?.font           = UIFont.systemFont(ofSize: 0)
        replayBtn.setImage(UIImage.init(named: "home_message"), for: .normal)
        replayBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        return replayBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(timeValueLabel)
        addSubview(replayBtn)
        addSubview(deleteBtn)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let itemY = (frame.size.height - 30) * 0.5
        timeValueLabel.frame = CGRect.init(x: 0, y: itemY, width: 100, height: 30)
        
        let replayBtnW: CGFloat = 30
        let replayX    = frame.size.width - replayBtnW - 10
        replayBtn.frame = CGRect.init(x: replayX, y: itemY, width: replayBtnW, height: replayBtnW)
        
        var marginValue: CGFloat = 55
        if k_screen_width < 375 {
            marginValue = 30
        }
        let deleteBtnX = replayX - replayBtnW - marginValue
        deleteBtn.frame = CGRect.init(x: deleteBtnX, y: itemY, width: replayBtnW, height: replayBtnW)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
