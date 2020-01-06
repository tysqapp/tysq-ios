//
//  SQShowCaptchaView.swift
//  SheQu
//
//  Created by gm on 2019/8/12.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    static let width: CGFloat  = SQShowCaptchaView.width
    static let height: CGFloat = SQShowCaptchaView.height
    
    ///contentView
    static var contentViewTop: CGFloat  = 150
    static let contentViewLeft: CGFloat = 20
    static let contentViewH: CGFloat = captchaImageViewH + 105
    static let contentViewW: CGFloat = captchaImageViewW
    
    ///closeBtn
    static let closeBtnTop: CGFloat       = 50
    static let closeBtnWH: CGFloat        = 30
    
    ///captchaImageView
    static let captchaImageViewH: CGFloat = SQShowCaptchaView.height
    static let captchaImageViewW: CGFloat = SQShowCaptchaView.width
    
    ///tf
    static let captchaTFX: CGFloat       = 17
    static let captchaTFRight: CGFloat   = 15
    static let captchaTFH: CGFloat       = submitBtnH
    static let captchaTFTop: CGFloat     = 15
    
    ///submitBtn
    static let submitBtnW: CGFloat = 90
    static let submitBtnH: CGFloat = 70
    static let submitBtnTop: CGFloat = 17.5
    static let submitBtnRight: CGFloat = 17
    
    static let aniDuration = 0.4
}

class SQShowCaptchaView: UIView {
    
    enum event {
       ///取消
       case cancel
       ///提交
       case submit
       ///刷新
       case refreshCaptcha
    }
    
