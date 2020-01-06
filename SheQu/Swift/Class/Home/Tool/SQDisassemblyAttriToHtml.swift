//
//  SQDisassemblyAttriToHtml.swift
//  GMTextView
//
//  Created by gm on 2019/5/10.
//  Copyright © 2019 SmartInspection. All rights reserved.
//

import UIKit

class SQDisassemblyAttriToHtml: NSObject {
    
    ///拼接成html字符串
    class func disassemblyAttriToHtml(
        _ attri: NSAttributedString,
        _ callBack:((_ htmlString: String,
        _ imageIdArray:[NSNumber],
        _ videoIdArray: [NSNumber],
        _ musicIdArray: [NSNumber])->())) {
        
        
        var imageArray = [NSNumber]()
        var videoArray = [NSNumber]()
        var musicArray = [NSNumber]()
        if attri.length == 0 {
            callBack(attri.string,imageArray,videoArray,musicArray)
            return
        }
        var htmlString = "<p>"
        attri.enumerateAttributes(in: NSRange.init(location: 0, length: attri.length), options: .longestEffectiveRangeNotRequired) { (dict, range, error) in
            let  dictStr = String.init(format: "%@", dict)
            //判断是不是附件 这里指图片
            if dictStr.contains("YYTextAttachment") {
                for value in dict.values {
                    if value is YYTextAttachment {
                        let valueTemp: YYTextAttachment = value as! YYTextAttachment
                        let contentView: SQContentDrawAttStrViewProtocol? = valueTemp.content as? SQContentDrawAttStrViewProtocol
                        if contentView != nil {
                            let text: String = contentView!.idStr
                            let idValue: UInt64 = UInt64(text.components(separatedBy: ":").last!)!
                            if text.hasPrefix("img") {
                                htmlString.append("</p><p><img src=\"{{img}}\"/></p><p>")
                                imageArray.append(NSNumber(value: idValue))
                            }
                            
                            if text.hasPrefix("video") {
                                htmlString.append("</p><p><video src=\"{{video}}\" controls=\"controls\" controlslist=\"nodownload\"></video></p><p>")
                                videoArray.append(NSNumber(value: idValue))
                            }
                            
                            if text.hasPrefix("audio") {
                                htmlString.append("</p><p><audio src=\"{{audio}}\" controls=\"controls\" controlslist=\"nodownload\"></audio></p><p>")
                                musicArray.append(NSNumber(value: idValue))
                            }
                            
                            break
                        }else {
                            let lineView: UIView? = valueTemp.content as? UIView
                            if lineView != nil {
                                if lineView!.tag == 100 {
                                    htmlString.append("</p><p><hr /></p><p>")
                                    break
                                }
                                
                            }
                        }
                    }
                }
            }else {
                var decoration = YYTextDecoration.init(style: YYTextLineStyle.init(rawValue: 0))
                var textBorder  = Dictionary<String, Any>.zeroBord()
                for key in dict.keys {
                    let keyStr = "\(key.rawValue)"
                    if keyStr.contains(Dictionary<String, Any>.borderKey()) {
                        textBorder = dict[key] as! YYTextBorder
                    }
                    
                    if keyStr.contains(Dictionary<String, Any>.throughKey()) {
                        decoration = dict[key] as! YYTextDecoration
                    }
                }
                
                var isTextBoled     = false //引用
                var isStrikethrough = false //删除线
                var isObliqueness   = false //斜体
                var isBold          = false //粗体
                var isH1            = false //h1
                var isH2            = false //h2
                var isH3            = false //h3
                var isH4            = false //h4
                //判断是不是引用
                if (textBorder.leftLineWidth != 0) {
                    isTextBoled = true
                    htmlString.append("</p><blockquote>")
                }
                
                //判断是不是下划线
                if decoration.style == .single {
                    isStrikethrough = true
                    htmlString.append("<span style='text-decoration:  line-through;'>")
                }
                
                //判断是不是斜体
                if !dictStr.contains("CGAffineTransform: {{1, 0, -0, 1}, {0, 0}}") {
                    isObliqueness  = true
                    htmlString.append("<em>")
                }
                
                if dictStr.contains("font-weight: bold") && dictStr.contains("font-size: 14.00pt") {
                    htmlString.append("<strong>")
                    isBold = true
                }
                
                if dictStr.contains("font-weight: bold") && dictStr.contains("font-size: 16.00pt") {
                    htmlString.append("<h4>")
                    isH4 = true
                }
                
                if dictStr.contains("font-weight: bold") && dictStr.contains("font-size: 18.00pt") {
                    htmlString.append("<h3>")
                    isH3 = true
                }
                
                if dictStr.contains("font-weight: bold") && dictStr.contains("font-size: 22.00pt") {
                    htmlString.append("<h2>")
                    isH2 = true
                }
                
                if dictStr.contains("font-weight: bold") && dictStr.contains("font-size: 26.00pt") {
                    htmlString.append("<h1>")
                    isH1 = true
                }
                
                let string = attri.attributedSubstring(from: range).string
                let value  = SQDisassemblyAttriToHtml.stringChangeMeans(string)
                htmlString.append(value)
    
                if isBold {
                    htmlString.append("</strong>")
                }
                
                if isH1 {
                    htmlString.append("</h1>")
                }
                
                if isH2 {
                    htmlString.append("</h2>")
                }
                
                if isH3 {
                    htmlString.append("</h3>")
                }
                
                if isH4 {
                    htmlString.append("</h4>")
                }
                
                if isObliqueness {
                    htmlString.append("</em>")
                }
                
                if isStrikethrough {
                    htmlString.append("</span>")
                }
                
                if isTextBoled {
                    htmlString.append("</blockquote><p>")
                }
            }

            if range.length + range.location == attri.length {
                htmlString.append("</p>")
                htmlString = htmlString.replacingOccurrences(of: "</blockquote><p></p><blockquote>", with: "")
                htmlString = htmlString.replacingOccurrences(of: "</h1><br/>", with: "</h1>")
                htmlString = htmlString.replacingOccurrences(of: "</h2><br/>", with: "</h2>")
                htmlString = htmlString.replacingOccurrences(of: "</h3><br/>", with: "</h3>")
                htmlString = htmlString.replacingOccurrences(of: "</h4><br/>", with: "</h4>")
                htmlString = htmlString.replacingOccurrences(of: "<br/></h1>", with: "</h1>")
                htmlString = htmlString.replacingOccurrences(of: "<br/></h2>", with: "</h2>")
                htmlString = htmlString.replacingOccurrences(of: "<br/></h3>", with: "</h3>")
                htmlString = htmlString.replacingOccurrences(of: "<br/></h4>", with: "</h4>")
                htmlString = htmlString.replacingOccurrences(of: "</p><br/>", with: "</p>")
                htmlString = htmlString.replacingOccurrences(of: "<br/></p>", with: "</p>")
                htmlString = htmlString.replacingOccurrences(of: "<p></p>", with: "")
                callBack(htmlString,imageArray,videoArray,musicArray)
            }
        }
    }
    
