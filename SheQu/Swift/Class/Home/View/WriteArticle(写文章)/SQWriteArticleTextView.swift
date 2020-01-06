//
//  SQWriteArticleTextView.swift
//  SheQu
//
//  Created by gm on 2019/5/8.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

protocol SQWriteArticleTextViewDelegate: NSObject {
    func writeArticleTextView(textView: SQWriteArticleTextView,inputAccessoryViewStyleChange style: SQWriteArticleInputAccessoryView.SQWriteArticleInputAccessoryViewStyle,handel:@escaping ([SQAccountFileItemModel]) -> ())
}
class SQWriteArticleTextView: YYTextView, YYTextKeyboardObserver {
    ///富文本编辑器高度回调
    var heightCallBack: ((CGFloat) -> ())?
    weak var customDelegate: SQWriteArticleTextViewDelegate?
    lazy var textViewHeight: CGFloat   = 50
    lazy var offsetMargin:  CGFloat    = 20
    lazy var oldHeight: CGFloat        = 0
    /// 视频文件
    lazy var videoModelArray = [SQAccountFileItemModel]()
    ///记录当前文本样式
    lazy var wordTypeArrayM   = [SQWriteArticleWordType]()
    
    ///富文本图片视频等的编辑栏
    lazy var customInputAccessoryView: SQWriteArticleInputAccessoryView = {
        let customInputAccessoryView = SQWriteArticleInputAccessoryView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: 50), styleArray: [.word,.image,.video,.music,.blockquote,.lines])
    
        return customInputAccessoryView
    }()
    
    /// 占位样式
    lazy var customPlaceholderText: NSMutableAttributedString = {
        let customPlaceholderText = NSMutableAttributedString.init(string: "请输入正文")
        var dict = Dictionary<String, Any>.defaultAttriDict()
        dict["CTForegroundColor"] = k_color_title_gray_blue
        customPlaceholderText.yy_setAttributes(dict)
        return customPlaceholderText
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isScrollEnabled           = false
        donotScrollToVisible      = true
        typingAttributes          = Dictionary<String, Any>.defaultAttriDict()
        placeholderAttributedText = customPlaceholderText
        inputAccessoryView        = customInputAccessoryView
        
        textContainerInset  = UIEdgeInsets.init(
            top: 10,
            left: 0,
            bottom: 30 + k_bottom_h,
            right: 0
        )
        
        addCallBack()
        addNoti()
    }
    
    ///添加监听
   fileprivate func addNoti() {
        ///监听文本编辑器高度 目的是为了更新文本编辑器的高度
        addObserver(
            self,
            forKeyPath: "contentSize",
            options: .new,
            context: nil
        )
        
        ///监听选中状态 目的是为了更换样式编辑器的选中状态
        addObserver(
            self,
            forKeyPath: "selectedRange",
            options: .new,
            context: nil
        )
        
        ///监听换行操作
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(changeLine),
            name: NSNotification.Name.init("noti_change_line"),
            object: nil
        )
    }
    
    ///换行键
    @objc func changeLine() {
        wordTypeArrayM.removeAll()
        typingAttributes = Dictionary<String, Any>.defaultAttriDict()
        if customInputAccessoryView.blockquoteBtn.isSelected {
            typingAttributes = getBlockquoteType(typingAttributes!)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (change != nil && keyPath == "contentSize") {
            let size: CGSize = change![NSKeyValueChangeKey.newKey] as! CGSize
            if heightCallBack != nil {
                if size.height + 50 != oldHeight {
                    self.oldHeight   = size.height + 50
                    heightCallBack!(size.height + 50)
                }
            }
        }
        
        ///这里是处理selectedRange改变时 更新文本样式框的选中状态
        if (change != nil && keyPath == "selectedRange") {
            if selectedRange.length == 0 && selectedRange.location != 0 && (attributedText?.length ?? 0) >= selectedRange.location {
                
                let frontAttstr: NSAttributedString = attributedText?.attributedSubstring(from: NSRange.init(location: selectedRange.location - 1, length: 1)) ?? NSAttributedString()
               getCurrentSelRange(frontAttstr)
            }else{
                let attStr = NSMutableAttributedString.init(string: " ")
                attStr.yy_setAttributes(typingAttributes ?? Dictionary<String, Any>.defaultAttriDict())
                getCurrentSelRange(attStr)
            }
            
        }
    }
    
    
    func getCurrentSelRange(_ attbuiteStr: NSAttributedString) {
        weak var weakSelf = self
        SQDisassemblyAttriToHtml.disassemblyAttriToHtml(attbuiteStr)
        { (htmlStr, image, Audio, Viedo) in
            if htmlStr.count == 0 ||
                htmlStr.contains("<hr />") ||
                htmlStr.contains("<video") ||
                htmlStr.contains("<img") ||
                htmlStr.contains("<audio"){
                weakSelf?.typingAttributes = Dictionary<String, Any>.defaultAttriDict()
            }
            weakSelf?.customInputAccessoryView.updateItemsSelectedType(htmlStr)
            
        }
    }
    
    func hiddenKeyBoard() {
        endEditing(true)
    }
    
    func keyboardChanged(with transition: YYTextKeyboardTransition) {
        if transition.fromVisible.boolValue {
            customInputAccessoryView.wordStyleView.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        removeObserver(self, forKeyPath: "selectedRange")
        removeObserver(self, forKeyPath: "contentSize")
    }
}

extension SQWriteArticleTextView {
    func findDrawImageView(drawView: SQContentDrawAttStrViewProtocol) {
        
        objc_sync_enter(self)
        guard let attributedTextTemp = attributedText else {
             objc_sync_exit(self)
            return
        }
        
        attributedTextTemp.enumerateAttributes(in: NSRange.init(location: 0,length: attributedText!.length), options: .longestEffectiveRangeNotRequired) { (dict, range, errorMessage) in
            let str  = "\(dict)"
            if str.contains("YYTextAttachment") {
                
               for value in dict.values {
                
                let valueTemp: YYTextAttachment? = value as? YYTextAttachment
                if valueTemp == nil {
                    continue
                }
                let contentView: SQContentDrawAttStrViewProtocol? = valueTemp!.content as? SQContentDrawAttStrViewProtocol
                
                if (contentView != nil) {
                    if contentView!.idStr == drawView.idStr {
                        let drawViewTemp: UIView = drawView as! UIView
                        let attM = NSMutableAttributedString()
                        attM.append(attributedText!.attributedSubstring(from: NSRange.init(location: 0, length: attributedText!.length)))
                        let attStr = NSMutableAttributedString.yy_attachmentString(
                            withContent: drawViewTemp,
                            contentMode: .scaleAspectFill,
                            attachmentSize: drawViewTemp.size(),
                            alignTo: UIFont.systemFont(ofSize: 0),
                            alignment: .bottom
                        )
                        attM.append(attStr)
                        let length = range.location + range.length
                        let totle  = attributedText!.length - length
                        if totle != 0 {
                        attM.append(attributedText!.attributedSubstring(from: NSRange.init(location: length, length: totle)))
                        }
                        
                        attributedText = attM
                    }
                }
                
               }
                
            }
        }
        
        objc_sync_exit(self)
    }
}
