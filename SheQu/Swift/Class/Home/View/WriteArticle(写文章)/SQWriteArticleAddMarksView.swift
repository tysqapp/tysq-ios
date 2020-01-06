//
//  SQWriteArticleAddMarksView.swift
//  SheQu
//
//  Created by gm on 2019/5/7.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQWriteArticleAddMarksView: UIView {
    static let defaultHeight: CGFloat = 110
    lazy var titlesArrayM = [SQLabelInfoModel]()
    var laskMarksView: SQMarksView?
    
//    lazy var titleLabel: UILabel = {
//        let titleLabel       = UILabel.init()
//        titleLabel.font      = k_font_title_weight_16
//        titleLabel.textColor = k_color_black
//        titleLabel.text      = "添加标签"
//        return titleLabel
//    }()
    
//    lazy var cancelBtn: UIButton = {
//        let cancelBtn = UIButton()
//        cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
//        return cancelBtn
//    }()
    
//    lazy var saveBtn: UIButton = {
//        let saveBtn = UIButton()
//        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
//        saveBtn.setTitle("确定", for: .normal)
//        saveBtn.setTitleColor(k_color_normal_blue, for: .normal)
//        return saveBtn
//    }()
    
    lazy var line1View: UIView = {
        let line1View = UIView()
        line1View.backgroundColor = k_color_line_light
        return line1View
    }()
    
    lazy var addedLabel: UILabel = {
        let addedLabel = UILabel()
        addedLabel.font      = k_font_title_16_weight
        addedLabel.textColor = k_color_black
        addedLabel.text      = "已添加"
        return addedLabel
    }()
    
    lazy var tipsLabel: UILabel = {
        let tipsLabel       = UILabel()
        tipsLabel.text      = "最多可添加6个标签"
        tipsLabel.textColor = k_color_title_black
        tipsLabel.font      = UIFont.systemFont(ofSize: 11)
        return tipsLabel
    }()
    
    lazy var marksView: UIView = {
        let marksView = UIView()
        //marksView.backgroundColor = UIColor.red
        return marksView
    }()
    
    lazy var line2View: UIView = {
        let line2View = UIView()
        line2View.backgroundColor = k_color_line_light
        return line2View
    }()
    
//    lazy var textEditView: UIView = {
//        let textEditView = UIView()
//        return textEditView
//    }()
//
//    lazy var editTF: UITextField = {
//        let editTF = UITextField()
//        editTF.backgroundColor = UIColor.colorRGB(0xf5f5f5)
//        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 30))
//        leftView.backgroundColor = UIColor.colorRGB(0xf5f5f5)
//       let leftV = UIView(frame: CGRect.init(x: 0, y: 0, width: 20, height: 30))
//       leftV.addSubView(leftView)
//        editTF.leftView = leftV
//        editTF.leftViewMode = .always
//        editTF.attributedPlaceholder = NSAttributedString.init(string: "输入标签", attributes: [NSAttributedString.Key.foregroundColor: k_color_title_gray,NSAttributedString.Key.font: k_font_title])
//        return editTF
//    }()
//
//    lazy var addBtn: UIButton = {
//        let addBtn = UIButton()
//        addBtn.setTitle("添加", for: .normal)
//        addBtn.setTitleColor(UIColor.white, for: .normal)
//        addBtn.backgroundColor = k_color_normal_blue
//        addBtn.addTarget(self, action: #selector(addBtnClick), for: .touchUpInside)
//        return addBtn
//    }()
//
//    lazy var coverView: UIView = {
//        let coverView = UIView()
//        coverView.backgroundColor = UIColor.black
//        coverView.alpha           = 0.7
//        return coverView
//    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
       // contentView.backgroundColor = UIColor.black
        return contentView
    }()
    
    var callBack: ((SQLabelInfoModel) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //addSubview(coverView)
        addSubview(contentView)
        //contentView.addSubview(titleLabel)
//        contentView.addSubview(saveBtn)
//        contentView.addSubview(cancelBtn)
        contentView.addSubview(line1View)
        contentView.addSubview(line2View)
       // contentView.addSubview(textEditView)
        contentView.addSubview(tipsLabel)
        contentView.addSubview(addedLabel)
        contentView.addSubview(marksView)
        //textEditView.addSubview(addBtn)
        //textEditView.addSubview(editTF)
        addLayout()
    }
    
    func addLayout() {
        let margin: CGFloat   = 20
        let marginNG: CGFloat = -20
        //let btnWH: CGFloat    = 40
        
//        coverView.snp.makeConstraints { (maker) in
//            maker.top.equalTo(self.snp.top)
//            maker.left.equalTo(self.snp.left)
//            maker.right.equalTo(self.snp.right)
//            maker.bottom.equalTo(self.snp.bottom)
//        }
        
        contentView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(self.snp.bottom)
            maker.left.equalTo(self.snp.left)
            maker.right.equalTo(self.snp.right)
            maker.top.equalTo(snp.top)
        }
        
//        titleLabel.snp.makeConstraints { (maker) in
//            maker.centerX.equalTo(contentView.snp.centerX)
//            maker.top.equalTo(contentView.snp.top)
//            maker.height.equalTo(45)
//        }
        