    ///转意成html字符串
   class func stringChangeMeans(_ string: String) -> String {
        var tempStr = string.replacingOccurrences(of: "&", with: "&amp;")
        tempStr = tempStr.replacingOccurrences(of: "<", with: "&lt;")
        tempStr = tempStr.replacingOccurrences(of: ">", with: "&gt;")
        tempStr = tempStr.replacingOccurrences(of: "\n", with: "<br/>")
        tempStr = tempStr.replacingOccurrences(of: " ", with: "&nbsp;")
        tempStr = tempStr.replacingOccurrences(of: "\"", with: "&quot;")
        return tempStr
    }
    
    ///html字符串解析成attStr
    class func htmlStrToParserModel(_ htmlStr: String, infoModel: SQArticleInfoModel) -> [SQParserModel] {
        
        var htmlStrTemp = self.stringChangeBackMeans(htmlStr)
        htmlStrTemp = htmlStrTemp.replacingOccurrences(of: "<p></p>", with: "")
        htmlStrTemp = htmlStrTemp.replacingOccurrences(of: "<p><blockquote>", with: "<blockquote>")
        htmlStrTemp = htmlStrTemp.replacingOccurrences(of: "</p></blockquote>", with: "</blockquote>")
        htmlStrTemp = htmlStrTemp.replacingOccurrences(of: "</p>", with: "</p><br/>")
        htmlStrTemp = htmlStrTemp.replacingOccurrences(of: "</h1>", with: "</h1><br/>")
        htmlStrTemp = htmlStrTemp.replacingOccurrences(of: "</h2>", with: "</h2><br/>")
        htmlStrTemp = htmlStrTemp.replacingOccurrences(of: "</h3>", with: "</h3><br/>")
        htmlStrTemp = htmlStrTemp.replacingOccurrences(of: "</h4>", with: "</h4><br/>")
        htmlStrTemp = htmlStrTemp.replacingOccurrences(of: "</h4>", with: "</h4><br/>")
        htmlStrTemp = htmlStrTemp.replacingOccurrences(of: "<br/><p><audio", with: "<p><audio")
        htmlStrTemp = htmlStrTemp.replacingOccurrences(of: "<br/><p><img", with: "<p><img")
        htmlStrTemp = htmlStrTemp.replacingOccurrences(of: "<br/><p><video", with: "<p><video")
        htmlStrTemp = htmlStrTemp.replacingOccurrences(of: "<br/><p><hr", with: "<p><hr")
        htmlStrTemp = htmlStrTemp.replacingOccurrences(of: "</audio></p><br/>", with: "</audio></p>")
        htmlStrTemp = htmlStrTemp.replacingOccurrences(of: "</video></p><br/>", with: "</video></p>")
        htmlStrTemp = htmlStrTemp.replacingOccurrences(of: "/></p><br/>", with: "/></p>")
        let htmlGC = OCGumboDocument.init(htmlString: htmlStrTemp)
        var parserModelArrayResult = [SQParserModel]()
        for att in (htmlGC?.body.childNodes)! {
            let parserModel = SQParserModel()
            parserModel.itemArray.append(SQParserItemModel())
            let attModel: OCGumboNode = att as! OCGumboNode
            getPassModel(attModel, parserModel)
            if parserModel.isImage {
                let attValue = infoModel.getShowUrlAndId(type: .image, urlString: parserModel.link)
                parserModel.id = attValue.id
                parserModel.fileLink = attValue.filePath
                parserModel.showLink = attValue.showLink
                parserModel.originalLink = attValue.originalUrl
                parserModel.size     = attValue.size
                parserModelArrayResult.append(parserModel)
            }
            
            if parserModel.isVideo {
                let attValue = infoModel.getShowUrlAndId(type: .video, urlString: parserModel.link)
                parserModel.fileLink = attValue.filePath
                parserModel.showLink = attValue.showLink
                parserModel.originalLink = attValue.originalUrl
                parserModel.id       = attValue.id
                parserModel.status   = attValue.status
                parserModelArrayResult.append(parserModel)
            }
            
            if parserModel.isAudio {
                let attValue = infoModel.getShowUrlAndId(type: .music, urlString: parserModel.link)
                parserModel.fileLink = attValue.filePath
                parserModel.showLink = attValue.showLink
                parserModel.id       = attValue.id
                parserModel.name     = attValue.fileName
                parserModel.originalLink = attValue.originalUrl
                parserModelArrayResult.append(parserModel)
            }
            
            if parserModel.isHr {
                parserModelArrayResult.append(parserModel)
            }
            
            for index in 0..<parserModel.itemArray.count {
                let subParserModel = SQParserModel()
                let item = parserModel.itemArray[index]
                subParserModel.wordTypeArrayM = item.wordTypeArrayM
                subParserModel.isBlockquote  = parserModel.isBlockquote
                if index == parserModel.itemArray.count - 1 {
                    subParserModel.content       = parserModel.content
                }else{
                    subParserModel.content       = item.content
                }
                
                parserModelArrayResult.append(subParserModel)
            }
        }
        
