//
//  SQGoldToCashSubmitView.swift
//  SheQu
//
//  Created by gm on 2019/8/15.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    static let contentViewTop: CGFloat = 150
    static let contentViewH: CGFloat   = 300
    static let contentViewW: CGFloat   = k_screen_width - 40
    
    ///closeBtn
    static let closeBtnTop: CGFloat = 50
    static let closeBtnWH: CGFloat = 30
    
    ///submitBnt
    static let submitBtnH: CGFloat = 50
    static let submitBtnW = contentViewW - 40
    
    static let aniDuration: CGFloat = 0.4
    
    static let titleArray = [
        "金币数量：",
        "兑换BTC：",
        "网络手续费：",
        "到账数量："
    ]
}

/// 金币转现金 提交view
class SQCoinToCashSubmitView: UIView {
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = UIColor.black
        coverView.alpha = 0.5
        return coverView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.setSize(size: CGSize.init(width: SQItemStruct.contentViewW, height: SQItemStruct.contentViewH))
        contentView.addRounded(corners: .allCorners, radii: k_corner_radiu_size, borderWidth: 0, borderColor: UIColor.clear)
        contentView.backgroundColor = UIColor.white
        return contentView
    }()
    
    lazy var submitBtn: UIButton = {
        let submitBtn = UIButton()
        submitBtn.setTitle("确定提交", for: .normal)
        submitBtn.backgroundColor = k_color_line
        submitBtn.setSize(size: CGSize.init(
            width: SQItemStruct.submitBtnW,
            height: SQItemStruct.submitBtnH
        ))
        
        submitBtn.updateBGColor(k_corner_radiu)
        submitBtn.layer.cornerRadius = k_corner_radiu
        submitBtn.addTarget(
            self,
            action: #selector(submitBtnClick),
            for: .touchUpInside
        )
        
        return submitBtn
    }()
    
    lazy var closeBtn: UIButton = {
        let closeBtn = UIButton()
        closeBtn.setImage(
            UIImage.init(named: "sq_integral_close"),
            for: .normal
        )
        
        closeBtn.addTarget(
            self,
            action: #selector(hiddenViewClick),
            for: .touchUpInside
        )
        
        closeBtn.isHidden = true
        return closeBtn
    }()
    
    var callBack: ((SQCoinToCashSubmitView) -> ())?
    
    init(frame: CGRect, valueArray:[String]) {
        super.init(frame: frame)
        addSubview(coverView)
        addSubview(contentView)
        addSubview(closeBtn)
        addLayout()
        layoutIfNeeded()
        
        var frameTemp = CGRect.init(x: 0, y: 10, width: 0, height: 0)
        let itemW = SQItemStruct.contentViewW - 40
        let itemH: CGFloat = 30
        let itemX: CGFloat = 20
        for index in 0..<valueArray.count {
            let itemY = frameTemp.maxY + 15
            let itemFrame = CGRect.init(x: itemX, y: itemY, width: itemW, height: itemH)
            let title = SQItemStruct.titleArray[index]
            let value = valueArray[index]
            let item = SQCoinToCashSubmitItemView.init(frame: itemFrame, title: title, valueStr: value)
            contentView.addSubview(item)
            frameTemp = item.frame
        }
        let submitBntY = frameTemp.maxY + 40
        submitBtn.frame = CGRect.init(x: 20, y: submitBntY, width: SQItemStruct.submitBtnW, height: SQItemStruct.submitBtnH)
        contentView.addSubview(submitBtn)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLayout() {
        coverView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.left.equalTo(snp.left)
            maker.bottom.equalTo(snp.bottom)
            maker.right.equalTo(snp.right)
        }
        
        contentView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top).offset(SQItemStruct.contentViewH * -1)
            maker.height.equalTo(SQItemStruct.contentViewH)
            maker.width.equalTo(SQItemStruct.contentViewW)
            maker.centerX.equalTo(snp.centerX)
        }
        
        closeBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(SQItemStruct.closeBtnWH)
            maker.height.equalTo(SQItemStruct.closeBtnWH)
            maker.centerX.equalTo(snp.centerX)
            maker.top.equalTo(contentView.snp.bottom)
                .offset(SQItemStruct.closeBtnTop)
        }
        
    }
    
   class func getShowText(value: CGFloat,_ needAbout: Bool = false) -> String{
        var tempValue = value
        if tempValue < 0 {
           tempValue = 0
        }

        if needAbout {
            return "≈ \(tempValue.scientificCountsToFloat()) BTC"
        }else{
            return "\(tempValue.scientificCountsToFloat()) BTC"
        }
    }
    
    
    @objc func hiddenViewClick() {
        hiddenSubmitView()
    }
    
    @objc func submitBtnClick(){
        if (callBack != nil) {
            callBack!(self)
        }
    }
    
    open func showSubmitView() {
        UIApplication.shared.keyWindow?.addSubview(self)
        ///获取验证码
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
    
    open func hiddenSubmitView() {
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
}

class SQCoinToCashSubmitItemView: UIView {
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = k_font_title_weight
        return titleLabel
    }()
    
    lazy var valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.font = k_font_title_weight
        valueLabel.textColor = k_color_title_blue
        valueLabel.textAlignment = .right
        return valueLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line
        return lineView
    }()
    
    init(frame: CGRect, title: String, valueStr: String) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(lineView)
        titleLabel.text = title
        valueLabel.text = valueStr
        addLayout()
    }
    
    func addLayout() {
        let height: CGFloat = 25
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left)
            maker.height.equalTo(height)
            maker.top.equalTo(snp.top)
        }
        
        valueLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(snp.right)
            maker.height.equalTo(height)
            maker.top.equalTo(snp.top)
        }
        
        lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(k_line_height)
            maker.bottom.equalTo(snp.bottom).offset(k_line_height * -1)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
