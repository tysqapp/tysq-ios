//
//  SQReportDetailCell.swift
//  SheQu
//
//  Created by iMac on 2019/9/20.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQReportDetailCell: UITableViewCell {
    static let cellID = "SQReportDetailCellID"
    ///标题
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = k_font_title
        return label
    }()
    ///详细描述
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.font = k_font_title_weight
        label.numberOfLines = 0
        return label
    }()
    ///箭头图标
    lazy var arrowImg: UIImageView = {
        let ai = UIImageView()
        ai.image = "sq_announcement_arrow".toImage()
        ai.setSize(size: CGSize.init(width: 7, height: 13))
        ai.isHidden = true
        return ai
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(titleLabel)
        addSubview(arrowImg)
        addSubview(detailLabel)
        addLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(snp.top).offset(18)
            $0.left.equalTo(snp.left).offset(20)
            
        }
        
        arrowImg.snp.makeConstraints {
            $0.centerY.equalTo(snp.centerY)
            $0.right.equalTo(snp.right).offset(-20)
        }
        
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.top)
            $0.left.equalTo(titleLabel.snp.right).offset(12)
            $0.right.equalTo(arrowImg.snp.left).offset(-8)
            
        }
        
        
    }
    
}