        return parserModelArrayResult
    }
    
    class func getPassModel(_ node: OCGumboNode, _ model: SQParserModel) {
        let titleStr = node.nodeName
        if (titleStr != nil) {
            if (node.nodeValue != nil) {
                let titleValue = node.nodeValue!
                model.content = model.content + titleValue
                TiercelLog("model.content  = \(titleValue)")
            }else{
                if titleStr!.lowercased().contains("br") {
                    model.content = model.content + "\n"
                    let item      = model.itemArray.last!
                    item.content  = model.content
                    model.content = ""
                    let itemModel = SQParserItemModel()
                    model.itemArray.append(itemModel)
                }else{
                  setParserModelTitle(titleStr!, model)
                  
                }
                TiercelLog("titleStr  = \(titleStr!)")
            }
        }
        
        if node.childNodes.count > 0 {
            for childNode in node.childNodes {
                let nodeTemp: OCGumboNode  = childNode as! OCGumboNode
                getPassModel(nodeTemp, model)
            }
        }
        
        if node is OCGumboElement {
            let nodeGumboElement: OCGumboElement = node as! OCGumboElement
            for attr in nodeGumboElement.attributes {
                let attrTemp: OCGumboAttribute = attr as! OCGumboAttribute
                let linkUrl = attrTemp.value
                if (linkUrl?.hasPrefix("http:") ?? false) || (linkUrl?.hasPrefix("https:") ?? false){
                    model.link = attrTemp.value
                    break
                }
                TiercelLog("model.link  = \(model.link)")
            }
        }
    }
    
