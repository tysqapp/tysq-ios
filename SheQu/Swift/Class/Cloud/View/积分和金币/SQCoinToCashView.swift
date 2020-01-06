//
//  SQGoldToCashView.swift
//  SheQu
//
//  Created by gm on 2019/8/13.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    
    ///
    static let marginX = k_margin_x
    static let marginBigX = 30
    static let textViewH: CGFloat    = 25
    
    ///messageLabel
    static let messageLabelTop: CGFloat = 20
    static let messageLabelHeight: CGFloat = 14
    static let messageLabeFont  = k_font_title_weight
    static let messageLabeColor = UIColor.black
    static let messageLabeText  = "提现至BTC账户"
    
    ///addressLabel
    static let addressLabelTop: CGFloat   = 20
    static let addressLabelH: CGFloat     = 14
    static let addressLabelFont           = k_font_title
    static let addressLabelText = "账户地址："
    
    ///addressTextView
    static let addressTextViewTop: CGFloat  = 10
    static let addressTextViewFont = k_font_title_weight
    static let addressTextViewH: CGFloat    = 16
    
    
    ///coinTitleView
    static let coinTitleViewTop: CGFloat   = 18
    static let coinTitleViewH: CGFloat     = 14
    static let coinTitleViewW: CGFloat     = 100
    static let coinTitleViewFont           = k_font_title
    static let coinTitleText = "金币数量："
    
    ///coinMaxTitleLabel
    static let coinMaxTitleLabelTop: CGFloat = 7.5
    static let coinMaxTitleLabelH: CGFloat   = 10
    static let coinMaxTitleLabelText = "最大可提数量："
    static let coinMaxTitleLabelFont = UIFont.systemFont(ofSize: coinMaxTitleLabelH)
    
    ///coinTF
    static let coinTFTop: CGFloat  = 10
    static let coinTFTH: CGFloat   = 16
    
    ///emailView
    static let emailViewTop: CGFloat = 20
    static let emailViewH: CGFloat = 14
    static let emailText = "邮箱验证码："
    
    ///emailTF
    static let emailTFTop: CGFloat    = 10
    static let emailTFH: CGFloat      = 16
    
    ///noteLable
    static let noteLableTop: CGFloat  = 20
    static let noteLablelH: CGFloat   = 14
    static let noteLableW: CGFloat    = 100
    static let noteLableFont = k_font_title
    static let noteLableText = "备注："
    
    ///noteTextView
    static let noteTextViewTop: CGFloat        = 15
    static let noteTextViewH: CGFloat          = 16
    
    ///poundageLabel
    static let poundageLabelTop: CGFloat = 21
    static let poundageLabelH: CGFloat   = 12
    static let poundageLabelFont = k_font_title_12
    static let poundageLabelText = "网络手续费："
    
    ///fundsToTheAccount
    static let fundsToTheAccountLableTop: CGFloat = 7.5
    static let fundsToTheAccountLableH: CGFloat   = 12
    static let fundsToTheAccountLableFont = k_font_title_12
    static let fundsToTheAccountLableText = "到账数量："
    
    ///notingLabel
    static let notingLabelTop: CGFloat = 33
    static let notingLabelFont         = k_font_title_12
    static let notingLabelH: CGFloat   = 12
    
    ///notingLabel
    static let notingLabel12Top: CGFloat = 7.5
}

class SQCoinToCashView: UIView {
    
    enum Event {
        case getBtc
        case getPin
    }
    
    static let height: CGFloat = 550
    
    lazy var line1View: UIView = {
        let line1View = UIView()
        line1View.backgroundColor = k_color_line_light
        return line1View
    }()
    
    lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.text = SQItemStruct.messageLabeText
        messageLabel.font = SQItemStruct.messageLabeFont
        return messageLabel
    }()
    
    private lazy var addressTitleView: SQGoldToCashTitleView = {
        let addressTitleView = SQGoldToCashTitleView.init(frame: CGRect.zero, title: SQItemStruct.addressLabelText, btnTitle: "")
        return addressTitleView
    }()
    
    private lazy var addressTextView: SQGoldToCashTextView = {
        let addressTextView = SQGoldToCashTextView.init(frame: CGRect.zero, textContainer: nil)
        return addressTextView
    }()
    
    lazy var addressTextLineView: UIView = {
        let addressTextLineView = UIView()
        addressTextLineView.backgroundColor = k_color_line
        return addressTextLineView
    }()
    
    private lazy var coinTitleView: SQGoldToCashTitleView = {
        let coinTitleView = SQGoldToCashTitleView.init(frame: CGRect.zero, title: SQItemStruct.coinTitleText, btnTitle: "全部")
        return coinTitleView
    }()
    
    private lazy var coinTF: SQGoldToCashTextFiled = {
        let coinTF = SQGoldToCashTextFiled()
        coinTF.rightView = coinValueLabel
        coinTF.rightViewMode = .always
        coinTF.keyboardType  = .phonePad
        return coinTF
    }()
    
    lazy var coinMaxTitleLabel: UILabel = {
        let coinMaxTitleLabel  = UILabel()
        coinMaxTitleLabel.text = SQItemStruct.coinMaxTitleLabelText
        coinMaxTitleLabel.font = SQItemStruct.coinMaxTitleLabelFont
        coinMaxTitleLabel.textColor = k_color_title_light
        return coinMaxTitleLabel
    }()
    
    lazy var coinValueLabel: UILabel = {
        let coinTitleLabel = UILabel()
        coinTitleLabel.textAlignment = .right
        coinTitleLabel.setSize(size: CGSize.init(width: 200, height: SQItemStruct.textViewH))
        coinTitleLabel.font = k_font_title
        coinTitleLabel.textColor = k_color_title_gray_blue
        coinTitleLabel.text      = "≈ 0.0 BTC"
        return coinTitleLabel
    }()
    
    private lazy var emailView: SQGoldToCashTitleView = {
        let emailView = SQGoldToCashTitleView.init(frame: CGRect.zero, title: SQItemStruct.emailText, btnTitle: "获取验证码")
        return emailView
    }()
    
    private lazy var emailTF: SQGoldToCashTextFiled = {
        let emailTF = SQGoldToCashTextFiled()
        return emailTF
    }()
    
    lazy var noteLabel: UILabel = {
        let noteLabel = UILabel()
        noteLabel.text = SQItemStruct.noteLableText
        noteLabel.font = SQItemStruct.noteLableFont
        return noteLabel
    }()
    
    lazy var noteTextView: SQGoldToCashTextView = {
        let noteTextView = SQGoldToCashTextView.init(frame: CGRect.zero, textContainer: nil)
        return noteTextView
    }()
    
    lazy var noteTextLineView: UIView = {
        let noteTextLineView = UIView()
        noteTextLineView.backgroundColor = k_color_line
        return noteTextLineView
    }()
    
    /// 网络手续费
    lazy var poundageLabel: UILabel = {
        let poundageLabel = UILabel()
        poundageLabel.textColor = k_color_black
        poundageLabel.font = SQItemStruct.poundageLabelFont
        poundageLabel.text = SQItemStruct.poundageLabelText + "0.00BTC"
        return poundageLabel
    }()
    
    
    /// 到账数量
    lazy var fundsToTheAccountLabel: UILabel = {
        let fundsToTheAccountLabel = UILabel()
        fundsToTheAccountLabel.textColor = k_color_black
        fundsToTheAccountLabel.font = SQItemStruct.fundsToTheAccountLableFont
        fundsToTheAccountLabel.text = SQItemStruct.fundsToTheAccountLableText + "0.00BTC"
        return fundsToTheAccountLabel
    }()
    
    
    /// 底部注释栏
    lazy var notingLabel: UILabel = {
        let notingLabel = UILabel()
        notingLabel.text = "注："
        notingLabel.numberOfLines = 0
        notingLabel.font          = SQItemStruct.notingLabelFont
        notingLabel.textColor     = k_color_title_gray_blue
        return notingLabel
    }()
    
    /// 底部注释栏
    lazy var notingLabel1: UILabel = {
        let notingLabel1 = UILabel()
        notingLabel1.text = "(1）汇率是一个波动的值，按提交申请时的汇率计算；"
        notingLabel1.numberOfLines = 0
        notingLabel1.font          = SQItemStruct.notingLabelFont
        notingLabel1.textColor     = k_color_title_gray_blue
        return notingLabel1
    }()
    
    /// 底部注释栏
    lazy var notingLabel2: UILabel = {
        let notingLabel = UILabel()
        notingLabel.text = "(2）网络手续费费率为0.5%，低于0.001BTC，则按0.001BTC收取；"
        notingLabel.numberOfLines = 0
        notingLabel.font          = SQItemStruct.notingLabelFont
        notingLabel.textColor     = k_color_title_gray_blue
        return notingLabel
    }()
    
    private lazy var gcdTimer    = SQGCDTimer() //gcd定时器，处理验证码时间
    private var isTheTiming = false
    
    private lazy var coinTotalNum = 0
    private lazy var cap_id       = ""
    
    var sureBtnCallBack: ((_ sureBtnState: Bool) -> ())?
    var eventCallBack: ((SQCoinToCashView.Event) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(line1View)
        addSubview(messageLabel)
        addSubview(addressTitleView)
        addSubview(addressTextView)
        addSubview(coinTF)
        addSubview(coinTitleView)
        addSubview(coinMaxTitleLabel)
        addSubview(emailView)
        addSubview(emailTF)
        addSubview(noteLabel)
        addSubview(noteTextView)
        addSubview(poundageLabel)
        addSubview(fundsToTheAccountLabel)
        addSubview(notingLabel)
        addSubview(notingLabel1)
        addSubview(notingLabel2)
        addSubview(addressTextLineView)
        addSubview(noteTextLineView)
        addLayout()
        addCallBack()
        emailTF.addTarget(self, action: #selector(tfValueChanged), for: .editingChanged)
        coinTF.addTarget(self, action: #selector(tfValueChanged), for: .editingChanged)
    }
    
    func addLayout() {
        line1View.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.top.equalTo(snp.top)
            maker.height.equalTo(k_line_height_big)
        }
        
        messageLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left)
                .offset(SQItemStruct.marginBigX)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(SQItemStruct.messageLabelHeight)
            maker.top.equalTo(line1View.snp.bottom)
                .offset(SQItemStruct.messageLabelTop)
        }
        
        addressTitleView.snp.makeConstraints { (maker) in
            maker.right.equalTo(snp.right).offset(-20)
            maker.height.equalTo(SQItemStruct.addressLabelH)
            maker.top.equalTo(messageLabel.snp.bottom)
                .offset(SQItemStruct.addressLabelTop)
            maker.left.equalTo(snp.left)
                .offset(SQItemStruct.marginX)
        }
        
        addressTextView.snp.makeConstraints { (maker) in
            maker.left.equalTo(addressTitleView.snp.left)
            maker.right.equalTo(addressTitleView.snp.right)
            maker.height.equalTo(SQItemStruct.textViewH)
            maker.top.equalTo(addressTitleView.snp.bottom)
                .offset(SQItemStruct.addressTextViewTop)
        }
        
        addressTextLineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(addressTitleView.snp.left)
            maker.right.equalTo(addressTitleView.snp.right)
            maker.height.equalTo(k_line_height)
            maker.top.equalTo(addressTextView.snp.bottom)
                .offset(k_line_height * -1 - 2)
        }
        
        coinTitleView.snp.makeConstraints { (maker) in
            maker.left.equalTo(addressTitleView.snp.left)
            maker.right.equalTo(addressTitleView.snp.right)
            maker.height.equalTo(SQItemStruct.coinTitleViewH)
            maker.top.equalTo(addressTextView.snp.bottom)
                .offset(SQItemStruct.coinTitleViewTop)
        }
        
        coinMaxTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left).offset(30)
            maker.right.equalTo(addressTitleView.snp.right)
            maker.height.equalTo(SQItemStruct.coinMaxTitleLabelH)
            maker.top.equalTo(coinTitleView.snp.bottom)
                .offset(SQItemStruct.coinMaxTitleLabelTop)
        }
        
        coinTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(addressTitleView.snp.left)
            maker.right.equalTo(addressTitleView.snp.right)
            maker.height.equalTo(SQItemStruct.textViewH)
            maker.top.equalTo(coinMaxTitleLabel.snp.bottom)
                .offset(SQItemStruct.coinTFTop)
        }
        
        emailView.snp.makeConstraints { (maker) in
            maker.left.equalTo(addressTitleView.snp.left)
            maker.right.equalTo(addressTitleView.snp.right)
            maker.height.equalTo(SQItemStruct.emailViewH)
            maker.top.equalTo(coinTF.snp.bottom)
                .offset(SQItemStruct.emailViewTop)
        }
        
        emailTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(addressTitleView.snp.left)
            maker.right.equalTo(addressTitleView.snp.right)
            maker.height.equalTo(SQItemStruct.textViewH)
            maker.top.equalTo(emailView.snp.bottom)
                .offset(SQItemStruct.emailTFTop)
        }
        
        noteLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left).offset(30)
            maker.right.equalTo(addressTitleView.snp.right)
            maker.height.equalTo(SQItemStruct.noteLablelH)
            maker.top.equalTo(emailTF.snp.bottom)
                .offset(SQItemStruct.noteLableTop)
        }
        
        noteTextView.snp.makeConstraints { (maker) in
            maker.left.equalTo(addressTitleView.snp.left)
            maker.right.equalTo(addressTitleView.snp.right)
            maker.height.equalTo(SQItemStruct.textViewH)
            maker.top.equalTo(noteLabel.snp.bottom)
                .offset(SQItemStruct.noteTextViewTop)
        }
        
        noteTextLineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(addressTitleView.snp.left)
            maker.right.equalTo(addressTitleView.snp.right)
            maker.height.equalTo(k_line_height)
            maker.top.equalTo(noteTextView.snp.bottom)
                .offset(k_line_height * -1 - 2)
        }
        
        poundageLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(addressTitleView.snp.left)
            maker.right.equalTo(addressTitleView.snp.right)
            maker.height.equalTo(poundageLabel.snp.height)
            maker.top.equalTo(noteTextView.snp.bottom)
                .offset(SQItemStruct.poundageLabelTop)
        }
        
        fundsToTheAccountLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(addressTitleView.snp.left)
            maker.right.equalTo(addressTitleView.snp.right)
            maker.height.equalTo(SQItemStruct
                .fundsToTheAccountLableH)
            maker.top.equalTo(poundageLabel.snp.bottom)
                .offset(SQItemStruct.fundsToTheAccountLableTop)
        }
        
        notingLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(addressTitleView.snp.left)
            maker.right.equalTo(addressTitleView.snp.right)
            maker.height.equalTo(SQItemStruct.notingLabelH)
            maker.top.equalTo(fundsToTheAccountLabel.snp.bottom)
                .offset(SQItemStruct.notingLabelTop)
        }
        
        let height1 = notingLabel1.text!.calcuateLabSizeHeight(font: SQItemStruct.notingLabelFont, maxWidth: k_screen_width - 40) + 5
        notingLabel1.snp.makeConstraints { (maker) in
            maker.left.equalTo(addressTitleView.snp.left)
            maker.right.equalTo(addressTitleView.snp.right)
            maker.height.equalTo(height1)
            maker.top.equalTo(notingLabel.snp.bottom)
                .offset(SQItemStruct.notingLabel12Top)
        }
        
        let height2 = notingLabel2.text!.calcuateLabSizeHeight(font: SQItemStruct.notingLabelFont, maxWidth: k_screen_width - 40) + 5
        notingLabel2.snp.makeConstraints { (maker) in
            maker.left.equalTo(addressTitleView.snp.left)
            maker.right.equalTo(addressTitleView.snp.right)
            maker.height.equalTo(height2)
            maker.top.equalTo(notingLabel1.snp.bottom)
                .offset(SQItemStruct.notingLabel12Top)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getAddress() -> String {
        return addressTextView.text
    }
    
    func getNote() -> String {
        return noteTextView.text
    }
    
    func getCoinNum() -> String {
        
        return coinTF.text!
    }
    
    
    /// 获取邮箱验证码 和 验证码ID
    ///
    /// - Returns: 返回 验证码 和 验证码ID
    func getEmailInfo() -> (captcha_id: String,captcha: String) {
        
        return (cap_id,emailTF.text!)
    }
    
    
    func updatePoundageLabel(_ poundage: CGFloat) {
        coinTitleView.clickBtn.isEnabled = true
        poundageLabel.text = SQItemStruct.poundageLabelText + "\(poundage.scientificCountsToFloat()) BTC"
    }
    
    func updateValueLabel(_ value: CGFloat) {
        
        coinValueLabel.text = "≈ \(value.scientificCountsToFloat()) BTC"
    }
    
    func updateFundsToTheAccount(_ fundsToTheAccount: CGFloat) {
        var value = fundsToTheAccount
        if value <= 0 {
            value = 0
        }
        fundsToTheAccountLabel.text = SQItemStruct.fundsToTheAccountLableText + "\(value.scientificCountsToFloat()) BTC"
    }
    
    func updateCoinMaxTitleLabelText(_ coinNum: Int) {
        coinTotalNum = coinNum
        coinMaxTitleLabel.text = SQItemStruct.coinMaxTitleLabelText + coinNum.toEuropeanType(3)
    }
    
    func updateCap_id(_ cap_id: String) {
        self.cap_id = cap_id
        getVerificationCodeSuccess()
    }
    
    
    @objc func tfValueChanged() {
        checkSureBtnState()
    }
    
    func checkSureBtnState() {
        let vfAddress: Bool = addressTextView.text.count > 0
        let vfCoin: Bool    = coinTF.text!.count > 0
        let vfEmail: Bool   = emailTF.text!.count > 0
        let state = vfAddress && vfCoin && vfEmail
        
        if (sureBtnCallBack != nil) {
            sureBtnCallBack!(state)
        }
    }
    
    func addCallBack() {
        weak var weakSelf = self
        addressTextView.editCallBack = { state in
           weakSelf?.checkSureBtnState()
        }
        
        coinTitleView.callBack = { titleView in
            weakSelf?.coinTF.text = "\(weakSelf!.coinTotalNum)"
            weakSelf?.getBTC()
        }
        
        coinTF.editEndCallBack = { coinTF in
            weakSelf?.getBTC()
        }
        
        emailView.callBack = { emailViewTemp in
            emailViewTemp.clickBtn.isEnabled = true
            weakSelf?.getPinCode()
        }
        
        addressTextView.heightCallBack = { height in
            if height < SQItemStruct.textViewH {
                return
            }
            weakSelf?.addressTextView.snp.updateConstraints({ (maker) in
                maker.height.equalTo(height)
            })
            
            weakSelf?.updateConstraints()
        }
        
        noteTextView.heightCallBack = { height in
            if height < SQItemStruct.textViewH {
                return
            }
            
            weakSelf?.noteTextView.snp.updateConstraints({ (maker) in
                maker.height.equalTo(height)
            })
            
            weakSelf?.updateConstraints()
        }
    }
    
    
    func getPinCode() {
        if isTheTiming {
            return
        }
        if eventCallBack != nil {
            eventCallBack!(SQCoinToCashView.Event.getPin)
        }
    }
    
    func getBTC(){
        if eventCallBack != nil {
            eventCallBack!(SQCoinToCashView.Event.getBtc)
        }
    }
    
    func getVerificationCodeSuccess() {
        isTheTiming  = true
        weak var weakSelf = self
        gcdTimer.startTimer(1.0, 60) { (count) in
            if(count == 0){//当时间为零时1
                weakSelf?.isTheTiming = false
                weakSelf?.emailView.clickBtn.setTitle("获取验证码", for: .normal)
            }else{
            weakSelf?.emailView.clickBtn.setTitle(String.init(format: "%d 秒", count), for: .normal)
            }
        }
        
    }
}


