//
//  Dictionary+custom.swift
//  SheQu
//
//  Created by gm on 2019/7/5.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
private let custom_font_key      = NSAttributedString.Key.font.rawValue
private let custom_em_key        = YYTextGlyphTransformAttributeName
private let custom_through_key   = YYTextStrikethroughAttributeName
private let custom_border_key    = YYTextBlockBorderAttributeName
private let custom_paragraph_key = "NSParagraphStyle"
extension Dictionary {
    static  func defaultAttriDict() -> [String: Any] {
        var attriDict = [String: Any]()
        let rotationZero   = CGAffineTransform.init(rotationAngle: CGFloat(0))
        let bordZero       = Dictionary.zeroBord()
        let decorationZero = YYTextDecoration.init(style: YYTextLineStyle.init(rawValue: 0))
        let value = NSValue.init(cgAffineTransform: rotationZero)
        let paragraphStyleZero = Dictionary.paragraphValue()
        attriDict[YYTextGlyphTransformAttributeName]    = value
        attriDict[YYTextStrikethroughAttributeName]     =  decorationZero
        attriDict[custom_font_key] = k_font_title
        attriDict[YYTextBlockBorderAttributeName]       = bordZero
        attriDict["CTForegroundColor"]                  = k_color_title_black
        attriDict["NSParagraphStyle"]                   = paragraphStyleZero
        attriDict["NSBackgroundColor"] = UIColor.blue
        return attriDict
    }

    static func h1Key() -> String{
        return custom_font_key
    }

    static func h2Key() -> String{
        return custom_font_key
    }
    
    static func h3Key() -> String{
        return custom_font_key
    }
    
    static func h4Key() -> String{
        return custom_font_key
    }
    
    static func strongKey() -> String{
        return custom_font_key
    }
    
    static func emKey() -> String{
        return custom_em_key
    }
    
    static func throughKey() -> String{
        return custom_through_key
    }
    
    static func borderKey() -> String{
        return custom_border_key
    }
    
    static func paragraphKey() -> String {
        return custom_paragraph_key
    }
    
    //MARK: ----------value---------------
    static func h1Value() -> UIFont{
        return UIFont.systemFont(ofSize: 26, weight: .bold)
    }
    
    static func h2Value() -> UIFont{
        return UIFont.systemFont(ofSize: 22, weight: .bold)
    }
    static func h3Value() -> UIFont{
        return UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    static func h4Value() -> UIFont{
        return UIFont.systemFont(ofSize: 16, weight: .bold)
    }

    static func strongValue() -> UIFont{
        return UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    
    static func emValue() -> NSValue{
        let rotation = CGAffineTransform.init(rotationAngle: CGFloat(-.pi * 0.020))
        return NSValue.init(cgAffineTransform: rotation)
    }
    
    static func throughValue() -> YYTextDecoration{
        return YYTextDecoration.init(style: .single)
    }
    
    static func bordValue() -> YYTextBorder {
        let bord = YYTextBorder.init(fill: UIColor.colorRGB(0xf5f5f5), cornerRadius: 0)
        bord.leftLineWidth  = 3.0
        bord.leftLineLColor = k_color_normal_blue
        return bord
    }
    
    static func bordParagraphValue() -> NSMutableParagraphStyle {
        let paragraphStyle  = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 10
        paragraphStyle.headIndent          = 10
        paragraphStyle.lineSpacing         = 10
        paragraphStyle.tailIndent          = -7
        return paragraphStyle
    }
    
    static func paragraphValue() -> NSMutableParagraphStyle {
        let paragraphStyle  = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing               = 10
        paragraphStyle.paragraphSpacing          = 10
        paragraphStyle.paragraphSpacingBefore    = 10
        return paragraphStyle
    }
    
    static func zeroBord() -> YYTextBorder {
        let bord = YYTextBorder.init(fill: UIColor.clear, cornerRadius: 0)
        bord.leftLineWidth  = 0
        bord.leftLineLColor = UIColor.clear
        bord.fillColor      = nil
        return bord
    }
    
    func appendH1Value() -> [String: Any]{
        var temp: [String : Any] = self as! [String : Any]
        temp[Dictionary.h1Key()] = Dictionary.h1Value()
        temp[NSAttributedString.Key.foregroundColor.rawValue] = k_color_black
        return temp
    }
    
    func appendEmValue() -> [String: Any] {
        var temp: [String : Any] = self as! [String : Any]
        temp[Dictionary.emKey()] = Dictionary.emValue()
        return temp
    }
    
    func appendThroughValue() -> [String: Any] {
        var temp: [String : Any] = self as! [String : Any]
        temp[Dictionary.throughKey()] = Dictionary.throughValue()
        return temp
    }
    
    func appendH2Value() -> [String: Any]{
        var temp: [String : Any] = self as! [String : Any]
        temp[Dictionary.h2Key()] = Dictionary.h2Value()
        temp[NSAttributedString.Key.foregroundColor.rawValue] = k_color_black
        return temp
    }
    
    func appendH3Value() -> [String: Any]{
        var temp: [String : Any] = self as! [String : Any]
        temp[Dictionary.h3Key()] = Dictionary.h3Value()
        temp[NSAttributedString.Key.foregroundColor.rawValue] = k_color_black
        return temp
    }
    
    func appendH4Value() -> [String: Any]{
        var temp: [String : Any] = self as! [String : Any]
        temp[Dictionary.h4Key()] = Dictionary.h4Value()
        temp[NSAttributedString.Key.foregroundColor.rawValue] = k_color_black
        return temp
    }
    
    func appendStrongValue() -> [String: Any]{
        var temp: [String : Any] = self as! [String : Any]
        temp[Dictionary.strongKey()] = Dictionary.strongValue()
        temp[NSAttributedString.Key.foregroundColor.rawValue] = k_color_title_gray_blue
        return temp
    }
    
    func appendBorderValue() -> [String: Any] {
        var temp: [String : Any] = self as! [String : Any]
        temp[Dictionary.paragraphKey()]              = Dictionary.bordParagraphValue()
        temp[Dictionary.borderKey()]  = Dictionary.bordValue()
        return temp
    }
    
    
}