    class func setParserModelTitle(_ titleString: String,_ model: SQParserModel) {
        if titleString.lowercased().contains("hr") {
            model.isHr = true
            return
        }
        
        if titleString.lowercased().contains("img") {
            model.isImage = true
            return
        }
        
        if titleString.lowercased().contains("video") {
            model.isVideo = true
            return
        }
        
        if titleString.lowercased().contains("audio") {
            model.isAudio = true
            return
        }
        
        if titleString.lowercased() == "p" {
            return
        }
        
        var subItem = model.itemArray.last!
        if model.content.count > 0 {
            subItem.content  = model.content
            model.content = ""
            let item      = SQParserItemModel()
            model.itemArray.append(item)
            subItem       = item
        }
        
        if titleString.lowercased().contains("em") {
            subItem.wordTypeArrayM.append(.em)
        }
        
        if titleString.lowercased().contains("strong") { ///如果是标题，加粗格式就忽略
            if subItem.wordTypeArrayM.contains(.h1) ||
                subItem.wordTypeArrayM.contains(.h2) ||
                subItem.wordTypeArrayM.contains(.h3) ||
                subItem.wordTypeArrayM.contains(.h4) {
                
            }else{
              subItem.wordTypeArrayM.append(.strong)
            }
        }
        
        if titleString.lowercased().contains("h1") {
            subItem.wordTypeArrayM.append(.h1)
        }
        
        if titleString.lowercased().contains("h2") {
            subItem.wordTypeArrayM.append(.h2)
        }
        
        if titleString.lowercased().contains("h3") {
            subItem.wordTypeArrayM.append(.h3)
        }
        
        if titleString.lowercased().contains("h4") {
            subItem.wordTypeArrayM.append(.h4)
        }
        
        if titleString.lowercased().contains("h5") {
            subItem.wordTypeArrayM.append(.h4)
        }
        
        if titleString.lowercased().contains("h6") {
            subItem.wordTypeArrayM.append(.h4)
        }
        
        if titleString.contains("span") {
            subItem.wordTypeArrayM.append(.through)
        }
        
        if titleString.contains("blockquote") {
            model.isBlockquote = true
        }
        
    }
    
    
    ///转义字符切换成需要的字符
    class func stringChangeBackMeans(_ string: String) -> String {
        var tempStr = string.replacingOccurrences(of: "&quot;", with: "\"")
        tempStr = tempStr.replacingOccurrences(of: "&mdash;", with: "-")
        tempStr = tempStr.replacingOccurrences(of: "&lt;", with: "<")
        tempStr = tempStr.replacingOccurrences(of: "&gt;", with: ">")
        tempStr = tempStr.replacingOccurrences(of: "&nbsp;", with: " ")
        tempStr = tempStr.replacingOccurrences(of: "&rdquo;", with: "”")
        tempStr = tempStr.replacingOccurrences(of: "&ldquo;", with: "“")
        tempStr = tempStr.replacingOccurrences(of: "&lsquo;", with: "‘")
        tempStr = tempStr.replacingOccurrences(of: "&rsquo;", with: "’")
        tempStr = tempStr.replacingOccurrences(of: "&middot;", with: ".")
        tempStr = tempStr.replacingOccurrences(of: "&aacute;", with: "?")
        tempStr = tempStr.replacingOccurrences(of: "&yen;", with: "￥")
        tempStr = tempStr.replacingOccurrences(of: "&hellip;", with: "......")
        tempStr = tempStr.replacingOccurrences(of: "&aacute;", with: "?")
        tempStr = tempStr.replacingOccurrences(of: "&aacute;", with: "?")
        tempStr = tempStr.replacingOccurrences(of: "&amp;", with: "&")
        return tempStr
    }
}


