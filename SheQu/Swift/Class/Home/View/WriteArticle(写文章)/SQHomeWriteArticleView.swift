//
//  SQHomeWriteArticleView.swift
//  SheQu
//
//  Created by gm on 2019/5/6.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQHomeWriteArticleView: UIView {
    static let  defaultHeight: CGFloat = k_screen_height - k_nav_height - k_bottom_h
    var model: [SQHomeCategoryInfo]?
    var heightCallBack:((CGFloat) ->())?
    var btnClickCallBack:((Int) -> ())?
    var categoryClickCallBack:((Bool) -> ())?
    var textViewH: CGFloat = 200
    lazy var chooseCategoryView: SQChooseCategoryView = {
        let chooseCategoryView = SQChooseCategoryView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: k_screen_height))
        chooseCategoryView.layoutSubviews()
        return chooseCategoryView
    }()
    
    lazy var writeArticleAddMarksView: SQWriteArticleAddMarksView = {
        let writeArticleAddMarksView = SQWriteArticleAddMarksView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: k_screen_height))
        writeArticleAddMarksView.layoutSubviews()
        return writeArticleAddMarksView
    }()
    lazy var titlesArrayM = [SQLabelInfoModel]()
    var laskMarksView: SQMarksView?
    
    
    /// 输入标题tf
    lazy var titleTF: UITextField = {
        let titleTF = UITextField()
        titleTF.placeholder = "请输入标题"
        let attributedDict  = [
        NSAttributedString.Key.foregroundColor:k_color_title_gray_blue,
        NSAttributedString.Key.font: k_font_title_16
        ]
        
        titleTF.attributedPlaceholder = NSAttributedString.init(
            string:"请输入标题",
            attributes: attributedDict
        )
        
        titleTF.font = k_font_title_16_weight
        titleTF.textColor = k_color_black
        return titleTF
    }()
    
    
    /// 选择分类tf
    lazy var chooseCategoryTF: UITextField = {
        let chooseCategoryTF  = UITextField()
        chooseCategoryTF.placeholder = "选择分类"
        let attributeDict = [
        NSAttributedString.Key.foregroundColor:k_color_title_gray_blue,
        NSAttributedString.Key.font: k_font_title_weight
        ]
        
        chooseCategoryTF.attributedPlaceholder = NSAttributedString.init(
            string:"选择分类",
            attributes: attributeDict
        )
        
        chooseCategoryTF.leftView      = getTFView("home_ac_category")
        chooseCategoryTF.rightView     = getTFView("home_ac_inside",true)
        chooseCategoryTF.leftViewMode  = .always
        chooseCategoryTF.rightViewMode = .always
        return chooseCategoryTF
    }()
    
    ///遮盖chooseCategoryTF 并处理点击事件
    lazy var chooseCategoryBtn: UIButton = {
        let chooseCategoryBtn = UIButton()
        chooseCategoryBtn.addTarget(self, action: #selector(chooseCategoryBtnClick), for: .touchUpInside)
        chooseCategoryBtn.backgroundColor = UIColor.clear
        return chooseCategoryBtn
    }()
    
    lazy var addMarksViewTF: UITextField = {
        let addMarksViewTF = UITextField()
        let attributeDict = [
        NSAttributedString.Key.foregroundColor:k_color_title_gray_blue,
        NSAttributedString.Key.font: k_font_title_weight
        ]
        
        addMarksViewTF.attributedPlaceholder = NSAttributedString.init(
            string:"添加标签",
            attributes: attributeDict
        )
        
        addMarksViewTF.leftView = getTFView("home_ac_mark")
        addMarksViewTF.rightView = getTFView("home_ac_inside",true)
        addMarksViewTF.leftViewMode = .always
        addMarksViewTF.rightViewMode = .always
        return addMarksViewTF
    }()
    
    lazy var addMarksViewBtn: UIButton = {
        let addMarksViewBtn = UIButton()
        addMarksViewBtn.addTarget(self, action: #selector(addMarksViewBtnClick), for: .touchUpInside)
        chooseCategoryBtn.backgroundColor = UIColor.clear
        return addMarksViewBtn
    }()
    
    ///添加markView
    lazy var addMarksView: UIView = {
        let addMarksView = UIView()
        return addMarksView
    }()
    
    lazy var line1View: UIView = {
        let line1View = UIView()
        line1View.backgroundColor = k_color_line
        return line1View
    }()
    
    lazy var line2View: UIView = {
        let line2View = UIView()
        line2View.backgroundColor = k_color_line
        return line2View
    }()
    
    lazy var line3View: UIView = {
        let line3View = UIView()
        line3View.backgroundColor = k_color_line
        return line3View
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleTF)
        addSubview(line1View)
        addSubview(chooseCategoryTF)
        addSubview(line2View)
        addSubview(addMarksView)
        addSubview(line3View)
        addSubview(chooseCategoryBtn)
        addSubview(addMarksViewTF)
        addSubview(addMarksViewBtn)
        addLayout()
        addCallBack()
    }
    
    func addLayout() {
        let margin: CGFloat   = 20
        let marginNG: CGFloat = -20
        let viewH: CGFloat    = 50
        
        titleTF.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.snp.top)
            maker.left.equalTo(self.snp.left).offset(margin)
            maker.right.equalTo(self.snp.right).offset(marginNG)
            maker.height.equalTo(viewH)
        }
        
        line1View.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleTF.snp.bottom)
            maker.left.equalTo(titleTF.snp.left)
            maker.right.equalTo(titleTF.snp.right)
            maker.height.equalTo(k_line_height)
        }
        
        chooseCategoryTF.snp.makeConstraints { (maker) in
            maker.top.equalTo(line1View.snp.bottom)
            maker.left.equalTo(titleTF.snp.left)
            maker.right.equalTo(titleTF.snp.right)
            maker.height.equalTo(viewH)
        }
        
        chooseCategoryBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(chooseCategoryTF.snp.top)
            maker.left.equalTo(chooseCategoryTF.snp.left)
            maker.right.equalTo(chooseCategoryTF.snp.right)
            maker.height.equalTo(chooseCategoryTF.snp.height)
        }
        
        line2View.snp.makeConstraints { (maker) in
            maker.top.equalTo(chooseCategoryTF.snp.bottom)
            maker.left.equalTo(titleTF.snp.left)
            maker.right.equalTo(titleTF.snp.right)
            maker.height.equalTo(k_line_height)
        }
        
        addMarksViewTF.snp.makeConstraints { (maker) in
            maker.top.equalTo(line2View.snp.bottom)
            maker.left.equalTo(titleTF.snp.left)
            maker.right.equalTo(titleTF.snp.right)
            maker.height.equalTo(viewH)
        }
        
        addMarksViewBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(addMarksViewTF.snp.top)
            maker.left.equalTo(addMarksViewTF.snp.left)
            maker.right.equalTo(addMarksViewTF.snp.right)
            maker.height.equalTo(addMarksViewTF.snp.height)
        }
        
        addMarksView.snp.makeConstraints { (maker) in
            maker.top.equalTo(addMarksViewTF.snp.bottom)
            maker.left.equalTo(titleTF.snp.left)
            maker.right.equalTo(titleTF.snp.right)
            maker.height.equalTo(0)
        }
        
        line3View.snp.makeConstraints { (maker) in
            maker.top.equalTo(addMarksView.snp.bottom)
            maker.left.equalTo(titleTF.snp.left)
            maker.right.equalTo(titleTF.snp.right)
            maker.height.equalTo(k_line_height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SQHomeWriteArticleView {
    
    func addCallBack() {
        weak var weakSelf = self
        
        let attr = [NSAttributedString.Key.font: k_font_title, NSAttributedString.Key.foregroundColor: k_color_black]
        
        chooseCategoryView.callBack = { (categoryInfoModel,categorySubInfoModel) in
            let attributeText = NSMutableAttributedString.init(string: categoryInfoModel.name, attributes: attr)
            if (categorySubInfoModel != nil) {
               let attMid = NSAttributedString.init(string: "  ▶  ", attributes: [NSAttributedString.Key.font : k_font_title_11,NSAttributedString.Key.foregroundColor: k_color_title_gray_blue])
               attributeText.append(attMid)
               let subAttStr = NSAttributedString.init(string: "\(categorySubInfoModel!.name)", attributes: attr)
               attributeText.append(subAttStr)
            }
            
            weakSelf!.chooseCategoryTF.attributedText = attributeText
            if weakSelf!.categoryClickCallBack != nil {
                weakSelf!.categoryClickCallBack!(true)
            }
        }
        
    }
    
}

extension SQHomeWriteArticleView {
    
    @objc func chooseCategoryBtnClick() {
        UIApplication.shared.keyWindow?.endEditing(true)
        titleTF.endEditing(true)
        chooseCategoryView.showChooseCategoryView()
        chooseCategoryView.model = model
    }
    
    @objc func addMarksViewBtnClick() {
        UIApplication.shared.keyWindow?.endEditing(true)
        titleTF.endEditing(true)
        if btnClickCallBack != nil {
            btnClickCallBack!(1)
        }
        //writeArticleAddMarksView.show(titlesArrayM)
        
//         weak var weakSelf = self
//        writeArticleAddMarksView.callBack = { titleArray in
//            weakSelf?.titlesArrayM = titleArray
//            weakSelf?.initMarksView()
//            weakSelf!.addMarksView.snp.updateConstraints({ (maker) in
//                let maxHeight: CGFloat = weakSelf!.laskMarksView?.maxY() ?? -10
//                maker.height.equalTo(maxHeight + 10)
//            })
//
//            super.updateConstraints()
//        }
    }
    
    func getMarksSubView(_ infoModel: SQLabelInfoModel) {
        var  maxX: CGFloat = 0
        var  minY: CGFloat = 0
        if (laskMarksView != nil) {
            maxX = laskMarksView!.maxX() + 20
            minY = laskMarksView!.top()
        }
        let title  = infoModel.label_name
        let height = SQMarksView.viewH
        let titleW = title.calcuateLabSizeWidth(font: SQMarksView.font, maxHeight: height)
        let marksViewW = titleW + SQMarksView.normal_width
        if maxX + marksViewW > k_screen_width - 40 {
            minY = minY + height + 10
            maxX = 0
        }
        
        let marksSubView  = SQMarksView.init(frame: CGRect.init(x: maxX, y: minY, width: marksViewW, height: height), title: title)
        
        weak var weakSelf = self
        marksSubView.callBack = { markString in
            weakSelf!.titlesArrayM.removeAll(where: {$0.label_name == markString})
            weakSelf!.initMarksView()
            let maxHeight: CGFloat = weakSelf!.laskMarksView?.maxY() ?? -10
            weakSelf!.addMarksView.snp.updateConstraints({ (maker) in
                maker.height.equalTo(maxHeight + 10)
            })
            weakSelf!.addMarksView.updateConstraintsIfNeeded()
            weakSelf!.addMarksView.setHeight(height: maxHeight + 10)
            
            super.updateConstraints()
            if ((weakSelf?.heightCallBack) != nil) {
                weakSelf!.heightCallBack!(weakSelf!.addMarksView.maxY() + 1)
            }
        }
        
        laskMarksView = marksSubView
        titlesArrayM.append(infoModel)
        addMarksView.addSubview(marksSubView)
    }
    
    func initMarksView(){
        laskMarksView = nil
        for subView in addMarksView.subviews {
            subView.removeFromSuperview()
        }
        
        let tempArray = titlesArrayM
        titlesArrayM.removeAll()
        for mark in tempArray {
           getMarksSubView(mark)
        }
        
        let maxHeight: CGFloat = laskMarksView?.maxY() ?? -10
        addMarksView.snp.updateConstraints({ (maker) in
            
            maker.height.equalTo(maxHeight + 10)
        })
        addMarksView.updateConstraintsIfNeeded()
        
        addMarksView.setHeight(height: maxHeight + 10)
        super.updateConstraints()
        
        if (heightCallBack != nil) {
            heightCallBack!(addMarksView.maxY() + 1)
        }
    }
    
    func getTFView(_ imageName: String,_ isRight: Bool = false) -> UIView{
        
        guard let image = UIImage.init(named: imageName) else {
            return UIView()
        }
        
        let imageViewW: CGFloat = image.size.width
        let imageViewX: CGFloat = isRight ? 30 - imageViewW : 0
        let imageView = UIImageView.init(frame: CGRect.init(x: imageViewX, y: 0, width: imageViewW, height: 50))
        imageView.image = image
        imageView.contentMode = .center
        
        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 50))
        leftView.addSubview(imageView)
        return leftView
    }
}

//MARK: -------- 准备发布文章数据 ----------------
extension SQHomeWriteArticleView {
    
    func getCategory_id() -> UInt64 {
        return chooseCategoryView.getSelCategory_id()
    }
    
    
    func getLabelArray() -> [NSNumber] {
        var labelsArray = [NSNumber]()
        for modle in titlesArrayM {
            labelsArray.append(NSNumber.init(value: modle.label_id))
        }
        return labelsArray
    }
}
