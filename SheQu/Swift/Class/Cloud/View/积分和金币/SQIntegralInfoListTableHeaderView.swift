//
//  SQIntegralInfoListTableHeaderView.swift
//  SheQu
//
//  Created by gm on 2019/7/17.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
fileprivate struct SQItemStruct {
    
    static let bottomH: CGFloat  = SQIntegralInfoListTableHeaderView.bottomH
    
    ///blueView
    static let blueViewH: CGFloat = 15
    static let blueViewTop: CGFloat =  (SQItemStruct.bottomH - SQItemStruct.blueViewH) * 0.5
    static let blueViewW: CGFloat = 3
    static let blueViewColor      = k_color_normal_blue
    
    ///titleLabel
    static let titleLabelH: CGFloat       = 14
    static let titleLabelMarginX: CGFloat = 10
    static let titleLabelTextColor        = k_color_black
    static let titleLabelFont             = k_font_title_weight
    static let titleLabelW: CGFloat       = 100
    ///checkWayBtn
    static let checkWayBtnFont            = k_font_title
    static let checkWayBtnTextColor       = k_color_title_gray_blue
    static let checkWayBtnH: CGFloat      = 40
    static let checkWayBtnW: CGFloat      = 100
    static let checkWayBtnRightX: CGFloat = -20
}
class SQIntegralInfoListTableHeaderView: UIView {
    
    static let margin           = k_margin_x
    static let bottomH: CGFloat = 45
    static let width            = k_screen_width
    static let height = SQIntegralInfoListCardView.height + SQIntegralInfoListTableHeaderView.bottomH + k_line_height_big
    
    lazy var customState = SQIntegralInfoListVC.State.integral
    var callBack: ((SQIntegralInfoListCardView.Event) -> ())!
    
    lazy var cardView: SQIntegralInfoListCardView = {
        weak var weakSelf = self
        let cardView = SQIntegralInfoListCardView.init(frame: CGRect.zero, state: customState, handel: { (event) in
            weakSelf?.callBack(event)
        })
        return cardView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line_light
        return lineView
    }()
    
    lazy var blueView: UIView = {
        let blueView = UIView()
        blueView.backgroundColor = SQItemStruct.blueViewColor
        return blueView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = SQItemStruct.titleLabelFont
        titleLabel.textColor = SQItemStruct.titleLabelTextColor
        titleLabel.text      = "积分明细"
        return titleLabel
    }()
    
    lazy var checkWayBtn: UIButton = {
        let checkWayBtn = SQImagePositionBtn.init(
            frame: CGRect.zero, position: .right,
            imageViewSize: CGSize.init(width: 15, height: 30)
        )
        
        checkWayBtn.titleLabel?.textAlignment = .right
        checkWayBtn.imageView?.contentMode    = .right
        checkWayBtn.titleLabel?.font = SQItemStruct.checkWayBtnFont
        checkWayBtn.setTitleColor(
            SQItemStruct.checkWayBtnTextColor,
            for: .normal
        )
        
        checkWayBtn.setImage(
            UIImage.init(named: "sq_arrow_friend"),
            for: .normal
        )
        
        checkWayBtn.setTitle("查看规则", for: .normal)
        checkWayBtn.contentHorizontalAlignment = .right
        checkWayBtn.isHidden = true
        return checkWayBtn
    }()
    
    lazy var line2View: UIView = {
        let line2View = UIView()
        line2View.backgroundColor = k_color_line
        return line2View
    }()
    
    init(frame: CGRect, state: SQIntegralInfoListVC.State, handel: @escaping ((SQIntegralInfoListCardView.Event) -> ())) {
        super.init(frame: frame)
        customState = state
        callBack = handel
        backgroundColor = UIColor.white
        if state == SQIntegralInfoListVC.State.gold {
            titleLabel.text = "金币明细"
        }
        
        if state == SQIntegralInfoListVC.State.exten {
            titleLabel.text = "邀请方式"
            checkWayBtn.isHidden = false
        }
        addSubview(cardView)
        addSubview(lineView)
        addSubview(blueView)
        addSubview(titleLabel)
        addSubview(line2View)
        addSubview(checkWayBtn)
        addLayout()
    }
    
    func addLayout() {
        
        cardView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.height.equalTo(SQIntegralInfoListCardView.height)
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
        }
        
        lineView.snp.makeConstraints { (maker) in
            maker.top.equalTo(cardView.snp.bottom)
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(k_line_height_big)
        }

        blueView.snp.makeConstraints { (maker) in
            maker.height.equalTo(SQItemStruct.blueViewH)
            maker.width.equalTo(SQItemStruct.blueViewW)
            maker.left.equalTo(snp.left)
                .offset(SQIntegralInfoListTableHeaderView.margin)
            maker.top.equalTo(lineView.snp.bottom)
                .offset(SQItemStruct.blueViewTop)
        }

        titleLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(SQItemStruct.titleLabelH)
            maker.centerY.equalTo(blueView.snp.centerY)
            maker.width.equalTo(SQItemStruct.titleLabelW)
            maker.left.equalTo(blueView.snp.right)
                .offset(SQItemStruct.titleLabelMarginX)
        }
        
        checkWayBtn.snp.makeConstraints { (maker) in
            maker.height.equalTo(SQItemStruct.checkWayBtnH)
            maker.centerY.equalTo(titleLabel.snp.centerY)
            maker.width.equalTo(SQItemStruct.checkWayBtnW)
            maker.right.equalTo(snp.right)
                .offset(SQItemStruct.checkWayBtnRightX)
        }
        
        line2View.snp.makeConstraints { (maker) in
            maker.height.equalTo(k_line_height)
            maker.bottom.equalTo(snp.bottom).offset(k_line_height * -1)
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
