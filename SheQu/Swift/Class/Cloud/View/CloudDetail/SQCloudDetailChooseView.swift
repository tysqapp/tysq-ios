//
//  SQCloudDetailChooseView.swift
//  SheQu
//
//  Created by gm on 2019/6/10.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

///我的云盘界面 选择按钮控件 已上传 上传
class SQCloudDetailChooseView: UIView {
    lazy var uploadedBtn: UIButton = {
        let uploadedBtn = UIButton()
        uploadedBtn.setTitle("已上传", for: .normal)
        uploadedBtn.setTitleColor(k_color_title_blue, for: .selected)
        uploadedBtn.setTitleColor(k_color_black, for: .normal)
        uploadedBtn.titleLabel?.font = k_font_title_16
        uploadedBtn.addTarget(self, action: #selector(uploadedBtnClick), for: .touchUpInside)
        return uploadedBtn
    }()
    
    lazy private var line1View: UIView = {
        let line1View = UIView()
        line1View.setSize(size: CGSize.init(width: 30, height: 4))
        line1View.backgroundColor    = k_color_normal_blue
        line1View.layer.cornerRadius = 2
        return line1View
    }()
    
    lazy var uploadIngBtn: UIButton = {
        let uploadIngBtn = UIButton()
        uploadIngBtn.setTitle("上传中", for: .normal)
        uploadIngBtn.setTitleColor(k_color_title_blue, for: .selected)
        uploadIngBtn.setTitleColor(k_color_black, for: .normal)
        uploadIngBtn.titleLabel?.font = k_font_title_16
        uploadIngBtn.addTarget(self, action: #selector(uploadIngBtnClick), for: .touchUpInside)
        return uploadIngBtn
    }()
    
    lazy private var line2View: UIView = {
        let line2View = UIView()
        line2View.setSize(size: CGSize.init(width: 30, height: 4))
        line2View.backgroundColor    = k_color_title_blue
        line2View.layer.cornerRadius = 2
        return line2View
    }()
    
    var callBack: ((SQCloudDetailChooseView) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(uploadedBtn)
        addSubview(uploadIngBtn)
        addSubview(line1View)
        addSubview(line2View)
        uploadedBtn.isSelected = true
        updateSelBtn()
        addLayout()
    }
    
    private func addLayout() {
        
        uploadedBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.left.equalTo(snp.left)
            maker.right.equalTo(uploadIngBtn.snp.left)
            maker.width.equalTo(uploadIngBtn.snp.width)
            maker.height.equalTo(50)
        }
        
        uploadIngBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(uploadedBtn.snp.height)
        }
        
        line1View.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(uploadedBtn.snp.centerX)
            maker.top.equalTo(snp.top).offset(40)
            maker.width.equalTo(30)
            maker.height.equalTo(4)
        }
        
        line2View.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(uploadIngBtn.snp.centerX)
            maker.top.equalTo(line1View.snp.top)
            maker.width.equalTo(line1View.snp.width)
            maker.height.equalTo(line1View.snp.height)
        }
    }
    
    func updateSelBtn() {
        line1View.isHidden = uploadIngBtn.isSelected
        line2View.isHidden = uploadedBtn.isSelected
    }
    
    @objc private func uploadedBtnClick() {
        uploadedBtn.isSelected = true
        uploadIngBtn.isSelected = false
        updateSelBtn()
        if (callBack != nil) {
            callBack!(self)
        }
    }
    
    @objc private func uploadIngBtnClick() {
        uploadedBtn.isSelected  = false
        uploadIngBtn.isSelected = true
        updateSelBtn()
        if (callBack != nil) {
            callBack!(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
