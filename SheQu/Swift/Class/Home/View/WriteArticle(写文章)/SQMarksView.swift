//
//  SQMarksView.swift
//  SheQu
//
//  Created by gm on 2019/5/7.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQMarksView: UIView {
    static let normal_width: CGFloat  = 34
    static let viewH: CGFloat        = 30
    static let font = UIFont.systemFont(ofSize: 11)
    lazy var titlesLabel: UILabel = {
        let titlesLabel = UILabel()
        titlesLabel.textColor = k_color_title_blue
        titlesLabel.font      = SQMarksView.font
        return titlesLabel
    }()
    
    var callBack: ((String) -> ())?
    
    lazy var removeBtn: UIButton = {
        let removeBtn = UIButton()
        removeBtn.addTarget(self, action: #selector(removeBtnClick), for: .touchUpInside)
        removeBtn.contentMode = .center
        removeBtn.setImage(UIImage.init(named: "home_ac_del"), for: .normal)
        return removeBtn
    }()
    
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        addSubview(titlesLabel)
        addSubview(removeBtn)
        titlesLabel.text = title
        layer.borderWidth = 0.7
        layer.borderColor = k_color_normal_blue.cgColor
        layer.cornerRadius = frame.size.height * 0.5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        removeBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(20)
            maker.height.equalTo(20)
            maker.right.equalTo(self.snp.right).offset(-4)
            maker.centerY.equalTo(self.snp.centerY)
        }
        
        titlesLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.snp.centerY)
            maker.left.equalTo(self.snp.left).offset(10)
            maker.height.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func removeBtnClick(){
        if callBack != nil {
            callBack!(titlesLabel.text!)
        }
    }
}
