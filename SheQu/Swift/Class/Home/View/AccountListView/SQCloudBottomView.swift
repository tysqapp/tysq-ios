//
//  SQCloudBottomView.swift
//  SheQu
//
//  Created by gm on 2019/5/13.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQCloudBottomView: UIView {
    static var cloudBottomViewH: CGFloat = 50
    static var cloudBottomViewW: CGFloat = k_screen_width - 30
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line
        return lineView
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton()
        sureBtn.isEnabled = false
        sureBtn.setTitle("确定", for: .disabled)
        sureBtn.titleLabel?.font = k_font_title_weight
        sureBtn.setTitleColor(UIColor.white, for: .normal)
        sureBtn.setTitleColor(UIColor.white, for: .disabled)
        sureBtn.setBackgroundImage(UIImage.init(named: "sq_btn_unuse"), for: .disabled)
        sureBtn.setBackgroundImage(UIImage.init(named: "sq_btn_use"), for: .normal)
        return sureBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lineView)
        addSubview(sureBtn)
        addLayout()
    }
    
    func addLayout() {
        lineView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.width.equalTo(snp.width)
            maker.left.equalTo(snp.left)
            maker.height.equalTo(k_line_height)
        }
        
        sureBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top).offset(5)
            maker.centerY.equalTo(snp.centerY)
            maker.centerX.equalTo(snp.centerX)
            maker.width.equalTo(SQCloudBottomView.cloudBottomViewW)
        }
        
        sureBtn.layer.cornerRadius  = k_corner_radiu
        sureBtn.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
