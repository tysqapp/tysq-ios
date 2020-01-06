//
//  SQHomeArticleInfoVC+Event.swift
//  SheQu
//
//  Created by gm on 2019/5/28.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

extension SQHomeArticleInfoVC {
    func startEdit() {
        let writeArticleVC = SQHomeWriteArticleVC()
        writeArticleVC.status = tableHeaderView.infoModel.status
        writeArticleVC.article_id = article_id
        writeArticleVC.isPut = true //确认是put防范
        writeArticleVC.publishBtn.isEnabled = true
        writeArticleVC.publishBtn.updateBGColor()
    
        writeArticleVC.writeArticleView.titleTF.text = tableHeaderView.infoModel.title
        
        let attributedTextValue = showTextView(modelArray: self.parserModelArray, isPass: true)
        writeArticleVC.cell.textView.attributedText = attributedTextValue
        

        
        /// 组装分类数据
        let category_infoArray  = SQHomeTableViewController.homeCategory!.category_info
        writeArticleVC.writeArticleView.chooseCategoryView.model = SQHomeTableViewController.homeCategory!.category_info
         writeArticleVC.model = category_infoArray
        var category_info    = SQHomeCategoryInfo()
        var subCategory_info = SQHomeCategorySubInfo()
        var levelSel1        = -1
        var levelSel2        = -1
        for index in 0..<category_infoArray.count {
            let categoryInfo = category_infoArray[index]
            
            if categoryInfo.id == tableHeaderView.infoModel.category_id {
                category_info  = categoryInfo
                levelSel1      = index
                break
            }
            
            for tag in 0..<categoryInfo.subcategories.count {
                let subCategoryInfo = categoryInfo.subcategories[tag]
                if subCategoryInfo.id == tableHeaderView.infoModel.category_id {
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
           writeArticleVC.writeArticleView.chooseCategoryView.level1Label.tag = levelSel1
            writeArticleVC.writeArticleView.chooseCategoryView.level1Label.text = category_info.name
        }
        
        if levelSel2 >= 0 {
            let attMid = NSAttributedString.init(string: "  ▶  ", attributes: [NSAttributedString.Key.font : k_font_title_11,NSAttributedString.Key.foregroundColor: k_color_title_gray_blue])
            attStrM.append(attMid)
            
            let subAttStr = NSAttributedString.init(string: subCategory_info.name, attributes: attr)
            attStrM.append(subAttStr)
           writeArticleVC.writeArticleView.chooseCategoryView.level2Label.tag = levelSel2
            writeArticleVC.writeArticleView.chooseCategoryView.level2Label.text = subCategory_info.name
        }
        
        writeArticleVC.isCategoryClick = true
        writeArticleVC.writeArticleView.chooseCategoryTF.attributedText = attStrM
        writeArticleVC.writeArticleView.titlesArrayM =  tableHeaderView.infoModel.label
        writeArticleVC.writeArticleView.initMarksView()
        ///组装视频的参数
        if tableHeaderView.infoModel.videos.count > 0 {
            for video in tableHeaderView.infoModel.videos {
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
            writeArticleVC.cell.textView.videoModelArray.append(fileListInfoModel)
            }
            
            
        }
        navigationController?.pushViewController(writeArticleVC, animated: true)
    }
    
    func deleteArticle() {
        weak var weakSelf = self
        let alertView = SQAlertView.sharedInstance
        alertView.showAlertView(title: "删除文章", message: "你确定删除该文章吗？删除后文章及评论内容都一起删除，且不可恢复", cancel: "取消", sure: "确定") { (index,tfStr1,tfStr2) in
            if index == 1 {
                weakSelf!.deleteArticleFromNetWork()
            }
        }
    }
    
    func copyLink() {
        let pasteboard    = UIPasteboard.general
        /**
         和后台沟通后 服务器只会返回相对路径
         现在跳转pc端的接口规则为 数据源 + 后台返回相对路径
         
         为和安卓端统一
         现在跳转pc端的接口规则为 数据源 + "/" + 后台返回相对路径
         */
        pasteboard.string = SQHostStruct.getLoaclHost() + "/api/pages/info?article_id=\(article_id)"
        showToastMessage("拷贝链接成功")
    }
    
    func showAuditView() {
        auditView.showAuditView()
    }
    
    func jumpReportVC() {
        let reportVC = SQReportVC()
        reportVC.articleID = article_id
        reportVC.articleName = tableHeaderView.infoModel.title
        navigationController?.pushViewController(reportVC, animated: true)
    }
    
    func unHideArticle() {
        SQAlertView.sharedInstance.showAlertView(title: "确定取消隐藏吗？", message: "", cancel: "取消", sure: "确定") {[weak self] (tag,tfStr1,tfStr2) in
            if tag != 0 {
                self?.changeArticleHiddenState(state: 1, message: "取消隐藏成功")
            }
        }
    }
    
    func hideArticle() {
        SQAlertView.sharedInstance.showAlertView(title: "确定要把该文章隐藏吗？", message: "隐藏后，文章不显示在主页列表和推荐列表", cancel: "取消", sure: "确定") {[weak self] (tag,tfStr1,tfStr2) in
            if tag != 0 {
                self?.changeArticleHiddenState(state: -4, message: "隐藏成功")
            }
        }
    }
    
    override func addMore() {
        getComments()
    }
    
    @objc func scrollToCommentBtnClick(btn: UIButton) {
        if commentModelArray.count > 0 {
            let count = infoModelArray.count + 1
            let indexPath = IndexPath.init(row: count, section: 0)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                self.tableView.scrollToRow(
                    at: indexPath ,
                    at: .top,
                    animated: false
                )
            }
        }
    }
    
    @objc func editArticleBtnClick() {
        if (editArticleView == nil) {
            weak var weakSelf  = self
            editArticleView = SQEditArticleInfoView.init(
                frame: UIScreen.main.bounds,
                typeArray: typeEditArticleEventArrayM, handel: { (event) in
                switch event {
                case .edit:
                    weakSelf?.startEdit()
                case .delete:
                    weakSelf?.deleteArticle()
                case .copy:
                    weakSelf?.copyLink()
                case .audit:
                    weakSelf?.showAuditView()
                case .report:
                    weakSelf?.jumpReportVC()
                case .hidden:
                    weakSelf?.unHideArticle()
                case .hide:
                    weakSelf?.hideArticle()
                case .topping:
                    weakSelf?.toppingArticle()
                }
            })
        }
        editArticleView?.showBottomView()
    }
    
    
    /// 收藏文章按钮点击
    ///
    /// - Parameter btn: 收藏按钮
    @objc func collectBtnClick(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        btn.isEnabled = false
        updateArticleInfoCollectStatu(btn)
    }
    
    @objc func jumpCommentVC() {
        guard let _: String = UserDefaults.standard.object(forKey: k_ud_user) as? String else {
            let loginVC = SQLoginViewController.getLoginVC()
            present(loginVC, animated: true, completion: nil)
            return
        }
        
        let commentModel = SQCommentModel()
        commentModel.article_id = article_id
        getAccountScoreJudgement(commentModel, nil,true)
    }
    
    func jumpCommentVCByBottomCommentBtn(_ commentModel: SQCommentModel, _ replayCommentModel: SQCommentReplyModel?) {
        weak var weakSelf       = self
        let vc   = SQCommentViewController()
        vc.getCommentBy(commentModel, nil) { (replyModel) in
            let commentModel = replyModel.toCommentModel(weakSelf!.article_id)
            if weakSelf!.commentModelArray.count > 0 {
                let firstModel = weakSelf!.commentModelArray[0]
                firstModel.isFirstView = false
                firstModel.getCommentFrame()
                commentModel.totleNum = firstModel.totleNum + 1
                weakSelf?.commentModelArray.insert(commentModel, at: 0)
            }else{
                commentModel.totleNum  = 1
                weakSelf?.commentModelArray.append(commentModel)
            }
            
            UIView.performWithoutAnimation {
                weakSelf?.tableView.reloadData()
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func deleteBtnClick(btn: UIButton) {
        weak var weakSelf = self
        
        let alertView = SQAlertView.sharedInstance
        alertView.showAlertView(title: "你确定要删除这条评论吗?", message: "", cancel: "取消", sure: "确定") { (index,tfStr1,tfStr2) in
            if index == 1 {
                weakSelf?.deleteComment(btn: btn)
            }
        }
        
    }
    
    func deleteComment(btn: UIButton) {
        let model = commentModelArray.first { (findeModel) -> Bool in
            return findeModel.id == btn.titleLabel!.text!
        }
        if model == nil {
            return
        }
        
        SQHomeNewWorkTool.deleteComment(model!.id) { (resultModel, statu, errorMessage) in
            if errorMessage != nil {
                return
            }
            let index: Int = self.commentModelArray.firstIndex(where: { (findeModel) -> Bool in
                return findeModel.id == btn.titleLabel!.text!
            }) ?? 0
            
            ///这里是当出现第一个评论时 样式上的变化
            if self.commentModelArray.count > 1 && index == 0 {
                let firstModelTemp = self.commentModelArray[1]
                firstModelTemp.isFirstView = true
                firstModelTemp.getCommentFrame()
                firstModelTemp.totleNum = model!.totleNum - 1
            }
            self.commentModelArray.remove(at: index)
            //let count = 1 + weakSelf!.infoModelArray.count
            
            let delCount = model!.reply.count + 1
            let dict = [
                "comment_num": delCount,
                "article_id": model!.article_id
                ] as [String : Any]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: k_noti_comment_num), object: dict)
            UIView.performWithoutAnimation {//取消刷新动画
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func replyBtnClick(btn: UIButton) {
        let model = commentModelArray.first { (findeModel) -> Bool in
            return findeModel.id == btn.titleLabel!.text!
        }
        replyComment(model!, nil)
    }
    
    func replyComment(_ commentModel: SQCommentModel, _ replyCommentModel: SQCommentReplyModel?) {
        guard let _: String = UserDefaults.standard.object(forKey: k_ud_user) as? String else {
            let loginVC = SQLoginViewController.getLoginVC()
            present(loginVC, animated: true, completion: nil)
            return
        }
        
        ///需要确定积分是否够才能发布评论
        getAccountScoreJudgement(commentModel, replyCommentModel)
        
    }
    
    
    func jumpCommentViewController(_ commentModel: SQCommentModel, _ replayCommentModel: SQCommentReplyModel?) {
        let vc    = SQCommentViewController()
        navigationController?.pushViewController(vc, animated: true)
        
        weak var weakSelf = self
        vc.getCommentBy(commentModel, replayCommentModel) { (replyModel) in
            weakSelf?.updateReplyModel(commentModel, replyModel)
        }
    }
    
    func updateReplyModel(_ commentModel: SQCommentModel,_ replyModel: SQCommentReplyModel) {
        
        if commentModel.reply.count > 0 {
            commentModel.reply.insert(replyModel, at: 0)
        }else{
            commentModel.reply.append(replyModel)
        }
        
        if commentModel.reply.count > 3 {
            commentModel.reply.remove(at: 3)
        }
        
        commentModel.getCommentFrame()
        let index: Int = commentModelArray.firstIndex(where: { (findModel) -> Bool in
            return findModel.id == commentModel.id
        }) ?? 0
        let count =  1 + infoModelArray.count
        
        UIView.performWithoutAnimation {
            tableView.reloadRows(at: [IndexPath.init(row: index + count, section: 0)], with: .none)
        }
        
        let dict = [
            "comment_num": -1,
            "article_id": commentModel.article_id
            ] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: k_noti_comment_num), object: dict)
    }
    
    @objc func getModelComment(btn: UIButton) {
        let model = commentModelArray[btn.tag]
        let vc    = SQFirstCommentViewController()
        navigationController?.pushViewController(vc, animated: true)
        vc.requestNetWork(model.article_id, model.id)
        
        weak var weakSelf = self
        vc.callBack = { (commentID, isDelete, modelArray) in
            if isDelete {
                let count = btn.tag + 1 + weakSelf!.infoModelArray.count
                let indexPathArray = [NSIndexPath.init(row: count, section: 0) as IndexPath]
                if model.id == commentID {
                    weakSelf!.commentModelArray.remove(at: btn.tag)
                    UIView.performWithoutAnimation {
                        weakSelf!.tableView.deleteRows(at: indexPathArray, with: .none)
                    }
                }else {
                    model.reply.removeAll()
                    if modelArray.count > 3 {
                        for index in 0...2 {
                            model.reply.append(modelArray[index])
                        }
                    }else{
                        model.reply.append(contentsOf: modelArray)
                    }
                    model.getCommentFrame()
                    UIView.performWithoutAnimation {
                        weakSelf?.tableView.reloadRows(at: indexPathArray, with: .none)
                    }
                }
            }else{
                weakSelf!.updateReplyModel(model, modelArray.first!)
            }
            
        }
        
    }
    
    func jumpForbinCommentVC(_ accountID: Int) {
        
    }
    
    func startClickImageView(_ urlLink: String,_ tag: Int) {
        var showImageArray = [SQBrowserImageViewItem]()
        for imageAtt in drawViewArrayM {
            let oldFrame = textView.convert(imageAtt.frame, to: UIApplication.shared.keyWindow)
            let item = SQBrowserImageViewItem.init(blurredImageLink: imageAtt.fileLink, originalImageLink: imageAtt.originalUrl, oldFrame: oldFrame, contentModel: .scaleAspectFit)
            showImageArray.append(item)
        }
        
        SQBrowserImageViewManager
            .showBrowserImageView(browserImageViewItemArray: showImageArray, selIndex: tag)
    }
    
    func startPlayVideo(_ urlLink: String,_ status: Int) {
        
        ///只有在文章发布的情况下 才显示视频未转码
        if status != 1 && tableHeaderView.infoModel.status == SQArticleAuditStatus.publish.rawValue  {
            SQToastTool.showToastMessage("视频转码中,请稍后再播")
            return
        }
        
        var requsetStr = urlLink
        ///4.1不添加视频缓存功能 所以注释掉
        if tableHeaderView.infoModel.status == SQArticleAuditStatus.publish.rawValue {
            let path = VideoDataTool.urlStrRemoveServer(urlStr: requsetStr)
            requsetStr = LocalServer.getLocalServer() + path.1 + "?=host" + path.0
        }
        
        
        IJKVideoViewController.present(
        from: self,
        withTitle: "",
        url: URL.init(string: requsetStr.encodeURLCodeStr())) {}
    }
    
    //MARK: ------------------处理文章详情显示验证码逻辑-------------------
    
    /// 验证码取消操作
    func captchaViewCancel() {
        showCaptchaView.hiddenCaptchaView()
        navigationController?.popViewController(animated: true)
    }
    
    /// 验证码提交操作
    func captchaViewSubmit() {
        vfArticleCaptcha()
    }
    
    /// 验证码刷新操作
    func captchaViewRefresh() {
        getArticleCaptcha()
    }
    
    
    /// 删除审核文章列表
    func deleteAdultArticleList() {
        let dict = [SQCheckPendingArticleVC.noti_audit_article_delete_key: article_id]
        NotificationCenter.default.post(
            name: SQCheckPendingArticleVC.noti_audit_article_delete,
            object: dict
        )
    }
}
