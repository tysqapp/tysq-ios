//
//  SQClouldTableHeaderView.swift
//  SheQu
//
//  Created by gm on 2019/5/26.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit


fileprivate struct SQItemStruct {
    
    static let margin: CGFloat = 20
    static let marginRight: CGFloat = -20
    
    ///backgroundImageView
    static let backgroundImageViewTop: CGFloat = 0
    static let backgroundImageViewH: CGFloat   = 100 + k_nav_height + 60
    
    ///contentView
    static let contentViewW: CGFloat   = k_screen_width
    static let contentViewH: CGFloat   = 100
    static let contentViewTop: CGFloat = -20
    
    ///iconImageView
    static let iconImageViewTop: CGFloat = k_nav_height
    static let iconImageViewWH: CGFloat  = 50
    
    ///jumpSetAccountBtn
    static let jumpSetAccountBtnW: CGFloat = 40
    static let jumpSetAccountBtnH: CGFloat = 50
    
    ///accountNameLabel
    static let accountNameLabelH: CGFloat  = 30
    static let accountNameLabelW: CGFloat  = SQClouldTableHeaderView.accountNameLabelMaxW
    static let accountNameLabelLeft: CGFloat = 10
    
    ///gradeBtn
    static let gradeBtnX: CGFloat = 0
    static let gradeBtnW: CGFloat = 45
    static let gradeBtnH: CGFloat = 45
    
    ///plView wzView
    static let wzViewX: CGFloat   = SQItemStruct.margin
    static let plViewTop: CGFloat = 25
    static let plViewX: CGFloat   = 40
    static let plViewW: CGFloat   = k_screen_width / 3 - 40
    static let plViewH: CGFloat   = 75
}


/// 我的头部（显示头像 文章 评论 收藏 积分金币）
class SQClouldTableHeaderView: UIView {
    
    enum Event: Int {
        case integral = 0
        case gold = 1
        case wz = 2
        case pl = 3
        case nameLabel = 4
        case collect   = 5
    }
    
    ///tableHeaderViewTop
    static let height = SQItemStruct.contentViewH
        + SQItemStruct.backgroundImageViewH
        + SQItemStruct.contentViewTop
        + SQItemStruct.backgroundImageViewTop
    
    static let accountNameLabelFont = UIFont.systemFont(ofSize: 20, weight: .bold)
    
    static let accountNameLabelMaxW: CGFloat = k_screen_width - SQItemStruct.jumpSetAccountBtnW - SQItemStruct.iconImageViewWH - 40 - SQItemStruct.gradeBtnW
    
    var callBack:((SQClouldTableHeaderView.Event) -> ())?
    
