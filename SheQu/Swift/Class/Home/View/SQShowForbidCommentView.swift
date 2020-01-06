//
//  SQShowForbinCommentView.swift
//  SheQu
//
//  Created by gm on 2019/8/29.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    ///contentView
    static let contentViewTop: CGFloat = (k_screen_height - contentViewH) * 0.5
    static let contentViewH: CGFloat = 205
    static let contentViewX: CGFloat = (k_screen_width - contentViewW) * 0.5
    static let contentViewW: CGFloat = 250
    
    ///iconImageView
    static let iconImageViewTop: CGFloat = 18.5
    static let iconImageViewWH: CGFloat = 60
    static let iconImageViewX = (k_screen_width - iconImageViewWH) * 0.5
    
    ///closeBtn
    static let closeBtnWH: CGFloat = 30
    static let closeBtnRight: CGFloat = -15
    static let closeBtnTop: CGFloat = 15
    
    ///nameLabel
    static let nameLabelTop: CGFloat = 15
    static let nameLabelH: CGFloat = 18
    
    ///vipImageViewTop
    static let vipImageViewTop: CGFloat = 10
    static let vipImageViewH: CGFloat   = 15
    
    static let aniDuration: CGFloat = 0.25
}

///禁止评论view
class SQShowForbidCommentView: UIView {
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = UIColor.black
        coverView.alpha = 0.7
        return coverView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = UIColor.white
        contentView.setSize(size: CGSize.init(
            width: SQItemStruct.contentViewW,
            height: SQItemStruct.contentViewH
        ))
        
