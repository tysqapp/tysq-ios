//
//  SQCloudTableViewCell.swift
//  SheQu
//
//  Created by gm on 2019/7/25.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    static let lineViewMarginX = k_margin_x
}

///我的页面 详情内容cell
class SQCloudTableViewCell: UITableViewCell {
    
    static let cellID = "SQCloudTableViewCellID"
    static let height: CGFloat = 60
    var notiNum = 0 {
        didSet {
            if notiNum != 0 {
                redView.isHidden = false
                notiNumLabel.isHidden = false
                if notiNum > 99 {
                    notiNumLabel.text = "99+"
                } else {
                    notiNumLabel.text = "\(notiNum)"
                }
                
            }
            
        }
    }
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line
        return lineView
    }()
    
    lazy var redView: UIView = {
        let redView = UIView(frame: CGRect.init(x: 0, y: 0, width: 14, height: 14))
        redView.backgroundColor = .red
        redView.layer.cornerRadius = 7
        return redView
    }()
    
    lazy var notiNumLabel: UILabel = {
        let notiNumLabel = UILabel()
        notiNumLabel.font = UIFont.systemFont(ofSize: 11)
        notiNumLabel.textColor = .white
        return notiNumLabel
    }()
    
    
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?,lineLeft: CGFloat = 20) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(lineView)
        addSubview(redView)
        addSubview(notiNumLabel)
        redView.isHidden = true
        notiNumLabel.isHidden = true
        
        let imageView         = UIImageView.init(image: UIImage.init(named: "home_ac_inside"))
        imageView.sizeToFit()
        accessoryView    = imageView
        textLabel?.font  = k_font_title
        addLayout(lineLeft)
        
    }
    
    private func addLayout(_ lineLeft: CGFloat) {
        lineView.snp.makeConstraints { (maker) in
            maker.height.equalTo(k_line_height)
            maker.right.equalTo(snp.right)
            maker.left.equalTo(snp.left)
                .offset(lineLeft)
            maker.bottom.equalTo(snp.bottom)
                .offset(k_line_height * -1)
        }
        
        redView.snp.makeConstraints { (maker) in
            maker.height.equalTo(notiNumLabel.snp.height)
            maker.width.equalTo(notiNumLabel.snp.width).offset(8)
            maker.centerY.equalTo(notiNumLabel.snp.centerY)
            maker.centerX.equalTo(notiNumLabel.snp.centerX)
            
        }
        
        notiNumLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(snp.centerY)
            maker.right.equalTo(snp.right).offset(-38)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
