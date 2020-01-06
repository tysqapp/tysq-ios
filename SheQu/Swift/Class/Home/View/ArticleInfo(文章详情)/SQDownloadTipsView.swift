//
//  SQDownloadTipsView.swift
//  SheQu
//
//  Created by iMac on 2019/10/29.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQDownloadTipsView: UIView {
    ///提示标题
    var title = "" {
        didSet {
            tipsView.titleLabel.text = title
        }
    }
    ///提示信息
    var message = "" {
        didSet {
            tipsView.messageLabel.text = title
        }
    }
    
    ///点击取消
    var dissmiss: (()->())? {
        didSet {
            tipsView.dissmissHandler = dissmiss
        }
    }
    ///点击确定
    var sure: (()->())? {
        didSet {
            tipsView.sureHandler = sure
        }
    }
    
    lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.3
        view.frame = bounds
        return view
    }()
    
    lazy var tipsView: SQTipsView = {
        let tipsView = SQTipsView()
        tipsView.backgroundColor = .white
        tipsView.layer.cornerRadius = 10
        return tipsView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(coverView)
        addSubview(tipsView)
        addLayout()
    }
    
    convenience init(frame: CGRect, title: String, message: String) {
        self.init(frame: frame)
        tipsView.titleLabel.text = title
        tipsView.messageLabel.text = message
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLayout() {
        tipsView.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.centerY.equalTo(snp.centerY)
            $0.width.equalTo(300)
            $0.height.equalTo(172)
        }
    }
    
    
    
}


class SQTipsView: UIView {
    ///点击取消
    var dissmissHandler: (()->())?
    ///点击确定
    var sureHandler: (()->())?
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "下载"
        titleLabel.textAlignment = .center
        titleLabel.font = k_font_title_16_weight
        return titleLabel
    }()
    
    lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.text = "下载视频需要扣5000积分，确定要下载吗"
        messageLabel.font = k_font_title
        messageLabel.textColor = k_color_title_black
        return messageLabel
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton()
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.titleLabel?.font = k_font_title
        sureBtn.setTitleColor(k_color_title_blue, for: .normal)
        sureBtn.addTarget(self, action: #selector(sure), for: .touchUpInside)
        return sureBtn
    }()
    
    lazy var needRemindBtn: UIButton = {
        let needRemindBtn = UIButton()
        needRemindBtn.setImage(UIImage.init(named: "sq_article_checkbox_0"), for: .normal)
        needRemindBtn.setImage(UIImage.init(named: "sq_article_checkbox_1"), for: .selected)
        needRemindBtn.addTarget(self, action: #selector(needRemindToggle), for: .touchUpInside)
        needRemindBtn.isSelected = false
        return needRemindBtn
    }()
    
    lazy var needRemindLabel: UILabel = {
        let needRemindLabel = UILabel()
        needRemindLabel.text = "七天内不再显示"
        needRemindLabel.font = k_font_title
        needRemindLabel.textColor = k_color_title_black
        return needRemindLabel
    }()
    
    lazy var dismissBtn: UIButton = {
        let dismissBtn = UIButton()
        dismissBtn.setTitle("取消", for: .normal)
        dismissBtn.titleLabel?.font = k_font_title
        dismissBtn.setTitleColor(k_color_title_blue, for: .normal)
        dismissBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return dismissBtn
    }()
    
    lazy var lineView1: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line_light
        return lineView
    }()
    
    lazy var lineView2: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line_light
        return lineView
    }()
    
    lazy var expandBtn: UIButton = {
        let expandBtn = UIButton()
        expandBtn.addTarget(self, action: #selector(needRemindToggle), for: .touchUpInside)
        return expandBtn
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(sureBtn)
        addSubview(dismissBtn)
        addSubview(lineView1)
        addSubview(lineView2)
        addSubview(needRemindBtn)
        addSubview(needRemindLabel)
        addSubview(expandBtn)
        addLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismiss() {
        self.superview?.removeFromSuperview()
        guard let dismiss = dissmissHandler else { return }
        dismiss()
        
    }
    
    @objc func sure() {
        self.superview?.removeFromSuperview()
        guard let sure = sureHandler else { return }
        sure()
        
    }
    
    @objc func needRemindToggle() {
        needRemindBtn.isSelected = !needRemindBtn.isSelected
    }
    
    func addLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.height.equalTo(16)
            $0.top.equalTo(snp.top).offset(17)

        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.left.equalTo(snp.left).offset(14)
            $0.right.equalTo(snp.right).offset(-14)
            
        }
        
        dismissBtn.snp.makeConstraints {
            $0.left.equalTo(snp.left)
            $0.bottom.equalTo(snp.bottom)
            $0.width.equalTo(150)
            $0.height.equalTo(50)
        }
        
        sureBtn.snp.makeConstraints {
            $0.right.equalTo(snp.right)
            $0.bottom.equalTo(snp.bottom)
            $0.width.equalTo(150)
            $0.height.equalTo(50)
        }
        
        lineView1.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalTo(snp.left)
            $0.right.equalTo(snp.right)
            $0.bottom.equalTo(sureBtn.snp.top)
        }
        
        lineView2.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(sureBtn.snp.height)
            $0.centerX.equalTo(snp.centerX)
            $0.bottom.equalTo(snp.bottom)
        }
        
        needRemindBtn.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(21)
            $0.left.equalTo(messageLabel.snp.left)
            $0.width.equalTo(13)
            $0.height.equalTo(13)
        }
        
        needRemindLabel.snp.makeConstraints {
            $0.centerY.equalTo(needRemindBtn.snp.centerY)
            $0.left.equalTo(needRemindBtn.snp.right).offset(7.5)
            $0.right.equalTo(messageLabel.snp.right)
        }
        
        expandBtn.snp.makeConstraints {
            $0.centerX.equalTo(needRemindBtn.snp.centerX)
            $0.centerY.equalTo(needRemindBtn.snp.centerY)
            $0.width.equalTo(36)
            $0.height.equalTo(36)
        }

    }
    
}
