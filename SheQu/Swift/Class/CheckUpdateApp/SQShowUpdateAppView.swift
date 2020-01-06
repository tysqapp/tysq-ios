//
//  SQShowUpdateAppView.swift
//  SheQu
//
//  Created by gm on 2019/7/19.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    
    ///contentView
    static let contentViewW: CGFloat = bgImageViewW
    static var contentViewH: CGFloat = 350
    
    static let bgImageViewW: CGFloat = 255
    static let bgImageViewH: CGFloat = 117
    
    ///versionLabel
    static let versionLabelTop: CGFloat = 20
    static let versionLabelX: CGFloat = 20
    static let versionLabelH: CGFloat = 16
    static let varsionLabelW: CGFloat = contentViewW - versionLabelX * 2
    
    ///tipsLabel
    static let tipsLabelTop: CGFloat = 17.5
    static let tipsLabelH: CGFloat   = 16
    
    ///upgradeBtn
    static let upgradeBtnBottom: CGFloat = 25
    static let upgradeBtnH: CGFloat   = 45
    static let upgradeBtnW: CGFloat   = 190
    
    ///closeBtn
    static let closeBtnTop: CGFloat = 50
    static let closeBtnWH: CGFloat  = 30
    
    static let aniDuration: CGFloat = 0.4
}


/// 我的好友界面 显示二维码view
class SQShowUpdateAppView: UIView {
    
    private lazy var coverView: UIView = {
        let coverView  = UIView()
        coverView.backgroundColor = UIColor.black
        coverView.alpha = 0.5
        return coverView
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage.init(named: "sq_upgrade_bg")
        return bgImageView
    }()
    
    private lazy var contentView: UIView = {
        let contentView  = UIView()
        contentView.backgroundColor = .clear
        return contentView
    }()
    
    private lazy var contentBGView: UIView = {
        let contentBGView  = UIView()
        contentBGView.backgroundColor = UIColor.white
        return contentBGView
    }()
    
    
    
    private lazy var versionLabel: UILabel = {
        let versionLabel = UILabel()
        versionLabel.font = k_font_title_weight
        versionLabel.textColor = UIColor.black
        return versionLabel
    }()
    
    private lazy var tipsLabel: UILabel = {
        let tipsLabel = UILabel()
        tipsLabel.text          = "新版特性:"
        tipsLabel.font = k_font_title_weight
        tipsLabel.textColor = UIColor.black
        return tipsLabel
    }()
    
    private lazy var tipsTableView: UITableView = {
        let tipsTableView = UITableView()
        tipsTableView.separatorStyle = .none
        tipsTableView.isScrollEnabled = false
        return tipsTableView
    }()
    
    private lazy var upgradeBtn: UIButton = {
        let upgradeBtn = UIButton()
        upgradeBtn.setTitle("立即更新", for: .normal)
        upgradeBtn.setTitleColor(UIColor.white, for: .normal)
        upgradeBtn.addTarget(
            self,
            action: #selector(jumpDownloadAppInterface),
            for: .touchUpInside
        )
        
        upgradeBtn.setSize(size: CGSize.init(
            width: SQItemStruct.upgradeBtnW,
            height: SQItemStruct.upgradeBtnH
        ))
        
        upgradeBtn.updateBGColor(4)
        return upgradeBtn
    }()
    
    lazy var closeBtn: UIButton = {
        let closeBtn = UIButton()
        closeBtn.setImage(UIImage.init(named: "sq_integral_close"), for: .normal)
        closeBtn.addTarget(self, action: #selector(hidden), for: .touchUpInside)
        closeBtn.isHidden = true
        return closeBtn
    }()
    
    class func showQRCodeView(qrCodeImage: UIImage){
        let _ = SQShowQRCodeView.init(frame: UIScreen.main.bounds, qrCodeImage: qrCodeImage)
    }
    
    var callBack:((SQShowUpdateAppView) -> ())!
    
    init(frame: CGRect, version: String, tipsArray: [String], isForce: Bool ,handel: @escaping ((SQShowUpdateAppView) -> ())) {
        super.init(frame: frame)
        SQItemStruct.contentViewH = 350
        callBack = handel
        addSubview(coverView)
        addSubview(contentView)
        contentView.addSubview(contentBGView)
        contentView.addSubview(versionLabel)
        contentView.addSubview(tipsLabel)
        contentView.addSubview(bgImageView)
        contentView.addSubview(upgradeBtn)
        contentView.addSubview(tipsTableView)
        addSubview(closeBtn)
        if isForce {
            closeBtn.alpha = 0
        }
        
        let tableHeaderView = UIView()
        var tempFrame = CGRect.init(x: 0, y: -10, width: 0, height: 0)
        let labelW = SQItemStruct.varsionLabelW
        let labelTopMargin: CGFloat = 10
        for index in 0..<tipsArray.count {
            let tipStr = tipsArray[index]
            let labebH = tipStr.calcuateLabSizeHeight(font: k_font_title, maxWidth: labelW)
            let lableY = tempFrame.maxY + labelTopMargin
            let lable = UILabel.init(frame: CGRect.init(x: 0, y: lableY, width: labelW, height: labebH))
            lable.font = k_font_title
            lable.text = tipStr
            lable.textColor = k_color_black
            lable.numberOfLines = 0
            tableHeaderView.addSubview(lable)
            tempFrame = lable.frame
        }
        
        versionLabel.text = "最新版本：V\(version)"
        let maxY = tempFrame.maxY
        let value = maxY - 74.5
        if value > 0 {
            SQItemStruct.contentViewH =  SQItemStruct.contentViewH + value
        }
        tipsTableView.tableHeaderView = tableHeaderView
        contentBGView.setSize(size: CGSize.init(
            width: SQItemStruct.contentViewW,
            height: SQItemStruct.contentViewH - 20
        ))
        
        contentBGView.layer.cornerRadius = 5
        addLayout()
        layoutIfNeeded()
        show()
    }
    
    private func addLayout() {
        
        coverView.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.top.equalTo(snp.top)
            maker.bottom.equalTo(snp.bottom)
        }
        
        contentView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(snp.centerX)
            maker.top.equalTo(snp.top).offset(SQItemStruct.contentViewH * -1)
            maker.width.equalTo(SQItemStruct.contentViewW)
            maker.height.equalTo(SQItemStruct.contentViewH)
        }
        
