//
//  SQShowRewardView.swift
//  SheQu
//
//  Created by iMac on 2019/11/7.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit


fileprivate struct SQItemStruct {
    ///tipsView
    static let tipsViewW: CGFloat = 335
    static let tipsViewH: CGFloat = 360
    
    ///closeBtn
    static let closeBtnTop: CGFloat = 50
    static let closeBtnWH: CGFloat   = 30
    
    ///rewardPriceBtn
    static let rewardPriceBtnW: CGFloat = 80
    static let rewardPriceBtnH: CGFloat   = 45
}

class SQShowRewardView: UIView {
    weak var vc: UIViewController?
    //遮罩
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
            action: #selector(hiddenRewardView),
            for: .touchUpInside
        )
        
        return closeBtn
    }()
    
    lazy var tipsView: SQRewardTipsView = {
        let tipsView = SQRewardTipsView()
        tipsView.backgroundColor = .white
        tipsView.layer.cornerRadius = 10
        tipsView.isHidden = false
        return tipsView
    }()
    
    lazy var goldShortageTipsView: GoldShortageTipsView = {
        let tipsView = GoldShortageTipsView()
        tipsView.backgroundColor = .white
        tipsView.layer.cornerRadius = 10
        tipsView.isHidden = true
        tipsView.vc = self.vc
        return tipsView
    }()
    
    init(frame: CGRect, vc: UIViewController) {
        super.init(frame: frame)
        self.vc = vc
        addSubview(coverView)
        addSubview(tipsView)
        addSubview(goldShortageTipsView)
        addSubview(closeBtn)
        
        addLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLayout() {
        coverView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.bottom.equalTo(snp.bottom)
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
        }
        
        tipsView.snp.makeConstraints { (maker) in
            maker.center.equalTo(snp.center)
            maker.height.equalTo(300)
            maker.width.equalTo(SQItemStruct.tipsViewW)
        }
        
        goldShortageTipsView.snp.makeConstraints { (maker) in
            maker.center.equalTo(snp.center)
            maker.height.equalTo(SQItemStruct.tipsViewH)
            maker.width.equalTo(SQItemStruct.tipsViewW)
        }
        
        closeBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(snp.centerX)
            maker.width.equalTo(SQItemStruct.closeBtnWH)
            maker.height.equalTo(SQItemStruct.closeBtnWH)
            maker.top.equalTo(tipsView.snp.bottom)
                .offset(SQItemStruct.closeBtnTop)
        }
    }
    
    
    @objc func hiddenRewardView() {
        self.removeFromSuperview()
    }
}



