//
//  SQFriendContentView.swift
//  SheQu
//
//  Created by gm on 2019/7/18.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
import EFQRCode

fileprivate struct SQItemStruct {
    
    static let margin = SQFriendContentView.margin
    
    ///numLabel
    static let numLabelBGColor      = k_color_normal_blue
    static let numLabelWH: CGFloat  = 16
    static let numLabelFont        = k_font_title
    
    ///inviteCode
    static let inviteCodeLabelH: CGFloat = 14
    static let inviteCodeLabelW: CGFloat = 100
    static let labelFont = k_font_title_weight
    static let labelTextColor = k_color_black
    
    ///inviteCodeValue
    static let inviteCodeValueLabelH: CGFloat = 18
    static let inviteCodeValueLabelW: CGFloat = 200
    static let inviteCodeValueLabelFont = k_font_title_16_weight
    static let inviteCodeValueLabelTextColor = k_color_normal_blue
    static let inviteCodeValueLabelTop = 12
    
    ///websiteLabel
    static let websiteLabelTop: CGFloat = 20
    
    ///websiteLinkLabel
    static let websiteLinkLabelTop: CGFloat = 12
    
    ///scanLabel
    static let scanLabelTop: CGFloat = 40
    
    ///scanImageView
    static let scanImageViewW: CGFloat = 100
    static let scanImageViewH: CGFloat = 100
    static let scanImageViewTop: CGFloat = 12
    
    ///btn
    static let btnH: CGFloat = 25
    static let btnW: CGFloat = 70
    static let btnFont = k_font_title_12
    
    ///blueView
    static let blueViewH: CGFloat = 15
    static let blueViewTop: CGFloat =  15
    static let blueViewW: CGFloat = 3
    static let blueViewColor      = k_color_normal_blue
    
    ///titleLabel
    static let titleLabelH: CGFloat       = 14
    static let titleLabelMarginX: CGFloat = 10
    static let titleLabelTextColor        = k_color_black
    static let titleLabelFont             = k_font_title_weight
    static let titleLabelW: CGFloat       = 100
    
    ///lineView
    static let lineViewTop: CGFloat = 25
}

///邀请好友View
class SQFriendContentView: UIView {
    
    enum Event: Int {
        case copy = 0
        case QRCode = 1
    }
    
    static let height: CGFloat = 375
    static let width  = k_screen_width
    static let margin = k_margin_x
    
    var callBack: ((SQFriendContentView.Event, SQFriendContentView) -> ())!
    
    lazy var num1Label: UILabel = {
        let num1Label = UILabel()
        num1Label.text = "1"
        num1Label.textAlignment   = .center
        num1Label.textColor       =  UIColor.white
        num1Label.font            = SQItemStruct.numLabelFont
        num1Label.backgroundColor = SQItemStruct.numLabelBGColor
        num1Label.setSize(size: CGSize.init(width: SQItemStruct.numLabelWH, height: SQItemStruct.numLabelWH))
        num1Label.layer.cornerRadius = SQItemStruct.numLabelWH * 0.5
        num1Label.layer.masksToBounds = true
        return num1Label
    }()
    
    lazy var inviteCodeLabel: UILabel = {
        let inviteCodeLabel       = UILabel()
        
        inviteCodeLabel.text      = "提供邀请码"
        inviteCodeLabel.font      = SQItemStruct.labelFont
        inviteCodeLabel.textColor = SQItemStruct.labelTextColor
        return inviteCodeLabel
    }()
    
    lazy var inviteCodeValueLabel: UILabel = {
        let inviteCodeValueLabel = UILabel()
        inviteCodeValueLabel.font = SQItemStruct.inviteCodeValueLabelFont
        inviteCodeValueLabel.textColor = SQItemStruct.inviteCodeValueLabelTextColor
        return inviteCodeValueLabel
    }()

