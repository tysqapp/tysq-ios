//
//  SearchView.swift
//  SheQu
//
//  Created by iMac on 2019/9/3.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

class SQForbinCommentListSearchView: UIView {
    
    lazy var magnifier: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "sq_label_search")
        imageView.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        imageView.contentMode = .center
        return imageView
    }()
    
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "请输入用户昵称搜索"
        tf.backgroundColor = k_color_bg_gray
        tf.layer.cornerRadius = 4
        tf.font = k_font_title
        let leftV = UIView(frame: CGRect.init(x: 0, y: 0, width: 28, height: 28))
        leftV.addSubview(magnifier)
        tf.leftView = leftV
        tf.leftViewMode = .always
        tf.clearButtonMode = .always
        return tf
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(textField)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
   private func setupLayout(){
    
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(10)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.left.equalTo(self.snp.left).offset(20)
            make.right.equalTo(self.snp.right).offset(-20)
        }
    
    }
    
}
