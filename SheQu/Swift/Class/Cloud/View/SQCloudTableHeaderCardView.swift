//
//  SQSQCloudTableHeaderCardView.swift
//  SheQu
//
//  Created by gm on 2019/7/17.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    ///titleLabel
    static let titleLabelH: CGFloat = 12
    static let titleLabelTop: CGFloat = 15
    static let titleLabelFont = k_font_title_12
    
    ///valueLabel
    static let valueLabelH: CGFloat = 16
    static let valueLabelTop: CGFloat = 5
    static let valueLabelFont = k_font_title_16_weight
    
    ///tipsImageView
    static let tipsImageViewW: CGFloat = 150
    static let tipsImageViewH: CGFloat = 60
}

///我的首页头部模块 金币 积分 子控件
class SQCloudTableHeaderCardView: UIView {
    static let marginX: CGFloat = k_margin_x
    static let margin: CGFloat  = 35
    static let height: CGFloat  = 70
    static let width = (k_screen_width -
        SQCloudTableHeaderCardView.marginX * 2 -
        SQCloudTableHeaderCardView.margin) * 0.5
    
    enum CardViewType {
        case integral
        case gold
    }
    
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = SQItemStruct.titleLabelFont
        titleLabel.textColor = UIColor.white
        return titleLabel
    }()
    
    lazy var valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.textAlignment = .center
        valueLabel.font = SQItemStruct.valueLabelFont
        valueLabel.textColor = UIColor.white
        return valueLabel
    }()
    
    lazy var rmbLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.textAlignment = .center
        valueLabel.font = UIFont.systemFont(ofSize: 10)
        valueLabel.alpha = 0.8
        valueLabel.textColor = UIColor.white
        valueLabel.isHidden = true
        return valueLabel
    }()
    
    lazy var tipsImageView: UIImageView = {
        let tipsImageView = UIImageView()
        return tipsImageView
    }()
    
    init(frame: CGRect, type: SQCloudTableHeaderCardView.CardViewType) {
        super.init(frame: frame)
        setSize(size: CGSize.init(
            width: SQCloudTableHeaderCardView.width,
            height: SQCloudTableHeaderCardView.height
            )
        )
        
        layer.cornerRadius = 10
//        addRounded(corners: .allCorners, radii: CGSize.init(width: 10, height: 10), borderWidth: 0, borderColor: UIColor.clear)
        
        
        var tipsImageName = ""
        var tipsTitle     = ""
        var bgColorArray  = [CGColor]()
        var shadowColor   = UIColor.colorRGB(0xfb605d)
        switch type {
        case .integral:
            tipsImageName = "sq_integral_card"
            tipsTitle     = "积分"
            bgColorArray = [
                UIColor.colorRGB(0xff8d76).cgColor,
                UIColor.colorRGB(0xfb605d).cgColor
            ]
            rmbLabel.isHidden = true
        case .gold:
            tipsImageName = "sq_gold_card"
            tipsTitle     = "金币"
            shadowColor   = UIColor.colorRGB(0xe8bf78)
            bgColorArray = [
                UIColor.colorRGB(0xe8bf78).cgColor,
                UIColor.colorRGB(0xcb9742).cgColor
            ]
            rmbLabel.isHidden = false
        }
        
        addGradientColor(
            gradientColors: bgColorArray,
            gradientLocations: [(0),(1)],
            cornerRadius: 10
        )
        addShadowColor(shadowColor: shadowColor)
        
        addSubview(tipsImageView)
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(rmbLabel)
        addLayout()
        
        tipsImageView.image = UIImage.init(named: tipsImageName)
        titleLabel.text     = tipsTitle
        valueLabel.text     = "0"
        rmbLabel.text       = "=0元"
    }
    
    func addLayout() {
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(snp.centerX)
            maker.height.equalTo(SQItemStruct.titleLabelH)
            maker.top.equalTo(snp.top)
                .offset(SQItemStruct.titleLabelTop)
        }
        
        valueLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(snp.centerX)
            maker.height.equalTo(SQItemStruct.valueLabelH)
            maker.top.equalTo(titleLabel.snp.bottom)
                .offset(SQItemStruct.valueLabelTop)
        }
        
        rmbLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(valueLabel.snp.centerX)
            maker.top.equalTo(valueLabel.snp.bottom).offset(5)
        }
        
        tipsImageView.snp.makeConstraints { (maker) in
            maker.right.equalTo(snp.right)
            maker.bottom.equalTo(snp.bottom)
            maker.width.equalTo(SQItemStruct.tipsImageViewW)
            maker.height.equalTo(SQItemStruct.tipsImageViewH)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
