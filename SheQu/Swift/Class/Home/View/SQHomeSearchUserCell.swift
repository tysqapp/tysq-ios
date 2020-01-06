//
//  SQHomeSearchUserCell.swift
//  SheQu
//
//  Created by iMac on 2019/9/18.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    ///iconImageView
    static let iconImageViewWH: CGFloat = 50
    static let iconImageViewLeft: CGFloat = 20
    ///accountNameLabel
    static let accountNameLabelLeft: CGFloat = 10
    //briefLabel
    static let briefLabelTop: CGFloat = 9
    static let briefLabelRight :CGFloat = -9
    ///attentionBtn
    static let attentionBtnTop: CGFloat = 13
    static let attentionBtnRight: CGFloat = -20
    static let attentionBtnH = 20
    static let attentionBtnW = 50
    ///gradeBtn
    static let gradeBtnH: CGFloat = 15
    static let gradeBtnW: CGFloat = 34
    static let gradeBtnLeft: CGFloat = 10
    ///articlesNum
    static let articlesNumTop: CGFloat = 9
    ///collectNum
    static let collectNumLeft: CGFloat = 10
    ///readingNum
    static let readingNumLeft: CGFloat = 10
    
}

class SQHomeSearchUserCell: UITableViewCell {
    static let cellID = "SQHomeSearchUserCellID"
    static let height: CGFloat = 100
    var keyword = ""
    var model:SQBriefUserInfo?{
        didSet{
            accountNameLabel.attributedText = model!.name.heightLightKeyWordText(keyword, color: .red)
            briefLabel.text = model!.personal_profile
            
            var str = ""
            if model!.career != "" {
                str = str + "\(model!.career)"
            }
            
            if model!.trade != "" {
                if str == "" {
                    str = str + "\(model!.career)"
                } else {
                    str = str + "  |  \(model!.career)"
                }
            }
            
            if model!.home_address != "" {
                if str == "" {
                    str = str + "\(model!.home_address)"
                } else {
                    str = str + "  |  \(model!.home_address)"
                }
            }
            
            careerLabel.text = str
            
            
            if careerLabel.text == "" && briefLabel.text == "" {
                accountNameLabel.snp.updateConstraints {
                    $0.top.equalTo(iconImageView.snp.top).offset(SQItemStruct.iconImageViewWH * 0.3)
                }
            } else {
                accountNameLabel.snp.updateConstraints {
                    $0.top.equalTo(iconImageView.snp.top)
                }
            }
            
            
            let gradeImage = UIImage.init(named: "sq_grade_\(model!.grade)")
            gradeBtn.setImage(gradeImage, for: .normal)
            
            iconImageView.sq_yysetImage(with: model!.head_url, placeholder: k_image_ph_account)
            iconImageView.addRounded(corners: .allCorners, radii: CGSize(width: 25, height: 25), borderWidth: 0, borderColor:.white)
            
            
        }
    }
    
    ///用户头像
    lazy var iconImageView: SQAniImageView = {
        let iconImageView = SQAniImageView()
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.setSize(size: CGSize.init(
            width: SQItemStruct.iconImageViewWH,
            height: SQItemStruct.iconImageViewWH
        ))
        return iconImageView
    }()
    
    ///用户名
    lazy var accountNameLabel: UILabel = {
        let accountNameLabel = UILabel()
        accountNameLabel.font = k_font_title_weight
        
        return accountNameLabel
    }()
    
    ///个人简介
    lazy var briefLabel: UILabel = {
        let brief = UILabel()
        brief.font = k_font_title_12
        brief.textColor = k_color_title_light_gray2
        return brief
    }()
    
    ///等级
    lazy var gradeBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    
    ///职位 + 行业 + 地址
    lazy var careerLabel: UILabel = {
        let label = UILabel()
        label.font = k_font_title_12
        label.textColor = k_color_title_light_gray2
        return label
    }()
    
    ///分割线3
    lazy var gapView3: UIView = {
        let gapView = UIView()
        gapView.backgroundColor = k_color_line
        return gapView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configUI()
        addLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configUI() {
        addSubview(iconImageView)
        addSubview(accountNameLabel)
        addSubview(briefLabel)
        addSubview(gradeBtn)
        addSubview(careerLabel)
        addSubview(gapView3)
    }
    

    
    func addLayout() {
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top).offset(20)
            make.height.equalTo(SQItemStruct.iconImageViewWH)
            make.width.equalTo(SQItemStruct.iconImageViewWH)
            make.left.equalTo(snp.left).offset(SQItemStruct.iconImageViewLeft)
        }
        
        accountNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconImageView.snp.top)
            make.left.equalTo(iconImageView.snp.right).offset(SQItemStruct.accountNameLabelLeft)
        }
        
        briefLabel.snp.makeConstraints { (make) in
            make.left.equalTo(careerLabel.snp.left)
            make.top.equalTo(careerLabel.snp.bottom).offset(SQItemStruct.briefLabelTop)
            make.right.equalTo(snp.right).offset(-15)
        }
        
        gradeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(accountNameLabel.snp.centerY)
            make.left.equalTo(accountNameLabel.snp.right).offset(SQItemStruct.gradeBtnLeft)
            make.width.equalTo(SQItemStruct.gradeBtnW)
            make.height.equalTo(SQItemStruct.gradeBtnH)
        }
        
        careerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(accountNameLabel.snp.left)
            make.top.equalTo(accountNameLabel.snp.bottom).offset(10)
        }
               
        gapView3.snp.makeConstraints { (make) in
            make.height.equalTo(k_line_height)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.bottom.equalTo(snp.bottom)
        }
        
    }

 
    
}

extension StringProtocol {
    func nsRange(from range: Range<Index>) -> NSRange {
        return .init(range, in: self)
    }
}
