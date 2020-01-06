//
//  SQSettingTableViewCell.swift
//  SheQu
//
//  Created by gm on 2019/7/11.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQSettingTableViewCell: UITableViewCell {
    static let cellID = "SQSettingTableViewCellID"
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = k_font_title
        titleLabel.textColor = k_color_black
        return titleLabel
    }()
    
    lazy var valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.font = k_font_title
        valueLabel.textColor = k_color_title_gray_blue
        return valueLabel
    }()
    
    var rightCustomView: UIView!
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, rightView: UIView) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle  = .none
        rightCustomView = rightView
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(rightView)
        addLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLayout() {
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left).offset(20)
            maker.width.equalTo(40)
            maker.height.equalTo(snp.height)
            maker.top.equalTo(snp.top)
        }
        
        valueLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel.snp.right).offset(20)
            maker.width.equalTo(200)
            maker.height.equalTo(snp.height)
            maker.top.equalTo(snp.top)
        }
        
        rightCustomView.snp.makeConstraints { (maker) in
            maker.width.equalTo(rightCustomView.width())
            maker.right.equalTo(snp.right).offset(-20)
            maker.height.equalTo(rightCustomView.height())
            maker.centerY.equalTo(snp.centerY)
        }
        
    }
}
