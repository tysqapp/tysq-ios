//
//  SQIntegralOrderListTableViewCell.swift
//  SheQu
//
//  Created by gm on 2019/7/15.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    
    static let margin: CGFloat     = 20
    static let marginTop: CGFloat  = 15
    static let labelH: CGFloat     = 14
    
    ///topViewH
    static let topViewH: CGFloat = 45
    
    ///blueView
    static let blueViewH: CGFloat = 15
    static let blueViewW: CGFloat = 3
    static let blueViewTop: CGFloat = 25
    
    ///orderTitleLabel
    static let orderTitleLabelW: CGFloat = 60
    
    ///moneyTitleLabel
    static let moneyTitleLabelW: CGFloat = 75
    
    ///exchangePointsTitleLabel
    static let exchangePointsTitleLabelW: CGFloat = 90
}

class SQIntegralOrderListTableViewCell: UITableViewCell {
    
    static let cellID = "SQIntegralOrderListTableViewCellID"
    static let rowH: CGFloat = 155
    
    lazy var line1View: UIView = {
        let line1View             = UIView()
        line1View.backgroundColor = k_color_line_light
        return line1View
    }()
    
    lazy var blueView: UIView = {
        let blueView             = UIView()
        blueView.backgroundColor = k_color_normal_blue
        return blueView
    }()
    
    lazy var orderTitleLabel: UILabel = {
        let orderTitleLabel       = UILabel()
        orderTitleLabel.text      = "订单号："
        orderTitleLabel.font      = k_font_title_weight
        orderTitleLabel.textColor = k_color_black
        return orderTitleLabel
    }()
    
    lazy var orderLabel: UILabel = {
        let order = UILabel()
        order.font      = k_font_title_weight
        order.textColor = k_color_black
        order.text      = "151684567"
        return order
    }()
    
    lazy var orderStateLabel: UILabel = {
        let orderStateLabel   = UILabel()
        orderStateLabel.font  = k_font_title
        orderStateLabel.text  = "已过期"
        return orderStateLabel
    }()
    
    lazy var line2View: UIView = {
        let line2View             = UIView()
        line2View.backgroundColor = k_color_line
        return line2View
    }()
    
    lazy var moneyTitleLabel: UILabel = {
        let moneyTitleLabel       = UILabel()
        moneyTitleLabel.text      = "订单金额："
        moneyTitleLabel.font      = k_font_title
        moneyTitleLabel.textColor = k_color_title_light
        return moneyTitleLabel
    }()
    
    lazy var moneyValueLabel: UILabel = {
        let moneyValueLabel       = UILabel()
        moneyValueLabel.text      = "￥ 200"
        moneyValueLabel.font      = k_font_title_weight
        moneyValueLabel.textColor = k_color_black
        return moneyValueLabel
    }()
    
    lazy var exchangePointsTitleLabel: UILabel = {
        let exchangePointsTitleLabel       = UILabel()
        exchangePointsTitleLabel.textColor = k_color_title_light
        exchangePointsTitleLabel.text      = "购买积分数："
        exchangePointsTitleLabel.font      = k_font_title
        return exchangePointsTitleLabel
    }()
    
    lazy var exchangePointsValueLabel: UILabel = {
        let exchangePointsValueLabel       = UILabel()
        exchangePointsValueLabel.textColor = k_color_black
        exchangePointsValueLabel.text      = "150000"
        exchangePointsValueLabel.font      = k_font_title_weight
        return exchangePointsValueLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel       = UILabel()
        timeLabel.textColor = k_color_title_light
        timeLabel.font      = k_font_title
        timeLabel.text      = "2019-1-1 11:22:33"
        return timeLabel
    }()
    
    var model: SQScoresorderDetailModel? {
        didSet{
            if (model != nil) {
                orderLabel.text = "\(model!.order_id)"
                orderStateLabel.text = getorderStateLabelValue()
                moneyValueLabel.text = "￥\(model!.price)"
                exchangePointsValueLabel.text = "\(model!.amount)"
                timeLabel.text = model?.created_at.formatStr("yyyy-MM-dd hh:mm:ss")
            }
        }
    }
    
