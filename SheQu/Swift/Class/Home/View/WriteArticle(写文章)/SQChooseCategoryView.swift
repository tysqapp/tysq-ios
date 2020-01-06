//
//  SQChooseCategoryView.swift
//  SheQu
//
//  Created by gm on 2019/5/6.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQChooseCategoryView: UIView {
    var model: [SQHomeCategoryInfo]? {
        didSet{
            if (model != nil) {
                let titleArray = model?.reduce([String](), { (titleArray, model) -> [String] in
                    var titleArrayM = titleArray
                    titleArrayM.append(model.name)
                    return titleArrayM
                })
                
                level1TableView.titleArray = titleArray
            }
        }
    }
   
    var callBack:((SQHomeCategoryInfo,SQHomeCategorySubInfo?) -> ())?
    lazy var titleWidth  = "一级分类".calcuateLabSizeWidth(font: k_font_title, maxHeight: 14)
   let chooseCategoryViewH: CGFloat = 350
    let tableViewW: CGFloat     = 100
    lazy var coverView: UIButton = {
        let coverView = UIButton()
        coverView.backgroundColor = UIColor.black
        coverView.alpha = 0.5
        coverView.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        return coverView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = UIColor.white
        contentView.setSize(size: CGSize.init(width: k_screen_width, height: chooseCategoryViewH))
        contentView.addRounded(corners: [.topRight,.topLeft], radii: CGSize.init(width: 9, height: 9), borderWidth: 0.7, borderColor: UIColor.lightGray)
        return contentView
    }()
    
    lazy var level1TableView: SQChooseCategoryTableView = {
        let level1TableView = SQChooseCategoryTableView.init(frame: CGRect.zero, style: .plain)
        return level1TableView
    }()
    
    lazy var level2TableView: SQChooseCategoryTableView = {
        let level2TableView = SQChooseCategoryTableView.init(frame: CGRect.zero, style: .plain)
        return level2TableView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = k_color_black
        titleLabel.text      = "分类选择"
        titleLabel.font      = k_font_title_16_weight
        
        return titleLabel
    }()
    
    lazy var level1Label: UILabel = {
        let level1Label       = UILabel()
        level1Label.tag       = -1
        level1Label.text      = "一级分类"
        level1Label.textColor = k_color_black
        level1Label.font      = k_font_title
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(level1LabelClick))
        level1Label.addGestureRecognizer(tap)
        level1Label.isUserInteractionEnabled = true
        return level1Label
    }()
    
    lazy var level2Label: UILabel = {
        let level2Label = UILabel()
        level2Label.tag = -1
        level2Label.text      = "二级分类"
        level2Label.textColor = k_color_black
        level2Label.font      = k_font_title
        return level2Label
    }()
    
    lazy var blueLineViw: UIView = {
        let blueLineView = UIView()
        blueLineView.backgroundColor = k_color_title_blue
        blueLineView.tag = 1
        return blueLineView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line
        return lineView
    }()
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.contentVerticalAlignment   = .top
        btn.contentHorizontalAlignment = .right
        btn.imageView?.contentMode     = .topRight
        btn.setImage(UIImage.init(named: "home_ac_close_sel"), for: .normal)
        btn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        return btn
    }()
    
    @objc func closeBtnClick(){
        hiddenChooseCategoryView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(coverView)
        addSubview(contentView)
        contentView.addSubview(level1Label)
        contentView.addSubview(level2Label)
        contentView.addSubview(lineView)
        contentView.addSubview(level1TableView)
        contentView.addSubview(level2TableView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(closeBtn)
        contentView.addSubview(blueLineViw)
        addLayout()
        appendCallBack()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addLayout() {
        let margin: CGFloat = 20
        let titleLabelH     = 55
        let tableViewH      = 265
        coverView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.snp.top)
            maker.left.equalTo(self.snp.left)
            maker.right.equalTo(self.snp.right)
            maker.bottom.equalTo(self.snp.bottom)
        }
        
        contentView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(self.snp.bottom)
            maker.left.equalTo(self.snp.left)
            maker.right.equalTo(self.snp.right)
            maker.height.equalTo(chooseCategoryViewH)
        }
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView.snp.top)
            maker.left.equalTo(contentView.snp.left).offset(margin)
            maker.right.equalTo(contentView.snp.right).offset(margin)
            maker.height.equalTo(titleLabelH)
        }
        
        closeBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView.snp.top).offset(margin)
            maker.right.equalTo(contentView.snp.right).offset(margin * -1)
            maker.width.equalTo(40)
            maker.height.equalTo(40)
        }
        
        level1Label.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom)
            maker.left.equalTo(titleLabel.snp.left)
            maker.height.equalTo(30)
            maker.width.equalTo(tableViewW)
        }
        
        
        blueLineViw.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left).offset(20)
            maker.top.equalTo(level1Label.snp.bottom).offset(-2)
            maker.height.equalTo(2)
            maker.width.equalTo(titleWidth)
        }
        
        level2Label.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom)
            maker.left.equalTo(level1Label.snp.right).offset(50)
            maker.height.equalTo(30)
            maker.width.equalTo(tableViewW)
        }
        
        lineView.snp.makeConstraints { (maker) in
            maker.top.equalTo(level2Label.snp.bottom)
            maker.left.equalTo(contentView.snp.left)
            maker.right.equalTo(contentView.snp.right)
            maker.height.equalTo(k_line_height)
        }
        
        level1TableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(lineView.snp.bottom)
            maker.left.equalTo(titleLabel.snp.left)
            maker.width.equalTo(tableViewW)
            maker.height.equalTo(tableViewH)
        }
        
        level2TableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(lineView.snp.bottom)
            maker.left.equalTo(level1TableView.snp.right).offset(50)
            maker.width.equalTo(tableViewW)
            maker.height.equalTo(tableViewH)
        }
    }
    
    func showChooseCategoryView() {
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    func hiddenChooseCategoryView() {
        level1TableView.tag = 0
        level1TableView.selLeve1Index = -1
        level1TableView.selLeve2Index = -1
        updateLeve1()
        removeFromSuperview()
    }
    
    
    /// 获取分类id的规则是 如果有二级分类 则使用二级分类id 反则使用一级分类id
    ///
    /// - Returns: 有效分类id
    func getSelCategory_id() -> UInt64 {
        if model == nil {
            return 0
        }
        
        if level1Label.tag >= model!.count {
            return 0
        }
        
        let categoryModel = model![level1Label.tag]
        if categoryModel.subcategories.count < 1 {
            return UInt64(categoryModel.id)
        }else{
            if level2Label.tag == -1 {
                return UInt64(categoryModel.id)
            }
            let subModel = categoryModel.subcategories[level2Label.tag]
            return UInt64(subModel.id)
        }
    }
    
    @objc func level1LabelClick() {
        blueLineViw.tag     = 1
        level1TableView.tag = 0
        level2Label.tag     = -1
        level1TableView.selLeve2Index = -1
        updateLeve1()
        let titleArray = model?.reduce([String](), { (titleArray, model) -> [String] in
            var titleArrayM = titleArray
            titleArrayM.append(model.name)
            return titleArrayM
        })
        
        level1TableView.titleArray = titleArray
    }
    
    func updateLeve1() {
        let width = level1Label.text!.calcuateLabSizeWidth(font: k_font_title, maxHeight: 14)
        blueLineViw.snp.updateConstraints { (maker) in
            maker.left.equalTo(snp.left).offset(20)
            maker.width.equalTo(width)
        }
        
        level2Label.text = "二级分类"
    }
    
    @objc func level2LabelClick() {
        blueLineViw.tag = 2
        let width = level2Label.text!.calcuateLabSizeWidth(font: k_font_title, maxHeight: 14)
        blueLineViw.snp.updateConstraints { (maker) in
            maker.left.equalTo(snp.left).offset(level2Label.left())
            maker.width.equalTo(width)
        }
    }
}