//        cancelBtn.snp.makeConstraints { (maker) in
//            maker.left.equalTo(contentView.snp.left).offset(margin)
//            maker.width.equalTo(btnWH)
//            maker.height.equalTo(btnWH)
//            maker.centerY.equalTo(titleLabel.snp.centerY)
//        }
//
//        saveBtn.snp.makeConstraints { (maker) in
//            maker.right.equalTo(contentView.snp.right).offset(marginNG)
//            maker.width.equalTo(btnWH)
//            maker.height.equalTo(btnWH)
//            maker.centerY.equalTo(titleLabel.snp.centerY)
//        }
        
        line1View.snp.makeConstraints { (maker) in
            maker.right.equalTo(contentView.snp.right)
            maker.left.equalTo(contentView.snp.left)
            maker.top.equalTo(contentView.snp.top)
            maker.height.equalTo(0.7)
        }
        
        addedLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(line1View.snp.bottom).offset(10)
            maker.left.equalTo(contentView.snp.left).offset(margin)
            maker.height.equalTo(20)
        }
        
        tipsLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(addedLabel.snp.bottom).offset(7.5)
            maker.left.equalTo(addedLabel.snp.left)
            maker.height.equalTo(20)
        }
        
//        textEditView.snp.makeConstraints { (maker) in
//            maker.bottom.equalTo(contentView.snp.bottom).offset(k_bottom_h * -1)
//            maker.height.equalTo(50)
//            maker.left.equalTo(contentView.snp.left)
//            maker.right.equalTo(contentView.snp.right)
//        }
        
        line2View.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(contentView.snp.bottom).offset(-10)
            maker.height.equalTo(10)
            maker.left.equalTo(contentView.snp.left)
            maker.right.equalTo(contentView.snp.right)
        }
        
        marksView.snp.makeConstraints { (maker) in
            maker.top.equalTo(tipsLabel.snp.bottom).offset(20)
            maker.bottom.equalTo(line2View.snp.top)
            maker.left.equalTo(tipsLabel.snp.left)
            maker.right.equalTo(contentView.snp.right).offset(marginNG)
        }
        
//        addBtn.snp.makeConstraints { (maker) in
//            maker.right.equalTo(textEditView.snp.right).offset(marginNG)
//            maker.height.equalTo(30)
//            maker.width.equalTo(50)
//            maker.centerY.equalTo(textEditView.snp.centerY)
//        }
        
//        editTF.snp.makeConstraints { (maker) in
//            maker.left.equalTo(textEditView.snp.left).offset(margin)
//            maker.height.equalTo(30)
//            maker.right.equalTo(addBtn.snp.left).offset(-15)
//            maker.centerY.equalTo(textEditView.snp.centerY)
//        }
        
//        editTF.layer.cornerRadius = 2
//        addBtn.layer.cornerRadius = 2
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func show(_ titleArrayM: [SQLabelInfoModel]){
        UIApplication.shared.keyWindow?.addSubview(self)
        titlesArrayM = titleArrayM
        initMarksView()
    }
    
    func hidden(){
        self.removeFromSuperview()
    }
}


// MARK: -------------objc method -------------
extension SQWriteArticleAddMarksView{
    
    @objc func cancelBtnClick() {
        hidden()
    }
    
    @objc func saveBtnClick() {
        hidden()
//        if callBack != nil {
//            callBack!(titlesArrayM)
//        }
    }
    
//    @objc func addBtnClick() {
//        if editTF.text!.count < 1 {
//            return
//        }
//        
//        if titlesArrayM.count >= 6 {
//            return
//        }
//        getMarksSubView(editTF.text!)
//        editTF.text = ""
//    }
    
    
    func getMarksSubView(_ infoModel: SQLabelInfoModel) {
        
        var  maxX: CGFloat = 0
        var  minY: CGFloat = 0
        if (laskMarksView != nil) {
            maxX = laskMarksView!.maxX() + 20
            minY = laskMarksView!.top()
        }
        
        let title      = infoModel.label_name
        let height     = SQMarksView.viewH
        let titleW     = title.calcuateLabSizeWidth(font: SQMarksView.font, maxHeight: height)
        let marksViewW = titleW + SQMarksView.normal_width
        let totleWidth = maxX + marksViewW
        if totleWidth > k_screen_width - 40 {
            minY = minY + height + 10
            maxX = 0
        }
        
        let marksSubView = SQMarksView.init(frame: CGRect.init(x: maxX, y: minY, width: marksViewW, height: height), title: title)
        
        weak var weakSelf = self
        marksSubView.callBack = { markString in
           weakSelf!.titlesArrayM.removeAll(where: {$0.label_name == markString})
           weakSelf!.initMarksView()
            if weakSelf!.callBack != nil {
                weakSelf!.callBack!(infoModel)
            }
        }
        
        laskMarksView = marksSubView
        titlesArrayM.append(infoModel)
        marksView.addSubview(marksSubView)
        updateFrame()
    }
    
    func updateFrame() {
        let maxHeight = SQWriteArticleAddMarksView.defaultHeight + (laskMarksView?.maxY() ?? 0)!
        if self.height() != maxHeight {
            self.setHeight(height: maxHeight)
        }
    }
    
    func initMarksView(){
        laskMarksView = nil
        for subView in marksView.subviews {
            subView.removeFromSuperview()
        }
        
        let tempArray = titlesArrayM
        titlesArrayM.removeAll()
        for mark in tempArray {
            getMarksSubView(mark)
        }
    }
}
