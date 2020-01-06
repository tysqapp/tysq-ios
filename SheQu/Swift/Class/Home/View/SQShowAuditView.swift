//
//  SQShowAuditView.swift
//  SheQu
//
//  Created by gm on 2019/8/28.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    
    ///contentView
    static let contentViewTop: CGFloat = (k_screen_height - contentViewH) * 0.5
    static let contentViewH: CGFloat = 300
    static let contentViewX: CGFloat = 20
    static let contentViewW: CGFloat = k_screen_width - (contentViewX * 2)
    
    ///closeBtn
    static let closeBtnTop: CGFloat       = 50
    static let closeBtnWH: CGFloat        = 30
    
    ///auditLabel
    static let auditLabelTop: CGFloat = 25
    static let auditLabelW: CGFloat   = 200
    static let auditLabelX: CGFloat   = 20
    static let auditLabelFont: UIFont = k_font_title_16
    static let auditLabelH: CGFloat   = 16
    
    ///auditSuccessBtn
    static let auditSuccessBtnX: CGFloat = 20
    static let auditSuccessBtnTop: CGFloat = 25
    static let auditSuccessBtnW: CGFloat = 60
    static let auditSuccessBtnH: CGFloat = 30
    
    ///sureBtn
    static let sureBtnX: CGFloat = 20
    static let sureBtnW: CGFloat = contentViewW - sureBtnX * 2
    static let sureBtnH: CGFloat = 45
    static let sureBtnBottom: CGFloat = -20
    
    ///textview
    static let textviewTop: CGFloat = 22
    static let textviewH: CGFloat = 100
    static let textviewW: CGFloat = sureBtnW
    
    ///aniDuration
    static let aniDuration: CGFloat = 0.25
    
}

class SQShowAuditView: UIView {
    
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
    
    lazy var closeBtn: UIButton = {
        let closeBtn = UIButton()
        closeBtn.setImage(
            UIImage.init(named: "sq_integral_close"),
            for: .normal
        )
        
        closeBtn.addTarget(
            self,
            action: #selector(hiddenAuditView),
            for: .touchUpInside
        )
        
        closeBtn.isHidden = true
        return closeBtn
    }()
    
    lazy var auditLabel: UILabel = {
        let auditLabel = UILabel()
        auditLabel.text = "审核结果："
        return auditLabel
    }()
    
