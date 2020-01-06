//
//  SQHomeArticleInfoVC+Attachment.swift
//  SheQu
//
//  Created by gm on 2019/6/27.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

extension SQHomeArticleInfoVC {
    
    func getAttachment(_ model: SQParserModel,_ isNeedPass: Bool, _ attStrM: NSMutableAttributedString) -> NSAttributedString {
        if model.isImage {
            return getImageAttachment(model, isNeedPass, attStrM)
        }
        if model.isAudio {
            return getAudioAttachment(model, isNeedPass)
        }
        return getVideoAttachment(model, isNeedPass)
    }
    
    
    func getImageAttachment(_ model: SQParserModel,_ isNeedPass: Bool, _ attStrM: NSMutableAttributedString) -> NSAttributedString{
        var attStr = NSAttributedString()
        weak var weakSelf = self
        if isNeedPass {
            let drawAttStrView = drawViewArrayM.first(where: { (findView) -> Bool in
                return findView.idStr.hasSuffix("\(model.id)")
            })
            
            if (drawAttStrView != nil) {

                attStr = drawAttStrView!
                    .copyImageView()
                    .toMutableAttributedString()
            }
        }else{
            let imageValue = model.getAttStrType(size: view.size(), handel: nil)
            attStr = imageValue.0
            if (imageValue.1 != nil) {
                let imageViewAtt = imageValue.1 as! SQContentDrawAttStrImageView
                imageViewAtt.originalUrl = model.originalLink
                imageViewAtt.tag = weakSelf?.drawViewArrayM.count ?? 0
                imageViewAtt.startClickImageView { (imageProtocol) in
                    weakSelf?.startClickImageView(imageProtocol.fileLink, imageViewAtt.tag)
                }
                
                weakSelf?.drawViewArrayM.append(imageViewAtt)
            }
        }
        
        return attStr
    }
    
    func getVideoAttachment(_ model: SQParserModel,_ isNeedPass: Bool) -> NSAttributedString{
        var attStr = NSAttributedString()
        let attStrType = model.getAttStrType(size: view.size())
        attStr = attStrType.0
        var attView = attStrType.1!
        attView.fileLink = model.fileLink
        if !isNeedPass {
            weak var weakSelf = self
            let attViewTemp: SQContentDrawAttStrVideoView = attView as! SQContentDrawAttStrVideoView
            attViewTemp.originalLink = model.originalLink
            attViewTemp.status = model.status
            attViewTemp.startPlayVideo { (attAudioView) in
                weakSelf?.startPlayVideo(attAudioView.fileLink, model.status)
            }
            
            
            attViewTemp.listeningEvent(events: [.download,.larger]) {[weak self] (videoView, event) in
                ///处理文章详情下载功能
                if event == .download {
                    self?.downloadOriginalUrl(videoID: model.id)
                   return
                }
                
                let oldFrame = weakSelf!.textView.convert(attViewTemp.frame, to: UIApplication.shared.keyWindow)
                let item = SQBrowserImageViewItem.init(
                    blurredImageLink: videoView.dispLink,
                    originalImageLink: videoView.originalLink,
                    oldFrame: oldFrame,
                    contentModel: .scaleAspectFill
                )
                
                SQBrowserImageViewManager
                    .showBrowserImageView(
                        browserImageViewItemArray: [item],
                        selIndex: 0
                )
            }
            
            videoArray.append(attView as! SQContentDrawAttStrVideoView)
        }
        return attStr
    }
    
    func getAudioAttachment(_ model: SQParserModel,_ isNeedPass: Bool) -> NSAttributedString{
        var attStr = NSAttributedString()
        
        let attStrType = model.getAttStrType(size: view.size())
        attStr = attStrType.0
        let attView  = attStrType.1
        if attView != nil {
            let attViewTemp: SQContentDrawAttStrAudioView = attView as! SQContentDrawAttStrAudioView
            attViewTemp.update(audioName: model.name)
            if !isNeedPass {
                attViewTemp.aniImageView.image = UIImage.init(named: "home_audio_pause")
                attViewTemp.createPlayToolByUrlStr(
                    urlStr: model.fileLink)
                audioArray.append(attViewTemp)
                weak var weakSelf = self
                attViewTemp.callBack = { respondAttw in
                    for findAttView in weakSelf!.audioArray {
                        findAttView.manuelPause()
                    }
                }
            }
        }
        
        return attStr
    }
    
}