    static let width: CGFloat  = k_screen_width - 40
    static var height: CGFloat = 335
    
    
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage.init(named: "sq_integral_bg")
        return bgImageView
    }()
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = UIColor.black
        coverView.alpha = 0.7
        return coverView
    }()
    
    
    
    lazy var closeBtn: UIButton = {
        let closeBtn = UIButton()
        closeBtn.setImage(
            UIImage.init(named: "sq_integral_close"),
            for: .normal
        )
        
        closeBtn.addTarget(
            self,
            action: #selector(hiddenCaptchaViewClick),
            for: .touchUpInside
        )
        
        closeBtn.isHidden = true
        return closeBtn
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
            radii: k_corner_radiu_size,
            borderWidth: 0.1,
            borderColor: UIColor.clear
        )
        
        return contentView
    }()
    
    lazy var captchaImageView: UIImageView = {
        let captchaImageView = UIImageView()
        return captchaImageView
    }()
    
    lazy var captchaTF: SQLoginTextField = {
        let captchaTF = SQLoginTextField()
        let att  = [
            NSAttributedString.Key.font: k_font_title_22,
            NSAttributedString.Key.foregroundColor: k_color_title_gray_blue
        ]
        
        captchaTF.attributedPlaceholder = NSAttributedString.init(
            string: "输入验证码",attributes: att)
        
        captchaTF.font        = k_font_title_22
        captchaTF.addTarget(
            self,
            action: #selector(tfChange),
            for: .editingChanged
        )
        
        let captchaTFW = SQItemStruct.contentViewW - SQItemStruct.submitBtnW - SQItemStruct.captchaTFRight - SQItemStruct.captchaTFX * 2
        captchaTF.setSize(size: CGSize.init(
            width: captchaTFW,
            height: SQItemStruct.captchaTFH
        ))
        
        captchaTF.layer.cornerRadius = k_corner_radiu
        captchaTF.layer.borderWidth  = 0.7
        captchaTF.layer.borderColor  = k_color_normal_blue.cgColor
        captchaTF.initSubViews()
        
        let refreshBtn          = UIButton()
        refreshBtn.setImage(UIImage.init(named: "login_refresh"), for: .normal)
        refreshBtn.setSize(size: CGSize.init(width: 30, height: 50))
        let rightV = UIView(frame: CGRect.init(x: 0, y: 0, width: 30, height: 50))
        rightV.addSubview(refreshBtn)
        captchaTF.rightView     = rightV
        captchaTF.rightViewMode = .always
        refreshBtn.addTarget(
            self,
            action: #selector(refreshBtnClick),
            for: .touchUpInside
        )
        
        let leftView = UIView()
        leftView.setSize(size: CGSize.init(
            width: 20,
            height: SQItemStruct.captchaTFH
        ))
        
        captchaTF.leftView = leftView
        captchaTF.leftViewMode = .always
        
        return captchaTF
    }()
    
    lazy var submitBtn: UIButton = {
        let submitBtn  = UIButton()
        submitBtn.setTitle("提交", for: .normal)
        submitBtn.titleLabel?.font = k_font_title_22
        submitBtn.backgroundColor = k_color_line
        submitBtn.setSize(size: CGSize.init(
            width: SQItemStruct.submitBtnW,
            height: SQItemStruct.submitBtnH
        ))
        
        submitBtn.isEnabled = false
        submitBtn.layer.cornerRadius = k_corner_radiu
        submitBtn.addTarget(
            self,
            action: #selector(submitBtnClick),
            for: .touchUpInside
        )
        
        return submitBtn
    }()
    var keyBoardTag = 0
    var callBack: ((SQShowCaptchaView.event)->())!
    
     private lazy var captcha      = ""
    
    init(frame: CGRect, handel:@escaping ((SQShowCaptchaView.event)->())) {
        super.init(frame: frame)
        callBack = handel
        SQItemStruct.contentViewTop =  150
        if UIScreen.main.bounds.height <  667 {
            SQItemStruct.contentViewTop = 20
            
            if UIScreen.main.bounds.height < 500 {
                SQShowCaptchaView.height = 300
            }
        }
        
        addSubview(bgImageView)
        addSubview(coverView)
        addSubview(contentView)
        addSubview(closeBtn)
        contentView.addSubview(captchaImageView)
        contentView.addSubview(captchaTF)
        contentView.addSubview(submitBtn)
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
       let captchaTFFrame     = contentView.convert(captchaTF.frame, to: UIApplication.shared.keyWindow)
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
        
        bgImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.bottom.equalTo(snp.bottom)
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
        }
        
        coverView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.bottom.equalTo(snp.bottom)
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
        }
        
        contentView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(snp.centerX)
            maker.top.equalTo(snp.top)
                .offset(SQItemStruct.contentViewH * -1)
            maker.height.equalTo(SQItemStruct.contentViewH)
            maker.width.equalTo(SQItemStruct.contentViewW)
        }
        
        closeBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(SQItemStruct.closeBtnWH)
            maker.height.equalTo(SQItemStruct.closeBtnWH)
            maker.centerX.equalTo(snp.centerX)
            maker.top.equalTo(contentView.snp.bottom)
                .offset(SQItemStruct.closeBtnTop)
        }
        
        captchaImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView.snp.top)
            maker.left.equalTo(contentView.snp.left)
            maker.width.equalTo(SQItemStruct.captchaImageViewW)
            maker.height.equalTo(SQItemStruct.captchaImageViewH)
        }
        
        captchaTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(contentView.snp.left)
                .offset(SQItemStruct.captchaTFX)
            maker.right.equalTo(submitBtn.snp.left)
                .offset(SQItemStruct.captchaTFX * -1)
            maker.height.equalTo(SQItemStruct.captchaTFH)
            maker.top.equalTo(submitBtn.snp.top)
        }
        
        submitBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(SQItemStruct.submitBtnW)
            maker.height.equalTo(SQItemStruct.submitBtnH)
            maker.right.equalTo(contentView.snp.right)
                .offset(SQItemStruct.submitBtnRight * -1)
            maker.top.equalTo(captchaImageView.snp.bottom)
                .offset(SQItemStruct.submitBtnTop)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tfChange() {
        let isEnabled = captchaTF.text!.count > 0
        if isEnabled == submitBtn.isEnabled {
            return
        }
        
        submitBtn.isEnabled = isEnabled
        submitBtn.updateBGColor(k_corner_radiu)
    }
    
    @objc private func refreshBtnClick() {
        callBack(.refreshCaptcha)
    }
    
    @objc private func hiddenCaptchaViewClick() {
        endEditing(true)
        callBack(.cancel)
    }
    
    @objc private func submitBtnClick() {
        callBack(.submit)
    }
    
    open func showCaptchaView() {
        UIApplication.shared.keyWindow?.addSubview(self)
        ///获取验证码
        callBack(.refreshCaptcha)
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
    
    open func hiddenCaptchaView() {
        UIView.animate(
            withDuration: TimeInterval.init(SQItemStruct.aniDuration),
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
    
    open func getCaptchaModel() -> (captcha: String, captchaValue: String){
        return (captcha, captchaTF.text!)
    }
    
    open func updateShowCaptchaView(captchaModel: SQCaptchaStruct) {
        captcha = captchaModel.captcha_id
        
        let imageStrArray = captchaModel.captcha_base64.components(separatedBy: "image/png;base64,")
        let imageStr =  imageStrArray.last
        
        guard let imageData = Data(base64Encoded: imageStr!, options: .ignoreUnknownCharacters) else {
            return
        }
        
        captchaImageView.image = UIImage.init(data: imageData)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
