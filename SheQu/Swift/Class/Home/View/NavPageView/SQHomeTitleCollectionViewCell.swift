//
//  SQHomeTitleCollectionViewCell.swift
//  SheQu
//
//  Created by gm on 2019/4/25.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQHomeTitleCollectionViewCell: UICollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font          = k_font_title_12
        return titleLabel
    }()
    
    func setNormalColor(_ color: UIColor,_ font: UIFont) {
        titleLabel.textColor = color
        titleLabel.font      = font
        //k_font_title_weight
    }
    
    func setSelColor(_ color: UIColor,_ font: UIFont) {
        titleLabel.textColor = color
        titleLabel.font      = font
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = k_color_bg
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.snp.left)
            maker.right.equalTo(self.snp.right)
            maker.top.equalTo(self.snp.top)
            maker.bottom.equalTo(self.snp.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

