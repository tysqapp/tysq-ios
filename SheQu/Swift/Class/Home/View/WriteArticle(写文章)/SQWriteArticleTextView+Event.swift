//
//  SQWriteArticleTextView+Event.swift
//  SheQu
//
//  Created by gm on 2019/7/3.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

extension SQWriteArticleTextView {
    func addCallBack() {
        
        weak var weakSelf = self
        ///富文本编辑器文本样式回调
        customInputAccessoryView.wordStyleView.callBack = { (typeArray,currentType) in
            weakSelf?.wordTypeArrayM = typeArray
            let typingAttributes = weakSelf!.getTypingAttributesFrom()
            weakSelf?.typingAttributes = typingAttributes
            
            ///如果是块级元素
            if currentType == SQWriteArticleWordType.h1 ||
                currentType == SQWriteArticleWordType.h2 ||
                currentType == SQWriteArticleWordType.h3 ||
                currentType == SQWriteArticleWordType.h4 {
                weakSelf?.updateBlockquoteElementSelText(att: typingAttributes,currentType: currentType)
            }else{
              weakSelf?.updateLineElementSelText(
                att: typingAttributes,
                updateRange: weakSelf!.selectedRange,
                selRange: weakSelf!.selectedRange,
                currentType: currentType
                )
            }
        }
        
        ///文件样式回调
        customInputAccessoryView.callBack = { type in
            if type == .blockquote {//代码块
                let att = weakSelf!.getTypingAttributesFrom()
                weakSelf!.typingAttributes = att
                weakSelf!.updateBlockquoteElementSelText(att: att, currentType: SQWriteArticleWordType.blockquote)
            }
            
            if type == .lines {//线段
                let tempAtt = weakSelf?.typingAttributes
                weakSelf!.appendLineToTextView(
                  NSMutableAttributedString.getLineValue()
                )
                weakSelf?.typingAttributes = tempAtt
            }
            
            if type == .close {
                weakSelf!.endEditing(true)
                return
            }
            
            ///从服务器拿数据回调
            if type == .video ||
                type == .image ||
                type == .music{//视频
                if ((weakSelf?.customDelegate) != nil) {
                    weakSelf!.customDelegate?.writeArticleTextView(
                        textView: weakSelf!,
                        inputAccessoryViewStyleChange: type,
                        handel: { (fileListInfoModel) in
                        weakSelf!.appendFileToTextView(fileListInfoModel)
                        if type == .video {
                            weakSelf!.videoModelArray.append(contentsOf: fileListInfoModel)
                        }
                    })
                }
            }
            
            
        }
    }
    
    ///添加文件 图片 视频 音乐到文本编辑器
    func appendFileToTextView(_ model: [SQAccountFileItemModel]) {
        for infoModel in model {
            let type = SQAccountFileListType.init(rawValue: infoModel.type)
            var drawAttStrView: SQContentDrawAttStrViewProtocol?
            let idStr         = "\(infoModel.id)"
            let showImageLink = infoModel.getShowImageLink()
            let filePath      = infoModel.url
            switch type! {
            case .image:
                let imageViewSize = CGSize.init(width: infoModel.width, height: infoModel.height)
                drawAttStrView = SQContentDrawAttStrImageViewFactory().getDrawAttStrViewProtocol(
                    idStr: idStr,
                    dispLink: showImageLink,
                    fileLink: filePath,
                    audioName: "", size: imageViewSize,
                    handel: { drawAttImageView in
                        drawAttStrView = drawAttImageView
                })
                
            case .video:
                drawAttStrView = SQContentDrawAttStrVideoViewFactory().getDrawAttStrViewProtocol(
                    idStr: idStr,
                    dispLink: showImageLink,
                    fileLink: filePath,
                    audioName: "", size: CGSize.zero, handel: nil
                )
            case .music:
                drawAttStrView = SQContentDrawAttStrAudioViewFactory().getDrawAttStrViewProtocol(
                    idStr: idStr,
                    dispLink: showImageLink,
                    fileLink: filePath,
                    audioName: infoModel.filename,
                    size: CGSize.zero,
                    handel: nil
                )
            case .others:
                break
            }
            
            let attStr = drawAttStrView?.toMutableAttributedString()
            
            appendLineToTextView(attStr!)
        }
    }
    
    
    
