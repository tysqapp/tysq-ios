//
//  SQNotificationInfoTableViewCell.swift
//  SheQu
//
//  Created by gm on 2019/8/29.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    
    ///iconImageView
    static let iconImageViewWH: CGFloat = 40
    static let iconImageViewX = k_margin_x
    static let iconImageViewTop:CGFloat = 15
    
    ///titleLabel
    static let titleLabelX: CGFloat = 15
    static let titleLabelH: CGFloat = 16
    static let titleLabelTop: CGFloat = 18.5
    
    ///timeLabel
    static let timeLabelRight: CGFloat = -20
    static let timeLabelH = titleLabelH
    
    ///messageLabel
    static let messageLabelBottom: CGFloat = -16
    static let messageLabelTop: CGFloat = 10
    static let messageLabelTotalTop: CGFloat = 42
    static let messageLabelW: CGFloat = k_screen_width - iconImageViewX * 2 - iconImageViewWH - titleLabelX
}

/// 通知cell
class SQNotificationInfoTableViewCell: UITableViewCell {
    static let cellID = "SQNotificationInfoTableViewCellID"
    
    var jumpPersonalCallback: ((Int)->())?
    var model: SQNotificationListItemModel? {
            didSet{
                if model == nil {
                    return
                }
                
                redPointView.isHidden = model!.is_read
                titleLabel.text = model!.remind_type
                switch model!.action {
                case "article_review":
                    model!.content = "\(model!.sender_name)发布了文章《\(model!.title)》，去审核吧"
                    iconImageView.image = k_image_ph_review
                    jumpPersonalBtn2.isHidden = true
                    jumpPersonalBtn.isHidden = false
                    jumpPersonalBtn3.isHidden = true

                case "article_new_comment":
                    model!.content = "评论了你的文章《\(model!.title)》"
                    iconImageView.sq_yysetImage(with:  model!.avatar_url, placeholder: k_image_ph_account)
                    titleLabel.text = "\(model!.sender_name)"
                    jumpPersonalBtn2.isHidden = false
                    jumpPersonalBtn.isHidden = true
                    jumpPersonalBtn3.isHidden = false

                case "comment_new_reply":
                    model!.content = "回复了你在文章《\(model!.title)》的评论"
                    iconImageView.sq_yysetImage(with: model!.avatar_url, placeholder: k_image_ph_account)
                    titleLabel.text = "\(model!.sender_name)"
                    jumpPersonalBtn2.isHidden = false
                    jumpPersonalBtn.isHidden = true
                    jumpPersonalBtn3.isHidden = false

                case "new_report_handler":
                    model!.content = "\(model!.sender_name)举报文章《\(model!.title)》，请尽快处理！\n举报编号:\(model!.report_number)"
                    iconImageView.image = k_image_ph_report
                    jumpPersonalBtn2.isHidden = true
                    jumpPersonalBtn.isHidden = false
                    jumpPersonalBtn3.isHidden = true

                case "effective_report_handler":
                    model!.content = "你提交的举报已处理！处理结果：有效举报，赠送1000积分;"
                    iconImageView.image = k_image_ph_report
                    jumpPersonalBtn2.isHidden = true
                    jumpPersonalBtn.isHidden = true
                    jumpPersonalBtn3.isHidden = true

                    
                case "invalid_report_handler":
                    model!.content = "你提交的举报已处理！处理结果：无效举报；"
                    iconImageView.image = k_image_ph_report
                    jumpPersonalBtn2.isHidden = true
                    jumpPersonalBtn.isHidden = true
                    jumpPersonalBtn3.isHidden = true

                    
                case "review_pass":
                    model!.content = "你的文章《\(model!.title)》，已审核通过"
                    iconImageView.image = k_image_ph_review
                    jumpPersonalBtn2.isHidden = true
                    jumpPersonalBtn.isHidden = true
                    jumpPersonalBtn3.isHidden = true

                    
                case "review_unpass":
                    model!.content = "你的文章《\(model!.title)》，未通过审核"
                    iconImageView.image = k_image_ph_review

                /**5.2期新增：分类已删除的通知：用户写的文章，如选择某一分类，该分类被删除后，给予作者通知*/
                case "delete_category":
                    model!.content = "文章《\(model!.title)》选择的分类已删除，请重新选择。"
                    iconImageView.image = k_image_ph_category_delete
                    jumpPersonalBtn2.isHidden = true
                    jumpPersonalBtn.isHidden = true
                    jumpPersonalBtn3.isHidden = true

                    
                default:
                    break
                    
                }
                
                messageLabel.attributedText = model!.content.heightLightKeyWordText(model!.sender_name, color: .black)
                
                timeLabel.text = model!.time.formatStr("yyyy-MM-dd HH:mm:ss")
                
                
                
                
                

                if model!.sender_name != "" && model!.action != "article_new_comment" {

                    jumpPersonalBtn.snp.makeConstraints { (maker) in
                        maker.top.equalTo(messageLabel.snp.top)
                        maker.left.equalTo(messageLabel.snp.left)
                        maker.height.equalTo(15)
                        maker.width.equalTo(model!.sender_name.calcuateLabSizeWidth(font: UIFont.systemFont(ofSize: 12), maxHeight: 14))
                    }
                    layoutIfNeeded()
                } else {
                    jumpPersonalBtn.isHidden = true
                }
                
            }
    }
    
