//
//  SQIntegralInfoListCardView.swift
//  SheQu
//
//  Created by gm on 2019/7/17.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    ///infoBtn
    static let infoBtnH: CGFloat = 35
    static let infoBtnW: CGFloat = 100
    static let leftMargin: CGFloat = -20
    static let infoFont       = UIFont.systemFont(ofSize: 10)
    static let infoTitleColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)
    
    ///valueLabel
    static let valueLabelH: CGFloat = 30
    static let valueLabelTop: CGFloat = 34
    
    ///bottom btn
    static let btnX: CGFloat   =   35
    static let btnTop: CGFloat =   28
    static let btnH: CGFloat   =   30
    static let btnW: CGFloat   =   100
    static let btnTitleColor   =   UIColor.white
    static let btnFont         =   k_font_title
    
    ///tipsImageView
    static let tipsImageViewW    = 155
    static let tipsImageViewH    = 21
    static let tipsImageViewTop  = 6
    
    ///tipsLabel
    static let tipsLabelW: CGFloat       = 200
    static let tipsLabelH: CGFloat       = 60
    static let tipsLabelTop: CGFloat     = 33
    static let tipsLabelMarginx: CGFloat = 16
    static let tipsLabelFont = UIFont.systemFont(ofSize: 24, weight: .bold)
}

class SQIntegralInfoListCardView: UIView {
    static let margin: CGFloat  = k_margin_x
    static let height: CGFloat = 160
    static let width = k_screen_width - SQIntegralInfoListCardView.margin * 2
    
    enum Event: Int {
        case buy = 0
        case list = 1
        case info = 2
    }
    
    var callBack: ((SQIntegralInfoListCardView.Event) -> ())!
    lazy var customState = SQIntegralInfoListVC.State.integral
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        let size = CGSize.init(
            width: SQIntegralInfoListCardView.width,
            height: SQIntegralInfoListCardView.height - 10
        )
        
        contentView.setSize(size: size)
        contentView.addRounded(
            corners: [.topLeft,.topRight],
            radii: CGSize.init(width: 10, height: 10),
            borderWidth: 0, borderColor: UIColor.clear
        )
        
        return contentView
    }()
    
    lazy var shadowView: UIView = {
        let shadowView = UIView()
        let size = CGSize.init(
            width: SQIntegralInfoListCardView.width,
            height: SQIntegralInfoListCardView.height - 10
        )
        
        shadowView.backgroundColor = UIColor.white
        shadowView.setSize(size: size)
        shadowView.layer.cornerRadius = 10
        return shadowView
    }()
    
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.image = UIImage.init(named: "sq_integral_custom_bg")
        return bgImageView
    }()
    