    /// 更新块级元素 状态有三种
    /// 1.在换行符后 选中长度为0(包括在句首) 整个段落选中
    /// 2.在某段落中间或者后面 选中长度没有覆盖其它段落 整个段落选中
    /// 3.长度覆盖多个段落 多个段落都为选中
    /// - Parameter att: 样式
    func updateBlockquoteElementSelText(att: [String: Any], currentType: SQWriteArticleWordType) {
        //处理第一种情况 文章开头或者句首情况
        var frontStr = ""
        if selectedRange.location > 0 && selectedRange.length == 0{ ///如果不是在文章开始 判断是不是句首 如果frontStr == "\n"则在句首
            let frontRange = NSRange.init(
                location: selectedRange.location - 1,
                length: 1
            )
            
            let frontAtt = attributedText!.attributedSubstring(from: frontRange)
            frontStr = frontAtt.string
        }
        
        //第一种情况
        if attributedText?.length == 0 || (frontStr == "\n" && selectedRange.location == attributedText!.length) {
            return
        }
        
        //判断是不是单个段落 就是判断选中的字符串里面有没有包涵\n
        var selText = ""
        if selectedRange.length > 0 {
            let selAtt = attributedText!.attributedSubstring(from: selectedRange)
            selText = selAtt.string
        }
        
        //第二种情况
        if selectedRange.length == 0 ||
            !selText.contains("\n") {
            //获取单个段落
            let fulleStr = attributedText!.string
            let lineStrArray = fulleStr.components(separatedBy: "\n")
            var length = 0 //记录每片总和
            var startLocation = 0
            var lineLength    = 0
            for index in 0..<lineStrArray.count {
                let subStr = lineStrArray[index]
                startLocation = length
                length += subStr.count
                
                //添加上"\n"长度 最后一个不需要添加
                if index != lineStrArray.count - 1 {
                   length += 1
                }
                
                if length >= selectedRange.location {
                    if frontStr != "\n" || selectedRange.location == 0 {
                        lineLength = length - startLocation
                    }else{
                        let selStr = lineStrArray[index + 1]
                        startLocation = length
                        lineLength    = selStr.count
                    }
                    break
                }
            }
            
            let updateRange = NSRange.init(
                location: startLocation,
                length: lineLength
            )
            
            updateLineElementSelText(
                att: att,
                updateRange: updateRange,
                selRange: selectedRange,
                currentType: currentType
            )
            
            return
        }
        
        //第三种状况 多行
        if selText.contains("\n") {
            let fulleStr = attributedText!.string
            let lineStrArray = fulleStr.components(separatedBy: "\n")
            var startLocation = -1
            var contentLength = 0
            var length        = 0
            let selLength     = selectedRange.length + selectedRange.location
            for index in 0..<lineStrArray.count {
                let subStr = lineStrArray[index]
                length     += subStr.count
                if index != lineStrArray.count - 1 {
                    length += 1
                }
                
                if length >= selectedRange.location && startLocation == -1{
                    if frontStr != "\n" {
                        startLocation = length - subStr.count - 1
                    }else{
                        startLocation = length
                    }
                }
                
                if startLocation != -1 {
                    if length >= selLength {
                        contentLength = length - startLocation
                        break
                    }
                }
            }
            
            let updateRange = NSRange.init(
                location: startLocation,
                length: contentLength
            )
            
            updateLineElementSelText(
                att: att,
                updateRange: updateRange,
                selRange: selectedRange,
                currentType: currentType
            )
        }
    }
    
