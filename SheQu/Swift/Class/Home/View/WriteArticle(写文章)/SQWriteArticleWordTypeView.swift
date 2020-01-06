//
//  SQWriteArticleWordTypeView.swift
//  SheQu
//
//  Created by gm on 2019/5/9.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
enum SQWriteArticleWordType: Int {
    ///粗体
    case strong     = 1
    ///斜体
    case em         = 2
    ///删除线
    case through    = 3
    ///标题1
    case h1         = 4
    ///标题2
    case h2         = 5
    ///标题3
    case h3         = 6
    ///标题4
    case h4         = 7
    ///引用
    case blockquote = 8
}
class SQWriteArticleWordTypeView: UIView {
    static let imageNameArray = [
        "home_wa_ws_weight",
        "home_wa_ws_em",
        "home_wa_ws_span",
        "home_wa_ws_h1",
        "home_wa_ws_h2",
        "home_wa_ws_h3",
        "home_wa_ws_h4"
    ]
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage.init(named: "home_wa_ws_bg")
        return bgImageView
    }()
    var callBack: (([SQWriteArticleWordType],SQWriteArticleWordType)->())?
    var selHBtn: UIButton?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.bottom.equalTo(snp.bottom)
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(changeLine), name: NSNotification.Name.init("noti_change_line"), object: nil)
        let btnW: CGFloat = self.width() / CGFloat(SQWriteArticleWordTypeView.imageNameArray.count)
        for index in 0...SQWriteArticleWordTypeView.imageNameArray.count {
            if index == SQWriteArticleWordTypeView.imageNameArray.count {return}
            let btn = UIButton()
            btn.tag = index + 1
            addSubview(btn)
            let btnX = CGFloat(index) * btnW
            btn.snp.makeConstraints { (maker) in
                maker.top.equalTo(snp.top)
                maker.width.equalTo(btnW)
                maker.bottom.equalTo(snp.bottom).offset(-10)
                maker.left.equalTo(snp.left).offset(btnX)
            }
            
            let imageName = SQWriteArticleWordTypeView.imageNameArray[index]
            btn.setImage(UIImage.init(named: imageName), for: .normal)
            btn.setImage(UIImage.init(named: imageName + "_sel"), for: .selected)
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        }
    }
    
    @objc func btnClick(btn: UIButton) {
        
        var typeArray = [SQWriteArticleWordType]()
        ///htmlBtn
        if btn.tag > 3 {
            if selHBtn == btn && selHBtn!.isSelected {
                btn.isSelected = false
            }else{
                selHBtn?.isSelected = false
                btn.isSelected = true
                selHBtn = btn
            }
        }else{
            btn.isSelected = !btn.isSelected
        }
        
        for index in 1...SQWriteArticleWordTypeView.imageNameArray.count {
            let subBtn: UIButton = self.viewWithTag(index) as! UIButton
            if subBtn.isSelected {
               let type = SQWriteArticleWordType.init(rawValue: subBtn.tag)
               typeArray.append(type!)
            }
        }
        
        
        if callBack != nil {
            callBack!(typeArray, SQWriteArticleWordType.init(rawValue: btn.tag)!)
        }
    }
    
    func updateSelWordType(_ htmlStr: String) {
        
        for subView in self.subviews {
            guard let btn: UIButton = subView as? UIButton else {
                continue
            }
            btn.isSelected = false
            if htmlStr.contains("<strong>") && btn.tag == 1 {///选中加粗
                btn.isSelected = true
            }
            
            if htmlStr.contains("<em>") && btn.tag == 2 {///选中斜体
                btn.isSelected = true
            }
            
            if htmlStr.contains("<span") && btn.tag == 3 {///选中删除线
                btn.isSelected = true
            }
            
            if htmlStr.contains("<h1>") && btn.tag == 4 {///选中h1
                btn.isSelected = true
            }
            
            if htmlStr.contains("<h2>") && btn.tag == 5 {///选中h2
                btn.isSelected = true
            }
            
            if htmlStr.contains("<h3>") && btn.tag == 6{///选中h3
                btn.isSelected = true
            }
            
            if htmlStr.contains("<h4>") && btn.tag == 7 {///选中h4
                btn.isSelected = true
            }
        }
        
        
    }
    
    @objc func changeLine() {
        for subView in subviews {
            if subView is UIButton {
                let btn: UIButton = subView as! UIButton
                btn.isSelected    = false
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
