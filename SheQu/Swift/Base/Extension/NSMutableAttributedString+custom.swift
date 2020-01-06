//
//  NSMutableAttributedString+custom.swift
//  SheQu
//
//  Created by gm on 2019/7/5.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    ///分割线
    static func getLineValue(_ margin: CGFloat = 20) -> NSMutableAttributedString {
        let lineViewContentView = UIView()
        let contentW = UIScreen.main.bounds.size.width - margin * 2
        lineViewContentView.setSize(size: CGSize.init(
            width:  contentW,
            height: 30)
        )
        
        let lineView               = UIView()
        lineViewContentView.tag    = 100
        lineView.backgroundColor   = k_color_line
        lineViewContentView.addSubview(lineView)
        lineView.setSize(size: CGSize.init(
            width: lineViewContentView.frame.size.width,
            height: 1))
        
        lineView.setTop(y: 9.5)
        
        let font     = UIFont.systemFont(ofSize: 20)
        let lineAtt  = NSMutableAttributedString.yy_attachmentString(
            withContent: lineViewContentView,
            contentMode: .top,
            attachmentSize: lineViewContentView.size(),
            alignTo: font,
            alignment: .center
        )
        return lineAtt
    }
    
    func updateType(_ wordType: SQWriteArticleWordType) {
        let range = NSRange.init(location: 0, length: length)
        if wordType == .h1 {
            yy_setFont(Dictionary<String, Any>.h1Value() as UIFont, range: range)
        }
        
        if wordType == .h2 {
            yy_setFont(Dictionary<String, Any>.h2Value() as UIFont, range: range)
        }
        
        if wordType == .h3 {
            yy_setFont(
                Dictionary<String, Any>.h3Value() as UIFont,
                range: range
            )
        }
        
        if wordType == .h4 {
            yy_setFont(
                Dictionary<String, Any>.h4Value() as UIFont,
                range: range
            )
        }
        
        if wordType == .blockquote {
            
            
            yy_setTextBackgroundBorder(
                Dictionary<String, Any>.bordValue() as YYTextBorder,
                range: range
            )
            
            yy_setParagraphStyle(
                Dictionary<String, Any>.bordParagraphValue() as NSParagraphStyle,
                range: range)
        }
    }
    
    
    func updateNormalFont() {
        yy_setFont(UIFont.systemFont(ofSize: 14), range: NSRange.init(location: 0, length: length))
    }
    
    func updateNormalBord() {
        let range = NSRange.init(location: 0, length: length)
        yy_setTextBackgroundBorder(
            Dictionary<String, Any>.zeroBord() as YYTextBorder,
            range: range
        )
        
        yy_setParagraphStyle(
            Dictionary<String, Any>.paragraphValue() as NSParagraphStyle,
            range: range)
    }
    
}
