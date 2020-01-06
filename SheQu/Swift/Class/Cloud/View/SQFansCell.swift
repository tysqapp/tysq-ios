//
//  SQFansCell.swift
//  SheQu
//
//  Created by iMac on 2019/9/10.
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
    static let attentionBtnH = 22
    static let attentionBtnW = 55
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

class SQFansCell: UITableViewCell {
    static let cellID = "SQFansCellID"
    static let height: CGFloat = 100
    //跳转登录页面callback
    var toLoginCallback: (() -> ())?
    var model:SQFanModel? {
        didSet{
            accountNameLabel.text = model!.account_name
            briefLabel.text = model!.personal_profile
            
            articleNum.text = "文章:\(model!.article_num.getShowString())"
            readingNum.text = "阅读:\(model!.readed_num.getShowString())"
            collectNum.text = "收藏:\(model!.collected_num.getShowString())"

            
            let gradeImage = UIImage.init(named: "sq_grade_\(model!.grade)")
            gradeBtn.setImage(gradeImage, for: .normal)
            
            iconImageView.sq_yysetImage(with: model!.head_url, placeholder: k_image_ph_account)
            
            
            iconImageView.addRounded(corners: .allCorners, radii: CGSize(width: 25, height: 25), borderWidth: 0, borderColor:.white)
            
            attentionBtn.isSelected = model!.is_follow
            /* 如果未登录，关注按钮样式全部显示 +关注 */
            if let _: String  = UserDefaults.standard.value(forKey: k_ud_user) as? String {
            
            } else {
                attentionBtn.isSelected = false
            }
            
            if(attentionBtn.isSelected){
                attentionBtn.setTitle("已关注", for: .selected)
                attentionBtn.backgroundColor = k_color_line_light
                attentionBtn.setTitleColor(k_color_title_light_gray_3 , for: .selected)
                attentionBtn.layer.borderColor = k_color_title_light_gray_3 .cgColor
                attentionBtn.layer.borderWidth = 0.5
                attentionBtn.setImage(nil, for: .normal)
                attentionBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                attentionBtn.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 4, right: 6)
            } else {
                attentionBtn.setTitle("关注", for: .normal)
                attentionBtn.setTitleColor(.white, for: .normal)
                attentionBtn.backgroundColor = k_color_normal_blue
                attentionBtn.layer.borderWidth = 0
                attentionBtn.setImage(UIImage(named: "sq_cloud_plus"), for: .normal)
                attentionBtn.imageEdgeInsets = UIEdgeInsets(top: 6, left: 9, bottom: 6, right: 35)
                attentionBtn.titleEdgeInsets = UIEdgeInsets(top: 5, left: 6, bottom: 4, right: 6)
            }
            
        }
    }
    
    ///用户头像
    lazy var iconImageView: SQAniImageView = {
        let iconImageView = SQAniImageView()
        iconImageView.setSize(size: CGSize.init(
            width: SQItemStruct.iconImageViewWH,
            height: SQItemStruct.iconImageViewWH
        ))
        iconImageView.contentMode = .scaleAspectFill
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
    
    ///关注按钮
    lazy var attentionBtn: UIButton = {
       let btn = UIButton()
       btn.setImage(UIImage(named: "sq_cloud_plus"), for: .normal)
       btn.imageEdgeInsets = UIEdgeInsets(top: 6, left: 9, bottom: 6, right: 35)
       btn.setTitle("关注", for: .normal)
       btn.layer.cornerRadius = 4
       btn.backgroundColor = k_color_normal_blue
       btn.titleLabel?.font = k_font_title_12
       btn.addTarget(self, action: #selector(clickAttention(sender:)), for: .touchUpInside )
       btn.titleEdgeInsets = UIEdgeInsets(top: 5, left: 6, bottom: 4, right: 6)
       return btn
    }()
    
    ///文章数
    lazy var articleNum: UILabel = {
        let label = UILabel()
        label.font = k_font_title_12
        label.textColor = k_color_title_light_gray2
        return label
    }()
    
    ///阅读数
    lazy var readingNum: UILabel = {
        let label = UILabel()
        label.font = k_font_title_12
        label.textColor = k_color_title_light_gray2
        return label
    }()
    
    ///收藏数
    lazy var collectNum: UILabel = {
        let label = UILabel()
        label.font = k_font_title_12
        label.textColor = k_color_title_light_gray2
        return label
    }()
    ///分割线1
    lazy var gapView1: UIView = {
        let gapView = UIView()
        gapView.backgroundColor = k_color_title_light_gray2
        return gapView
    }()
    ///分割线2
    lazy var gapView2: UIView = {
        let gapView = UIView()
        gapView.backgroundColor = k_color_title_light_gray2
        return gapView
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
        addSubview(attentionBtn)
        addSubview(articleNum)
        addSubview(readingNum)
        addSubview(collectNum)
        addSubview(gapView1)
        addSubview(gapView2)
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
            make.left.equalTo(accountNameLabel.snp.left)
            make.top.equalTo(accountNameLabel.snp.bottom).offset(SQItemStruct.briefLabelTop)
            //make.centerY.equalTo(iconImageView.snp.centerY)
            make.right.equalTo(snp.right).offset(SQItemStruct.briefLabelRight)
        }
        
        gradeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(accountNameLabel.snp.centerY)
            make.left.equalTo(accountNameLabel.snp.right).offset(SQItemStruct.gradeBtnLeft)
            make.width.equalTo(SQItemStruct.gradeBtnW)
            make.height.equalTo(SQItemStruct.gradeBtnH)
        }
        
        attentionBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(accountNameLabel.snp.centerY).offset(-3)
            make.right.equalTo(snp.right).offset(SQItemStruct.attentionBtnRight)
            make.height.equalTo(SQItemStruct.attentionBtnH)
            make.width.equalTo(SQItemStruct.attentionBtnW)
        }
        
        articleNum.snp.makeConstraints { (make) in
            make.left.equalTo(accountNameLabel.snp.left)
            make.top.equalTo(briefLabel.snp.bottom).offset(10)
        }
        
        gapView1.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.height.equalTo(12)
            make.left.equalTo(articleNum.snp.right).offset(10)
            make.centerY.equalTo(articleNum.snp.centerY)
        }
        
        readingNum.snp.makeConstraints { (make) in
            make.bottom.equalTo(articleNum.snp.bottom)
            make.left.equalTo(gapView1.snp.right).offset(SQItemStruct.readingNumLeft)
        }
        
        gapView2.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.height.equalTo(12)
            make.left.equalTo(readingNum.snp.right).offset(10)
            make.centerY.equalTo(readingNum.snp.centerY)
        }
        
        collectNum.snp.makeConstraints { (make) in
            make.bottom.equalTo(readingNum.snp.bottom)
            make.left.equalTo(gapView2.snp.right).offset(SQItemStruct.collectNumLeft)
        }
        
        gapView3.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.bottom.equalTo(snp.bottom)
        }
        
    }
    


    
    //关注 or 已关注
    @objc func clickAttention(sender: UIButton){
        /**
          如果未登录，点击关注/未关注按钮跳到登录页面
         */
        if let _: String  = UserDefaults.standard.value(forKey: k_ud_user) as? String {
        
        } else {
            if let callback = toLoginCallback {
                callback()
                return
            }
        }
        
        if(sender.isSelected){

            SQCloudNetWorkTool.attention(attention_id: model!.account_id, is_follow: false) { [weak self] (listModel, status, errorMessage) in
                
                if errorMessage != nil {
                    self?.makeToast("操作失败,请重试!")
                    return
                }
                
                sender.isSelected = !sender.isSelected
                sender.setTitle("关注", for: .normal)
                sender.setTitleColor(.white, for: .normal)
                sender.backgroundColor = k_color_normal_blue
                sender.layer.borderWidth = 0
                sender.setImage(UIImage(named: "sq_cloud_plus"), for: .normal)
                sender.imageEdgeInsets = UIEdgeInsets(top: 6, left: 9, bottom: 6, right: 35)
                sender.titleEdgeInsets = UIEdgeInsets(top: 5, left: 6, bottom: 4, right: 6)
                
            }
        } else {
            
            SQCloudNetWorkTool.attention(attention_id: model!.account_id, is_follow: true) {[weak self] (listModel, status, errorMessage) in
                if errorMessage != nil {
                    self?.makeToast("操作失败,请重试!")
                    return
                }
                
                sender.isSelected = !sender.isSelected
                sender.setTitle("已关注", for: .selected)
                sender.backgroundColor = k_color_line_light
                sender.setTitleColor(k_color_title_light_gray_3 , for: .selected)
                sender.layer.borderColor = k_color_title_light_gray_3 .cgColor
                sender.layer.borderWidth = 0.5
                sender.setImage(nil, for: .normal)
                sender.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                sender.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 4, right: 6)
                
               
                
            }
        }
    }
    
    
}