    ///更新行级元素选中状态
    func updateLineElementSelText(att: [String: Any], updateRange: NSRange, selRange: NSRange, currentType: SQWriteArticleWordType) {
        if (attributedText != nil && updateRange.length > 0) {
            let atMiddle  =  attributedText!.attributedSubstring(from: updateRange)
            let attM      = NSMutableAttributedString()
            if updateRange.location != 0 {
                let firstRange = NSRange.init(
                    location: 0,
                    length: updateRange.location
                )
                
                let atFirst  = attributedText!.attributedSubstring(from: firstRange)
                attM.append(atFirst)
            }
            
            if currentType == .h1 || currentType == .h2 || currentType == .h3 || currentType == .h4 || currentType == .blockquote {
                let atMiddleM = NSMutableAttributedString.init(attributedString: atMiddle)
                if currentType == .blockquote {
                   attM.append(updateBlockquoto(atMiddleM))
                }else{
                    if wordTypeArrayM.contains(currentType) {
                       atMiddleM.updateType(currentType)
                    }else{
                        atMiddleM.updateNormalFont()
                    }
                    
                    attM.append(atMiddleM)
                }
            }else{
                let middleAttri = NSMutableAttributedString.init(string: atMiddle.string)
                middleAttri.yy_setAttributes(att)
                attM.append(middleAttri)
            }
            
            
            let selTotleLength = updateRange.location + updateRange.length
            let behindLength = attributedText!.length - selTotleLength
            if behindLength > 0 {
                let begindRange = NSRange.init(
                    location: selTotleLength,
                    length: behindLength
                )
                
                let behind   = attributedText!.attributedSubstring(from: begindRange)
                attM.append(behind)
            }
            attributedText = attM
            selectedRange = selRange
        }
    }
    
    func updateBlockquoto(_ atMiddleM: NSMutableAttributedString) -> NSMutableAttributedString {
        let atMiddleMTemp = NSMutableAttributedString()
        //weak var weakSelf = self
        let needBorder = customInputAccessoryView.blockquoteBtn.isSelected
        atMiddleM.enumerateAttributes(in: NSRange.init(location: 0, length: atMiddleM.length), options: .longestEffectiveRangeNotRequired) { (dict, range, errorMessage) in
            var dictTemp: [String : Any] = Dictionary()
            for key in dict.keys {
                dictTemp["\(key.rawValue)"] = dict[key]
            }
            let subTemp = NSMutableAttributedString.init(string: atMiddleM.attributedSubstring(from: range).string)
            let  paragraphKey = Dictionary<String, Any>.paragraphKey()
            let borderKey = Dictionary<String, Any>.borderKey()
            if needBorder {
                dictTemp[borderKey] = Dictionary<String, Any>.bordValue()
                dictTemp[paragraphKey] = Dictionary<String, Any>.bordParagraphValue()
            }else{
                dictTemp[borderKey] = Dictionary<String, Any>.zeroBord()
                dictTemp[paragraphKey] = Dictionary<String, Any>.paragraphValue()
            }
            subTemp.yy_setAttributes(dictTemp)
            atMiddleMTemp.append(subTemp)
        }
        
        return atMiddleMTemp
    }
    
    func getSelectedFrame() -> CGRect{
        if (selectedTextRange == nil) {
            return CGRect.zero
        }
        
        let rect = self.innerLayout.rect(for: selectedTextRange as! YYTextRange)
        return rect
    }
    
    func appendLineToTextView(_ attStr: NSAttributedString) {
        if (attributedText == nil) {
            attributedText = attStr
            selectedRange  = NSRange.init(location: attStr.length, length: 0)
            return
        }
        
        let tempRange = selectedRange
        let attStrM   = NSMutableAttributedString()
        if selectedRange.location != 0 {//判断是否有前段
            let firstAttStr = attributedText!.attributedSubstring(from: NSRange.init(location: 0, length: selectedRange.location))
            attStrM.append(firstAttStr)
        }
        
        attStrM.append(attStr)
        
        let mixValue = selectedRange.location + selectedRange.length
        let length = attributedText!.length - mixValue
        if length > 0  {//说明有结尾
            let tailAttStr = attributedText!.attributedSubstring(from: NSRange.init(location: mixValue, length: length))
            attStrM.append(tailAttStr)
        }
        
        attributedText = attStrM
        selectedRange  = NSRange.init(location: tempRange.location + attStr.length, length: 0)
        typingAttributes = Dictionary<String, Any>.defaultAttriDict()
        wordTypeArrayM.removeAll()
    }
}
