//
//  SQHomeInfoDetailTableFooterView.swift
//  SheQu
//
//  Created by gm on 2019/10/14.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
fileprivate struct SQItemStruct {
    static let btnMargin: CGFloat = 17.5
    static let btnW = (k_screen_width - 40 - btnMargin * 2) / 3
    static let btnH: CGFloat = 35
}
class SQHomeInfoDetailTableFooterView: UIView {
    enum BtnEvent: Int {
        case previous = 1
        case choose   = 2
        case next     = 3
    }
    
    static let pageSize  = 20
    
    static let height: CGFloat = 60
    
    private var  currentPage = 1
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    lazy var smallLineView: UIView = {
        let smallLineView = UIView()
        smallLineView.backgroundColor = k_color_line
        return smallLineView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line_light
        return lineView
    }()
    
    lazy var previousBtn: UIButton = {
        let previousBtn = getBtn()
        previousBtn.tag = SQHomeInfoDetailTableFooterView.BtnEvent.previous.rawValue
        previousBtn.setTitle("上一页", for: .normal)
        appendBoard(previousBtn)
        return previousBtn
    }()
    
    lazy var chooseBtn: UIButton = {
        let chooseBtn = getBtn()
        chooseBtn.tag = SQHomeInfoDetailTableFooterView.BtnEvent.choose.rawValue
        appendBoard(chooseBtn)
        return chooseBtn
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = getBtn()
        nextBtn.tag = SQHomeInfoDetailTableFooterView.BtnEvent.next.rawValue
        nextBtn.setTitle("下一页", for: .normal)
        appendBoard(nextBtn)
        return nextBtn
    }()
    
    private lazy var totalePage = 1
    var callBack: ((_ currentPage:Int,_ size: Int) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(smallLineView)
        addSubview(contentView)
        addSubview(lineView)
        
        contentView.addSubview(previousBtn)
        contentView.addSubview(chooseBtn)
        contentView.addSubview(nextBtn)
        addLayout()
    }
    
    private func getBtn() -> UIButton {
        
        let btn = UIButton()
        btn.setSize(size: CGSize.init(
            width: SQItemStruct.btnW,
            height: SQItemStruct.btnH)
        )
        
        btn.setTitleColor(k_color_title_light_gray_3, for: .disabled)
        btn.setTitleColor(k_color_normal_blue, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = k_font_title
        btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        return btn
    }
    
    @objc private func btnClick(_ btn: UIButton) {
        let event = SQHomeInfoDetailTableFooterView.BtnEvent.init(rawValue: btn.tag) ?? .previous
        
        switch event {
        case .previous:
            currentPage -= 1
        case .choose:
           weak var weakSelf = self
           SQShowPagePickView.sharedInstance.showPagePickView(
           currentPage, totalePage) { (currentPage) in
            ///如果是同一个 则不刷新
            if currentPage == weakSelf?.currentPage ?? 0 {
                return
            }
              weakSelf?.currentPage = currentPage
              weakSelf?.handlerCurrentPage()
            }
            
            return
        case .next:
            currentPage += 1
        }
        
        handlerCurrentPage()
    }
    
    private func handlerCurrentPage() {
        if callBack == nil {
            return
        }
        
        callBack!(currentPage,
                  SQHomeInfoDetailTableFooterView.pageSize)
        update(currentPage: currentPage, totalNum: totalePage * SQHomeInfoDetailTableFooterView.pageSize)
    }
    
    
    /// 更新当前选中分页 以及总分页数
    /// - Parameter currentPage: 当前选中分页
    /// - Parameter totalNum: 总分页数
    func update(currentPage: Int?, totalNum: Int) {
        if totalNum == 0 {
            return
        }
        
        self.currentPage = currentPage ?? 1
        previousBtn.isEnabled = currentPage != 1
        
        
        var page = Int(totalNum / SQHomeInfoDetailTableFooterView.pageSize)
        if totalNum % SQHomeInfoDetailTableFooterView.pageSize > 0 {
            page += 1
        }
        
        self.totalePage = page
        
        let chooseTitle = "\(self.currentPage) / \(page)"
        chooseBtn.isEnabled = page != 1
        
        var imageName = "sq_inverted_triangle_gray"
        var titleColor = k_color_title_light_gray_3
        if chooseBtn.isEnabled {
            imageName = "sq_inverted_triangle_blue"
            titleColor = k_color_normal_blue
        }
        
        let chooseTitleAtt = chooseTitle.stringAppendImage(textColor: titleColor, font: k_font_title, imageName: imageName, isFront: false, margin: " ", offsetY: 2)
        
        chooseBtn.setAttributedTitle(chooseTitleAtt, for: .normal)
        
        nextBtn.isEnabled = page != currentPage
        
        appendBoard(previousBtn)
        appendBoard(chooseBtn)
        appendBoard(nextBtn)
    }
    
    
    
    private func appendBoard(_ btn: UIButton) {
        btn.layer.cornerRadius = k_corner_radiu
        btn.layer.borderWidth  = k_corner_boder_width
        if !btn.isEnabled {
            btn.layer.borderColor = k_color_title_light_gray_3.cgColor
        }else {
            btn.layer.borderColor = k_color_normal_blue.cgColor
        }
    }
    
    private func addLayout() {
        
        smallLineView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(k_line_height)
        }
        
        contentView.snp.makeConstraints { (maker) in
            maker.top.equalTo(smallLineView.snp.bottom)
            maker.left.equalTo(snp.left).offset(20)
            maker.right.equalTo(snp.right).offset(-20)
            maker.bottom.equalTo(lineView.snp.top)
        }
        
        previousBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView.snp.centerY)
            maker.left.equalTo(contentView.snp.left)
            maker.width.equalTo(SQItemStruct.btnW)
            maker.height.equalTo(SQItemStruct.btnH)
        }
        
        chooseBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView.snp.centerY)
            maker.width.equalTo(SQItemStruct.btnW)
            maker.height.equalTo(SQItemStruct.btnH)
            maker.left.equalTo(previousBtn.snp.right)
            .offset(SQItemStruct.btnMargin)
        }
        
        nextBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView.snp.centerY)
            maker.width.equalTo(SQItemStruct.btnW)
            maker.height.equalTo(SQItemStruct.btnH)
            maker.left.equalTo(chooseBtn.snp.right)
            .offset(SQItemStruct.btnMargin)
        }
        
        lineView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(snp.bottom)
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(k_line_height_big)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

