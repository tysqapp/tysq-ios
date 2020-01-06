//
//  SQPersonalHeaderView.swift
//  SheQu
//
//  Created by gm on 2019/9/16.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    static let iconImageViewWH: CGFloat = 50
    static let iconImageViewTop: CGFloat = 14
    
    static let rightBtnW: CGFloat = 70
    static let rightBtnH: CGFloat = 30
    static let rightBtnRight: CGFloat = -20
    
    static let nameAndVipLabelTop: CGFloat = 7
    static let nameAndVipLabelH: CGFloat   = 30
    
    static let accountDetailLabelTop: CGFloat = 7
    static let accountDetailLabelH: CGFloat = 13
    
    static let briefLabelTop: CGFloat = 7
    static let briefFont = k_font_title_12
    
    static let achieveBtnH: CGFloat = 40
    
    static let btnH: CGFloat        = 49
}

class SQPersonalHeaderView: UIView {
    
    static let height: CGFloat = 265
    
    ///用户头像imageView
    lazy var iconImageView: SQAniImageView  = {
        let iconImageView = SQAniImageView()
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.image = k_image_ph_account
        let size = CGSize.init(
            width: SQItemStruct.iconImageViewWH,
            height: SQItemStruct.iconImageViewWH
        )
        
        iconImageView.setSize(size: size)
        let radiSize = CGSize.init(
            width: SQItemStruct.iconImageViewWH * 0.5,
            height: SQItemStruct.iconImageViewWH * 0.5
        )
        
        iconImageView.addRounded(corners: .allCorners, radii: radiSize, borderWidth: 0, borderColor: UIColor.clear)
        return iconImageView
    }()
    
