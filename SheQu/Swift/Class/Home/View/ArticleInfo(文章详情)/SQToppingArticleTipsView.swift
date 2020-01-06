//
//  SQToppingArticleTipsView.swift
//  SheQu
//
//  Created by iMac on 2019/11/6.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQToppingArticleTipsView: UIView {
    
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
    
    lazy var tipsView: SQToppingTipsView = {
        let tipsView = SQToppingTipsView()
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
    
    convenience init(frame: CGRect, message: String) {
        self.init(frame: frame)
        tipsView.messageLabel.text = message
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLayout() {
        tipsView.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.centerY.equalTo(snp.centerY)
            $0.width.equalTo(320)
            $0.height.equalTo(225)
        }
    }
    
    
    
}


class SQToppingTipsView: UIView, UITextFieldDelegate {
    ///点击取消
    var dissmissHandler: (()->())?
    ///点击确定
    var sureHandler: (()->())?
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "置顶排序:"
        titleLabel.textAlignment = .left
        titleLabel.font = k_font_title
        return titleLabel
    }()
    
    lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.text = "1、请输入置顶文章的排序，数字大的排的前面。\n\n2、输入0代表取消置顶。\n\n3、只能输入0和正整数。"
        messageLabel.numberOfLines = 0
        messageLabel.font = k_font_title_12
        messageLabel.textColor = k_color_title_light_gray2
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
    
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = k_color_line_light
        tf.textColor = k_color_normal_blue
        tf.keyboardType = .numberPad
        tf.layer.cornerRadius = 2
        tf.leftView = UIView(frame: CGRect.init(x: 0, y: 0, width: 12, height: 1))
        tf.leftViewMode = .always
        tf.layer.borderColor = k_color_normal_blue.cgColor
        tf.delegate = self
        return tf
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
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(sureBtn)
        addSubview(dismissBtn)
        addSubview(lineView1)
        addSubview(lineView2)
        addSubview(textField)
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
        guard let sure = sureHandler else { return }
        sure()
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderWidth = 0.5
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }

    func addLayout() {
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(snp.left).offset(21)
            $0.height.equalTo(16)
            $0.right.equalTo(textField.snp.left).offset(12)
            $0.top.equalTo(snp.top).offset(44)

        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(26)
            $0.left.equalTo(snp.left).offset(21)
            $0.right.equalTo(snp.right).offset(-21)
            
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
        
        textField.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.right.equalTo(snp.right).offset(-42)
            $0.height.equalTo(40)
            $0.width.equalTo(164)
        }
       
    }
    
}
