//
//  SQForbinCommentTableHeaderView.swift
//  SheQu
//
//  Created by gm on 2019/9/2.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQForbinCommentTableHeaderView: UITableViewHeaderFooterView {
    
    static let cellID = "SQForbinCommentTableHeaderViewCellID"
    
    var forbinCommentViewEventCallBack: ((UIButton, SQForbinCommentView.Event) -> ())?
    
    lazy var forbinCommentView: SQForbinCommentView = {
        let forbinCommentView = SQForbinCommentView()
        weak var weakSelf = self
        forbinCommentView.forbinCommentViewEventCallBack = { (btn,event) in
            if ((weakSelf?.forbinCommentViewEventCallBack) != nil) {
                weakSelf!.forbinCommentViewEventCallBack!(btn,event)
            }
        }
        
        forbinCommentView.titleLabel.font = k_font_title_weight
        forbinCommentView.titleLabel.textColor = k_color_title_black
        return forbinCommentView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.clear
        return lineView
    }()

    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(forbinCommentView)
        addSubview(lineView)
        backgroundColor = UIColor.white
        forbinCommentView.unwindBtn.isHidden = false
        addLayout()
    }
    
    private func addLayout() {
        forbinCommentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.top.equalTo(snp.top)
            maker.bottom.equalTo(snp.bottom)
        }
        
        lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left).offset(20)
            maker.height.equalTo(k_line_height)
            maker.right.equalTo(snp.right)
            maker.bottom.equalTo(snp.bottom)
        }
    }
    
    var itemModel: SQModeratorCategoryItemModel? {
        didSet {
            if  (itemModel == nil) {
                return
            }
            
            if !itemModel!.isUnwind {
                lineView.isHidden = true
            }else{
                lineView.isHidden = itemModel!.sub_category.count == 0
            }
            
            if itemModel!.sub_category.count == 0 {
                forbinCommentView.unwindBtn.isHidden = true
            }else{
                forbinCommentView.unwindBtn.isHidden = false
            }
            forbinCommentView.chooseBtn.isSelected = itemModel!.isSel
            forbinCommentView.unwindBtn.isSelected = itemModel!.isUnwind
            forbinCommentView.titleLabel.text      = itemModel!.category_name
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SQForbinCommentTableFooterView: UITableViewHeaderFooterView {
    static let cellID = "SQForbinCommentTableFooterViewCellID"
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.clear
        return lineView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.red
        addSubview(lineView)
    }
    
    private func addLayout() {
        lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.top.equalTo(snp.top)
            maker.bottom.equalTo(snp.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