    ///用户名字 以及vip等级
    lazy var nameAndVipLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "密密麻麻"
        nameLabel.textColor = k_color_title_black
        nameLabel.textAlignment = .center
        return nameLabel
    }()

    ///用户个人信息
    lazy var accountDetailLabel: UILabel = {
        let accountDetailLabel = UILabel()
        accountDetailLabel.textAlignment = .center
        accountDetailLabel.textColor     = k_color_title_gray
        accountDetailLabel.font          = SQItemStruct.briefFont
        accountDetailLabel.text = "产品经理 | 电商 | 广东广州"
        return accountDetailLabel
    }()
    
    /// 简介label
    lazy var briefLabel: UILabel = {
        let briefLabel = UILabel()
        briefLabel.numberOfLines = 0
        briefLabel.textColor     = k_color_title_gray
        briefLabel.font          = SQItemStruct.briefFont
        briefLabel.textAlignment = .center
        return briefLabel
    }()
    
    ///右边按钮 1.如果是用户自己 则显示修改个人信息 如果不是用户自己 则显示关注和已关注
    lazy var rightBtn: UIButton = {
        let rightBtn = UIButton()
        rightBtn.titleLabel?.font = k_font_title
        rightBtn.setSize(size: CGSize.init(
            width: SQItemStruct.rightBtnW,
            height: SQItemStruct.rightBtnH
        ))
        rightBtn.layer.cornerRadius = k_corner_radiu
        rightBtn.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
        return rightBtn
    }()
    
    lazy var line1View: UIView = {
        let lineView1 = UIView()
        lineView1.backgroundColor = k_color_line_light
        return lineView1
    }()
    
    lazy var achieveBtn: UIButton = {
        let achieveBtn = UIButton()
        achieveBtn.isUserInteractionEnabled = false
        achieveBtn.setImage("sq_personal_active".toImage(), for: .normal)
        achieveBtn.setTitle("个人成就", for: .normal)
        achieveBtn.setTitleColor(k_color_title_black, for: .normal)
        achieveBtn.contentHorizontalAlignment = .left
        achieveBtn.titleLabel?.font = k_font_title
        achieveBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
        return achieveBtn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line
        return lineView
    }()
    
    lazy var readBtn: SQCloudTableHeaderItemView = {
        let readBtn = SQCloudTableHeaderItemView()
        readBtn.updateTipsBtn(imageName: "", title: "被阅读")
        updateItemColor(readBtn)
        return readBtn
    }()
    
    lazy var collectBtn: SQCloudTableHeaderItemView = {
        let collectBtn = SQCloudTableHeaderItemView()
        collectBtn.updateTipsBtn(imageName: "", title: "被收藏")
        updateItemColor(collectBtn)
        return collectBtn
    }()
    
    lazy var line2View: UIView = {
        let line2View = UIView()
        line2View.backgroundColor = k_color_line_light
        return line2View
    }()
    
    
    /// string 动作描述 Int accountID
    var callback:((String,Int) -> ())?
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      addSubview(iconImageView)
      addSubview(rightBtn)
      addSubview(nameAndVipLabel)
      addSubview(accountDetailLabel)
      addSubview(briefLabel)
      addSubview(line1View)
      addSubview(achieveBtn)
      addSubview(lineView)
      addSubview(readBtn)
      addSubview(collectBtn)
      addSubview(line2View)
      addLayout()
    }
    
    private var accountModel: SQAccountModel?
    
    func updateTableHeader(accountModel: SQAccountModel) {
        self.accountModel = accountModel
        iconImageView.sq_yysetImage(with: accountModel.head_url, placeholder: k_image_ph_account)

        
        let imageName = "sq_grade_\(accountModel.asset.grade)"
        nameAndVipLabel.attributedText = accountModel.account.stringAppendImage(textColor: k_color_title_black, font: k_font_title_16, imageName: imageName, isFront: false, margin: "  ", offsetY: -2.5)
        
        let accountDetail = getDetailStr()
        if accountDetail.count > 0 {
            accountDetailLabel.text = accountDetail
        }else {
            accountDetailLabel.snp.updateConstraints { (maker) in
                maker.height.equalTo(0)
                maker.top.equalTo(nameAndVipLabel.snp.bottom)
            }
        }
        
        briefLabel.text = accountModel.personal_profile
        
        readBtn.valueBtn.setTitle(
            accountModel.readed_num.getShowString(),
            for: .normal
        )
        
        collectBtn.valueBtn.setTitle(
            accountModel.collected_num.getShowString(),
            for: .normal
        )
        
        let account = SQAccountModel.getAccountModel()
        if accountModel.account_id == account.account_id {
            rightBtn.setTitle("修改资料", for: .normal)
            rightBtn.setTitleColor(k_color_normal_blue, for: .normal)
            rightBtn.layer.borderWidth = k_corner_boder_width
            rightBtn.layer.borderColor = k_color_normal_blue.cgColor
        }else{
            updateRightBtn(accountModel)
        }
        
        layoutIfNeeded()
    }
    
    func updateRightBtn(_ acountModel: SQAccountModel?) {
        self.accountModel = acountModel
        if (acountModel == nil) {
            return
        }
        
        rightBtn.backgroundColor = UIColor.clear
        if acountModel!.is_follow {
            rightBtn.setTitle("已关注", for: .normal)
            rightBtn.setTitleColor(UIColor.white, for: .normal)
            rightBtn.backgroundColor = k_color_title_light_gray_3
            rightBtn.layer.borderColor = UIColor.clear.cgColor
        }else{
            rightBtn.setTitle("+ 关注", for: .normal)
            rightBtn.setTitleColor(k_color_normal_blue, for: .normal)
            rightBtn.layer.borderWidth = k_corner_boder_width
            rightBtn.layer.borderColor = k_color_normal_blue.cgColor
        }
    }
    
    private func addLayout() {
        iconImageView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(snp.centerX)
            maker.width.height.equalTo(SQItemStruct.iconImageViewWH)
            maker.top.equalTo(snp.top)
                .offset(SQItemStruct.iconImageViewTop)
        }
        
        rightBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(iconImageView.snp.centerY)
            maker.height.equalTo(SQItemStruct.rightBtnH)
            maker.width.equalTo(SQItemStruct.rightBtnW)
            maker.right.equalTo(snp.right)
                .offset(SQItemStruct.rightBtnRight)
        }
        
        nameAndVipLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left).offset(k_margin_x)
            maker.right.equalTo(rightBtn.snp.right)
            maker.height.equalTo(SQItemStruct.nameAndVipLabelH)
            maker.top.equalTo(iconImageView.snp.bottom)
                .offset(SQItemStruct.nameAndVipLabelTop)
        }
        
        accountDetailLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameAndVipLabel.snp.left)
            maker.right.equalTo(nameAndVipLabel.snp.right)
            maker.height.equalTo(SQItemStruct.accountDetailLabelH)
            maker.top.equalTo(nameAndVipLabel.snp.bottom)
                .offset(SQItemStruct.accountDetailLabelTop)
        }
        
        briefLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameAndVipLabel.snp.left)
            maker.right.equalTo(nameAndVipLabel.snp.right)
            maker.top.equalTo(accountDetailLabel.snp.bottom)
                .offset(SQItemStruct.briefLabelTop)
        }
        
        line1View.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(k_line_height_big)
            maker.top.equalTo(briefLabel.snp.bottom).offset(11)
        }
        
        achieveBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(line1View.snp.bottom)
            maker.left.equalTo(nameAndVipLabel.snp.left)
            maker.right.equalTo(nameAndVipLabel.snp.right)
            maker.height.equalTo(SQItemStruct.achieveBtnH)
        }
        
        lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(k_line_height)
            maker.top.equalTo(achieveBtn.snp.bottom)
        }
        
        readBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameAndVipLabel.snp.left)
            maker.height.equalTo(SQItemStruct.btnH)
            maker.top.equalTo(lineView.snp.bottom).offset(15)
            
        }
        
        collectBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(readBtn.snp.width)
            maker.left.equalTo(readBtn.snp.right)
            maker.height.equalTo(readBtn.snp.height)
            maker.right.equalTo(nameAndVipLabel.snp.right)
            maker.top.equalTo(readBtn.snp.top)
        }
        
        line2View.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(k_line_height_big)
            maker.top.equalTo(readBtn.snp.bottom)
        }
    }
    
    class func getPersonalHeaderViewHeight(accountModel: SQAccountModel) -> CGFloat {
        
        let maxWidth  = k_screen_width - k_margin_x * 2
        var height = accountModel.personal_profile.calcuateLabSizeHeight(
            font: SQItemStruct.briefFont,
            maxWidth: maxWidth
        )
        
        if accountModel.personal_profile.count == 0 {
            height = 0
        }
        
        let accountDetail = getDetailStr(accountModel)
        if accountDetail.count < 1 {
            height -= SQItemStruct.accountDetailLabelH
            height -= SQItemStruct.accountDetailLabelTop
        }
        
        return SQPersonalHeaderView.height + height
    }
    
    private func getDetailStr() -> String {
        return SQPersonalHeaderView.getDetailStr(accountModel!)
    }
    
    private class func getDetailStr(_ accountModel: SQAccountModel) -> String {
        var accountDetail = ""
        if accountModel.career.count > 0 {
            accountDetail += accountModel.career + " | "
        }
        
        if accountModel.trade.count > 0 {
            accountDetail += accountModel.trade + " | "
        }
        
        if accountModel.home_address.count > 0 {
            accountDetail += accountModel.home_address
        }
        
        return accountDetail
    }
    
    private func updateItemColor(_ item: SQCloudTableHeaderItemView) {
        item.valueBtn.setTitleColor(k_color_title_black, for: .normal)
        item.valueBtn.titleLabel?.font = k_font_title_16_weight
        item.tipsBtn.setTitleColor(k_color_title_gray, for: .normal)
        item.tipsBtn.titleLabel?.font = k_font_title
    }
    
    
    @objc private func rightBtnClick() {
        if (callback != nil) {
            callback!(rightBtn.titleLabel!.text!, Int(accountModel?.account_id ?? -1))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
