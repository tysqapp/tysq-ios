//
//  sdsd.swift
//  SheQu
//
//  Created by gm on 2019/11/14.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

import UIKit

extension SQHomeWriteArticleVC {
    
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
        let imageValue = model.getAttStrType(size: view.size(), handel: nil)
        attStr = imageValue.0
        if (imageValue.1 != nil) {
            let imageViewAtt = imageValue.1 as! SQContentDrawAttStrImageView
            imageViewAtt.originalUrl = model.originalLink
        }
        
        return attStr
    }
    
    func getVideoAttachment(_ model: SQParserModel,_ isNeedPass: Bool) -> NSAttributedString{
        var attStr = NSAttributedString()
        let attStrType = model.getAttStrType(size: view.size())
        attStr = attStrType.0
        var attView = attStrType.1!
        attView.fileLink = model.fileLink
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
        }
        
        return attStr
    }
    
    func startEdit(infoModel: SQArticleInfoModel) {
        self.status = infoModel.status
        self.article_id = infoModel.article_id
        self.isPut = true //确认是put防范
        self.writeArticleView.titleTF.text = infoModel.title
        
        let attributedTextValue = showTextView(modelArray: self.parserModelArray, isPass: true)
        self.cell.textView.attributedText = attributedTextValue
        
        /// 组装分类数据
        let category_infoArray  = SQHomeTableViewController.homeCategory!.category_info
        self.writeArticleView.chooseCategoryView.model = SQHomeTableViewController.homeCategory!.category_info
         self.model = category_infoArray
        var category_info    = SQHomeCategoryInfo()
        var subCategory_info = SQHomeCategorySubInfo()
        var levelSel1        = -1
        var levelSel2        = -1
        for index in 0..<category_infoArray.count {
            let categoryInfo = category_infoArray[index]
            
            if categoryInfo.id == infoModel.category_id {
                category_info  = categoryInfo
                levelSel1      = index
                break
            }
            
            for tag in 0..<categoryInfo.subcategories.count {
                let subCategoryInfo = categoryInfo.subcategories[tag]
                if subCategoryInfo.id == infoModel.category_id {
                    levelSel1 = index
                    levelSel2 = tag
                     category_info  = categoryInfo
                    subCategory_info = subCategoryInfo
                    break
                }
            }
        }
        
        let attr = [
            NSAttributedString.Key.font: k_font_title,
            NSAttributedString.Key.foregroundColor: k_color_black
        ]
        let attStrM = NSMutableAttributedString()
        if levelSel1 >= 0 {
            let level1 = NSAttributedString.init(string: category_info.name, attributes: attr)
           attStrM.append(level1)
            self.writeArticleView.chooseCategoryView.level1Label.tag = levelSel1
            self.writeArticleView.chooseCategoryView.level1Label.text = category_info.name
            self.publishBtn.isEnabled = true
            self.publishBtn.updateBGColor()
        }
        
        if levelSel2 >= 0 {
            let attMid = NSAttributedString.init(string: "  ▶  ", attributes: [NSAttributedString.Key.font : k_font_title_11,NSAttributedString.Key.foregroundColor: k_color_title_gray_blue])
            attStrM.append(attMid)
            
            let subAttStr = NSAttributedString.init(string: subCategory_info.name, attributes: attr)
            attStrM.append(subAttStr)
            self.writeArticleView.chooseCategoryView.level2Label.tag = levelSel2
            self.writeArticleView.chooseCategoryView.level2Label.text = subCategory_info.name
        }
        
        self.isCategoryClick = true
        self.writeArticleView.chooseCategoryTF.attributedText = attStrM
        self.writeArticleView.titlesArrayM =  infoModel.label
        self.writeArticleView.initMarksView()
        ///组装视频的参数
        if infoModel.videos.count > 0 {
            for video in infoModel.videos {
                let fileListInfoModel = SQAccountFileItemModel()
                for cover in video.cover {
                    let coverModel = SQAccountCoversModel()
                    coverModel.id  = UInt64(cover.id)
                    coverModel.cover_url = cover.url
                    fileListInfoModel.covers.append(coverModel)
                }
                
                for screanShot in video.screen_shot {
                    let screanShotModel = SQAccountScreenShotsModel()
                    screanShotModel.id  = UInt64(screanShot.id)
                    screanShotModel.screenshots_url = screanShot.url
                    fileListInfoModel.screenshots.append(screanShotModel)
                }
                
                fileListInfoModel.url = video.video.url
                fileListInfoModel.id  = Int32(video.video.id)
            self.cell.textView.videoModelArray.append(fileListInfoModel)
            }
        }
    }

    
}

