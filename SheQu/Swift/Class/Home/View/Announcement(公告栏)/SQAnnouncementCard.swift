//
//  SQAnnouncementCard.swift
//  SheQu
//
//  Created by gm on 2019/8/20.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    static let bgImageViewX: CGFloat = 20
    static let bgImageViewH: CGFloat = 65
    static let bgImageViewW: CGFloat = k_screen_width - bgImageViewX * 2
    
    ///jumpBtn
    static let jumpBtnW: CGFloat    = 40
    static let jumpBtnH: CGFloat    = 20
    static let jumpBtnRightMargin: CGFloat = -10
    
    ///titleLabel
    static let titleLabelX: CGFloat = 10
    static let titleLabelRightMargin: CGFloat = -10 - jumpBtnW + jumpBtnRightMargin
    static let titleLabelRightMarginMin: CGFloat = -10
    static let titleLabelHeight: CGFloat = 50
    static let titleLabelFont = k_font_title
}

class SQAnnouncementCard: UICollectionViewCell {
    
    static let height: CGFloat = 65
    static let width: CGFloat  = k_screen_width
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.setSize(size: CGSize.init(
            width: SQItemStruct.bgImageViewW,
            height: SQItemStruct.bgImageViewH
        ))
        
        bgImageView.addRounded(
            corners: [.topLeft,.topRight],
            radii: k_corner_radiu_size_10,
            borderWidth: 0,
            borderColor: UIColor.clear
        )
        return bgImageView
    }()
    
    lazy var titleLabel: UILabel  = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.font          = SQItemStruct.titleLabelFont
        titleLabel.textColor     = UIColor.white
        return titleLabel
    }()
    
    lazy var jumpBtn: UIButton = {
        let jumpBtn = UIButton()
        jumpBtn.setImage(UIImage.init(named: "sq_announcement_jump"), for: .normal)
        jumpBtn.isUserInteractionEnabled = false
        return jumpBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(bgImageView)
        addSubview(titleLabel)
        addSubview(jumpBtn)
        addLayout()
    }
    
    var customItemData: SQAnnouncementItemData? {
        didSet {
            if (customItemData != nil) {
                if customItemData!.jumpUrl.count > 0 {
                    jumpBtn.isHidden = false
                }else{
                    jumpBtn.isHidden = true
                }
                
                let imageName = "sq_announcement_bg\(customItemData!.imageNameType.rawValue)"
                titleLabel.text   = customItemData?.title
                bgImageView.image = UIImage.init(named: imageName)
                layoutIfNeeded()
            }
        }
    }
    
    private func addLayout(){
        bgImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.left.equalTo(snp.left)
                .offset(SQItemStruct.bgImageViewX)
            maker.width.equalTo(SQItemStruct.bgImageViewW)
            maker.height.equalTo(SQItemStruct.bgImageViewH)
        }
        
        jumpBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(SQItemStruct.jumpBtnW)
            maker.height.equalTo(SQItemStruct.jumpBtnH)
            maker.centerY.equalTo(snp.centerY)
            maker.right.equalTo(bgImageView.snp.right)
                .offset(SQItemStruct.jumpBtnRightMargin)
        }
        
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(SQItemStruct.titleLabelHeight)
            maker.centerY.equalTo(snp.centerY)
            maker.right.equalTo(bgImageView.snp.right)
                .offset(SQItemStruct.titleLabelRightMargin)
            maker.left.equalTo(bgImageView.snp.left)
                .offset(SQItemStruct.titleLabelX)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
