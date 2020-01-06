//
//  SQArticleTableHeaderView.swift
//  SheQu
//
//  Created by gm on 2019/5/17.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    static let auditImageViewTop: CGFloat = 15
    static let auditImageViewW: CGFloat = 77.5
    static let auditImageViewH: CGFloat = 59
}

class SQArticleTableHeaderView: UIView {
    static let defaultH: CGFloat = 90
    static let titleLabelFont    = UIFont.systemFont(ofSize: 20, weight: .bold)
    
    lazy var titleLabel: UILabel = {
        let titleLabel           = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textColor     = k_color_black
        titleLabel.font          = SQArticleTableHeaderView.titleLabelFont
        titleLabel.text          = "**************************"
        return titleLabel
    }()
    
    lazy var labelLabel: UILabel = {
        let labelLabel       = UILabel()
        labelLabel.font      = k_font_title
        labelLabel.textColor = k_color_title_black
        return labelLabel
    }()
    
    lazy var labelsView: UIView = {
        let labelsView = UIView()
        return labelsView
    }()
    
    lazy var iconImageView: SQAniImageView = {
        let iconImageView = SQAniImageView()
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.image       = k_image_ph_account
        iconImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(accountBtnClick))
        iconImageView.addGestureRecognizer(tap)
        return iconImageView
    }()
    
    lazy var accountLabel: UILabel = {
        let accountLabel = UILabel()
        accountLabel.textColor = k_color_black
        accountLabel.font      = k_font_title_12_weight
        accountLabel.text      = "************"
        accountLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(accountBtnClick))
        accountLabel.addGestureRecognizer(tap)
        return accountLabel
    }()
    
    lazy var reasonLabel: UILabel = {
        let reasonLabel = UILabel()
        reasonLabel.font = k_font_title_11
        reasonLabel.textColor = UIColor.red
        return reasonLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = k_font_title_12
        timeLabel.textColor = k_color_title_gray_blue
        return timeLabel
    }()
    
    lazy var auditImageView: SQAduitImageView = {
        let auditImageViewX = k_screen_width - SQItemStruct.auditImageViewW - 20
        let auditImageView = SQAduitImageView.init(frame: CGRect.init(x: auditImageViewX, y: SQItemStruct.auditImageViewTop, width: SQItemStruct.auditImageViewW, height: SQItemStruct.auditImageViewH))
        auditImageView.image = UIImage.init(named: "sq_audit_waiting")
        auditImageView.isHidden = true
        return auditImageView
    }()
    
    
    lazy var readBtn: UIButton = {
        let readBtn = UIButton()
        readBtn.titleLabel?.font = k_font_title_12
        readBtn.setTitleColor(
            k_color_title_gray_blue,
            for: .normal
        )
        
        readBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        readBtn.setImage(UIImage.init(named: "home_see"), for: .normal)
        readBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0)
        return readBtn
    }()
    
    var callBack: ((CGFloat) -> ())?
    var accountIDCallBack:((Int) -> ())?
    var infoModel: SQArticleInfoModel = SQArticleInfoModel() {
        didSet {
            if infoModel.account_id == -1 {
                return
            }
            
            var labelLabelText = infoModel.parent_category_name
            if infoModel.category_name.count > 0 {
                labelLabelText.append(contentsOf: " • \(infoModel.category_name)")
            }
            
            labelLabel.text = labelLabelText
            ///为了满足增加草稿字段的真实size 添加草稿字段
            var calcuateTitle = infoModel.title
            if infoModel.status == SQArticleAuditStatus.draft.rawValue {
                calcuateTitle = "  草稿  " + infoModel.title
                titleLabel.attributedText = infoModel.title.toDraftAttStr()
            }else{
               titleLabel.text   = infoModel.title
            }
            
            accountLabel.text = infoModel.account
            timeLabel.text    = infoModel.created_time.updateTimeToCurrennTime()
            let timeLabelWidth = timeLabel.text?.calcuateLabSizeWidth(font: k_font_title_12, maxHeight: 30) ?? 0
            timeLabel.snp.updateConstraints { (maker) in
                maker.width.equalTo(timeLabelWidth + 10)
            }
            
            readBtn.setTitle(
                infoModel.read_number.getShowString(),
                for: .normal)
            
            iconImageView.sq_yysetImage(
                with: infoModel.head_url,
                placeholder: k_image_ph_account
            )
            
            
            var titleLabelH = calcuateTitle.calcuateLabSizeHeight(font: SQArticleTableHeaderView.titleLabelFont, maxWidth: k_screen_width - 40) + 5
            
            var totleHeight = SQArticleTableHeaderView.defaultH
            if infoModel.label.count > 0 {
                totleHeight += 25
                iconImageView.snp.updateConstraints { (maker) in
                    maker.top.equalTo(labelsView.snp.bottom).offset(25)
                }
                
               let labelsViewH = initLabelsView()
                labelsView.snp.updateConstraints { (maker) in
                    maker.height.equalTo(labelsViewH)
                }
                
                totleHeight += labelsViewH
            }
            
            auditImageView.updateImage(infoModel.status)
            
            if titleLabelH < 30 {
                titleLabelH = 30
            }
            
            totleHeight = totleHeight + titleLabelH
            titleLabel.snp.updateConstraints { (maker) in
                maker.height.equalTo(titleLabelH)
            }
            
            let accountLabelW = infoModel.account.calcuateLabSizeWidth(font: k_font_title_12_weight, maxHeight: 20) + 10
            accountLabel.snp.updateConstraints { (maker) in
                maker.width.equalTo(accountLabelW)
            }
            
            if infoModel.reason.count > 0 {
                reasonLabel.text = "驳回原因：" + infoModel.reason
                reasonLabel.snp.updateConstraints { (maker) in
                    maker.height.equalTo(20)
                }
                
                totleHeight += 20
            }
            
            updateConstraints()
            
            if totleHeight > SQArticleTableHeaderView.defaultH {
                setHeight(height: totleHeight)
            }
            
            weak var weakSelf = self
            infoModel.articelCallBack = { articelModel in
                weakSelf?.readBtn.setTitle(
                    articelModel.read_number.getShowString(),
                    for: .normal)
            }
            
            
            if callBack != nil {
                callBack!(totleHeight)
            }
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(labelLabel)
        addSubview(titleLabel)
        addSubview(labelsView)
        addSubview(iconImageView)
        addSubview(timeLabel)
        addSubview(readBtn)
        addSubview(accountLabel)
        addSubview(auditImageView)
        addSubview(reasonLabel)
        addLayout()
    }
    
    func initLabelsView() -> CGFloat{
        
        var tempBtn          = UIButton()
        tempBtn.setLeft(x: -10)
        let btnH: CGFloat    = 25
        let margin: CGFloat  = 10
        let font             = k_font_title_11
        let titleColor       = k_color_normal_blue
        let viewW            = k_screen_width - 40
        for titleLabel in infoModel.label {
            let titleStr      = titleLabel.label_name
            var btnX: CGFloat = tempBtn.maxX() + margin
            var btnY: CGFloat = tempBtn.top()
            let titleLabelW   = titleStr.calcuateLabSizeWidth(font: font, maxHeight: btnH) + margin * 2
            if btnX + titleLabelW > viewW  {
               btnX = 0
               btnY = btnY + btnH + margin
            }
            
            let btn = UIButton.init(frame: CGRect.init(x: btnX, y: btnY, width: titleLabelW, height: btnH))
            btn.setTitle(titleStr, for: .normal)
            btn.setTitleColor(titleColor, for: .normal)
            btn.titleLabel?.font = font
            tempBtn = btn
            labelsView.addSubview(btn)
            btn.layer.cornerRadius = btnH * 0.5
            btn.layer.borderColor  = titleColor.cgColor
            btn.layer.borderWidth  = k_corner_boder_width
        }
        
        return tempBtn.maxY()
    }
    
    func addLayout() {
        
        labelLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top).offset(10)
            maker.left.equalTo(snp.left).offset(20)
            maker.right.equalTo(snp.right).offset(-20)
            maker.height.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { (maker) in
           maker.top.equalTo(labelLabel.snp.bottom).offset(10)
           maker.left.equalTo(snp.left).offset(20)
           maker.right.equalTo(snp.right).offset(-20)
           maker.height.equalTo(30)
        }
        
        reasonLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom)
            maker.left.equalTo(titleLabel.snp.left)
            maker.right.equalTo(titleLabel.snp.right)
            maker.height.equalTo(0)
        }
        
        labelsView.snp.makeConstraints { (make) in
            make.top.equalTo(reasonLabel.snp.bottom).offset(10)
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(titleLabel.snp.right)
            make.height.equalTo(0)
        }
        
        
        
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(labelsView.snp.bottom)
            make.left.equalTo(titleLabel.snp.left)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        iconImageView.layer.cornerRadius = 15
        iconImageView.layer.masksToBounds = true

        accountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.top.equalTo(iconImageView.snp.top)
            make.height.equalTo(iconImageView.snp.height)
            make.width.equalTo(50)
        }
        
        timeLabel.snp.makeConstraints { (maker) in
            maker.left
                .equalTo(accountLabel.snp.right).offset(10)
            maker.top.equalTo(accountLabel.snp.top)
            maker.width.equalTo(80)
            maker.height.equalTo(iconImageView.snp.height)
        }
        
        readBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(timeLabel.snp.right).offset(20)
            maker.top.equalTo(iconImageView.snp.top)
            maker.height.equalTo(iconImageView.snp.height)
            maker.width.equalTo(100)
        }
    }
    
    @objc private func accountBtnClick() {
        if (accountIDCallBack != nil) {
            accountIDCallBack!(infoModel.account_id)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