        contentBGView.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView.snp.top).offset(20)
            maker.left.equalTo(contentView.snp.left)
            maker.right.equalTo(contentView.snp.right)
            maker.bottom.equalTo(contentView.snp.bottom)
        }
        
        bgImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(contentView.snp.left)
            maker.top.equalTo(contentView.snp.top)
            maker.width.equalTo(SQItemStruct.bgImageViewW)
            maker.height.equalTo(SQItemStruct.bgImageViewH)
        }
        
        versionLabel.snp.makeConstraints { (maker) in
            maker.width.equalTo(SQItemStruct.varsionLabelW)
            maker.height.equalTo(SQItemStruct.versionLabelH)
            maker.top.equalTo(bgImageView.snp.bottom)
            maker.left.equalTo(contentView.snp.left)
                .offset(SQItemStruct.versionLabelX)
        }
        
        tipsLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(versionLabel.snp.left)
            maker.right.equalTo(versionLabel.snp.right)
            maker.height.equalTo(SQItemStruct.tipsLabelH)
            maker.top.equalTo(versionLabel.snp.bottom)
                .offset(SQItemStruct.tipsLabelTop)
        }
        
        tipsTableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(tipsLabel.snp.bottom).offset(10)
            maker.left.equalTo(versionLabel.snp.left)
            maker.right.equalTo(versionLabel.snp.right)
            maker.bottom.equalTo(upgradeBtn.snp.top)
                .offset(SQItemStruct.upgradeBtnBottom * -1)
        }
        
        upgradeBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(SQItemStruct.upgradeBtnW)
            maker.height.equalTo(SQItemStruct.upgradeBtnH)
            maker.centerX.equalTo(contentView.snp.centerX)
            maker.bottom.equalTo(contentView.snp.bottom)
                .offset(SQItemStruct.upgradeBtnBottom * -1)
        }
        
        closeBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(snp.centerX)
            maker.width.equalTo(SQItemStruct.closeBtnWH)
            maker.height.equalTo(SQItemStruct.closeBtnWH)
            maker.top.equalTo(contentView.snp.bottom)
                .offset(SQItemStruct.closeBtnTop)
        }
    }
    
    @objc private func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        let height = (k_screen_height - SQItemStruct.contentViewH) * 0.5
        UIView.animate(
            withDuration: TimeInterval.init(SQItemStruct.aniDuration),
            animations: {
                self.contentView.snp.updateConstraints({ (maker) in
                    maker.top.equalTo(self.snp.top).offset(height)
                })
                self.layoutIfNeeded()
        }) { (isFinish) in
            self.closeBtn.isHidden = false
        }
    }
    
    @objc private func jumpDownloadAppInterface() {
        guard let updateUrl =  URL.init(string: "\(SQHostStruct.host.replacingOccurrences(of: SQHostStruct.apiVersion, with: "/api/pages/"))download_app") else {
            return
        }
        UIApplication.shared.open(updateUrl, options: [:], completionHandler: nil)
    }
    
    
    
    @objc private func hidden() {
        closeBtn.isHidden = true
        UIView.animate(withDuration: TimeInterval.init(SQItemStruct.aniDuration),
                       animations: {
                        self.contentView.snp.updateConstraints({ (maker) in
                            maker.top.equalTo(self.snp.top)
                                .offset(SQItemStruct.contentViewH * -1)
                        })
                        self.layoutIfNeeded()
        }) { (isFinish) in
            if isFinish {
                self.callBack(self)
                self.removeFromSuperview()
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
