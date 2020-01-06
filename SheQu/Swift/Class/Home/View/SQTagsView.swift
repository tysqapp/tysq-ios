//
//  SQTagsView.swift
//  SheQu
//
//  Created by iMac on 2019/9/18.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit



class SQTagsView: UIView {
    ///标签字符串数组
    lazy var tagStringArr = [String]()
    ///tagsView的高度
    lazy var viewHeight: CGFloat = 0
    ///tag的高度
    var btnH: CGFloat = 35
    ///tag的水平间隔
    var btnHMargin: CGFloat = 15
    ///tag的垂直间隔
    var btnVMargin: CGFloat = 15
    ///tag内左右边距
    var btnPadding: CGFloat = 15
    ///第一个tag上边距
    var firstTagLeft: CGFloat = 20
    ///第一个tag左边距
    var firstTagTop: CGFloat = 20
    ///标签的颜色
    var tagColor: UIColor = .gray
    ///标签背景色
    var tagBackgroundColor: UIColor = k_color_bg_gray
    ///标签圆角
    var tagCornerRadius: CGFloat = 18
    ///标签按钮数组
    lazy var tagButtons = [UIButton]()
    ///tag的点击回调
    lazy var tagCallBack: ((Int)->()) = { _index in

    }
    ///tag的字体大小
    var tagFontSize: CGFloat = 13.0
    
    lazy var container: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(container)
        addLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLayout() {

        container.snp.makeConstraints {
            $0.left.equalTo(snp.left)
            $0.right.equalTo(snp.right)
            $0.top.equalTo(snp.top)
            $0.bottom.equalTo(snp.bottom)
        }
        
    }
    
    @objc func clickTag(button: UIButton){
        tagCallBack(button.tag)
    }
    
    
    func setTags(tags: [String]){
        tagStringArr = tags
        let count = tagStringArr.count
        if(count == 0){
            return
        }
        
        for subView in container.subviews {
            if subView is UIButton {
                subView.removeFromSuperview()
            }
        }
        tagButtons.removeAll()
        
        var lastBtn:UIButton? //前一个tag button
        var isRowFirst:Bool = true // 判断是否为每一行的第一个
        var tempWidth: CGFloat = 0 // 目前行所有tag button占的宽度
        var row:Int = 0 //tag button行数
        
        for i in 0..<count {
            
            let btnTag = UIButton()
            btnTag.tag = i
            btnTag.backgroundColor = tagBackgroundColor
            btnTag.setTitleColor(tagColor, for: .normal)
            btnTag.titleLabel?.font = UIFont.systemFont(ofSize: tagFontSize)
            btnTag.setTitle(tagStringArr[i], for: .normal)
            btnTag.layer.cornerRadius = tagCornerRadius
            btnTag.contentEdgeInsets = UIEdgeInsets(top: 0, left: btnPadding, bottom: 0, right: btnPadding)
            btnTag.addTarget(self, action: #selector(clickTag(button:)), for: .touchUpInside)
            
            container.addSubview(btnTag)
            btnTag.snp.makeConstraints { (make) in
                make.height.equalTo(btnH)
            }
            tagButtons.append(btnTag)
            
            //每个tag button占的宽度
            let titleWidth = tagStringArr[i].calcuateLabSizeWidth(font: UIFont.systemFont(ofSize: tagFontSize), maxHeight: btnH) + btnHMargin * 2
            
            
            //判断加上当前的tag button 是否会超出屏幕宽度
            if(tempWidth + titleWidth + btnHMargin * 2 > UIScreen.main.bounds.size.width){
                tempWidth = 0
                row += 1
                isRowFirst = true
            }
            
            //tag button布局
            if(isRowFirst){
                //为该行第一个tag button
                btnTag.snp.makeConstraints { (make) in
                    make.top.equalTo(container.snp.top).offset(row * Int(btnH) + Int(firstTagTop) + row * Int(btnVMargin))
                    make.left.equalTo(container.snp.left).offset(firstTagLeft)
                }
                isRowFirst = false
            }else{
                btnTag.snp.makeConstraints { (make) in
                    make.top.equalTo((lastBtn?.snp.top)!)
                    make.left.equalTo((lastBtn?.snp.right)!).offset(btnHMargin)
                }
            }
            
            tempWidth += titleWidth + 2 * btnHMargin
            lastBtn = btnTag
        }
        
        viewHeight = (CGFloat(row) + 1) * btnH + firstTagTop * 2 + CGFloat(row) * btnVMargin
    }
    
    
}
