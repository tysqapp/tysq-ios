//
//  SQWriteArticleInputAccessoryView.swift
//  SheQu
//
//  Created by gm on 2019/5/9.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQWriteArticleInputAccessoryView: UIView {
    var selBtn        = UIButton()
    var blockquoteBtn = UIButton()
    struct SQWriteArticleInputAccessoryViewStyle: OptionSet {
        
        let rawValue: Int
        ///字体
        static let word = SQWriteArticleInputAccessoryViewStyle(rawValue: 0)
        ///图片
        static let image  = SQWriteArticleInputAccessoryViewStyle(rawValue: 1)
        ///视频
        static let video  = SQWriteArticleInputAccessoryViewStyle(rawValue: 2)
        ///音乐
        static let music = SQWriteArticleInputAccessoryViewStyle(rawValue: 3)
        ///块
        static let blockquote = SQWriteArticleInputAccessoryViewStyle(rawValue: 4)
        ///分割线
        static let lines = SQWriteArticleInputAccessoryViewStyle(rawValue: 5)
        ///关闭
        static let close = SQWriteArticleInputAccessoryViewStyle(rawValue: 6)
    }
    
    lazy var wordStyleView: SQWriteArticleWordTypeView = {
        let wordStyleView = SQWriteArticleWordTypeView.init(frame: CGRect.init(x: 10, y: 0, width: 275, height: 50))
        return wordStyleView
    }()
    
    var callBack:((SQWriteArticleInputAccessoryViewStyle)->())?
    
    init(frame: CGRect, styleArray: [SQWriteArticleInputAccessoryView.SQWriteArticleInputAccessoryViewStyle]) {
        super.init(frame: frame)
        backgroundColor = k_color_line_light
        
        var num = 6 + 1
        if styleArray.count > num {
            num = styleArray.count
        }
        
        let viewW: CGFloat = k_screen_width / CGFloat(num)
        let viewH: CGFloat = self.height()
        let closeBtn = UIButton()
        closeBtn.tag = SQWriteArticleInputAccessoryViewStyle.close.rawValue
        closeBtn.setImage(UIImage.init(named: "home_ac_ia_06"), for: .normal)
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(self.snp.bottom)
            maker.right.equalTo(self.snp.right)
            maker.height.equalTo(viewH)
            maker.width.equalTo(viewW)
        }
        closeBtn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        
        for index in 0..<styleArray.count {
           
            let style = styleArray[index]
            let viewX = CGFloat(index) * viewW
            let btn = UIButton()
            addSubview(btn)
            btn.snp.makeConstraints { (maker) in
                maker.bottom.equalTo(self.snp.bottom)
                maker.left.equalTo(self.snp.left).offset(viewX)
                maker.height.equalTo(viewH)
                maker.width.equalTo(viewW)
            }
            let imageName = String.init(format: "home_ac_ia_%02d", style.rawValue)
            btn.setImage(UIImage.init(named: imageName), for: .normal)
            btn.setImage(UIImage.init(named: imageName + "_sel"), for: .selected)
            btn.tag = style.rawValue
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            if SQWriteArticleInputAccessoryViewStyle.init(rawValue: btn.tag) == .blockquote {
                blockquoteBtn = btn
            }
        }
    }
    
    
    @objc func btnClick(btn: UIButton){
        
        wordStyleView.removeFromSuperview()
        let style = SQWriteArticleInputAccessoryViewStyle.init(rawValue: btn.tag)

        if style == SQWriteArticleInputAccessoryViewStyle.word {
            selBtn = btn
            btn.isSelected = !btn.isSelected
            if btn.isSelected {
                let position = btn.convert(btn.origin(), to: UIApplication.shared.keyWindow)
                var viewX = btn.centerX() - 25
                if viewX < 0 {
                    viewX = 0
                }
                
                let viewY: CGFloat = position.y - 50
                wordStyleView.setTop(y: viewY)
                wordStyleView.setLeft(x: viewX)
                UIApplication.shared.keyWindow?.addSubview(wordStyleView)
                UIApplication.shared.keyWindow?.bringSubviewToFront(wordStyleView)
            }else{
                wordStyleView.removeFromSuperview()
            }
            return
        }
        
        if (callBack != nil) {
            if style == SQWriteArticleInputAccessoryViewStyle.blockquote {
                blockquoteBtn.isSelected = !blockquoteBtn.isSelected
            }else{
               selBtn.isSelected = false
            }
            callBack!(style)
        }
        
    }
    
    func updateItemsSelectedType(_ html: String) {
        if html.contains("blockquote") {
            blockquoteBtn.isSelected = true
        }else{
            blockquoteBtn.isSelected = false
        }
        
        wordStyleView.updateSelWordType(html)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
