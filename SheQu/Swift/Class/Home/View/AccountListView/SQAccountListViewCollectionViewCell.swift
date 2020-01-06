//
//  SQAccountListViewCollectionViewCell.swift
//  SheQu
//
//  Created by gm on 2019/5/13.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQAccountListViewCollectionViewCell: UICollectionViewCell {
    
    lazy var contentImageView: SQAniImageView = {
        let contentImageView = SQAniImageView()
        contentImageView.contentMode = .scaleAspectFill
        contentImageView.layer.masksToBounds = true
        return contentImageView
    }()
    
    lazy var selBtn: UIButton = {
        let selBtn = UIButton()
        selBtn.setImage(UIImage.init(named: "home_cloud_sel"), for: .selected)
        selBtn.setImage(UIImage.init(named: "home_cloud_unsel"), for: .normal)
        selBtn.isUserInteractionEnabled = false
        return selBtn
    }()
    
    lazy var titleLabel: YYLabel = {
        let titleLabel = YYLabel()
        titleLabel.numberOfLines         = 2
        titleLabel.textVerticalAlignment = .top
        titleLabel.textAlignment         = .center
        titleLabel.textColor             = k_color_black
        titleLabel.font                  = UIFont.systemFont(ofSize: 12)
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         addSubview(contentImageView)
        addSubview(selBtn)
        addSubview(titleLabel)
        addLayout()
    }
    
    func addLayout() {
        
        contentImageView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(snp.centerX)
            maker.top.equalTo(snp.top).offset(20)
            maker.width.equalTo(90)
            maker.height.equalTo(90)
        }
        
        contentImageView.layer.borderWidth  = 0.7
        contentImageView.layer.borderColor  = k_color_line.cgColor
        contentImageView.layer.cornerRadius = k_corner_radiu
        
        selBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(contentImageView.snp.right).offset(-5)
            maker.top.equalTo(contentImageView.snp.top).offset(5)
            maker.height.equalTo(20)
            maker.width.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentImageView.snp.bottom).offset(5)
            maker.centerX.equalTo(snp.centerX)
            maker.width.equalTo(contentImageView.snp.width)
            maker.height.equalTo(40)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
