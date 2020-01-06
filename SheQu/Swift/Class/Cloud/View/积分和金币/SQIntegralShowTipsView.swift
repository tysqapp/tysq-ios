//
//  SQIntegralShowTipsView.swift
//  SheQu
//
//  Created by gm on 2019/8/14.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    ///contentViewW
    static let contentViewX: CGFloat = 20
    static let contentViewH: CGFloat = 300
    static let contentViewTop: CGFloat = 150
    static let contentViewW = k_screen_width - contentViewX * 2
    
    ///closeBtn
    static let closeBtnTop: CGFloat = 50
    static let closeBtnWH: CGFloat  = 30
    
    static let aniDuration: CGFloat = 0.4
}

class SQIntegralShowTipsView: UIView {
    
    lazy var titleArray = [
        "订单只有两种状态:\"待支付\"和\"已支付\"。", "下单后(或支付后),订单状态显示\"待支付\",待商家确认收到支付金额后,才会变为\"已支付\"。",
        "状态变为\"已支付\",其购买的积分才会显示在积分明细,且添加到积分账户余额。",
        " 注:为方便商家尽快确认收款信息,支付后请点击\"已支付\"按钮。"
    ]
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = UIColor.black
        coverView.alpha = 0.5
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
            radii: k_corner_radiu_size,
            borderWidth: 0,
            borderColor: UIColor.clear
        )
        return contentView
    }()
    
    lazy var closeBtn: UIButton = {
        let closeBtn = UIButton()
        closeBtn.setImage(UIImage.init(named: "sq_integral_close"), for: .normal)
        closeBtn.addTarget(self, action: #selector(hidden), for: .touchUpInside)
        closeBtn.isHidden = true
        return closeBtn
    }()
    
    init(frame: CGRect, titleArray: [String]) {
        super.init(frame: frame)
        addSubview(coverView)
        addSubview(contentView)
        addSubview(closeBtn)
        self.titleArray = titleArray
        var tempFrame = CGRect.zero
        for index in 0..<titleArray.count {
            let title = titleArray[index]
            let frame = CGRect.init(
                x: 0,
                y: tempFrame.maxY + 22.5,
                width: SQItemStruct.contentViewW,
                height: 16
            )
            
            let titleView = SQIntegralShowTipsItemView.init(frame: frame, num: "\(index + 1)", title: title)
            contentView.addSubview(titleView)
            tempFrame = titleView.frame
        }
        
        addLayout()
        layoutIfNeeded()
    }
    
    func addLayout() {
        
        coverView.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left)
            maker.top.equalTo(snp.top)
            maker.bottom.equalTo(snp.bottom)
            maker.right.equalTo(snp.right)
        }
        
        contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left).offset(SQItemStruct.contentViewX)
            maker.width.equalTo(SQItemStruct.contentViewW)
            maker.top.equalTo(snp.top)
                .offset(SQItemStruct.contentViewH * -1)
            maker.height.equalTo(SQItemStruct.contentViewH)
        }
        
        closeBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView.snp.bottom)
                .offset(SQItemStruct.closeBtnTop)
            maker.centerX.equalTo(contentView.snp.centerX)
            maker.width.equalTo(SQItemStruct.closeBtnWH)
            maker.height.equalTo(SQItemStruct.closeBtnWH)
        }
    }
    
    func showTipsView() {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(
            withDuration: TimeInterval.init(SQItemStruct.aniDuration),
            animations: {
                self.contentView.snp.updateConstraints({ (maker) in
                    maker.top.equalTo(self.snp.top).offset(SQItemStruct.contentViewTop)
                })
                self.layoutIfNeeded()
        }) { (isFinish) in
            self.closeBtn.isHidden = false
        }
    }
    
    @objc func hidden() {
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class SQIntegralShowTipsItemView: UIView {
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.frame = CGRect.init(x: 10, y: 0, width: 16, height: 16)
        numLabel.layer.cornerRadius  = 8
        numLabel.layer.masksToBounds = true
        numLabel.backgroundColor     = k_color_normal_blue
        numLabel.textColor           = UIColor.white
        numLabel.font                = k_font_title
        numLabel.textAlignment       = .center
        return numLabel
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel           = UILabel()
        titleLabel.font          = k_font_title
        titleLabel.numberOfLines = 0
        titleLabel.textColor     = k_color_black
        return titleLabel
    }()
    
    init(frame: CGRect, num: String, title: String) {
        super.init(frame: frame)
        addSubview(numLabel)
        addSubview(titleLabel)
        let titleLabelX  = numLabel.frame.maxX + 5
        let titleLabelW  = frame.size.width - titleLabelX - 10
        var titleLabelH  =  title.calcuateLabSizeHeight(font: k_font_title, maxWidth: titleLabelW)
        if titleLabelH < 16 {
            titleLabelH = 16
        }
        
        titleLabel.frame = CGRect.init(
            x: titleLabelX,
            y: 0,
            width: titleLabelW,
            height: titleLabelH
        )
        
        numLabel.text = num
        titleLabel.text  = title
        setHeight(height: titleLabel.maxY())
        
        if num == "4" {
            numLabel.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
