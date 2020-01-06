//
//  SQCommentEmptyTableViewCell.swift
//  SheQu
//
//  Created by gm on 2019/6/21.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQCommentEmptyTableViewCell: UITableViewCell {
    static let cellID = "SQCommentEmptyTableViewCellCellID"
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line_light
        return lineView
    }()
    
    lazy var totleCommentLabel: UILabel = {
        let totleCommentLabel = UILabel()
        totleCommentLabel.textColor = k_color_black
        totleCommentLabel.font      = k_font_title_16
        totleCommentLabel.text = "全部评论 • 0"
        return totleCommentLabel
    }()
    
    lazy var iconImageView: UIView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage.init(named: "sq_empty_pl")
        return  iconImageView
    }()
    
    lazy var tipsLabel: UILabel = {
        let tipsLabel = UILabel()
        tipsLabel.textAlignment = .center
        tipsLabel.textColor     = k_color_title_gray
        tipsLabel.font          = k_font_title
        tipsLabel.text          = "快来抢占沙发吧!"
        return tipsLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(lineView)
        addSubview(totleCommentLabel)
        addSubview(iconImageView)
        addSubview(tipsLabel)
        addLayout()
    }
    
    func addLayout() {
        
        lineView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(k_line_height_big)
        }
        
        totleCommentLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(lineView.snp.top).offset(20)
            maker.left.equalTo(snp.left).offset(20)
            maker.right.equalTo(snp.right).offset(-20)
            maker.height.equalTo(16)
        }
        
        iconImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(totleCommentLabel.snp.bottom).offset(20)
            maker.centerX.equalTo(totleCommentLabel.snp.centerX)
            maker.width.equalTo(50)
            maker.height.equalTo(55)
        }
        
        tipsLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(iconImageView.snp.bottom).offset(10)
            maker.left.equalTo(totleCommentLabel.snp.left)
            maker.right.equalTo(totleCommentLabel.snp.right)
            maker.height.equalTo(14)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
