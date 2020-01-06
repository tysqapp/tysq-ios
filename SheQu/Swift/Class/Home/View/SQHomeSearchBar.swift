//
//  SQHomeSearchBar.swift
//  SheQu
//
//  Created by iMac on 2019/9/17.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQHomeSearchBar: UIView {
    var searchCallBack: (()->())?
    
    lazy var typeButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 35)
        button.setTitle("文章", for: .normal)
        button.titleLabel?.font = k_font_title
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.setImage("sq_wz_load_all".toImage(), for: .normal)
       

        button.imageEdgeInsets = UIEdgeInsets.init(top: 17, left: 50, bottom: 14, right: 4)
       button.titleEdgeInsets = UIEdgeInsets.init(top: 11, left: 5, bottom: 11, right: 26)
        
        return button
    }()
    
    lazy var lineView: UIView = {
       let view = UIView()
       view.backgroundColor = k_color_line
       view.frame = CGRect.init(x: 65, y: 0, width: 1, height: 35)
       return view
    }()

    lazy var leftV: UIView = {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 71, height: 35))
        view.addSubview(typeButton)
        view.addSubview(lineView)
        return view
    }()
    
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "请输入搜索内容"
        tf.backgroundColor = k_color_bg_gray
        tf.layer.cornerRadius = 4
        tf.font = k_font_title
        tf.leftView = leftV
        tf.leftViewMode = .always
        tf.clearButtonMode = .always
        tf.returnKeyType = .search
        return tf
    }()
    
    lazy var searchButton: UIButton = {
        let sb = UIButton()
        sb.setTitle("搜索", for: .normal)
        sb.titleLabel?.font = k_font_title
        sb.setTitleColor(k_color_normal_blue, for: .normal)
        sb.addTarget(self, action: #selector(clickSearch), for: .touchUpInside)
        return sb
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textField)
        addSubview(searchButton)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setupLayout(){
        
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top).offset(10)
            make.bottom.equalTo(snp.bottom).offset(-10)
            make.left.equalTo(snp.left).offset(20)
            make.right.equalTo(searchButton.snp.left)
        }
        
        searchButton.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.top.equalTo(textField.snp.top)
            $0.bottom.equalTo(textField.snp.bottom)
            $0.right.equalTo(snp.right).offset(-5)
        }
        
    }

    @objc func clickSearch() {
        guard searchCallBack != nil else {
            return
        }
        searchCallBack!()
    }

}