class SQParserModel: NSObject {
    
    var id               = 0
    var name             = ""
    var duration: Int64 = 0
    ///视频
    var isVideo = false
    ///视频播放状态
    var status  = 0
    /// 图片
    var isImage = false
    
    ///音频
    var isAudio = false
    
    lazy var wordTypeArrayM   = [SQWriteArticleWordType]()
    
    ///引用
    var isBlockquote = false
    
    /// 段落线
    var isHr   = false
    
    /// 附件链接
    var link   = ""
    
    /// 字体内容
    var content = ""
    
    var fileLink = ""
    var showLink = ""
    var originalLink = ""
    var size = CGSize.zero
    
    var itemArray  = [SQParserItemModel]()
    
    func toAccountFileListInfoModel() -> SQAccountFileItemModel {
        let infoModel = SQAccountFileItemModel()
        infoModel.url = link
        infoModel.type = "image"
        
        if isVideo {
           let coverModel = SQAccountCoversModel()
           coverModel.cover_url = link
           infoModel.covers      = [coverModel]
           infoModel.type  = "video"
        }
        
        if isAudio {
            infoModel.type = "music"
        }
        
        return infoModel
    }
    
    func getAttStrType(size: CGSize, handel: ((SQContentDrawAttStrViewProtocol) -> ())? = nil) -> (NSAttributedString, SQContentDrawAttStrViewProtocol?) {
         /// 首先判断 是不是附件
        
        if isHr { /// 段落线附件
            return (NSMutableAttributedString.getLineValue(),nil)
        }
        
        //let model = self.toAccountFileListInfoModel()
        if isImage || isVideo || isAudio { //附件image
            var drawStrView: SQContentDrawAttStrViewProtocol?
            let idStr = "\(id)"
            if isImage {
                drawStrView = SQContentDrawAttStrImageViewFactory()
                    .getDrawAttStrViewProtocol(
                        idStr: idStr,
                        dispLink: showLink,
                        fileLink: fileLink,
                        audioName: "",
                        size: self.size,
                        handel: nil
                )
            }
            
            if isVideo {
                drawStrView = SQContentDrawAttStrVideoViewFactory()
                    .getDrawAttStrViewProtocol(
                        idStr: idStr,
                        dispLink: showLink,
                        fileLink: fileLink,
                        audioName: "",
                        size: CGSize.zero,
                        handel: nil
                )
            }
            
            if isAudio {
                drawStrView = SQContentDrawAttStrAudioViewFactory()
                    .getDrawAttStrViewProtocol(
                        idStr: idStr,
                        dispLink: showLink,
                        fileLink: fileLink,
                        audioName: name,
                        size: CGSize.zero,
                        handel: nil
                )
            }
            
           let attStr = drawStrView!.toMutableAttributedString()
            
           return (attStr, drawStrView)
        }
        
        var attriDict = Dictionary<String, Any>.defaultAttriDict()
        for type in wordTypeArrayM {
            switch type {
            case .strong://加粗
                attriDict = attriDict.appendStrongValue()
            case .through://删除
                attriDict = attriDict.appendThroughValue()
            case .em://斜体
                attriDict = attriDict.appendEmValue()
            case .h1://标题h1
                attriDict = attriDict.appendH1Value()
                break
            case .h2://标题h2
                attriDict = attriDict.appendH2Value()
                break
            case .h3://标题h3
                attriDict = attriDict.appendH3Value()
                break
            case .h4://标题h4
                attriDict = attriDict.appendH4Value()
                break
            case .blockquote:
                break
            }
        }
        
        if isBlockquote {
            attriDict = attriDict.appendBorderValue()
        }
        
        let attStr = NSMutableAttributedString.init(string: content)
        attStr.yy_setAttributes(attriDict)
        return (attStr, nil)
    }
    
    func getAttStr() -> NSAttributedString {
        let attStrM = NSMutableAttributedString()
        return attStrM
    }
}


class SQParserItemModel: NSObject{
    var content: String = ""
    var wordTypeArrayM   = [SQWriteArticleWordType]()
}