    lazy var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView()
        backgroundImageView.backgroundColor = k_color_normal_blue
        backgroundImageView.image = UIImage.init(named: "sq_cloud_image_bg")
        backgroundImageView.contentMode = .bottomRight
        return backgroundImageView
    }()
    
    lazy var contentView: UIView = {
        let contentView  = UIView()
        contentView.backgroundColor = UIColor.white
        contentView.setSize(size: CGSize.init(
            width: k_screen_width,
            height: SQItemStruct.contentViewH
        ))
        
        contentView.addRounded(
            corners: [.topLeft,.topRight],
            radii: CGSize.init(width: 10, height: 10),
            borderWidth: 0.7,
            borderColor: k_color_line
        )
        
        return contentView
    }()
    
    lazy var iconImageView: SQAniImageView = {
        let iconImageView = SQAniImageView()
        iconImageView.setSize(size: CGSize.init(
            width: SQItemStruct.iconImageViewWH,
            height: SQItemStruct.iconImageViewWH
        ))
        
        iconImageView.layer.cornerRadius  = 4
        iconImageView.layer.borderWidth   = 1
        iconImageView.layer.borderColor   = UIColor.white.cgColor
        iconImageView.contentMode         = .scaleAspectFill
        iconImageView.layer.masksToBounds = true
        return iconImageView
    }()
    
    lazy var accountNameLabel: UILabel = {
        let accountNameLabel = UILabel()
        accountNameLabel.font = SQClouldTableHeaderView.accountNameLabelFont
        accountNameLabel.textColor = UIColor.white
        accountNameLabel.isUserInteractionEnabled = true
        accountNameLabel.tag = SQClouldTableHeaderView.Event.nameLabel.rawValue
        appendEvent(accountNameLabel)
        return accountNameLabel
    }()
    
    lazy var gradeBtn: UIButton = {
        let gradeBtn = UIButton()
        gradeBtn.contentHorizontalAlignment = .left
        return gradeBtn
    }()
    
    lazy var jumpSetAccountBtn: UIButton = {
        let jumpSetAccountBtn = UIButton()
        jumpSetAccountBtn.setImage(
            UIImage.init(named: "sq_cloud_edit"),
            for: .normal
        )
        
        jumpSetAccountBtn.contentHorizontalAlignment = .right
        return jumpSetAccountBtn
    }()
    
    lazy var integralCardView: SQCloudTableHeaderCardView = {
        let integralCardView = SQCloudTableHeaderCardView.init(
            frame: CGRect.zero,
            type: .integral
        )
        
        integralCardView.tag = SQClouldTableHeaderView.Event.integral.rawValue
        appendEvent(integralCardView)
        return integralCardView
    }()
    
    lazy var goldCardView: SQCloudTableHeaderCardView = {
        let goldCardView = SQCloudTableHeaderCardView.init(
            frame: CGRect.zero,
            type: .gold
        )
        
        goldCardView.tag = SQClouldTableHeaderView.Event.gold.rawValue
        appendEvent(goldCardView)
        return goldCardView
    }()
    
    lazy var wzView: SQCloudTableHeaderItemView = {
        let wzView = SQCloudTableHeaderItemView()
        wzView.updateTipsBtn(
            imageName: "",
            title: "文章"
        )
        
        wzView.tag = SQClouldTableHeaderView.Event.wz.rawValue
        appendEvent(wzView)
        return wzView
    }()
    
    lazy var plView: SQCloudTableHeaderItemView = {
        let plView = SQCloudTableHeaderItemView()
        plView.updateTipsBtn(
            imageName: "",
            title:  "评论"
        )
        
        plView.tag = SQClouldTableHeaderView.Event.pl.rawValue
        appendEvent(plView)
        return plView
    }()
    
    lazy var collectView: SQCloudTableHeaderItemView = {
        let collectView = SQCloudTableHeaderItemView()
        collectView.updateTipsBtn(
            imageName: "",
            title:  "收藏"
        )
        
        collectView.tag = SQClouldTableHeaderView.Event.collect.rawValue
        appendEvent(collectView)
        return collectView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundImageView)
        addSubview(iconImageView)
        addSubview(accountNameLabel)
        addSubview(gradeBtn)
        addSubview(jumpSetAccountBtn)
        addSubview(wzView)
        addSubview(plView)
        addSubview(collectView)
        addSubview(contentView)
        contentView.addSubview(integralCardView)
        contentView.addSubview(goldCardView)
        addLayout()
    }
    
    func addLayout() {
        backgroundImageView.snp.makeConstraints { (maker) in
           
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(SQItemStruct.backgroundImageViewH)
            maker.top.equalTo(snp.top)
                .offset(SQItemStruct.backgroundImageViewTop)
        }
        
        iconImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top).offset(SQItemStruct
                .iconImageViewTop)
            maker.width.equalTo(SQItemStruct.iconImageViewWH)
            maker.height.equalTo(SQItemStruct.iconImageViewWH)
            maker.left.equalTo(snp.left).offset(k_margin_x)
        }
        
        jumpSetAccountBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(iconImageView.snp.centerY)
            maker.right.equalTo(snp.right).offset(SQItemStruct
                .marginRight)
            maker.width.equalTo(SQItemStruct.jumpSetAccountBtnW)
            maker.height.equalTo(SQItemStruct.jumpSetAccountBtnH)
        }
        
        accountNameLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(iconImageView.snp.centerY)
            maker.left.equalTo(iconImageView.snp.right)
                .offset(SQItemStruct.accountNameLabelLeft)
            maker.height.equalTo(SQItemStruct.accountNameLabelH)
            maker.width.equalTo(SQItemStruct.accountNameLabelW)
        }
        
        gradeBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(accountNameLabel.snp.centerY)
            maker.left.equalTo(accountNameLabel.snp.right)
                .offset(SQItemStruct.gradeBtnX)
            maker.width.equalTo(SQItemStruct.gradeBtnW)
            maker.height.equalTo(SQItemStruct.gradeBtnH)
        }
        
        wzView.snp.makeConstraints { (maker) in
            maker.top.equalTo(iconImageView.snp.bottom)
                .offset(SQItemStruct.plViewTop)
            maker.left.equalTo(contentView.snp.left)
                .offset(SQItemStruct.wzViewX)
            maker.height.equalTo(SQItemStruct.plViewH)
            maker.width.equalTo(SQItemStruct.plViewW)
        }
        
        plView.snp.makeConstraints { (maker) in
            maker.top.equalTo(wzView.snp.top)
            maker.left.equalTo(wzView.snp.right)
                .offset(SQItemStruct.plViewX)
            maker.height.equalTo(wzView.snp.height)
            maker.width.equalTo(SQItemStruct.plViewW)
        }
        
        collectView.snp.makeConstraints { (maker) in
            maker.top.equalTo(wzView.snp.top)
            maker.height.equalTo(wzView.snp.height)
            maker.width.equalTo(SQItemStruct.plViewW)
            maker.left.equalTo(plView.snp.right)
                .offset(SQItemStruct.plViewX)
        }
    
        contentView.snp.makeConstraints { (maker) in
            maker.top.equalTo(backgroundImageView.snp.bottom)
                .offset(SQItemStruct.contentViewTop)
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(SQItemStruct.contentViewH)
        }
        
        integralCardView.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView.snp.top).offset(15)
            maker.left.equalTo(contentView.snp.left).offset(20)
            maker.width.equalTo(SQCloudTableHeaderCardView.width)
            maker.height.equalTo(SQCloudTableHeaderCardView.height)
        }
        
        goldCardView.snp.makeConstraints { (maker) in
            maker.top.equalTo(integralCardView.snp.top)
            maker.right.equalTo(contentView.snp.right).offset(-20)
            maker.width.equalTo(integralCardView.snp.width)
            maker.height.equalTo(integralCardView.snp.height)
        }
        
    }
    
    func appendEvent(_ view: UIView) {
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick(tap:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func tapClick(tap: UITapGestureRecognizer) {
        let view = tap.view
        if (callBack != nil) {
            let event = SQClouldTableHeaderView.Event.init(
                rawValue: view!.tag
            )
            
            callBack!(event!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
