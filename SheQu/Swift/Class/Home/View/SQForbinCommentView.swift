//
//  SQForbinCommentView.swift
//  SheQu
//
//  Created by gm on 2019/9/2.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    
    ///chooseBtn
    static let chooseBtnW: CGFloat = 30
    static let chooseBtnH: CGFloat = 30
    
    ///unwindBtn
    static let unwindBtnW: CGFloat = 30
    static let unwindBtnH: CGFloat = 30
}

class SQForbinCommentView: UIView {
    
    enum Event {
        case sel
        case unwind
    }
    
    static let height: CGFloat = 50
    
    /// 选择btn
    lazy var chooseBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "sq_audit_sel"), for: .selected)
        btn.setImage(UIImage.init(named: "sq_audit_unSel"), for: .normal)
        btn.addTarget(self, action: #selector(selBtnClick), for: .touchUpInside)
        return btn
    }()
    
    ///分类名字label
    lazy var titleLabel: UILabel = {
        let titleLable = UILabel()
        return titleLable
    }()
    
    
    /// 展开子页面btn
    lazy var unwindBtn: UIButton = {
        let unwindBtn = UIButton()
        unwindBtn.isHidden = true
        unwindBtn.setImage(UIImage.init(named: "sq_forbin_comment_close"), for: .normal)
        unwindBtn.setImage(UIImage.init(named: "sq_forbin_comment_open"), for: .selected)
        unwindBtn.addTarget(self, action: #selector(unwindBtnClick), for: .touchUpInside)
        return unwindBtn
    }()
    
    var forbinCommentViewEventCallBack: ((UIButton,SQForbinCommentView.Event) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(chooseBtn)
        addSubview(titleLabel)
        addSubview(unwindBtn)
        addLayout()
    }
    
    private func addLayout() {
        chooseBtn.snp.makeConstraints { (maker) in
           maker.left.equalTo(snp.left).offset(20)
           maker.centerY.equalTo(titleLabel.snp.centerY)
           maker.width.equalTo(SQItemStruct.chooseBtnW)
           maker.width.equalTo(SQItemStruct.chooseBtnH)
        }
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(chooseBtn.snp.right).offset(10)
            maker.centerY.equalTo(snp.centerY)
            maker.right.equalTo(unwindBtn.snp.left)
            maker.height.equalTo(chooseBtn.snp.height)
        }
        
        unwindBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(snp.right).offset(-20)
            maker.centerY.equalTo(snp.centerY)
            maker.width.equalTo(SQItemStruct.unwindBtnW)
            maker.width.equalTo(SQItemStruct.unwindBtnH)
        }
    }
    
    @objc func unwindBtnClick() {
        unwindBtn.isSelected = !unwindBtn.isSelected
        if (forbinCommentViewEventCallBack != nil) {
            forbinCommentViewEventCallBack!(unwindBtn,.unwind)
        }
    }
    
    @objc func selBtnClick() {
        chooseBtn.isSelected = !chooseBtn.isSelected
        if (forbinCommentViewEventCallBack != nil) {
            forbinCommentViewEventCallBack!(chooseBtn,.sel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
