//
//  SQWriteArticleTextView+Style.swift
//  SheQu
//
//  Created by gm on 2019/7/3.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

extension SQWriteArticleTextView {
    
    /// 需要被编辑文章的富文本类型
    ///
    /// - Returns: 编辑文章的富文本类型
    func getTypingAttributesFrom() -> [String: Any] {
        
        var attriDict = Dictionary<String, Any>.defaultAttriDict()
        for type in wordTypeArrayM {
            switch type {
            case .strong://加粗 行级元素
                attriDict = attriDict.appendStrongValue()
            case .through://删除 行级元素
                attriDict = attriDict.appendThroughValue()
            case .em://斜体 行级元素
                attriDict = attriDict.appendEmValue()
            case .h1://标题h1 块级元素
                attriDict = attriDict.appendH1Value()
                break
            case .h2://标题h2 块级元素
                attriDict = attriDict.appendH2Value()
                break
            case .h3://标题h3 块级元素
                attriDict = attriDict.appendH3Value()
                break
            case .h4://标题h4 块级元素
                attriDict = attriDict.appendH4Value()
            case .blockquote:
                break
            }
        }
        
        if customInputAccessoryView.blockquoteBtn.isSelected { ///块级元素
            attriDict = getBlockquoteType(attriDict)
        }
        
        return attriDict
    }
    
    func getBlockquoteType(_ typeDict: [String: Any]) -> [String: Any]{
        return typeDict.appendBorderValue()
    }
    
    
}
