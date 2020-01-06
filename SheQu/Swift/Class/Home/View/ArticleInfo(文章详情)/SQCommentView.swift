//
//  SQCommentView.swift
//  SheQu
//
//  Created by gm on 2019/5/24.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQCommentView: UIView {
    static let defaultH: CGFloat = 50
    lazy var textFiled: UITextField = {
        let textFiled = UITextField()
        let leftView  = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        leftView.contentMode = .center
        leftView.image     = UIImage.init(named: "sq_comment_pen")
        let leftV = UIView(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        leftV.addSubview(leftView)
        textFiled.leftView = leftV
        textFiled.leftViewMode      = .always
        textFiled.backgroundColor   = UIColor.colorRGB(0xf5f5f5)
        textFiled.isUserInteractionEnabled = false
        
        let attributes = [
        NSAttributedString.Key.foregroundColor : k_color_title_gray_blue,
        NSAttributedString.Key.font: k_font_title_12
        ]
        
        textFiled.attributedPlaceholder = NSAttributedString.init(string: "输入评论...", attributes: attributes)
        return textFiled
    }()
    
    lazy var placeHolderBtn = UIButton()
    
    lazy var commentBtn: UIButton = {
        let commentBtn = UIButton()
        commentBtn.contentHorizontalAlignment = .right
        commentBtn.setImage(UIImage.init(named: "sq_comment_image_big"), for: .normal)
        commentBtn.setTitleColor(k_color_title_gray_blue, for: .normal)
        commentBtn.titleLabel?.font = k_font_title_12
        commentBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 5)
        return commentBtn
    }()
    
    lazy var collectBtn: UIButton = {
        let collectBtn = UIButton()
        collectBtn.contentHorizontalAlignment = .right
        collectBtn.setImage(UIImage.init(named: "home_collect")?.reSizeImage(reSize: CGSize.init(width: 16.5, height: 16.5)) , for: .normal)
        collectBtn.setImage(UIImage.init(named: "home_collect_sel")?.reSizeImage(reSize: CGSize.init(width: 16.5, height: 16.5)) , for: .selected)
        collectBtn.setTitleColor(k_color_title_gray_blue, for: .normal)
        collectBtn.titleLabel?.font = k_font_title_12
        collectBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 5)
        return collectBtn
    }()
    
    lazy var editArticleBtn: UIButton = {
        let editArticleBtn = UIButton()
        editArticleBtn.contentHorizontalAlignment = .right
        editArticleBtn.setImage(UIImage.init(named: "sq_article_info"), for: .normal)
        return editArticleBtn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textFiled)
        addSubview(commentBtn)
        addSubview(editArticleBtn)
        addSubview(collectBtn)
        addSubview(lineView)
        addSubview(placeHolderBtn)
        addLayout()
    }
    
    func addObserverByArticleID(_ articleID: String) {
        NotificationCenter.default.addObserver(self, selector: #selector(reviceAtricleNoti(noti:)), name: Notification.Name.init(rawValue: articleID), object: nil)
    }
    
    
    
    @objc func reviceAtricleNoti(noti: Notification) {
        guard let dict: [String: Int] = noti.object as? [String : Int] else {
            return
        }
        
        if dict.keys.contains("comment_number") {
            let comment_number: Int = dict["comment_number"] ?? 0
            commentBtn.setTitle(comment_number.getShowString(), for: .normal)
        }
        
    }
    
    func addLayout() {
        let btnWidth: CGFloat = 40
        let viewH: CGFloat    = 30
        
        lineView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(k_line_height)
        }
        
        editArticleBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(snp.right).offset(-20)
            maker.width.equalTo(btnWidth)
            maker.centerY.equalTo(snp.centerY)
            maker.height.equalTo(viewH)
        }
        
        collectBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(editArticleBtn.snp.left)
            maker.width.equalTo(btnWidth)
            maker.centerY.equalTo(snp.centerY)
            maker.height.equalTo(viewH)
        }
        
        commentBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(collectBtn.snp.left)
            maker.width.equalTo(40)
            maker.centerY.equalTo(snp.centerY)
            maker.height.equalTo(viewH)
        }
        
        
        textFiled.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left).offset(20)
            maker.centerY.equalTo(snp.centerY)
            maker.right.equalTo(commentBtn.snp.left).offset(-20)
            maker.height.equalTo(viewH)
        }
        
        placeHolderBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left).offset(20)
            maker.centerY.equalTo(snp.centerY)
            maker.right.equalTo(commentBtn.snp.left).offset(-20)
            maker.height.equalTo(viewH)
        }
        textFiled.layer.borderWidth = 0.7
        textFiled.layer.borderColor = UIColor.colorRGB(0xdddddd).cgColor
        textFiled.layer.cornerRadius = k_corner_radiu
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