fileprivate class SQGoldToCashTitleView: UIView {
    
    lazy var starLabel: UILabel = {
        let starLabel = UILabel()
        starLabel.textAlignment = .left
        starLabel.text          = "*"
        starLabel.font          = k_font_title
        starLabel.textColor     = UIColor.colorRGB(0xee0000)
        return starLabel
    }()
    
    lazy var titleLable: UILabel = {
        let titleLable = UILabel()
        titleLable.font = k_font_title
        return titleLable
    }()
    
    lazy var clickBtn: UIButton = {
        let clickBtn = UIButton()
        clickBtn.isHidden = true
        clickBtn.setTitleColor(k_color_title_blue, for:  .normal)
        clickBtn.titleLabel?.font = k_font_title
        clickBtn.contentHorizontalAlignment = .right
        clickBtn.addTarget(
            self,
            action: #selector(btnClick),
            for: .touchUpInside
        )
        return clickBtn
    }()
    
    var callBack: ((SQGoldToCashTitleView)-> ())?
    
    init(frame: CGRect, title: String, btnTitle: String) {
        super.init(frame: frame)
        addSubview(starLabel)
        addSubview(titleLable)
        addSubview(clickBtn)
        
        titleLable.text = title
        if btnTitle.count > 0 {
            clickBtn.isHidden = false
            clickBtn.setTitle(btnTitle, for: .normal)
        }
        
        addLayout()
    }
    
   private func addLayout() {
        
        starLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left)
            maker.top.equalTo(snp.top)
            maker.bottom.equalTo(snp.bottom)
            maker.width.equalTo(10)
        }
        
        titleLable.snp.makeConstraints { (maker) in
            maker.left.equalTo(starLabel.snp.right)
            maker.top.equalTo(snp.top)
            maker.bottom.equalTo(snp.bottom)
            maker.width.equalTo(150)
        }
        
        clickBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLable.snp.left)
            maker.top.equalTo(snp.top)
            maker.bottom.equalTo(snp.bottom)
            maker.right.equalTo(snp.right)
        }
        
    }
    
    @objc func btnClick() {
        if (callBack != nil) {
            clickBtn.isEnabled = false
            callBack!(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class SQGoldToCashTextView: UITextView, UITextViewDelegate {
    
    var heightCallBack:((CGFloat) -> ())?
    var editCallBack:((Bool) -> ())?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator   = false
        isScrollEnabled                = false
        textContainerInset  = UIEdgeInsets.init(
            top: 0,
            left: 6,
            bottom: 0,
            right: 0
        )
        font = k_font_title_weight
        delegate = self
    }
    
    
    
    
    
    //MARK: ----------textviewDelegate------------
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        var textValue: String = textView.text
        if range.length > 0 { ///去除被替换部分
            let textValueTemp: NSString = textValue as NSString
           textValue = textValueTemp.replacingCharacters(in: range, with: "")
        }
        
        textValue = textValue + text
        let height = textValue.calcuateLabSizeHeight(font: textView.font!, maxWidth: textView.width())
        
        if (heightCallBack != nil) {
            heightCallBack!(height + 5)
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (editCallBack != nil) {
            editCallBack!(true)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class SQGoldToCashTextFiled: UITextField, UITextFieldDelegate {
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line
        return lineView
    }()
    
    var editEndCallBack: ((SQGoldToCashTextFiled) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lineView)
        let view = UIView()
        view.setSize(size: CGSize.init(width: 10, height: 20))
        leftView = view
        leftViewMode = .always
        font = k_font_title_weight
        delegate = self
        addLayout()
    }
    
    func addLayout() {
        lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(k_line_height)
            maker.bottom.equalTo(snp.bottom).offset(k_line_height * -1)
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (editEndCallBack != nil) {
            editEndCallBack!(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