//    lazy var infoBtn: SQImagePositionBtn = {
//        let infoBtn = SQImagePositionBtn.init(
//            frame: CGRect.zero,
//            position: .right,
//            imageViewSize: CGSize.init(width: 10, height: 30)
//        )
//
//        infoBtn.contentVerticalAlignment   = .bottom
//        infoBtn.imageView?.contentMode     = .right
//        infoBtn.titleLabel?.textAlignment  = .right
//        infoBtn.setTitleColor(SQItemStruct.infoTitleColor, for: .normal)
//        infoBtn.titleLabel?.font = SQItemStruct.infoFont
//        infoBtn.tag = SQIntegralInfoListCardView.Event.info.rawValue
//        infoBtn.setImage(
//            UIImage.init(named: "sq_arrow_light_gray"),
//            for: .normal
//        )
//
//        infoBtn.addTarget(
//            self,
//            action: #selector(btnClick(btn:)),
//            for: .touchUpInside
//        )
//
//        return infoBtn
//    }()
    
    lazy var valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.textAlignment = .center
        return valueLabel
    }()
    //我的金币 金币下面的 = xx元
    lazy var rmbLabel: UILabel = {
        let rmbLabel = UILabel()
        rmbLabel.textAlignment = .center
        rmbLabel.font = k_font_title
        rmbLabel.textColor = .white
        rmbLabel.text = "=xxx元"
        rmbLabel.alpha = 0.8
        return rmbLabel
    }()
    
    lazy var buyBtn: UIButton = {
        let buyBtn = UIButton()
        let size = CGSize.init(
            width: SQItemStruct.btnW,
            height: SQItemStruct.btnH
        )
        
        buyBtn.setSize(size: size)
        buyBtn.layer.cornerRadius = size.height * 0.5
        buyBtn.layer.borderWidth  = 1
        buyBtn.layer.borderColor  = UIColor.white.cgColor
        
        buyBtn.setTitleColor(SQItemStruct.btnTitleColor, for: .normal)
        buyBtn.titleLabel?.font = SQItemStruct.btnFont
        buyBtn.tag = SQIntegralInfoListCardView.Event.buy.rawValue
        buyBtn.setTitle("购买积分", for: .normal)
        buyBtn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        return buyBtn
    }()
    
    lazy var listBtn: UIButton = {
        let listBtn = UIButton()
        let size = CGSize.init(
            width: SQItemStruct.btnW,
            height: SQItemStruct.btnH
        )
        
        listBtn.setSize(size: size)
        listBtn.layer.cornerRadius = size.height * 0.5
        listBtn.layer.borderWidth  = 1
        listBtn.layer.borderColor  = UIColor.white.cgColor
        
        listBtn.setTitleColor(SQItemStruct.btnTitleColor, for: .normal)
        listBtn.titleLabel?.font = SQItemStruct.btnFont
        listBtn.tag = SQIntegralInfoListCardView.Event.list.rawValue
        listBtn.setTitle("积分订单", for: .normal)
        listBtn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        return listBtn
    }()
    
    lazy var friendImageView: UIImageView = {
        let friendImageView = UIImageView()
        friendImageView.isHidden = true
        friendImageView.image    = UIImage.init(named: "sq_friend_bg")
        return friendImageView
    }()
    
    lazy var tipsLabel: UILabel = {
        let tipsLabel = UILabel()
        tipsLabel.numberOfLines = 0
        return tipsLabel
    }()
    
    lazy var tipsImageView: UIImageView = {
        let tipsImageView = UIImageView()
        tipsImageView.image = UIImage.init(named: "sq_friend_tips")
        tipsImageView.isHidden = true
        return tipsImageView
    }()
    
    init(frame: CGRect, state: SQIntegralInfoListVC.State, handel:@escaping ((SQIntegralInfoListCardView.Event) -> ())) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        callBack = handel
        customState = state
        addSubview(shadowView)
        addSubview(contentView)
        addSubview(bgImageView)
        //addSubview(infoBtn)
        addSubview(valueLabel)
        addSubview(buyBtn)
        addSubview(listBtn)
        addSubview(friendImageView)
        addSubview(tipsImageView)
        addSubview(tipsLabel)
        if customState == .gold {
            addSubview(rmbLabel)
        }
        addLayout()
        initSubViews()
    }
    
    func initSubViews() {
        var bgColorArray = [CGColor]()
        var shadowColor  = UIColor.colorRGB(0xfb605d)
        switch customState {
        case .integral:
            bgColorArray = [
                UIColor.colorRGB(0xff8d76).cgColor,
                UIColor.colorRGB(0xfb605d).cgColor
            ]
            //infoBtn.setTitle("积分说明", for: .normal)
        case .gold:
            bgColorArray = [
                UIColor.colorRGB(0xe8bf78).cgColor,
                UIColor.colorRGB(0xcb9742).cgColor
            ]
            shadowColor  = UIColor.colorRGB(0xcb9742)
            //infoBtn.setTitle("金币说明", for: .normal)
            buyBtn.setTitle("提现", for: .normal)
            listBtn.setTitle("购买", for: .normal)
        case .exten:
            tipsImageView.isHidden = false
            friendImageView.isHidden = false
            tipsLabel.isHidden = false
            return
        }
        
        contentView.addGradientColor(
            gradientColors: bgColorArray,
            gradientLocations: [(0),(1)]
        )
        
        shadowView.addShadowColor(
            shadowColor: shadowColor,
            shadowOffset:CGSize(width: -1, height: -1))
    }
    
    
    private func addLayout() {
        
        shadowView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top).offset(10)
            maker.height.equalTo(SQIntegralInfoListCardView.height - 10)
            maker.width.equalTo(SQIntegralInfoListCardView.width)
            maker.left.equalTo(snp.left)
                .offset(SQIntegralInfoListCardView.margin)
        }
        
        contentView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top).offset(10)
            maker.height.equalTo(SQIntegralInfoListCardView.height - 10)
            maker.width.equalTo(SQIntegralInfoListCardView.width)
            maker.left.equalTo(snp.left)
                .offset(SQIntegralInfoListCardView.margin)
        }
        
        bgImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.height.equalTo(SQIntegralInfoListCardView.height)
            maker.width.equalTo(SQIntegralInfoListCardView.width)
            maker.left.equalTo(snp.left)
                .offset(SQIntegralInfoListCardView.margin)
        }
        