        contentView.addRounded(
            corners: .allCorners,
            radii: k_corner_radiu_size_10,
            borderWidth: 0,
            borderColor: UIColor.clear
        )
        return contentView
    }()
    
    lazy var iconImageView: SQAniImageView = {
        let iconImageView = SQAniImageView()
        iconImageView.setSize(size: CGSize.init(
            width: SQItemStruct.iconImageViewWH,
            height: SQItemStruct.iconImageViewWH
        ))
        
        let radii     = SQItemStruct.iconImageViewWH * 0.5
        let radiiSize = CGSize.init(width: radii, height: radii)
        iconImageView.addRounded(corners: .allCorners, radii: radiiSize, borderWidth: 0, borderColor: UIColor.clear)
        
        iconImageView.contentMode = .scaleAspectFill
        return iconImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.font = k_font_title_weight
        nameLabel.textColor = k_color_black
        return nameLabel
    }()
    
    lazy var vipImageView: UIImageView = {
        let vipImageView = UIImageView()
        vipImageView.isHidden = false
        vipImageView.image = UIImage.init(named: "sq_grade_1")
        vipImageView.contentMode = .top
        return vipImageView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line
        return lineView
    }()
    
    lazy var closeBtn: UIButton = {
        let closeBtn = UIButton()
        closeBtn.setImage(UIImage.init(named: "home_ac_close"), for: .normal)
        closeBtn.contentHorizontalAlignment = .right
        closeBtn.contentVerticalAlignment   = .top
        closeBtn.addTarget(self, action: #selector(hiddenForbinCommentView), for: .touchUpInside)
        return closeBtn
    }()
    
    lazy var forbinCommentBtn: UIButton = {
        let forbinCommentBtn = UIButton()
        forbinCommentBtn.setTitle("禁止评论", for: .normal)
        forbinCommentBtn.setTitleColor(k_color_black, for: .normal)
        forbinCommentBtn.titleLabel?.font = k_font_title
        forbinCommentBtn.addTarget(self, action: #selector(forbinCommentBtnClick), for: .touchUpInside)
        return forbinCommentBtn
    }()
    
    var forbinCommentCallBack: ((SQShowForbidCommentView) ->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(coverView)
        addSubview(contentView)
        contentView.addSubview(closeBtn)
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(vipImageView)
        contentView.addSubview(lineView)
        contentView.addSubview(forbinCommentBtn)
        addLayout()
        layoutIfNeeded()
    }
    
    private func addLayout() {
        coverView.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.top.equalTo(snp.top)
            maker.bottom.equalTo(snp.bottom)
        }
        
        contentView.snp.makeConstraints { (maker) in
            maker.height.equalTo(SQItemStruct.contentViewH)
            maker.width.equalTo(SQItemStruct.contentViewW)
            maker.top.equalTo(snp.top).offset(SQItemStruct
                .contentViewTop)
            maker.left.equalTo(snp.left).offset(SQItemStruct
                .contentViewX)
        }
        
        closeBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(SQItemStruct.closeBtnWH)
            maker.height.equalTo(SQItemStruct.closeBtnWH)
            maker.top.equalTo(contentView.snp.top)
                .offset(SQItemStruct.closeBtnTop)
            maker.right.equalTo(contentView.snp.right)
                .offset(SQItemStruct.closeBtnRight)
        }
        
        iconImageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(SQItemStruct.iconImageViewWH)
            maker.height.equalTo(SQItemStruct.iconImageViewWH)
            maker.centerX.equalTo(contentView.snp.centerX)
            maker.top.equalTo(contentView.snp.top)
                .offset(SQItemStruct.iconImageViewTop)
        }
        
        nameLabel.snp.makeConstraints { (maker) in
            maker.width.equalTo(SQItemStruct.contentViewW)
            maker.centerX.equalTo(contentView.snp.centerX)
            maker.height.equalTo(SQItemStruct.nameLabelH)
            maker.top.equalTo(iconImageView.snp.bottom)
                .offset(SQItemStruct.nameLabelTop)
        }
        
        vipImageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(SQItemStruct.contentViewW)
            maker.centerX.equalTo(contentView.snp.centerX)
            maker.height.equalTo(SQItemStruct.vipImageViewH)
            maker.top.equalTo(nameLabel.snp.bottom)
                .offset(SQItemStruct.vipImageViewTop)
        }
        
        lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(contentView.snp.left)
            maker.width.equalTo(contentView.snp.width)
            maker.height.equalTo(k_line_height)
            maker.top.equalTo(vipImageView.snp.bottom)
                .offset(10)
        }
        
        forbinCommentBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(lineView.snp.bottom)
            maker.bottom.equalTo(contentView.snp.bottom)
            maker.width.equalTo(SQItemStruct.contentViewW)
            maker.centerX.equalTo(contentView.snp.centerX)
        }
    }
    
    func update(iconLink: String, name: String, grade: Int) {
        iconImageView.sq_yysetImage(with: iconLink, placeholder: k_image_ph_account)
        nameLabel.text = name
        vipImageView.image = UIImage.init(named: "sq_grade_\(grade)")
    }
    
    @objc func forbinCommentBtnClick() {
        hiddenForbinCommentView(0)
        
        if (forbinCommentCallBack != nil) {
            forbinCommentCallBack!(self)
        }
    }
    
    func showForbinCommentView() {
        UIApplication.shared.keyWindow?.addSubview(self)
        ///获取验证码
        UIView.animate(
            withDuration: TimeInterval.init(SQItemStruct.aniDuration),
            animations: {
                self.contentView.snp.updateConstraints({ (maker) in
                    maker.top.equalTo(self.snp.top)
                        .offset(SQItemStruct.contentViewTop)
                })
                self.layoutIfNeeded()
        }) { (isFinish) in

        }
    }
    
    
    
    @objc func hiddenForbinCommentView(_ aniDuration: CGFloat = SQItemStruct.aniDuration) {
        UIView.animate(
            withDuration: TimeInterval.init(aniDuration),
            animations: {
                self.contentView.snp.updateConstraints({ (maker) in
                    maker.top.equalTo(self.snp.top)
                        .offset(SQItemStruct.contentViewH * -1)
                })
                self.layoutIfNeeded()
        }) { (isFinish) in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
