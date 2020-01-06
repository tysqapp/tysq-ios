//
//  SQIntegralTipsView.swift
//  SheQu
//
//  Created by gm on 2019/7/16.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    static let width: CGFloat  = 255
    static let height: CGFloat = 350
    static let margin: CGFloat = 20
    ///tipsImageView
    static let tipsImageViewH: CGFloat = 142
    
    ///tipsLabel
    static let tipsLabelTop: CGFloat = 35
    static let tipsLabelH: CGFloat   = 41
    
    ///getIntegralBtn
    static let getIntegralBtnTop: CGFloat = 35
    static let getIntegralBtnH: CGFloat   = 45
    static let getIntegralBtnX: CGFloat   = 32.5
    
    ///getIntegralWayBtn
    static let getIntegralWayBtnTop: CGFloat = 10
}

class SQIntegralTipsView: UIView {
    
    lazy var tipsImageView: UIImageView = {
        let tipsImageView = UIImageView()
        tipsImageView.image = UIImage.init(named: "sq_integral_tips")
        return tipsImageView
    }()
    
    lazy var tipsLabel: UILabel = {
        let tipsLabel = UILabel()
        tipsLabel.numberOfLines = 0
        return tipsLabel
    }()
    
    lazy var getIntegralBtn: UIButton = {
        let getIntegralBtn = UIButton()
        getIntegralBtn.titleLabel?.font = k_font_title_weight
        getIntegralBtn.setTitle("我要购买积分", for: .normal)
        getIntegralBtn.setTitleColor(UIColor.white, for: .normal)
        
        let btnWidth = SQItemStruct.width - (SQItemStruct.getIntegralBtnX * 2)
        let btnSize = CGSize.init(
            width: btnWidth,
            height: SQItemStruct.getIntegralBtnH
        )
        
        getIntegralBtn.setSize(size: btnSize)
        getIntegralBtn.updateBGColor(4)
        getIntegralBtn.addTarget(
            self,
            action: #selector(btnClick(_:)),
            for: .touchUpInside
        )
        return getIntegralBtn
    }()
    
    lazy var getIntegralWayBtn: UIButton = {
        let getIntegralWayBtn = UIButton()
        getIntegralWayBtn.contentHorizontalAlignment = .right
        getIntegralWayBtn.contentVerticalAlignment   = .top
        getIntegralWayBtn.titleLabel?.font           = k_font_title
        
        getIntegralWayBtn.setTitle(
            "怎么挣积分?",
            for: .normal
        )
        
        getIntegralWayBtn.setTitleColor(
            k_color_normal_blue,
            for: .normal
        )
        
        getIntegralWayBtn.addTarget(
            self,
            action: #selector(btnClick(_:)),
            for: .touchUpInside
        )
        
        getIntegralWayBtn.tag = 1
        return getIntegralWayBtn
    }()
    
    var callBack:((Int) -> ())?
    
    func updateTipsLabelValue(_ value: Int, tipsTitle: String) {
        getIntegralBtn.updateBGColor()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7.5
        let customAtt = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: k_font_title_weight,
            NSAttributedString.Key.foregroundColor: k_color_black
        ]
        
        let valueAtt = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: k_font_title_weight,
            NSAttributedString.Key.foregroundColor: UIColor.colorRGB(0xee0000)
        ]
        
        
        let attStrM = NSMutableAttributedString()
        let attStr = NSAttributedString.init(
            string: tipsTitle,
            attributes: customAtt
        )
        
        let attStrMid = NSAttributedString.init(
            string: "\(value)积分",
            attributes: valueAtt
        )
        
        let attStrLast = NSAttributedString.init(
            string: "，您的积分不足，请先获取积分",
            attributes: customAtt
        )
        
        attStrM.append(attStr)
        attStrM.append(attStrMid)
        attStrM.append(attStrLast)
        
        tipsLabel.attributedText = attStrM
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(tipsImageView)
        addSubview(tipsLabel)
        addSubview(getIntegralBtn)
        addSubview(getIntegralWayBtn)
        addlayout()
    }
    
    func addlayout() {
        
        tipsImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(SQItemStruct.tipsImageViewH)
        }
        
        tipsLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left).offset(SQItemStruct.margin)
            maker.height.equalTo(SQItemStruct.tipsLabelH)
            maker.right.equalTo(snp.right)
                .offset(SQItemStruct.margin * -1)
            maker.top.equalTo(tipsImageView.snp.bottom)
                .offset(SQItemStruct.tipsLabelTop)
        }
        
        getIntegralBtn.snp.makeConstraints { (maker) in
            maker.height.equalTo(SQItemStruct.getIntegralBtnH)
            maker.top.equalTo(tipsLabel.snp.bottom)
                .offset(SQItemStruct.getIntegralBtnTop)
            maker.right.equalTo(snp.right)
                .offset(SQItemStruct.getIntegralBtnX * -1)
            maker.left.equalTo(snp.left).offset(SQItemStruct
                .getIntegralBtnX)
        }
        
        getIntegralWayBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(getIntegralBtn.snp.left)
            maker.right.equalTo(getIntegralBtn.snp.right)
            maker.bottom.equalTo(snp.bottom)
            maker.top.equalTo(getIntegralBtn.snp.bottom)
                .offset(SQItemStruct.getIntegralWayBtnTop)
        }
        
    }

    @objc func btnClick(_ btn: UIButton) {
        if (callBack != nil) {
            callBack!(btn.tag)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
