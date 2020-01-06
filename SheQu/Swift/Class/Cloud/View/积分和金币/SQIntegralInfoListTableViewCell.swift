//
//  SQIntegralInfoListTableViewCell.swift
//  SheQu
//
//  Created by gm on 2019/7/15.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQIntegralInfoListTableViewCell: UITableViewCell {
    static let cellID = "SQIntegralInfoListTableViewCellID"
    static let rowH: CGFloat = 75
    
    lazy var titleLabel: UILabel = {
        let titleLabel       = UILabel()
        titleLabel.font      = k_font_title_16_weight
        titleLabel.textColor = k_color_black
        titleLabel.text      = "注册"
        return titleLabel
    }()
    
    lazy var valueLabel: UILabel = {
        let valueLabel       = UILabel()
        valueLabel.font      = k_font_title_16_weight
        valueLabel.text      = "+ 1000"
        valueLabel.textAlignment = .right
        return valueLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel       = UILabel()
        timeLabel.font      = k_font_title_12
        timeLabel.textColor = k_color_title_gray_blue
        timeLabel.text      = "1990-02-03 04:23:33"
        return timeLabel
    }()
    
    
    /// 有效期
    lazy var periodValidityLabel: UILabel = {
        let periodValidityLabel       = UILabel()
        periodValidityLabel.font      = k_font_title
        periodValidityLabel.textColor = k_color_black
        periodValidityLabel.text      = ""
        periodValidityLabel.font      = k_font_title_12
        periodValidityLabel.textAlignment = .right
        return periodValidityLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(timeLabel)
        addSubview(periodValidityLabel)
        addSubview(lineView)
        addlayout()
    }
    
    var model: SQAccountCoinDetailModel? {
        
        didSet{
            if (model != nil) {
                valueLabel.text = getValueLabelText()
                titleLabel.text = model?.action
                timeLabel.text = model?.time.formatStr("YYYY-MM-dd hh:mm:ss")
                if model!.expired_at != 0 && model!.change_number > 0 {
                    periodValidityLabel.text = "有效期至\(model!.expired_at.formatStr("YYYY-MM-dd"))"
                }else{
                    periodValidityLabel.text = ""
                }
            }
        }
        
    }
    
    func getValueLabelText() -> String {
        if model!.change_number > 0 {
            valueLabel.textColor = UIColor.colorRGB(0xfb605d)
            return "+\(model!.change_number)"
        }else{
            valueLabel.textColor = k_color_black
            return "\(model!.change_number)"
        }
    }
    
    func addlayout() {
        
        let margin: CGFloat = 20
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top).offset(margin)
            maker.left.equalTo(snp.left).offset(margin)
            maker.height.equalTo(16)
            maker.width.equalTo(k_screen_width * 0.5)
        }
        
        valueLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(snp.right).offset(margin * -1)
            maker.centerY.equalTo(titleLabel.snp.centerY)
            maker.height.equalTo(16)
            maker.width.equalTo(titleLabel.snp.width)
        }
        
        timeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel.snp.left)
            maker.top.equalTo(titleLabel.snp.bottom).offset(12)
            maker.height.equalTo(12)
            maker.width.equalTo(timeLabel.snp.width)
        }
        
        periodValidityLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(snp.right).offset(margin * -1)
            maker.centerY.equalTo(timeLabel.snp.centerY)
            maker.height.equalTo(14)
            maker.width.equalTo(titleLabel.snp.width)
        }
        
        lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel.snp.left)
            maker.height.equalTo(k_line_height)
            maker.top.equalTo(snp.bottom).offset(k_line_height * -1)
            maker.right.equalTo(snp.right)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
