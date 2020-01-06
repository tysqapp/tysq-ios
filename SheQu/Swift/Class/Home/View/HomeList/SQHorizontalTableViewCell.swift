//
//  SQHorizontalTableViewCell.swift
//  SheQu
//
//  Created by gm on 2019/4/30.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQHorizontalTableViewCell: UITableViewCell {
    
    lazy var roundView = UIView()
    
    lazy var titleLable : UILabel = {
        let titleLable = UILabel()
        titleLable.font = UIFont.systemFont(ofSize: 11)
        titleLable.textColor = k_color_title_blue
        titleLable.textAlignment = .center
        return titleLable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(roundView)
        addSubview(titleLable)
        addLayout()
    }
   
    func addLayout() {
        let margin: CGFloat = 10
        roundView.frame = CGRect.init(x: margin, y: margin, width: self.width() - margin, height: self.height() - margin * 2)
        roundView.addRounded(corners: .allCorners, radii: CGSize.init(width: 10, height: 10), borderWidth: 0.7, borderColor: titleLable.textColor)
        
        titleLable.frame = roundView.frame
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