extension SQChooseCategoryView {
   
   private func appendCallBack(){
    weak var weakSelf = self
    
    
    level1TableView.callBack = { selIndex in
        if (weakSelf!.model == nil) {
            return
        }
        
        if weakSelf!.level1TableView.tag == 0 { ///当为0时 表示是一级view
            let categoryInfo = weakSelf!.model![selIndex]
            weakSelf?.level1Label.text = categoryInfo.name
            weakSelf?.level1Label.tag  = selIndex
            weakSelf?.level2Label.tag  = -1
            weakSelf?.level1TableView.selLeve2Index = -1
            if (weakSelf!.callBack != nil) {
                weakSelf!.callBack!(categoryInfo, nil)
            }
            if categoryInfo.subcategories.count == 0 {
                weakSelf?.level1TableView.selLeve1Index = -1
                weakSelf?.removeFromSuperview()
            }else{
               weakSelf?.level2Label.text = "二级分类"
               weakSelf?.level2LabelClick()
               weakSelf?.level1TableView.tag = 1 //标记为二级分类
                let titleArray = categoryInfo.subcategories.reduce([String](), { (titleArray, model) -> [String] in
                    var titleArrayM = titleArray
                    titleArrayM.append(model.name)
                    return titleArrayM
                })
               weakSelf?.level1TableView.titleArray = titleArray
            }
        }else{
            weakSelf!.updateLeve1()
            weakSelf!.level1TableView.tag = 0
            weakSelf!.level2Label.tag = selIndex
            let categoryInfo = weakSelf!.model![weakSelf!.level1Label.tag]
            let subInfo      = categoryInfo.subcategories[selIndex]
            weakSelf?.level2Label.text = subInfo.name
            if (weakSelf!.callBack != nil) {
                weakSelf?.level1TableView.selLeve1Index = -1
                weakSelf?.level1TableView.selLeve2Index = -1
                weakSelf!.callBack!(categoryInfo, subInfo)
            }
            weakSelf?.removeFromSuperview()
        }
        
//
//        weakSelf!.level2TableView.selIndex = 0
//        weakSelf!.level2TableView.titleArray = categoryInfo.subcategories.reduce([String](), { (titleArray, model) -> [String] in
//            var titleArrayM = titleArray
//            titleArrayM.append(model.name)
//            return titleArrayM
//        })
       
    }
    
//    level2TableView.callBack = { selIndex in
//        let sel1Model = weakSelf!.model![weakSelf!.level1TableView.selIndex]
//        if weakSelf!.callBack != nil {
//            var selIndexTemp = selIndex
//            if selIndex >= sel1Model.subcategories.count {
//                selIndexTemp = 0
//            }
//
//            weakSelf!.callBack!(sel1Model,
//                                sel1Model.subcategories[selIndexTemp])
//        }
//    }
    
   }
}