// -----------------------------打赏提示View------------------------------------
class SQRewardTipsView: UIView, UITextFieldDelegate {
    lazy var priceArray = [100, 200, 500, 1000, 2000, 0]
    lazy var priceBtnArray = [RewardPriceBtn]()
    var selectedBtn: RewardPriceBtn?
    var rewardCallback: ((Int) -> ())?
    private var moveY: CGFloat = 0.0
    lazy var keyBoardTag = 0
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "打赏金币"
        titleLabel.font = k_font_title_16_weight
        titleLabel.textColor = k_color_title_black
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    lazy var subTitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.text = "千言万语都抵不过一次打赏，给作者一些鼓励吧。"
        subtitleLabel.font = k_font_title_12
        subtitleLabel.textColor = k_color_title_black
        subtitleLabel.textAlignment = .center
        return subtitleLabel
    }()
    
    lazy var rewardBtn: UIButton = {
        let rewardBtn = UIButton()
        rewardBtn.setSize(size: CGSize.init(width: 295, height: 45))
        rewardBtn.setTitle("打赏", for: .normal)
        rewardBtn.titleLabel?.font = k_font_title_weight
        rewardBtn.setTitleColor(UIColor.white, for: .normal)
        rewardBtn.updateBGColor(4)
        rewardBtn.addTarget(self, action: #selector(reward(sender:)), for: .touchUpInside)
        return rewardBtn
    }()
    
    lazy var customizeRewardPriceView: CustomizeRewardPriceView = {
        let customizeRewardPriceView = CustomizeRewardPriceView()
        customizeRewardPriceView.textField.delegate = self
        customizeRewardPriceView.isHidden = true
        return customizeRewardPriceView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(rewardBtn)
        priceBtnArray = priceArray.map {
            let btn = RewardPriceBtn(price: $0)
            btn.addTarget(self, action: #selector(selectGoldBtn(sender:)), for: .touchUpInside)
            return btn
        }
        
        priceBtnArray.last?.setTitle("自定义", for: .normal)
        priceBtnArray.last?.setTitle("自定义", for: .selected)
        priceBtnArray.last?.setImage(nil, for: .normal)
        priceBtnArray.last?.setImage(nil, for: .selected)
        priceBtnArray.last?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        priceBtnArray.last?.titleEdgeInsets = UIEdgeInsets.init(top: 16, left: 10, bottom: 16, right: 10)
        priceBtnArray.last?.tag = 123456

        priceBtnArray.forEach { [weak self] in
            self?.addSubview($0)
        }
        
        addSubview(customizeRewardPriceView)
        addLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(keybordShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybordHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        //移除监听
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keybordShow(notification: Notification) {
        
        if keyBoardTag == 1 {
            return
        }
        
        let  keyBoardFrame = notification.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! CGRect
        if keyBoardFrame.origin.y < self.frame.maxY - 90 {
            keyBoardTag += 1
        } else {
            return
        }
        TiercelLog(self.debugDescription)
        
        let keyBoardY: CGFloat = keyBoardFrame.origin.y
        
        moveY = self.frame.maxY - 90 - keyBoardY + 15
        
        
        UIView.animate(withDuration: 0.25) {
            self.snp.updateConstraints { (maker) in
                maker.centerY.equalTo(self.superview!.snp.centerY)
                    .offset(-self.moveY)
            }
            self.layoutIfNeeded()
        }
        
        
    }
    
    @objc func keybordHide(notification: Notification) {
        keyBoardTag = 0
        UIView.animate(withDuration: 0.25) {
            self.snp.updateConstraints { (maker) in
                maker.centerY.equalTo(self.superview!.snp.centerY)
            }
            self.layoutIfNeeded()
        }
        moveY = 0
    }
    
    func addLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.top.equalTo(snp.top).offset(18)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.top.equalTo(titleLabel.snp.bottom).offset(11)
        }
        
        for i in 0..<priceBtnArray.count {
            let topOffset = 28 + (i / 3) * Int(SQItemStruct.rewardPriceBtnH + 15)
            let leftOffset = 20 + (i % 3) * Int(SQItemStruct.rewardPriceBtnW + 27)
            priceBtnArray[i].snp.makeConstraints {
                $0.top.equalTo(subTitleLabel.snp.bottom).offset(topOffset)
                $0.left.equalTo(snp.left).offset(leftOffset)
                $0.width.equalTo(SQItemStruct.rewardPriceBtnW)
                $0.height.equalTo(SQItemStruct.rewardPriceBtnH)
            }

        }
        
        rewardBtn.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.left.equalTo(snp.left).offset(20)
            $0.right.equalTo(snp.right).offset(-20)
            $0.bottom.equalTo(snp.bottom).offset(-35)
        }
        
        customizeRewardPriceView.snp.makeConstraints {
            $0.bottom.equalTo(rewardBtn.snp.top).offset(-25)
            $0.left.equalTo(rewardBtn.snp.left)
            $0.right.equalTo(rewardBtn.snp.right)
            $0.height.equalTo(40)
        }
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else{
            return true
        }
        
        let textLength = text.count + string.count - range.length
        
        return textLength <= 8
    }
    
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        selectedBtn?.isSelected = false
        selectedBtn?.layer.borderColor = k_color_line.cgColor
        let newSelectedBtn = priceBtnArray.last
        newSelectedBtn?.layer.borderColor = k_color_normal_blue.cgColor
        newSelectedBtn?.isSelected = true
        selectedBtn = newSelectedBtn
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///选择的打赏数量按钮
    @objc func selectGoldBtn(sender: Any?) {
        selectedBtn?.isSelected = false
        selectedBtn?.layer.borderColor = k_color_line.cgColor
        let newSelectedBtn = sender as! RewardPriceBtn
        newSelectedBtn.layer.borderColor = k_color_normal_blue.cgColor
        newSelectedBtn.isSelected = true
        selectedBtn = newSelectedBtn
        if selectedBtn?.tag == 123456 {
            customizeRewardPriceView.isHidden = false
            snp.updateConstraints {
                $0.height.equalTo(SQItemStruct.tipsViewH)
            }
            customizeRewardPriceView.textField.becomeFirstResponder()
        } else {
            customizeRewardPriceView.textField.text = ""
            customizeRewardPriceView.isHidden = true
            customizeRewardPriceView.textField.resignFirstResponder()
            snp.updateConstraints {
                $0.height.equalTo(300)
            }
        }
    }
    
    ///打赏操作
    @objc func reward(sender: Any?) {
        if let callback = rewardCallback {
            if selectedBtn?.tag != 123456 {
                callback(selectedBtn?.price ?? 0)
            } else {
                /// -1代表没有输入 提示请选择打赏数量   -2代表输入非法字符 提示请输入大于100的整数
                let price = Int(customizeRewardPriceView.textField.text ?? "-1") ?? -2
                callback(price)
                
            }
            
        }
        customizeRewardPriceView.textField.resignFirstResponder()
    }
    
}


