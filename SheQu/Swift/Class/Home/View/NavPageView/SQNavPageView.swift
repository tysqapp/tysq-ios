//
//  SQNavPageView.swift
//  SheQu
//
//  Created by gm on 2019/4/25.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
import SnapKit
public enum SQNavPageViewClickState{
     case menu
     case edit
}
typealias SQNavPageViewClickCallBack = ((SQNavPageViewClickState, [SQHomeCategoryInfo]?) -> ())
class SQNavPageView: SQView {
    
    static let rightMargin: CGFloat = -15
    static let leftMargin: CGFloat  = 20
    static let btnW: CGFloat    = 20
    static let btnH: CGFloat    = 20
    var callBack: Level1SelCallBack?
    var navPageViewClickCallBack: SQNavPageViewClickCallBack?
    lazy var titlesCollectionView: SQHomeTitleScrollView = {
        let titlesCollectionView = SQHomeTitleScrollView()
        return titlesCollectionView
    }()
    
    lazy var editBtn: UIButton = {
        let editBtn = UIButton()
        editBtn.setImage(UIImage.init(named: "home_edit"), for: .normal)
        editBtn.addTarget(self, action: #selector(editBtnClick), for: .touchUpInside)
        return editBtn
    }()
    
    lazy var menuBtn: UIButton = {
        let menuBtn = UIButton()
        menuBtn.setImage(UIImage.init(named:"home_menu"), for: .normal)
        menuBtn.addTarget(self, action: #selector(menuBtnClick), for: .touchUpInside)
        return menuBtn
    }()
    
    var titleArray: [SQHomeCategoryInfo]? {
        didSet{
          titlesCollectionView.titleArray = titleArray
        }
    }
    
    @objc func editBtnClick() {
        if navPageViewClickCallBack != nil {
            navPageViewClickCallBack!(.edit, titleArray)
        }
    }
    
    @objc func menuBtnClick() {
        if navPageViewClickCallBack != nil {
            navPageViewClickCallBack!(.menu, titleArray)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(editBtn)
        addSubview(menuBtn)
        addSubview(titlesCollectionView)
        addLayout()
        //一级分类点击选中回掉
        weak var weakSelf = self
        titlesCollectionView.callBack = {(index, modelArray) in
            if weakSelf!.callBack != nil {
               weakSelf!.callBack!(index, modelArray)
            }
        }
    }
    
    func addLayout() {
       
        editBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(snp.right)
            .offset(SQNavPageView.rightMargin)
            maker.width.equalTo(SQNavPageView.btnW)
            maker.height.equalTo(SQNavPageView.btnH)
            maker.centerY.equalTo(snp.centerY)
        }
        
        menuBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(editBtn.snp.left)
                .offset(SQNavPageView.rightMargin)
            maker.width.equalTo(SQNavPageView.btnW)
            maker.height.equalTo(SQNavPageView.btnH)
            maker.centerY.equalTo(snp.centerY)
        }
        
        titlesCollectionView.snp.makeConstraints { (maker) in
            maker.right.equalTo(menuBtn.snp.left).offset(-20)
            maker.left.equalTo(snp.left)
                .offset(SQNavPageView.leftMargin)
            maker.height.equalTo(SQHomeTitleScrollView.viewH)
            maker.centerY.equalTo(snp.centerY)
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
