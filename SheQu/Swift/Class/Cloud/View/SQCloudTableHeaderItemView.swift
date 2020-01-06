//
//  SQCloudTableHeaderItemView.swift
//  SheQu
//
//  Created by gm on 2019/5/26.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

///我的头部view 文章 评论 收藏子控件
class SQCloudTableHeaderItemView: UIView {
    
    lazy var tipsBtn: UIButton = {
        let tipsBtn = UIButton()
        tipsBtn.isUserInteractionEnabled = false
        tipsBtn.setTitleColor(k_color_white, for: .normal)
        tipsBtn.titleLabel?.font = k_font_title
        tipsBtn.contentHorizontalAlignment = .center
        return tipsBtn
    }()
    
    lazy var valueBtn: UIButton = {
        let valueBtn = UIButton()
        valueBtn.isUserInteractionEnabled = false
        valueBtn.setTitleColor(k_color_white, for: .normal)
        valueBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        valueBtn.contentHorizontalAlignment = .center
        valueBtn.setTitle("0", for: .normal)
        return  valueBtn
    }()
    
    func updateTipsBtn(imageName: String, title: String){
        tipsBtn.setImage(UIImage.init(named: imageName), for: .normal)
        tipsBtn.setTitle(title, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tipsBtn)
        addSubview(valueBtn)
        addLayout()
    }
    
    func addLayout() {
        tipsBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(valueBtn.snp.left)
            maker.top.equalTo(valueBtn.snp.bottom).offset(7.5)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(14)
        }
        
        valueBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.top.equalTo(snp.top)
            maker.height.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
