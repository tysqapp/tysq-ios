//
//  SQSettingAcountTableViewCell.swift
//  SheQu
//
//  Created by gm on 2019/6/5.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQSettingAcountTableViewCell: UITableViewCell {
    
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = k_font_title
        return titleLabel
    }()
    
    lazy var aniImageView: SQAniImageView = {
        let aniImageView = SQAniImageView()
        aniImageView.setSize(size: CGSize.init(width: 40, height: 40))
        aniImageView.contentMode = .scaleAspectFill
        aniImageView.layer.cornerRadius  = k_corner_radiu
        aniImageView.layer.masksToBounds = true
        return aniImageView
    }()
    
    lazy var valueLabel: UILabel = {
        let valueLabel       = UILabel()
        valueLabel.font      = k_font_title
        valueLabel.textColor = k_color_title_light_gray_3
        valueLabel.textAlignment = .right
        valueLabel.numberOfLines = 0
        return valueLabel
    }()
    
//    lazy var valueTextView: UITextView = {
//        let textView = UITextView()
//        textView.isScrollEnabled = false
//        textView.isEditable = false
//        textView.isUserInteractionEnabled = false;
//        textView.textAlignment = .left
//        textView.textColor = k_color_title_light_gray_3
//        textView.font = k_font_title
//        return textView
//    }()
    
    lazy var customAccessoryView: UIImageView = {
        let customAccessoryView = UIImageView.init(image: UIImage.init(named: "home_ac_inside"))
        customAccessoryView.sizeToFit()
        customAccessoryView.contentMode = .right
        return customAccessoryView
    }()

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, isAniImage: Bool, isBrief: Bool) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(titleLabel)
        addSubview(aniImageView)
        addSubview(customAccessoryView)
        addSubview(valueLabel)
        //addSubview(valueTextView)
        addLayout(isAniImage: isAniImage, isBrief: isBrief)
    }
    
    func addLayout(isAniImage: Bool, isBrief: Bool) {
        titleLabel.snp.makeConstraints { (maker) in
                maker.left.equalTo(snp.left).offset(20)
                if isBrief{
                    maker.top.equalTo(snp.top).offset(20)
                }else{
                    maker.centerY.equalTo(snp.centerY)
                }
            
                maker.width.equalTo(60)
        }
        
        
        customAccessoryView.snp.makeConstraints { (maker) in
            maker.right.equalTo(snp.right).offset(-20)
            maker.centerY.equalTo(snp.centerY)
            maker.height.equalTo(40)
            maker.width.equalTo(10)
        }
        
        if isAniImage {
            valueLabel.isHidden = true
            aniImageView.snp.makeConstraints { (maker) in
                maker.right.equalTo(customAccessoryView.snp.left).offset(-20)
                maker.centerY.equalTo(snp.centerY)
                maker.height.equalTo(40)
                maker.width.equalTo(40)
            }
        }else {
            aniImageView.isHidden = true
            valueLabel.snp.makeConstraints { (maker) in
                maker.right.equalTo(customAccessoryView.snp.left).offset(-20)
                maker.left.equalTo(titleLabel.snp.right).offset(10)
                if isBrief{
                    maker.top.equalTo(titleLabel.snp.top)
                    // maker.centerY.equalTo(snp.centerY)
                }else{
                    maker.centerY.equalTo(snp.centerY)
                }         
            }
            
            if isBrief {
               valueLabel.textAlignment = .left
                
            }
            
        }
        

        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
