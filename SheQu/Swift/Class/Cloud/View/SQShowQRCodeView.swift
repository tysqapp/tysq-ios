//
//  SQShowQRCodeView.swift
//  SheQu
//
//  Created by gm on 2019/7/19.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    
    ///contentView
    static let contentViewW: CGFloat = 255
    static let contentViewH: CGFloat = 350
    
    ///tipsLabel
    static let tipsLabelTop: CGFloat = 27.5
    static let tipsLabelH: CGFloat   = 14
    static let tipsLabelFont         = k_font_title
    static let tipsLabelTextColor    = k_color_black
    
    ///qrcodeImageView
    static let qrcodeImageViewWH: CGFloat = 180
    static let qrcodeImageViewTop: CGFloat = 25
    
    ///saveBtn
    static let saveBtnTop: CGFloat = 30
    static let saveBtnH: CGFloat   = 45
    
    ///closeBtn
    static let closeBtnTop: CGFloat = 50
    static let closeBtnWH: CGFloat  = 30
    
    static let aniDuration: CGFloat = 0.4
}


/// 我的好友界面 显示二维码view
class SQShowQRCodeView: UIView {
    
    private lazy var coverView: UIView = {
        let coverView  = UIView()
        coverView.backgroundColor = UIColor.black
        coverView.alpha = 0.5
        return coverView
    }()
    
    private lazy var contentView: UIView = {
        let contentView  = UIView()
        contentView.backgroundColor = UIColor.white
        contentView.setSize(size: CGSize.init(
            width: SQItemStruct.contentViewW,
            height: SQItemStruct.contentViewH
        ))
        
        contentView.layer.cornerRadius = 10
        return contentView
    }()
    
   private lazy var tipsLabel: UILabel = {
        let tipsLabel = UILabel()
        tipsLabel.textAlignment = .center
        tipsLabel.text          = "邀请好友扫码注册"
        tipsLabel.font = SQItemStruct.tipsLabelFont
        tipsLabel.textColor = SQItemStruct.tipsLabelTextColor
        return tipsLabel
    }()
    
   private lazy var qrCodeImageView: UIImageView = {
        let qrCodeImageView = UIImageView()
        return qrCodeImageView
    }()
    
   private lazy var saveBtn: UIButton = {
        let saveBtn = UIButton()
        saveBtn.setTitle("保存至手机相册", for: .normal)
        saveBtn.setTitleColor(UIColor.white, for: .normal)
        saveBtn.addTarget(
            self,
            action: #selector(saveQRcodeImage),
            for: .touchUpInside
        )
        
        saveBtn.setSize(size: CGSize.init(
            width: SQItemStruct.qrcodeImageViewWH,
            height: SQItemStruct.saveBtnH
        ))
        
        saveBtn.updateBGColor(4)
        return saveBtn
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
    
    init(frame: CGRect, qrCodeImage: UIImage) {
        super.init(frame: frame)
        addSubview(coverView)
        addSubview(contentView)
        contentView.addSubview(tipsLabel)
        contentView.addSubview(qrCodeImageView)
        contentView.addSubview(saveBtn)
        addSubview(closeBtn)
        addLayout()
        qrCodeImageView.image = qrCodeImage
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
        
        tipsLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(contentView.snp.left)
            maker.right.equalTo(contentView.snp.right)
            maker.height.equalTo(SQItemStruct.tipsLabelH)
            maker.top.equalTo(contentView.snp.top)
                .offset(SQItemStruct.tipsLabelTop)
        }
        
        qrCodeImageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(SQItemStruct.qrcodeImageViewWH)
            maker.height.equalTo(SQItemStruct.qrcodeImageViewWH)
            maker.centerX.equalTo(snp.centerX)
            maker.top.equalTo(tipsLabel.snp.bottom)
                .offset(SQItemStruct.qrcodeImageViewTop)
        }
        
        saveBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(qrCodeImageView.snp.width)
            maker.height.equalTo(SQItemStruct.saveBtnH)
            maker.centerX.equalTo(snp.centerX)
            maker.top.equalTo(qrCodeImageView.snp.bottom)
                .offset(SQItemStruct.saveBtnTop)
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
    
    @objc private func saveQRcodeImage() {
        UIImageWriteToSavedPhotosAlbum(qrCodeImageView.image!, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    @objc private func image(image: UIImage, didFinishSavingWithError: NSError?,contextInfo: AnyObject)
    {
        if didFinishSavingWithError != nil
        {
            SQToastTool.showToastMessage("保存二维码失败")
            return
        }
        
        SQToastTool.showToastMessage("保存二维码成功")
        self.hidden()
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
               self.removeFromSuperview()
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
