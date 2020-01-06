//
//  SQCoinToCashTableViewCell.swift
//  SheQu
//
//  Created by gm on 2019/8/13.
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
    
    ///orderStateLabel
    static let orderStateLabelW: CGFloat = 130
    
    ///coinAmountLabel
    static let coinAmountLabelW: CGFloat = 100
    
    ///addressLabel
    static let addressLabelW: CGFloat = 48
    
    ///rejectedLabel
    static let rejectedLabelW: CGFloat = 75
    
    ///timeLabel
    static let timeLabelW: CGFloat = 75
    
    ///noteLabel
    static let noteLabelW: CGFloat = 48
    
    ///btcAmountLabel
    static let btcAmountLabelW: CGFloat = 100
    
    static let valueFont = k_font_title
}

class SQCoinToCashTableViewCell: UITableViewCell {
    
    static let cellID = "SQGoldToCashTableViewCellID"
    
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
        orderTitleLabel.text      = "流水号："
        orderTitleLabel.font      = SQItemStruct.valueFont
        orderTitleLabel.textColor = k_color_black
        return orderTitleLabel
    }()
    
    lazy var orderLabel: UILabel = {
        let order = UILabel()
        order.font      = SQItemStruct.valueFont
        order.textColor = k_color_black
        order.text      = ""
        return order
    }()
    
    lazy var orderStateLabel: UILabel = {
        let orderStateLabel   = UILabel()
        orderStateLabel.font  = k_font_title
        orderStateLabel.text  = "已过期"
        orderStateLabel.textAlignment = .right
        return orderStateLabel
    }()
    
    lazy var line2View: UIView = {
        let line2View             = UIView()
        line2View.backgroundColor = k_color_line
        return line2View
    }()
    
    lazy var coinAmountLabel: UILabel = {
        let coinAmountLabel       = UILabel()
        coinAmountLabel.text      = "提现金币数量："
        coinAmountLabel.font      = k_font_title
        coinAmountLabel.textColor = k_color_title_light
        return coinAmountLabel
    }()
    
    lazy var coinAmountValueLabel: UILabel = {
        let coinAmountValueLabel       = UILabel()
        coinAmountValueLabel.text      = "￥ 200"
        coinAmountValueLabel.font      = k_font_title_weight
        coinAmountValueLabel.textColor = k_color_black
        return coinAmountValueLabel
    }()
    
    lazy var btcAmountLabel: UILabel = {
        let btcAmountLabel       = UILabel()
        btcAmountLabel.textColor = k_color_title_light
        btcAmountLabel.text      = "到账BTC数量："
        btcAmountLabel.font      = k_font_title
        return btcAmountLabel
    }()
    
    
    /// 到账金币数量
    lazy var btcAmountValueLabel: UILabel = {
        let btcAmountValueLabel       = UILabel()
        btcAmountValueLabel.textColor = k_color_black
        btcAmountValueLabel.text      = "150000"
        btcAmountValueLabel.font      = k_font_title_weight
        return btcAmountValueLabel
    }()
    
    lazy var addressLabel: UILabel = {
        let addressLabel       = UILabel()
        addressLabel.textColor = k_color_title_light
        addressLabel.text      = "地址："
        addressLabel.font      = k_font_title
        return addressLabel
    }()
    
    
    /// 地址详情
    lazy var addressValueLabel: UILabel = {
        let addressValueLabel       = UILabel()
        addressValueLabel.textColor = k_color_black
        addressValueLabel.text      = "150000"
        addressValueLabel.font      = SQItemStruct.valueFont
        addressValueLabel.numberOfLines = 0
        return addressValueLabel
    }()
    
    lazy var noteLabel: UILabel = {
        let noteLabel       = UILabel()
        noteLabel.textColor = k_color_title_light
        noteLabel.text      = "备注："
        noteLabel.font      = k_font_title
        return noteLabel
    }()
    
    /// 描述详情
    lazy var noteValueLabel: UILabel = {
        let noteValueLabel       = UILabel()
        noteValueLabel.textColor = k_color_black
        noteValueLabel.text      = ""
        noteValueLabel.font      = SQItemStruct.valueFont
        noteValueLabel.numberOfLines = 0
        return noteValueLabel
    }()
    
    lazy var rejectedLabel: UILabel = {
        let rejectedLabel       = UILabel()
        rejectedLabel.textColor = k_color_title_light
        rejectedLabel.text      = "驳回原因："
        rejectedLabel.font      = k_font_title
        return rejectedLabel
    }()
    
    /// 驳回原因详情
    lazy var rejectedValueLabel: UILabel = {
        let rejectedValueLabel       = UILabel()
        rejectedValueLabel.textColor = k_color_black
        rejectedValueLabel.text      = ""
        rejectedValueLabel.font      = SQItemStruct.valueFont
        rejectedValueLabel.numberOfLines = 0
        return rejectedValueLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel       = UILabel()
        timeLabel.textColor = k_color_title_light
        timeLabel.text      = "申请时间："
        timeLabel.font      = k_font_title
        return timeLabel
    }()
    
    lazy var timeValueLabel: UILabel = {
        let timeLabel       = UILabel()
        timeLabel.textColor = k_color_black
        timeLabel.font      = SQItemStruct.valueFont
        timeLabel.text      = "2019-1-1 11:22:33"
        return timeLabel
    }()
    
    var model: SQCoinToCashItemModel? {
        didSet {
            if model != nil {
                let itemFrame = model!.itemFrame
                line1View.frame = itemFrame.line1ViewFrame
                blueView.frame  = itemFrame.blueViewFrame
                orderTitleLabel.frame = itemFrame.orderTitleLabelFrame
                orderLabel.frame      = itemFrame.orderLabelFrame
                orderStateLabel.frame = itemFrame.orderStateLabelFrame
                line2View.frame       = itemFrame.line2ViewFrame
                coinAmountLabel.frame = itemFrame.coinAmountLabelFrame
                coinAmountValueLabel.frame = itemFrame.coinAmountValueLabelFrame
                btcAmountLabel.frame  = itemFrame.btcAmountLabelFrame
                btcAmountValueLabel.frame = itemFrame.btcAmountValueLabelFrame
                addressLabel.frame    = itemFrame.addressLabelFrame
                addressValueLabel.frame = itemFrame.addressValueLabelFrame
                noteLabel.frame         = itemFrame.noteLabelFrame
                noteValueLabel.frame    = itemFrame.noteValueLabelFrame
                rejectedLabel.frame     = itemFrame.rejectedLabelFrame
                rejectedValueLabel.frame = itemFrame.rejectedValueLabelFrame
                timeLabel.frame         = itemFrame.timeLabelFrame
                timeValueLabel.frame    = itemFrame.timeValueLabelFrame
                
                if model!.note.count > 0 {
                    noteValueLabel.isHidden = false
                    noteLabel.isHidden      = false
                }else{
                    noteValueLabel.isHidden = true
                    noteLabel.isHidden      = true
                }
                
                if model!.reason.count > 0 {
                    rejectedValueLabel.isHidden = false
                    rejectedLabel.isHidden      = false
                }else{
                    rejectedValueLabel.isHidden = true
                    rejectedLabel.isHidden      = true
                }
                
                orderLabel.text = "\(model!.id)"
                coinAmountValueLabel.text = model!.coin_amount.toEuropeanType(3)
                btcAmountValueLabel.text  = "\(model!.btc_amount.scientificCountsToFloat())"
                addressValueLabel.text    = model!.address
                noteValueLabel.text       = model?.note
                rejectedValueLabel.text   = model?.reason
                timeValueLabel.text       = model?.created_at.formatStr("yyyy-MM-dd HH:mm:ss")
                orderStateLabel.text      = getorderStateLabelValue()
            }
        }
    }
    
    func getorderStateLabelValue() -> String{
        var valueStr = "审核中"
        orderStateLabel.textColor = k_color_normal_blue
        
        if model!.status == 2 || model!.status == 4 {
            valueStr = "审核驳回"
            orderStateLabel.textColor = UIColor.colorRGB(0xee0000)
        }
        
        if model!.status == 5 {
            valueStr = "审核通过,待转账"
            orderStateLabel.textColor = k_color_normal_blue
        }
        
        
        if model!.status == 6 {
            valueStr = "审核通过,已转账"
            orderStateLabel.textColor = k_color_normal_green
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
        addSubview(coinAmountLabel)
        addSubview(coinAmountValueLabel)
        addSubview(btcAmountLabel)
        addSubview(btcAmountValueLabel)
        addSubview(addressLabel)
        addSubview(addressValueLabel)
        addSubview(noteLabel)
        addSubview(noteValueLabel)
        addSubview(rejectedLabel)
        addSubview(rejectedValueLabel)
        addSubview(timeLabel)
        addSubview(timeValueLabel)
    }
    
    
    class func createGoldToCashFrame(model: SQCoinToCashItemModel){
        var itemFrame = SQCoinToCashInfoItemFrame()
        let marginX: CGFloat = 10
        let minMarginX: CGFloat = 0
        let contentW = k_screen_width - SQItemStruct.margin
        let line1X: CGFloat    = 0
        let line1Y: CGFloat    = 0
        let line1W             = k_screen_width
        let line1H             = k_line_height_big
        itemFrame.line1ViewFrame = CGRect.init(
            x: line1X,
            y: line1Y,
            width: line1W,
            height: line1H
        )
        
        let blueViewX = SQItemStruct.margin
        let blueViewY = itemFrame.line1ViewFrame.maxY + SQItemStruct.blueViewTop
        let blueViewW = SQItemStruct.blueViewW
        let blueViewH = SQItemStruct.blueViewH
        itemFrame.blueViewFrame = CGRect.init(x: blueViewX, y: blueViewY, width: blueViewW, height: blueViewH)
        
        let orderTitleLabelX = itemFrame.blueViewFrame.maxX + marginX
        let orderTitleLabelY = blueViewY
        let orderTitleLabelH = blueViewH
        let orderTitleLabelW = SQItemStruct.orderTitleLabelW
        itemFrame.orderTitleLabelFrame = CGRect.init(x: orderTitleLabelX, y: orderTitleLabelY, width: orderTitleLabelW, height: orderTitleLabelH)
        
        let orderStateLabelW = SQItemStruct.orderStateLabelW
        let orderStateLabelX = contentW - orderStateLabelW
        let orderStateLabelH = blueViewH
        let orderStateLabelY = blueViewY
        itemFrame.orderStateLabelFrame = CGRect.init(x: orderStateLabelX, y: orderStateLabelY, width: orderStateLabelW, height: orderStateLabelH)
        
        let orderLabelX = itemFrame.orderTitleLabelFrame.maxX
        let orderLabelY = blueViewY
        let orderLabelW = orderStateLabelX - orderLabelX
        let orderLabelH = blueViewH
        itemFrame.orderLabelFrame = CGRect.init(x: orderLabelX, y: orderLabelY, width: orderLabelW, height: orderLabelH)
        
        let line2ViewY = itemFrame.orderLabelFrame.maxY + SQItemStruct.marginTop
        let line2ViewX = blueViewX
        let line2ViewW = k_screen_width - line2ViewX
        let line2ViewH = k_line_height
        itemFrame.line2ViewFrame = CGRect.init(x: line2ViewX, y: line2ViewY, width: line2ViewW, height: line2ViewH)
        
        let coinAmountLabelX = blueViewX
        let coinAmountLabelY = itemFrame.line2ViewFrame.maxY + SQItemStruct.marginTop
        let coinAmountLabelW = SQItemStruct.coinAmountLabelW
        let coinAmountLabelH = SQItemStruct.labelH
        itemFrame.coinAmountLabelFrame  = CGRect.init(x: coinAmountLabelX, y: coinAmountLabelY, width: coinAmountLabelW, height: coinAmountLabelH)
        
        let coinAmountValueLabelX = itemFrame.coinAmountLabelFrame.maxX + minMarginX
        let coinAmountValueLabelY = coinAmountLabelY
        let coinAmountValueLabelW = k_screen_width - coinAmountValueLabelX - SQItemStruct.margin
        let coinAmountValueLabelH = SQItemStruct.labelH
        itemFrame.coinAmountValueLabelFrame = CGRect.init(x: coinAmountValueLabelX, y: coinAmountValueLabelY, width: coinAmountValueLabelW, height: coinAmountValueLabelH)
        
        let btcAmountLabelX = blueViewX
        let btcAmountLabelY = itemFrame.coinAmountLabelFrame.maxY + SQItemStruct.marginTop
        let btcAmountLabelW = SQItemStruct.btcAmountLabelW
        let btcAmountLabelH = SQItemStruct.labelH
        itemFrame.btcAmountLabelFrame = CGRect.init(x: btcAmountLabelX, y: btcAmountLabelY, width: btcAmountLabelW, height: btcAmountLabelH)
        
        let btcAmountValueLabelX = itemFrame.btcAmountLabelFrame.maxX + minMarginX
        let btcAmountValueLabelY = btcAmountLabelY
        let btcAmountValueLabelW = contentW - btcAmountValueLabelX
        let btcAmountValueLabelH = SQItemStruct.labelH
        itemFrame.btcAmountValueLabelFrame = CGRect.init(x: btcAmountValueLabelX, y: btcAmountValueLabelY, width: btcAmountValueLabelW, height: btcAmountValueLabelH)
       
        let addressLabelX = blueViewX
        let addressLabelY = itemFrame.btcAmountValueLabelFrame.maxY + SQItemStruct.marginTop
        let addressLabelW = SQItemStruct.addressLabelW
        let addressLabelH = SQItemStruct.labelH
        itemFrame.addressLabelFrame = CGRect.init(x: addressLabelX, y: addressLabelY, width: addressLabelW, height: addressLabelH)
        
        let addressValueLabelX = itemFrame.addressLabelFrame.maxX + minMarginX
        let addressValueLabelY = addressLabelY
        let addressValueLabelW = contentW - addressValueLabelX
        var addressValueLabelH = model.address.calcuateLabSizeHeight(font: SQItemStruct.valueFont, maxWidth: addressValueLabelW)
        if addressValueLabelH < SQItemStruct.labelH {
            addressValueLabelH = SQItemStruct.labelH
        }
        itemFrame.addressValueLabelFrame = CGRect.init(x: addressValueLabelX, y: addressValueLabelY, width: addressValueLabelW, height: addressValueLabelH)
        
        var maxY = itemFrame.addressValueLabelFrame.maxY
        if model.note.count > 0 {
            let noteLabelX = blueViewX
            let noteLabelY = maxY + SQItemStruct.marginTop
            let noteLabelW = SQItemStruct.noteLabelW
            let noteLabelH = SQItemStruct.labelH
            itemFrame.noteLabelFrame = CGRect.init(x: noteLabelX, y: noteLabelY, width: noteLabelW, height: noteLabelH)
            
            let noteValueLabelX = itemFrame.noteLabelFrame.maxX + minMarginX
            let noteValueLabelW = contentW - noteValueLabelX
            let noteValueLabelY = noteLabelY
            var noteValueLabelH = model.note.calcuateLabSizeHeight(font: SQItemStruct.valueFont, maxWidth: noteValueLabelW)
            if noteValueLabelH < SQItemStruct.labelH {
                noteValueLabelH = SQItemStruct.labelH
            }
            itemFrame.noteValueLabelFrame = CGRect.init(x: noteValueLabelX, y: noteValueLabelY, width: noteValueLabelW, height: noteValueLabelH)
            maxY = itemFrame.noteValueLabelFrame.maxY
        }
        
        if model.reason.count > 0 {
            let rejectedLabelX = blueViewX
            let rejectedLabelY = maxY + SQItemStruct.marginTop
            let rejectedLabelH = SQItemStruct.labelH
            let rejectedLabelW = SQItemStruct.rejectedLabelW
            itemFrame.rejectedLabelFrame = CGRect.init(x: rejectedLabelX, y: rejectedLabelY, width: rejectedLabelW, height: rejectedLabelH)
            
            let rejectedValueLabelX = itemFrame.rejectedLabelFrame.maxX + minMarginX
            let rejectedValueLabelY = rejectedLabelY
            let rejectedValueLabelW = contentW - rejectedValueLabelX
            var rejectedValueLabelH = model.reason.calcuateLabSizeHeight(font: SQItemStruct.valueFont, maxWidth: rejectedValueLabelW)
            if rejectedValueLabelH < SQItemStruct.labelH {
                rejectedValueLabelH = SQItemStruct.labelH
            }
            itemFrame.rejectedValueLabelFrame = CGRect.init(x: rejectedValueLabelX, y: rejectedValueLabelY, width: rejectedValueLabelW, height: rejectedValueLabelH)
            
            maxY = itemFrame.rejectedValueLabelFrame.maxY
        }
        
        let timeLabelX = blueViewX
        let timeLabelY = maxY + SQItemStruct.marginTop
        let timeLabelW = SQItemStruct.timeLabelW
        let timeLabelH = SQItemStruct.labelH
        itemFrame.timeLabelFrame = CGRect.init(x: timeLabelX, y: timeLabelY, width: timeLabelW, height: timeLabelH)
        
        let timeValueLabelX = itemFrame.timeLabelFrame.maxX + minMarginX
        let timeValueLabelY = timeLabelY
        let timeValueLabelW = contentW - timeValueLabelX
        let timeValueLabelH = SQItemStruct.labelH
        itemFrame.timeValueLabelFrame = CGRect.init(x: timeValueLabelX, y: timeValueLabelY, width: timeValueLabelW, height: timeValueLabelH)
        model.itemFrame = itemFrame
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
