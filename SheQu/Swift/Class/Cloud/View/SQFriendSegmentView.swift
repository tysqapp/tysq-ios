//
//  SQFriendSegmentView.swift
//  SheQu
//
//  Created by iMac on 2019/9/24.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQFriendSegmentView: UIView {
    var callBack: ((SQFriendSegmentView) -> ())?
    
    lazy var lineView1: UIView = {
        let view = UIView()
        view.setSize(size: CGSize.init(width: 30, height: 4))
        view.backgroundColor    = k_color_normal_blue
        view.layer.cornerRadius = 3
        return view
    }()
    
    lazy var lineView2: UIView = {
        let view = UIView()
        view.setSize(size: CGSize.init(width: 30, height: 4))
        view.backgroundColor    = k_color_normal_blue
        view.layer.cornerRadius = 3
        return view
    }()
    
    lazy var inviteBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("邀请好友", for: .normal)
        btn.setTitleColor(k_color_title_blue, for: .selected)
        btn.setTitleColor(k_color_black, for: .normal)
        btn.titleLabel?.font = k_font_title_15
        btn.addTarget(self, action: #selector(inviteBtnClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var listBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("好友列表", for: .normal)
        btn.setTitleColor(k_color_title_blue, for: .selected)
        btn.setTitleColor(k_color_black, for: .normal)
        btn.titleLabel?.font = k_font_title_15
        btn.addTarget(self, action: #selector(listBtnClick), for: .touchUpInside)
        return btn
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lineView1)
        addSubview(lineView2)
        addSubview(inviteBtn)
        addSubview(listBtn)
        addLayout()
        inviteBtn.isSelected = true
        updateSelBtn()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLayout() {
        inviteBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top).offset(15)
            maker.left.equalTo(snp.left)
            maker.right.equalTo(listBtn.snp.left).offset(-40)
            maker.width.equalTo(listBtn.snp.width)
            maker.height.equalTo(15)
            maker.width.equalTo(60)
        }
        
        listBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(60)
            maker.top.equalTo(snp.top).offset(15)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(15)
        }
        
        lineView1.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(inviteBtn.snp.centerX)
            maker.top.equalTo(inviteBtn.snp.bottom).offset(5)
            maker.width.equalTo(30)
            maker.height.equalTo(4)
        }
        
        lineView2.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(listBtn.snp.centerX)
            maker.top.equalTo(listBtn.snp.bottom).offset(5)
            maker.width.equalTo(lineView1.snp.width)
            maker.height.equalTo(lineView1.snp.height)
        }
    }
    
    func updateSelBtn() {
        lineView1.isHidden = listBtn.isSelected
        lineView2.isHidden = inviteBtn.isSelected
    }
    @objc private func inviteBtnClick() {
        inviteBtn.isSelected = true
        listBtn.isSelected = false
        updateSelBtn()
        if (callBack != nil) {
            callBack!(self)
        }
    }
    
    @objc private func listBtnClick() {
        inviteBtn.isSelected  = false
        listBtn.isSelected = true
        updateSelBtn()
        if (callBack != nil) {
            callBack!(self)
        }
        
    }
    
}