//        infoBtn.snp.makeConstraints { (maker) in
//            maker.top.equalTo(contentView.snp.top)
//            maker.right.equalTo(contentView.snp.right)
//                .offset(SQItemStruct.leftMargin)
//            maker.height.equalTo(SQItemStruct.infoBtnH)
//            maker.width.equalTo(SQItemStruct.infoBtnW)
//        }
        
        
        valueLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(contentView.snp.left)
            maker.right.equalTo(contentView.snp.right)
            maker.height.equalTo(SQItemStruct.valueLabelH)
            maker.top.equalTo(contentView.snp.top)
                .offset(SQItemStruct.valueLabelTop)
        }
        
        if customState == .gold {
            rmbLabel.snp.makeConstraints { (maker) in
                maker.centerX.equalTo(valueLabel.snp.centerX)
                maker.left.equalTo(valueLabel.snp.left)
                maker.right.equalTo(valueLabel.snp.right)
                maker.top.equalTo(valueLabel.snp.bottom).offset(5)
                maker.height.equalTo(15)
            }
        }
        
        
        
        buyBtn.snp.makeConstraints { (maker) in
            maker.height.equalTo(SQItemStruct.btnH)
            maker.width.equalTo(SQItemStruct.btnW)
            maker.top.equalTo(valueLabel.snp.bottom)
                .offset(SQItemStruct.btnTop)
            maker.left.equalTo(contentView.snp.left)
                .offset(SQItemStruct.btnX)
        }
        
        listBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(buyBtn.snp.top)
            maker.width.equalTo(buyBtn.snp.width)
            maker.height.equalTo(buyBtn.snp.height)
            maker.right.equalTo(contentView.snp.right)
                .offset(SQItemStruct.btnX * -1)
        }
        
        friendImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.height.equalTo(SQIntegralInfoListCardView.height)
            maker.width.equalTo(SQIntegralInfoListCardView.width)
            maker.left.equalTo(snp.left)
                .offset(SQIntegralInfoListCardView.margin)
        }
        
        tipsLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(SQItemStruct.tipsLabelH)
            maker.right.equalTo(friendImageView.snp.right)
            maker.top.equalTo(snp.top).offset(SQItemStruct.tipsLabelTop)
            maker.left.equalTo(friendImageView.snp.left)
                .offset(SQItemStruct.tipsLabelMarginx)
        }
        
        tipsImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(tipsLabel.snp.bottom)
                .offset(SQItemStruct.tipsImageViewTop)
            maker.left.equalTo(tipsLabel.snp.left)
            maker.width.equalTo(SQItemStruct.tipsImageViewW)
            maker.height.equalTo(SQItemStruct.tipsImageViewH)
        }
    }
    
    
    func updateValue(_ value: Int,_ unitStr: String) {
        
        let valueStr = value.toEuropeanType(3)
        
        let attValue = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .bold)
        ]
        
        let attUnit = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: k_font_title
        ]
        
        let attM = NSMutableAttributedString()
        let attStrValue = NSAttributedString.init(string: valueStr, attributes: attValue)
        let attStrUnit  = NSAttributedString.init(string: " \(unitStr)", attributes: attUnit)
        
        attM.append(attStrValue)
        attM.append(attStrUnit)
        
        valueLabel.attributedText = attM
        let rmb = String(format: "%.2f",(Double(value) / 1000))
        rmbLabel.text = "=\(rmb)元"
    }
    
    func updateTipsLabelValue(_ value: Int) {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        shadow.shadowOffset = CGSize.init(width: 2, height: 1)
        let attValue = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: SQItemStruct.tipsLabelFont,
            NSAttributedString.Key.shadow: shadow
        ]
        
        let str = "邀请好友成功注册\n可获\(value)积分"
        
        tipsLabel.attributedText = NSAttributedString.init(string: str, attributes: attValue)
        
        
    }
    
    @objc func btnClick(btn: UIButton) {
        callBack(SQIntegralInfoListCardView.Event.init(rawValue: btn.tag)!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