    lazy var num2Label: UILabel = {
        let num2Label = UILabel()
        num2Label.text = "2"
        num2Label.textAlignment   = .center
        num2Label.textColor       =  UIColor.white
        num2Label.font            = SQItemStruct.numLabelFont
        num2Label.backgroundColor = SQItemStruct.numLabelBGColor
        num2Label.setSize(size: CGSize.init(width: SQItemStruct.numLabelWH, height: SQItemStruct.numLabelWH))
        num2Label.layer.cornerRadius = SQItemStruct.numLabelWH * 0.5
        num2Label.layer.masksToBounds = true
        return num2Label
    }()
    
    lazy var websiteLabel: UILabel = {
        let websiteLabel = UILabel()
        websiteLabel.text = "网址"
        websiteLabel.font = SQItemStruct.labelFont
        websiteLabel.textColor = SQItemStruct.labelTextColor
        return websiteLabel
    }()
    
    lazy var websiteLinkLabel: UILabel = {
        let websiteLinkLabel = UILabel()
        websiteLinkLabel.font = SQItemStruct.inviteCodeValueLabelFont
        websiteLinkLabel.textColor = SQItemStruct.inviteCodeValueLabelTextColor
        return websiteLinkLabel
    }()
    
    lazy var scanLabel: UILabel = {
        let scanLabel = UILabel()
        scanLabel.textColor = SQItemStruct.labelTextColor
        scanLabel.font      = SQItemStruct.labelFont
        scanLabel.text      = "扫码注册"
        return scanLabel
    }()
    
    lazy var scanImageView: UIImageView = {
        let scanImageView = UIImageView()
        return scanImageView
    }()
    
    lazy var copyLinkBtn: UIButton = {
        let copyLinkBtn = UIButton()
        copyLinkBtn.titleLabel?.font = SQItemStruct.btnFont
        copyLinkBtn.setTitle("复制链接", for: .normal)
        copyLinkBtn.setSize(size: CGSize.init(width: SQItemStruct.btnW, height: SQItemStruct.btnH))
        copyLinkBtn.updateBGColor(4)
        copyLinkBtn.addTarget(self, action: #selector(copyDomainAddress), for: .touchUpInside)
        return copyLinkBtn
    }()
    
    lazy var scanBtn: UIButton = {
        let scanBtn = UIButton()
        scanBtn.setTitle("查看二维码", for: .normal)
        scanBtn.titleLabel?.font = SQItemStruct.btnFont
        scanBtn.setSize(size: CGSize.init(width: SQItemStruct.btnW, height: SQItemStruct.btnH))
        scanBtn.updateBGColor(4)
        scanBtn.addTarget(self, action: #selector(showQRCode), for: .touchUpInside)
        return scanBtn
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
        titleLabel.text      = "你成功邀请了0人"
        return titleLabel
    }()
    
    lazy var line2View: UIView = {
        let line2View = UIView()
        line2View.backgroundColor = k_color_line
        return line2View
    }()
    
    init(frame: CGRect, handel:@escaping ((SQFriendContentView.Event, SQFriendContentView) -> ())) {
        super.init(frame: frame)
        callBack = handel
        addSubview(num1Label)
        addSubview(inviteCodeLabel)
        addSubview(inviteCodeValueLabel)
        addSubview(websiteLabel)
        addSubview(websiteLinkLabel)
        addSubview(num2Label)
        addSubview(scanLabel)
        addSubview(scanImageView)
        addSubview(scanBtn)
        addSubview(copyLinkBtn)
        addSubview(lineView)
        addSubview(blueView)
        addSubview(titleLabel)
        addSubview(line2View)
        addLayout()
    }
    
    func addLayout() {
        
        num1Label.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top).offset(20)
            maker.left.equalTo(snp.left).offset(SQItemStruct.margin)
            maker.height.equalTo(SQItemStruct.numLabelWH)
            maker.width.equalTo(SQItemStruct.numLabelWH)
        }
        
        inviteCodeLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(num1Label.snp.centerY)
            maker.left.equalTo(num1Label.snp.right).offset(10)
            maker.width.equalTo(SQItemStruct.inviteCodeLabelW)
            maker.height.equalTo(SQItemStruct.inviteCodeLabelH)
        }
        
        inviteCodeValueLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(inviteCodeLabel.snp.left)
            maker.top.equalTo(inviteCodeLabel.snp.bottom)
                .offset(SQItemStruct.inviteCodeValueLabelTop)
            maker.width.equalTo(SQItemStruct.inviteCodeValueLabelW)
            maker.height.equalTo(SQItemStruct.inviteCodeValueLabelH)
        }
        
        websiteLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(inviteCodeLabel.snp.left)
            maker.width.equalTo(SQItemStruct.inviteCodeLabelW)
            maker.height.equalTo(SQItemStruct.inviteCodeLabelH)
            maker.top.equalTo(inviteCodeValueLabel.snp.bottom)
                .offset(SQItemStruct.websiteLabelTop)
        }
        
        websiteLinkLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(inviteCodeLabel.snp.left)
            maker.top.equalTo(websiteLabel.snp.bottom)
                .offset(SQItemStruct.websiteLinkLabelTop)
            maker.right.equalTo(copyLinkBtn.snp.right)
            maker.height.equalTo(SQItemStruct.inviteCodeValueLabelH)
        }
        
        num2Label.snp.makeConstraints { (maker) in
            maker.height.equalTo(SQItemStruct.numLabelWH)
            maker.width.equalTo(SQItemStruct.numLabelWH)
            maker.left.equalTo(num1Label.snp.left)
            maker.top.equalTo(websiteLinkLabel.snp.bottom)
                .offset(SQItemStruct.scanLabelTop)
        }
        
        scanLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(inviteCodeLabel.snp.left)
            maker.centerY.equalTo(num2Label.snp.centerY)
            maker.width.equalTo(SQItemStruct.inviteCodeLabelW)
            maker.height.equalTo(SQItemStruct.inviteCodeLabelH)
        }
        
        scanImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(inviteCodeLabel.snp.left)
            maker.height.equalTo(SQItemStruct.scanImageViewH)
            maker.width.equalTo(SQItemStruct.scanImageViewW)
            maker.top.equalTo(scanLabel.snp.bottom)
                .offset(SQItemStruct.scanImageViewTop)
        }
        
        scanBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(num2Label.snp.centerY)
            maker.right.equalTo(snp.right).offset(-20)
            maker.width.equalTo(SQItemStruct.btnW)
            maker.height.equalTo(SQItemStruct.btnH)
        }
        
        copyLinkBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(websiteLabel.snp.centerY)
            maker.right.equalTo(scanBtn.snp.right)
            maker.width.equalTo(SQItemStruct.btnW)
            maker.height.equalTo(SQItemStruct.btnH)
        }
        
        lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(k_line_height_big)
            maker.top.equalTo(scanImageView.snp.bottom)
                .offset(SQItemStruct.lineViewTop)
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
            maker.right.equalTo(scanBtn.snp.right)
            maker.left.equalTo(blueView.snp.right)
                .offset(SQItemStruct.titleLabelMarginX)
        }
        
        
        line2View.snp.makeConstraints { (maker) in
            maker.height.equalTo(k_line_height)
            maker.bottom.equalTo(snp.bottom).offset(k_line_height * -1)
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
        }

    }
    
    var model: SQInviteFriendModel? {
        didSet {
            if (model != nil) {
                inviteCodeValueLabel.text = model?.referral_code
                websiteLinkLabel.text     = model?.domain_name
                let cgImage = EFQRCode.generate(content: model!.referral_link, size: EFIntSize.init(width: Int(SQItemStruct.scanImageViewW * 2), height: Int(SQItemStruct.scanImageViewH * 2)))
                if (cgImage != nil) {
                  scanImageView.image = UIImage.init(cgImage: cgImage!)
                }
                titleLabel.text = "你成功邀请了\(model!.total_num)人"
            }
        }
    }
    
    @objc func copyDomainAddress() {
        let board = UIPasteboard.general
        board.string = model!.domain_name
        SQToastTool.showToastMessage("复制成功")
    }
    
    @objc func showQRCode() {
        let cgImage = EFQRCode.generate(content: model!.referral_link, size: EFIntSize.init(width: Int(180 * 2), height: Int(180 * 2)))
        SQShowQRCodeView.showQRCodeView(qrCodeImage: UIImage.init(cgImage: cgImage!))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
