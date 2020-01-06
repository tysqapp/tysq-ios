//
//  SQCheckPendingArticleTableViewCell.swift
//  SheQu
//
//  Created by gm on 2019/8/27.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    
    ///checkArticleBtn
    static let checkArticleBtnW: CGFloat = 74.5
    static let checkArticleBtnH: CGFloat = 30
    static let checkArticleBtnRight: CGFloat = -20
    
    ///titleLabel
    static let titleLabelTop: CGFloat = 15
    static let titleLabelRight: CGFloat = -20
    static let titleLabelX: CGFloat     = 20
    static let titleLabelH: CGFloat     = 36
    
    ///accountLabel
    static let accountLabelBottom: CGFloat = -15
    static let accountLabelFont    = UIFont.systemFont(ofSize: 12)
    static let accountLabelH: CGFloat  = 16
    
    ///timeLabel
    static let timeLabelLeft: CGFloat = 20
}

class SQCheckPendingArticleTableViewCell: UITableViewCell {
    static let cellID = "SQCheckPendingArticleTableViewCellID"
    static let height: CGFloat = 90.5
    
    lazy var titleLabel: HGOrientationLabel = {
        let titleLabel = HGOrientationLabel()
        titleLabel.textAlign({ (hgMaker) in
            hgMaker!.typeArray = [(textAlignType.top.rawValue)]
        })
        titleLabel.font = k_font_title_weight
        titleLabel.textColor = k_color_black
        titleLabel.numberOfLines = 2
        titleLabel.text = "test"
        //titleLabel.backgroundColor = UIColor.red
        return titleLabel
    }()
    
    lazy var accountLabel: UILabel = {
        let accountLabel = UILabel()
        accountLabel.font = k_font_title_12
        accountLabel.textColor = k_color_title_gray_blue
        accountLabel.text = "text"
        return accountLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = k_font_title_12
        timeLabel.textColor = k_color_title_gray_blue
        timeLabel.text   = "07-25 11:33"
        return timeLabel
    }()
    
    
    lazy var checkArticleBtn: UIButton = {
        let checkArticleBtn = UIButton()
        checkArticleBtn.setSize(size: CGSize.init(
            width: SQItemStruct.checkArticleBtnW,
            height: SQItemStruct.checkArticleBtnH
        ))
        
        checkArticleBtn.setTitle("去审核", for: .normal)
        checkArticleBtn.setTitleColor(UIColor.white, for: .normal)
        checkArticleBtn.titleLabel?.font = k_font_title
        checkArticleBtn.updateBGColor(SQItemStruct.checkArticleBtnH * 0.5)
        checkArticleBtn.isUserInteractionEnabled = false
        return checkArticleBtn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line_light
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        addSubview(accountLabel)
        addSubview(timeLabel)
        addSubview(checkArticleBtn)
        addSubview(lineView)
        addLayout()
    }
    
    var itemModel: SQAuditArticleItemModel? {
        didSet {
            if (itemModel == nil) {
                return
            }
            
            titleLabel.text = itemModel?.title
            accountLabel.text = itemModel?.author
            timeLabel.text    = itemModel?.updated_at.formatStr("MM-dd HH:mm")
        }
    }
    
    fileprivate func addLayout() {
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(checkArticleBtn.snp.left)
                .offset(SQItemStruct.titleLabelRight)
            maker.top.equalTo(snp.top)
                .offset(SQItemStruct.titleLabelTop)
            maker.left.equalTo(snp.left)
                .offset(SQItemStruct.titleLabelX)
            maker.height.equalTo(SQItemStruct.titleLabelH)
        }
        
        checkArticleBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(snp.centerY)
            maker.width.equalTo(SQItemStruct.checkArticleBtnW)
            maker.height.equalTo(SQItemStruct.checkArticleBtnH)
            maker.right.equalTo(snp.right)
                .offset(SQItemStruct.checkArticleBtnRight)
        }
        
        lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.bottom.equalTo(snp.bottom)
            maker.height.equalTo(k_line_height)
        }
        
        accountLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel.snp.left)
            maker.height.equalTo(SQItemStruct.accountLabelH)
            maker.bottom.equalTo(lineView.snp.top)
                .offset(SQItemStruct.accountLabelBottom)
        }
        
        timeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(accountLabel.snp.top)
            maker.bottom.equalTo(accountLabel.snp.bottom)
            maker.right.equalTo(titleLabel.snp.right)
            maker.left.equalTo(accountLabel.snp.right)
                .offset(SQItemStruct.timeLabelLeft)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