    func getorderStateLabelValue() -> String{
        var valueStr = "全部"
        orderStateLabel.textColor = k_color_black

        if model!.status == 1 {
            valueStr = "待支付"
            orderStateLabel.textColor = k_color_normal_blue
        }
        
        if model!.status == 2 {
            valueStr = "已支付，待到账"
        }
        
        
        if model!.status == 3 {
            valueStr = "已支付，已到账"
            orderStateLabel.textColor = k_color_normal_green
        }
        
        if model!.status == 4 {
            valueStr = "已取消"
        }
        
        if model!.status == 5 {
            valueStr = "已过期"
        }
        
        return valueStr
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(line1View)
        addSubview(line2View)
        addSubview(blueView)
        addSubview(orderTitleLabel)
        addSubview(orderLabel)
        addSubview(orderStateLabel)
        addSubview(moneyTitleLabel)
        addSubview(moneyValueLabel)
        addSubview(exchangePointsTitleLabel)
        addSubview(exchangePointsValueLabel)
        addSubview(timeLabel)
        addlayout()
    }
    
    
    func addlayout() {
        
        let labelH = SQItemStruct.labelH
        let marginX: CGFloat = 10
        let minMarginX: CGFloat = 0
        line1View.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(k_line_height_big)
        }
        
        blueView.snp.makeConstraints { (maker) in
            maker.top.equalTo(line1View.snp.bottom)
                .offset(SQItemStruct.marginTop)
            maker.left.equalTo(snp.left).offset(SQItemStruct.margin)
            maker.height.equalTo(SQItemStruct.blueViewH)
            maker.width.equalTo(SQItemStruct.blueViewW)
        }
        
        orderTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(blueView.snp.right).offset(marginX)
            maker.height.equalTo(labelH)
            maker.width.equalTo(SQItemStruct.orderTitleLabelW)
            maker.centerY.equalTo(blueView.snp.centerY)
        }
        
        let rightMargin = SQItemStruct.margin * -1
        orderStateLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(snp.right).offset(rightMargin)
            maker.height.equalTo(SQItemStruct.labelH)
            maker.top.equalTo(orderTitleLabel.snp.top)
        }
        
        orderLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(orderTitleLabel.snp.right)
                .offset(minMarginX)
            maker.height.equalTo(SQItemStruct.labelH)
            maker.top.equalTo(orderTitleLabel.snp.top)
        }
        
        line2View.snp.makeConstraints { (maker) in
            maker.left.equalTo(blueView.snp.left)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(k_line_height)
            maker.top.equalTo(blueView.snp.bottom)
                .offset(SQItemStruct.marginTop)
        }
        
        moneyTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(line2View.snp.left)
            maker.width.equalTo(SQItemStruct.moneyTitleLabelW)
            maker.height.equalTo(SQItemStruct.labelH)
            maker.top.equalTo(line2View.snp.bottom)
                .offset(SQItemStruct.marginTop)
        }
        
        moneyValueLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(moneyTitleLabel.snp.right)
                .offset(minMarginX)
            maker.height.equalTo(SQItemStruct.labelH)
            maker.top.equalTo(moneyTitleLabel.snp.top)
            maker.right.equalTo(orderStateLabel.snp.right)
        }
        
        exchangePointsTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(line2View.snp.left)
            maker.width.equalTo(SQItemStruct.exchangePointsTitleLabelW)
            maker.height.equalTo(SQItemStruct.labelH)
            maker.top.equalTo(moneyValueLabel.snp.bottom)
                .offset(SQItemStruct.marginTop)
        }
        
        exchangePointsValueLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(exchangePointsTitleLabel.snp.top)
            maker.height.equalTo(SQItemStruct.labelH)
            maker.right.equalTo(orderStateLabel.snp.right)
            maker.left.equalTo(exchangePointsTitleLabel.snp.right)
                .offset(minMarginX)
        }
        
        timeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(line2View.snp.left)
            maker.height.equalTo(SQItemStruct.labelH)
            maker.right.equalTo(orderStateLabel.snp.right)
            maker.top.equalTo(exchangePointsValueLabel.snp.bottom)
                .offset(SQItemStruct.marginTop)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