    lazy var jumpPersonalBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(jumpPersonal), for: .touchUpInside)
        return btn
    }()
    
    lazy var jumpPersonalBtn2: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.addTarget(self, action: #selector(jumpPersonal), for: .touchUpInside)
        return btn
    }()
    
    lazy var jumpPersonalBtn3: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.addTarget(self, action: #selector(jumpPersonal), for: .touchUpInside)
        return btn
    }()
    
    lazy var iconImageView: SQAniImageView = {
        let iconImageView = SQAniImageView()
        iconImageView.setSize(size: CGSize.init(
            width: SQItemStruct.iconImageViewWH,
            height: SQItemStruct.iconImageViewWH
        ))
        
        let radi = SQItemStruct.iconImageViewWH * 0.5
        let radiSize = CGSize.init(width: radi, height: radi)
        
        iconImageView.addRounded(corners: .allCorners, radii: radiSize, borderWidth: 0, borderColor: UIColor.clear)
        
        iconImageView.backgroundColor = UIColor.lightGray
        return iconImageView
    }()
    
    lazy var redPointView: UIView = {
        let redPointView = UIView()
        redPointView.backgroundColor = UIColor.red
        redPointView.setSize(size: CGSize.init(width: 8, height: 8))
        redPointView.layer.cornerRadius = 4
        return redPointView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = k_font_title_weight
        titleLabel.textColor = k_color_black
        titleLabel.text = "文章审核"
        return titleLabel
    }()
    
    lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.textColor     = k_color_title_gray_blue
        messageLabel.font          = k_font_title
        messageLabel.numberOfLines = 0
        return messageLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textColor     = k_color_title_gray_blue
        timeLabel.font          = k_font_title_11
        timeLabel.textAlignment = .right
        timeLabel.text          = "2019-05-23 14:23:43"
        return timeLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line
        return lineView
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(iconImageView)
        addSubview(redPointView)
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(timeLabel)
        addSubview(lineView)
        addSubview(jumpPersonalBtn)
        addSubview(jumpPersonalBtn2)
        addSubview(jumpPersonalBtn3)
        addLayout()
    }
    
    @objc func jumpPersonal() {
        if let callback = jumpPersonalCallback {
            callback(model?.sender ?? 0)
        }
        
    }
    
    private func addLayout() {
        
        iconImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
                .offset(SQItemStruct.iconImageViewTop)
            maker.left.equalTo(snp.left)
                .offset(SQItemStruct.iconImageViewX)
            maker.width.equalTo(SQItemStruct.iconImageViewWH)
            maker.height.equalTo(SQItemStruct.iconImageViewWH)
        }
        
        jumpPersonalBtn3.snp.makeConstraints { (maker) in
            maker.center.equalTo(iconImageView.snp.center)
            maker.height.equalTo(iconImageView.snp.height)
            maker.width.equalTo(iconImageView.snp.width)
        }
        
        let radi = SQItemStruct.iconImageViewWH * 0.5
        let offsetValue = CGFloat(sqrtf(Float(radi * radi * 0.5)))
        redPointView.snp.makeConstraints { (maker) in
            maker.width.equalTo(8)
            maker.height.equalTo(8)
            maker.centerX.equalTo(iconImageView.snp.centerX)
                .offset(offsetValue)
            maker.centerY.equalTo(iconImageView.snp.centerY)
                .offset(offsetValue * -1)
        }
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(iconImageView.snp.right)
                .offset(SQItemStruct.titleLabelX)
            maker.height.equalTo(SQItemStruct.titleLabelH)
            maker.top.equalTo(snp.top).offset(SQItemStruct.titleLabelTop)
        }
        
        jumpPersonalBtn2.snp.makeConstraints { (maker) in
            maker.center.equalTo(titleLabel.snp.center)
            maker.height.equalTo(titleLabel.snp.height)
            maker.width.equalTo(titleLabel.snp.width)
        }
        
        timeLabel.snp.makeConstraints { (maker) in
           maker.left.equalTo(titleLabel.snp.right)
           maker.top.equalTo(titleLabel.snp.top)
           maker.height.equalTo(SQItemStruct.timeLabelH)
           maker.right.equalTo(snp.right)
            .offset(SQItemStruct.timeLabelRight)
        }
        
        lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(iconImageView.snp.left)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(k_line_height)
            maker.bottom.equalTo(snp.bottom).offset(k_line_height * -1)
        }
        
        messageLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel.snp.left)
            maker.right.equalTo(timeLabel.snp.right)
            maker.top.equalTo(titleLabel.snp.bottom)
                .offset(SQItemStruct.messageLabelTop)
            maker.bottom.equalTo(lineView.snp.top)
                .offset(SQItemStruct.messageLabelBottom)
        }
        

        
    }
    
    class func getRowHeight(FromMessage message: String) -> CGFloat {
        let messageHeight = message.calcuateLabSizeHeight(font: k_font_title, maxWidth: SQItemStruct.messageLabelW) + 5  + SQItemStruct.messageLabelTotalTop
        
        let bottomH = SQItemStruct.messageLabelBottom * -1 + k_line_height
        
        let iconImageViewH = SQItemStruct.iconImageViewTop
            + SQItemStruct.iconImageViewWH
        var rowH = iconImageViewH
        if iconImageViewH < messageHeight {
            rowH = messageHeight
        }
        
        return rowH + bottomH
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
