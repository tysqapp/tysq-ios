//
//  SQHomeSortTypeView.swift
//  SheQu
//
//  Created by gm on 2019/8/20.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQHomeSortTypeView: UIView {
    
    static let sortTypeViewH: CGFloat = 45
    lazy var selBtn = UIButton()
    var sortCallBack: ((SQArticleSortType) -> ())?
    var searchCallBack: ((SQHomeSortTypeView) -> ())?
    
    lazy var searchBtn: UIButton = {
        let searchBtn = UIButton()
        searchBtn.contentHorizontalAlignment = .right
        searchBtn.titleLabel?.font = k_font_title_12
        searchBtn.setTitle("搜索", for: .normal)
        searchBtn.setImage("sq_home_search".toImage(), for: .normal)
        searchBtn.setTitleColor(k_color_title_blue, for: .normal)
        searchBtn.addTarget(self, action: #selector(searchBtnClick), for: .touchUpInside)
        searchBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 5)
        searchBtn.tag = -1
        return searchBtn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line
        return lineView
    }()
    
    init(frame: CGRect, sortTypeArray: [SQArticleSortType]) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        var tempFrame = CGRect.init(x: 20, y: 0, width: 0, height: 0)
        let btnW: CGFloat = 50
        let btnH: CGFloat = SQHomeSortTypeView.sortTypeViewH
        for index in 0..<sortTypeArray.count {
           let type = sortTypeArray[index]
           let title = getBtnTitle(type)
           let btnX = tempFrame.maxX
           let btn  = UIButton.init(frame: CGRect.init(
            x: btnX,
            y: 0,
            width: btnW,
            height: btnH
           ))
           
           btn.titleLabel?.font = k_font_title
           btn.contentHorizontalAlignment = .left
           btn.setTitle(title, for: .normal)
           btn.setTitle(title, for: .selected)
           btn.setTitleColor(k_color_black, for: .selected)
           btn.setTitleColor(k_color_title_gray_blue, for: .normal)
           btn.tag = type.rawValue
           btn.addTarget(
                self,
                action: #selector(btnClick(btn:)),
                for: .touchUpInside
           )
           tempFrame = btn.frame
            if index == 0 {
                btn.isSelected = true
                selBtn = btn
            }
           
            lineView.frame = CGRect.init(
                x: 0,
                y: SQHomeSortTypeView.sortTypeViewH - k_line_height,
                width: k_screen_width,
                height: k_line_height
            )
            
            let searchBtnW: CGFloat = 60
            let searchBtnX = k_screen_width - searchBtnW - 20
            searchBtn.frame = CGRect.init(
                x: searchBtnX,
                y: 0,
                width: searchBtnW,
                height: btnH
            )
           
           addSubview(btn)
           addSubview(lineView)
           addSubview(searchBtn)
        }
    }
    
    func getBtnTitle(_ sortType: SQArticleSortType) -> String{
        switch sortType {
        case .newest:
            return "最新"
        case .hottest:
            return "热门"
        case .synthesize:
            return "综合"
        }
    }
    
    func updateSelBtn(_ btnTag: Int?) {
        if (btnTag == nil) {
            return
        }
        
        for subView in subviews {
            if subView is UIButton {
                if subView.tag == btnTag {
                    let updateBtn: UIButton = subView as! UIButton
                    selBtn.isSelected = false
                    updateBtn.isSelected = true
                    selBtn = updateBtn
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func btnClick(btn: UIButton) {
        selBtn.isSelected = false
        btn.isSelected = true
        selBtn = btn
        
        if (sortCallBack != nil) {
            sortCallBack!(SQArticleSortType(rawValue: btn.tag)!)
        }
    }
    
    @objc func searchBtnClick() {
        if (searchCallBack != nil) {
            searchCallBack!(self)
        }
    }
}