    lazy var auditSuccessBtn: UIButton = {
        let auditSuccessBtn = UIButton()
        initBtn(auditSuccessBtn, title: "通过")
        auditSuccessBtn.isSelected = true
        auditSuccessBtn.addTarget(self, action: #selector(successBtnClick), for: .touchUpInside)
        return auditSuccessBtn
    }()
    
    lazy var auditFailBtn: UIButton = {
        let auditFailBtn = UIButton()
        initBtn(auditFailBtn, title: "驳回")
        auditFailBtn.addTarget(self, action: #selector(failBtnClick), for: .touchUpInside)
        return auditFailBtn
    }()
    
    var keyBoardTag = 0
    
    private func initBtn(_ btn: UIButton, title: String) {
        btn.setTitle(title, for: .normal)
        btn.setTitle(title, for: .selected)
        btn.setImage(UIImage.init(named: "sq_audit_unSel"), for: .normal)
        btn.setImage(UIImage.init(named: "sq_audit_sel"), for: .selected)
        btn.setTitleColor(k_color_title_blue, for: .selected)
        btn.setTitleColor(k_color_title_gray, for: .normal)
        btn.titleLabel?.font = k_font_title
        btn.contentHorizontalAlignment = .left
        btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
    }
    
    lazy var auditSuccessImageView: UIImageView = {
        let auditSuccessImageView = UIImageView()
        auditSuccessImageView.contentMode = .center
        auditSuccessImageView.image = UIImage.init(named: "sq_audit_success")
        return auditSuccessImageView
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isHidden = true
        textView.setSize(size: CGSize.init(width: SQItemStruct.textviewW, height: SQItemStruct.textviewH))
        textView.backgroundColor = k_color_line_light
        textView.font            = k_font_title
        textView.textColor       = k_color_title_gray
        textView.textContainerInset    = UIEdgeInsets.init(top: 10, left: 6, bottom: 10, right: 10)
        textView.addRounded(corners: .allCorners, radii: k_corner_radiu_size_10, borderWidth: 1, borderColor: k_color_line)
        textView.delegate = self
        return textView
    }()
    
    lazy var placeHolderLable: UILabel = {
        let placeHolderLable = UILabel()
        placeHolderLable.textColor = k_color_title_gray
        placeHolderLable.font      = k_font_title
        placeHolderLable.text      = "请输入驳回原因"
        placeHolderLable.isHidden  = true
        return placeHolderLable
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton()
        sureBtn.setSize(size: CGSize.init(
            width: SQItemStruct.sureBtnW,
            height: SQItemStruct.sureBtnH
        ))
        
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitle("确定", for: .disabled)
        sureBtn.updateBGColor()
        sureBtn.addTarget(self, action: #selector(submitBtnClick), for: .touchUpInside)
        return sureBtn
    }()
    
    
    /// status == 1 则为审核通过  status == -2则为不通过
    var submitStateCallBack:((_ status:Int,_ reanson: String) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(coverView)
        addSubview(contentView)
        contentView.addSubview(auditLabel)
        contentView.addSubview(auditSuccessBtn)
        contentView.addSubview(auditFailBtn)
        contentView.addSubview(auditFailBtn)
        contentView.addSubview(auditSuccessImageView)
        contentView.addSubview(textView)
        contentView.addSubview(sureBtn)
        contentView.addSubview(placeHolderLable)
        addSubview(closeBtn)
        addLayout()
        layoutIfNeeded()
        addNoti()
    }
    
    private func addNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDisp(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardHidden(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyBoardDisp(noti: Notification) {
       
        if keyBoardTag == 1 {
            return
        }
        
        let  keyBoardFrame = noti.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! CGRect
        if keyBoardFrame.height > 200 {
           keyBoardTag += 1
        }else{
            return
        }
       
       let keyBoardY: CGFloat = keyBoardFrame.origin.y
       let captchaTFFrame     = contentView.convert(textView.frame, to: UIApplication.shared.keyWindow)
       let moveY     = captchaTFFrame.maxY  - keyBoardY
       let top       = SQItemStruct.contentViewTop - moveY - 44
            
       UIView.animate(withDuration: TimeInterval.init(0.25), animations: {
            self.contentView.snp.updateConstraints({ (maker) in
                maker.top.equalTo(self.snp.top).offset(top)
            })
           self.layoutIfNeeded()
        }) { (isFinish) in
            
        }
    }
    
    @objc func keyBoardHidden(noti: Notification) {
        keyBoardTag = 0
        UIView.animate(withDuration: TimeInterval.init(0.25), animations: {
            self.contentView.snp.updateConstraints({ (maker) in
                maker.top.equalTo(self.snp.top).offset(SQItemStruct.contentViewTop)
                
            })
            self.layoutIfNeeded()
        }) { (isFinish) in
        }
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
            maker.height.equalTo(SQItemStruct.closeBtnWH)
            maker.width.equalTo(SQItemStruct.closeBtnWH)
            maker.centerX.equalTo(snp.centerX)
            maker.top.equalTo(contentView.snp.bottom)
                .offset(SQItemStruct.closeBtnTop)
        }
        
        auditLabel.snp.makeConstraints { (maker) in
            maker.width.equalTo(SQItemStruct.auditLabelW)
            maker.height.equalTo(SQItemStruct.auditLabelH)
            maker.top.equalTo(contentView.snp.top)
                .offset(SQItemStruct.auditLabelTop)
            maker.left.equalTo(contentView.snp.left)
                .offset(SQItemStruct.auditLabelX)
        }
        
        auditSuccessBtn.snp.makeConstraints { (maker) in
            maker.height.equalTo(SQItemStruct.auditSuccessBtnH)
            maker.width.equalTo(SQItemStruct.auditSuccessBtnW)
            maker.left.equalTo(contentView.snp.left)
                .offset(SQItemStruct.auditSuccessBtnX)
            maker.top.equalTo(auditLabel.snp.bottom)
                .offset(SQItemStruct.auditSuccessBtnTop)
        }
        
        auditFailBtn.snp.makeConstraints { (maker) in
            maker.height.equalTo(SQItemStruct.auditSuccessBtnH)
            maker.width.equalTo(SQItemStruct.auditSuccessBtnW)
            maker.top.equalTo(auditSuccessBtn.snp.top)
            maker.left.equalTo(auditSuccessBtn.snp.right)
                .offset(100)
        }
        
        auditSuccessImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(sureBtn.snp.left)
            maker.right.equalTo(sureBtn.snp.right)
            maker.top.equalTo(auditSuccessBtn.snp.bottom)
            maker.bottom.equalTo(sureBtn.snp.top)
        }
        
        textView.snp.makeConstraints { (maker) in
            maker.left.equalTo(sureBtn.snp.left)
            maker.width.equalTo(SQItemStruct.textviewW)
            maker.height.equalTo(SQItemStruct.textviewH)
            maker.top.equalTo(auditSuccessBtn.snp.bottom)
                .offset(SQItemStruct.textviewTop)
        }
        
        placeHolderLable.snp.makeConstraints { (maker) in
            maker.top.equalTo(textView.snp.top).offset(10)
            maker.left.equalTo(textView.snp.left).offset(10)
            maker.height.equalTo(14)
        }
        
        sureBtn.snp.makeConstraints { (maker) in
            maker.height.equalTo(SQItemStruct.sureBtnH)
            maker.width.equalTo(SQItemStruct.sureBtnW)
            maker.left.equalTo(SQItemStruct.sureBtnX)
            maker.bottom.equalTo(contentView.snp.bottom)
                .offset(SQItemStruct.sureBtnBottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func submitBtnClick() {
        if textView.text.count < 1 && auditFailBtn.isSelected {
            SQToastTool.showToastMessage("请输入驳回原因")
            return
        }
        
        if (submitStateCallBack == nil) {
            return
        }
        
        if auditSuccessBtn.isSelected {
            submitStateCallBack!(1,"")
        }else{
            submitStateCallBack!(-2,textView.text)
        }
        
        hiddenAuditView(0)
    }
    
    @objc private func successBtnClick() {
        auditSuccessBtn.isSelected     = true
        auditFailBtn.isSelected        = false
        textView.isHidden              = true
        auditSuccessImageView.isHidden = false
        placeHolderLable.isHidden      = true
    }
    
    @objc private func failBtnClick() {
        auditSuccessBtn.isSelected     = false
        auditFailBtn.isSelected        = true
        textView.isHidden              = false
        auditSuccessImageView.isHidden = true
        changeplaceHolderLableState()
    }
    
    func showAuditView() {
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
            self.closeBtn.isHidden = false
        }
    }
    
    
    
    @objc func hiddenAuditView(_ aniDuration: CGFloat = 0.25) {
        UIView.animate(
            withDuration: TimeInterval.init(aniDuration),
            animations: {
                self.contentView.snp.updateConstraints({ (maker) in
                    maker.top.equalTo(self.snp.top).offset(SQItemStruct.contentViewH * -1)
                })
                self.layoutIfNeeded()
        }) { (isFinish) in
            self.closeBtn.isHidden = true
            self.removeFromSuperview()
        }
    }
    
}


extension SQShowAuditView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        changeplaceHolderLableState()
    }
    
    private func changeplaceHolderLableState() {
        if textView.text.count > 0 {
            placeHolderLable.isHidden = true
        }else{
            placeHolderLable.isHidden = false
        }
    }
}