///自定义打赏金额View
class CustomizeRewardPriceView: UIView {
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .numberPad
        tf.placeholder = "请输入打赏金币数"
        tf.font = UIFont.boldSystemFont(ofSize: 16)
        tf.textColor = k_color_normal_blue
        return tf
    }()
    
    lazy var label: UIImageView = {
        let lb = UIImageView(image: "sq_reward_star".toImage())
        return lb
    }()
    
    lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = k_color_normal_blue
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(textField)
        addSubview(label)
        addSubview(line)
        addLayout()
    }
    
    func addLayout(){
        line.snp.makeConstraints {
            $0.left.equalTo(snp.left)
            $0.right.equalTo(snp.right)
            $0.height.equalTo(0.5)
            $0.bottom.equalTo(snp.bottom)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalTo(snp.centerY)
            $0.left.equalTo(snp.left)
            $0.width.equalTo(12)
            $0.height.equalTo(12)
        }
        
        textField.snp.makeConstraints {
            $0.centerY.equalTo(snp.centerY)
            $0.left.equalTo(label.snp.right).offset(10)
            $0.height.equalTo(18)
            $0.right.equalTo(snp.right)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

///打赏金额按钮
class RewardPriceBtn: UIButton {
    var price = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(price: Int) {
        self.init(frame: CGRect.zero)
        self.price = price
        titleLabel?.font = k_font_title_16_weight
        setTitle("\(price)", for: .normal)
        setTitleColor(k_color_normal_blue, for: .selected)
        setTitleColor(k_color_black, for: .normal)
        setImage("sq_reward_star".toImage(), for: .normal)
        setImage("sq_reward_star".toImage(), for: .selected)
        imageEdgeInsets = UIEdgeInsets.init(top: 16, left: 8, bottom: 16, right: 59)
        titleEdgeInsets = UIEdgeInsets.init(top: 16, left: 12, bottom: 16, right: 10)
        layer.borderColor = k_color_line.cgColor
        layer.borderWidth = k_line_height
        layer.cornerRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
// ---------------------------------------------------------------------------------------

// -----------------------------打赏金币不足温馨提示View------------------------------------
class GoldShortageTipsView: UIView {
    weak var vc: UIViewController?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: "sq_article_reward_tips".toImage())
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.font = k_font_title_16_weight
        title.text = "温馨提示"
        title.textAlignment = .center
        return title
    }()
    
    lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.font = k_font_title_15
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        return messageLabel
    }()
    
    lazy var buyGoldBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("我要购买金币", for: .normal)
        btn.setSize(size: CGSize.init(width: 100, height: 40))
        btn.titleLabel?.font = k_font_title
        btn.updateBGColor(4)
        btn.addTarget(self, action: #selector(jumpBuyGold), for: .touchUpInside)
        return btn
    }()
    
    lazy var changeRewardBtn: UIButton = {
        let btn = UIButton()
        btn.setSize(size: CGSize.init(width: 100, height: 40))
        btn.setTitle("修改打赏数量", for: .normal)
        btn.titleLabel?.font = k_font_title
        btn.updateBGColor(4)
        btn.addTarget(self, action: #selector(toChangeReward), for: .touchUpInside)
        return btn
    }()
    
    lazy var getGoldInfoBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(k_color_title_blue, for: .normal)
        btn.setTitle("怎么挣金币?", for: .normal)
        btn.titleLabel?.font = k_font_title_12
        btn.addTarget(self, action: #selector(jumpGoldInfo), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(buyGoldBtn)
        addSubview(changeRewardBtn)
        addSubview(getGoldInfoBtn)
        addLayout()
    }
    
    func addLayout() {
        imageView.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.top.equalTo(snp.top).offset(63)
            $0.width.equalTo(102)
            $0.height.equalTo(93)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.top.equalTo(imageView.snp.bottom).offset(6)
            $0.left.equalTo(snp.left).offset(5)
            $0.right.equalTo(snp.right).offset(-5)
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.left.equalTo(snp.left).offset(10)
            $0.right.equalTo(snp.right).offset(-10)
        }
        
        buyGoldBtn.snp.makeConstraints {
            $0.left.equalTo(snp.left).offset(57)
            $0.bottom.equalTo(snp.bottom).offset(-50)
            $0.width.equalTo(100)
            $0.height.equalTo(40)
        }
        
        changeRewardBtn.snp.makeConstraints {
            $0.right.equalTo(snp.right).offset(-57)
            $0.bottom.equalTo(snp.bottom).offset(-50)
            $0.width.equalTo(100)
            $0.height.equalTo(40)
        }
        
        getGoldInfoBtn.snp.makeConstraints {
            $0.top.equalTo(changeRewardBtn.snp.bottom).offset(16)
            $0.right.equalTo(changeRewardBtn.snp.right)
            $0.bottom.equalTo(snp.bottom).offset(-23)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func toChangeReward() {
        self.isHidden = true
    }
    
    @objc func jumpBuyGold() {
        superview?.removeFromSuperview()
        let webvc = SQWebViewController()
        webvc.urlPath = WebViewPath.buyGold
        vc?.navigationController?.pushViewController(webvc, animated: true)
    }
    
    @objc func jumpGoldInfo() {
        superview?.removeFromSuperview()
        let webvc = SQWebViewController()
        webvc.urlPath = WebViewPath.goldInfo
        vc?.navigationController?.pushViewController(webvc, animated: true)
    }
    
}
