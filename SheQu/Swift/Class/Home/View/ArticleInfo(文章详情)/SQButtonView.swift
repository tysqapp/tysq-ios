//
//  SQButtonView.swift
//  SheQu
//
//  Created by gm on 2019/5/28.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQButtonView: UIView {

    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .top
        return imageView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = k_font_title
        label.textColor = k_color_black
        return label
    }()
    
    fileprivate var callBack: ((Int) -> ())!
    
    init(frame: CGRect, imageName: String, title: String, handel: @escaping ((Int)->())) {
        super.init(frame: frame)
        callBack = handel
        
        imageView.image = UIImage.init(named: imageName)
        titleLabel.text = title
        
        addSubview(imageView)
        addSubview(titleLabel)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(sqbtnClick))
        addGestureRecognizer(tap)
    }
    
    @objc private func sqbtnClick() {
        callBack(tag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: 50)
        titleLabel.frame = CGRect.init(x: 0, y: 65, width: frame.size.width, height: 10)
    }
    
    func setDisImageView(_ imageName: String){
        imageView.image = UIImage.init(named: imageName)
        isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
