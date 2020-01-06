//
//  String+Extension.swift
//  SheQu
//
//  Created by gm on 2019/4/28.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
import CommonCrypto

extension String {
    
    public func calcuateLabSizeWidth(font: UIFont, maxHeight: CGFloat) -> CGFloat {
        let attributes = [kCTFontAttributeName: font]
        let norStr = NSString(string: self)
        let size = norStr.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: maxHeight), options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
        return size.width
    }
    
    public func calcuateLabSizeHeight(font: UIFont, maxWidth: CGFloat) -> CGFloat {
        let attributes = [kCTFontAttributeName: font]
        let norStr = NSString(string: self)
        let size = norStr.boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
        return size.height
    }
    
    func toTopArticleTitle() -> NSMutableAttributedString {

        return stringAppendImage(
            textColor: k_color_title_black,
            font: k_font_title,
            imageName: "sq_article_top_tag",
            isFront: true,
            margin: "  ",
            offsetY: -3.5
        )
    }
    
    func toDraftAttStr() -> NSMutableAttributedString {
        
        return stringAppendImage(
            textColor: k_color_title_black,
            font: k_font_title_weight,
            imageName: "sq_draft",
            isFront: true,
            margin: "  ",
            offsetY: -2.5
        )
    }
    
    func toHiddenAttStr() -> NSMutableAttributedString {
        
        return stringAppendImage(
            textColor: k_color_title_black,
            font: k_font_title_weight,
            imageName: "sq_hidden",
            isFront: true,
            margin: "   ",
            offsetY: -2.5
        )
    }
    
    /// 文字添加图片
    ///
    /// - Parameters:
    ///   - textColor: 字体颜色
    ///   - font:字体大小
    ///   - imageName: 图片名字
    ///   - isFront: 图片位置 如果在前面 为true false 为后面
    ///   - margin: 图片和文字之间的间距 通过空格符号来控制
    ///   - offsetY: 图片偏移量
    /// - Returns: 返回图片文字字体
    func stringAppendImage(textColor: UIColor,font: UIFont,imageName: String, isFront: Bool, margin: String, offsetY: CGFloat) -> NSMutableAttributedString {
        
        let attStrM       = NSMutableAttributedString()
        let attachment    = NSTextAttachment()
        attachment.image  = UIImage.init(named: imageName)
        attachment.bounds = CGRect.init(
            x: 0,
            y: offsetY,
            width: attachment.image?.size.width ?? 0,
            height: attachment.image?.size.height ?? 0
        )
        
        let imageAtt = NSAttributedString.init(attachment: attachment)
        let contentAttDict = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: textColor
        ]
        
        let marginAtt   = NSAttributedString.init(string: margin, attributes: contentAttDict)
        
        let contentAtt   = NSAttributedString.init(string: self, attributes: contentAttDict)
        
        if isFront {
            attStrM.append(imageAtt)
            attStrM.append(marginAtt)
            attStrM.append(contentAtt)
        }else{
            attStrM.append(contentAtt)
            attStrM.append(marginAtt)
            attStrM.append(imageAtt)
        }
        
        return attStrM
    }
    
    func toImage() -> UIImage? {
        let image = UIImage.init(named: self)
        return image
    }
    
    ///获取真实图片
    func toOriginalPath() -> String{
       return self 
    }
    
    
    
    func toMD5String() -> String {
        let cStr = cString(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();

        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }

        free(buffer)
        return md5String as String
    }
    ///将关键词高亮
    func heightLightKeyWordText(_ keyWord: String, color: UIColor) -> NSMutableAttributedString {
        let strs = self.components(separatedBy: keyWord)
        let attrStr = NSMutableAttributedString(string: "")
        let attrKeyWord = NSMutableAttributedString(string: keyWord)
        attrKeyWord.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange.init(location: 0, length: keyWord.count))
        
        for i in 0..<strs.count {
           
            let attrStrChunk = NSMutableAttributedString(string: strs[i])
            attrStr.append(attrStrChunk)
            if i != strs.count - 1 {
                attrStr.append(attrKeyWord)
            }
        }
        return attrStr
    }
    
    ///utf-8转化为URL编码
    func encodeURLCodeStr() -> String {
        let temp = self.decodeURLCodeStr()
        return temp.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
            ) ?? ""
    }
    
    ///url编码转化为uft-8
    func decodeURLCodeStr() -> String {
        return self.removingPercentEncoding ?? ""
    }
}



extension String {
    ///根据正则表达式 筛选输入的地址的域名部分 若成功则返回域名 失败返回 ”“
    func toValidatedDataSource() -> String {
        let urlRegEx = "((https://)|(http://))?(\\w{1,63}\\.)*\\w{0,61}\\.\\w{2,6}(:[0-9]{1,6})?"
        let reg = try? NSRegularExpression(pattern: urlRegEx, options: [])
        let checktext = reg?.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
        guard let result = getdataSourceFix(results: checktext, dataSource: self) else { return "" }
        if result.count == 0 {
            return ""
        } else {
            return result[0]
        }
        
    }
    
    func getdataSourceFix(results: [NSTextCheckingResult]?, dataSource: String?) -> [String]? {
        guard let results = results, let dataSource = dataSource else {
            return nil
        }
        
        let nsString = dataSource as NSString
        
        let dataSourceFixed = results.map { (result) -> String in
            let dataSourceFixed = nsString.substring(with: result.range)
            return dataSourceFixed
        }
        
        return dataSourceFixed
    }
    
}
