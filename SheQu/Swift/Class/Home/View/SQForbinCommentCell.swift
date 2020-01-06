//
//  SQForbinCommentCell.swift
//  SheQu
//
//  Created by gm on 2019/9/2.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQForbinCommentCell: UITableViewCell {

    static let cellID = "SQForbinCommentCellID"
    var forbinCommentViewEventCallBack: ((UIButton, SQForbinCommentView.Event) -> ())?
    lazy var forbinCommentView: SQForbinCommentView = {
        let forbinCommentView = SQForbinCommentView()
        forbinCommentView.titleLabel.textColor = k_color_title_gray
        forbinCommentView.titleLabel.font  = k_font_title
        
        weak var weakSelf = self
        forbinCommentView.forbinCommentViewEventCallBack = { (btn,event) in
            if ((weakSelf?.forbinCommentViewEventCallBack) != nil) {
                weakSelf!.forbinCommentViewEventCallBack!(btn,event)
            }
        }
        return forbinCommentView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(forbinCommentView)
        addLayout()
    }
    
    private func addLayout() {
        forbinCommentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left).offset(20)
            maker.right.equalTo(snp.right)
            maker.top.equalTo(snp.top)
            maker.bottom.equalTo(snp.bottom)
        }
    }
    
    var itemSubModel: SQModeratorSubCategoryItemModel? {
        didSet {
            if  (itemSubModel == nil) {
                return
            }
            
            forbinCommentView.chooseBtn.isSelected = itemSubModel!.isSel
            forbinCommentView.titleLabel.text      = itemSubModel!.category_name
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
