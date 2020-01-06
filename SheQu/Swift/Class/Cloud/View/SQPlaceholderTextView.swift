//
//  SQPlaceholderTextView.swift
//  SheQu
//
//  Created by iMac on 2019/9/16.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

//textView内边距
struct TextContainerInset{
    var top:CGFloat = 10.0
    var left:CGFloat = 20.0
    var bottom:CGFloat = 20.0
    var right:CGFloat = 10.0
    
    init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat ) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }
    

}

class SQPlaceholderTextView: UIView {
     var textContainerInset:TextContainerInset = TextContainerInset(top: 10, left: 20, bottom: 10, right: 20)
    ///字数限制
     var limitWords: Int = 9999
    ///是否显示placeholder
     var isShowPlaceholder: Bool = true {
        didSet{
            if isShowPlaceholder == false {
                  placeholderLabel.isHidden = true
            }
        }
    }
    ///是否显示剩余字数
     var isShowNumWordsLabel: Bool = true {
        didSet{
            if isShowPlaceholder == false {
                  numLabel.isHidden = true
            }
          
        }
    }
    
    
    var placeholderString: String? {
        didSet{
            placeholderLabel.text = placeholderString
            placeholderLabel.sizeToFit()
        }
    }
    
     lazy var textView: UITextView = {
        let textView = UITextView()
        textView.returnKeyType = .done
        return textView
    }()
    
     lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textColor = k_color_title_light_gray_3
        numLabel.text = "\(limitWords - textView.text.count)"
        return numLabel
    }()
    
     lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.textColor = k_color_title_light_gray_3
        return placeholderLabel
    }()
    
     override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, placeholder: String, limit: Int,textContainerInset: TextContainerInset) {
        self.init(frame: frame)
        self.textContainerInset = textContainerInset
        placeholderString = placeholder
        limitWords = limit
        setupUI()
        checkShowHiddenPlaceholder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SQPlaceholderTextView {
    private func setupUI() {
        textView.delegate = self
        textView.textContainerInset =  UIEdgeInsets(top: textContainerInset.top, left: textContainerInset.left, bottom: textContainerInset.bottom, right: textContainerInset.right)
        textView.font = k_font_title
        addSubview(textView)
        placeholderLabel.font = textView.font
        placeholderLabel.textAlignment = .left
        placeholderLabel.text = placeholderString
        placeholderLabel.sizeToFit()
        addSubview(placeholderLabel)
        addSubview(numLabel)
        addLayout()
    }
    
    private func addLayout() {
        textView.snp.makeConstraints {
            $0.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        numLabel.snp.makeConstraints {
            $0.right.equalTo(textView.snp.right).offset(-20)
            $0.bottom.equalTo(textView.snp.bottom).offset(-20)
            
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.left.equalTo(textView.snp.left).offset(textContainerInset.left + 4.0)
            $0.top.equalTo(textView.snp.top).offset(textContainerInset.top)
           
        }
        
    }
    
}

extension SQPlaceholderTextView {
    func checkShowHiddenPlaceholder() {
        if textView.hasText {
            if(textView.text.count <= limitWords){
                numLabel.text =  "\(limitWords - textView.text.count)"
            }
            placeholderLabel.isHidden = true
        }else {
            placeholderLabel.isHidden = false
            
        }
        
    }
    
}

extension SQPlaceholderTextView: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        checkShowHiddenPlaceholder()
        if textView.text.count > limitWords {
            
            //获得已输出字数与正输入字母数
            let selectRange = textView.markedTextRange
            
            //获取高亮部分 － 如果有联想词则解包成功
            if let selectRange = selectRange {
                let position =  textView.position(from: (selectRange.start), offset: 0)
                if (position != nil) {
                    return
                }
            }
            
            let textContent = textView.text
            let textNum = textContent?.count
            
            //截取50个字
            if textNum! > 50 {
                let index = textContent?.index((textContent?.startIndex)!, offsetBy: 50)
                let str = textContent?.substring(to: index!)
                textView.text = str
            }
        }
        
        let textNum = textView.text.count
        if textNum <= limitWords{
            numLabel.text =  "\(limitWords - textNum)"
        }
        
        
    }
}
