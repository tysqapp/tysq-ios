//
//  SQHomeArticleInfoVC+Network.swift
//  SheQu
//
//  Created by gm on 2019/5/23.
//  Copyright © 2019 sheQun. All rights reserved.
// 单独处理网络请求

import UIKit

//MARK ----------------------- 网络请求 -----------------

extension SQHomeArticleInfoVC {
    /**进入文章详情，规则判断顺序：登陆>阅读数量限制>等级要求>积分要求>验证码*/
    
    ///获取详情页面
    func getArticleInfo() {
        
        weak var weakSelf = self
        SQHomeNewWorkTool.getArticle(article_id, { (infoModel, statu, errorMessage, dataDict) in
            if (errorMessage != nil) {
                if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: statu, handel: { loginSuccess in
                    if loginSuccess {
                        weakSelf?.getArticleInfo()
                    }else{
                        weakSelf?.navigationController?
                            .popViewController(animated: true)
                    }
                }) {
                    return
                }
                SQEmptyView.showEmptyView(handel: { (click) in
                    if click {
                        weakSelf?.getArticleInfo()
                    }else{
                        weakSelf?.navigationController?
                            .popViewController(animated: true)
                    }
                })
                return
                
            }
            
            ///判断是否删除
            if infoModel!.status == SQArticleAuditStatus.delete.rawValue {
                weakSelf?.isDelete = true
                weakSelf?.updateDeleteArticleState()
            }
            
            ///5.2: 判断等级是否达到要求
            if !infoModel!.is_satisfy && statu == 3996 { ///如果是等级不够
               SQShowGradeView.showGradeView(
                vc: weakSelf,
                gradeValue: infoModel!.grade.toGradeName()
                )
                return
            }
            
            ///5.3: 判断等级达到要求后，积分是否达到要求
            if !infoModel!.is_satisfy && statu == 3995 { ///如果是等级不够
               SQShowGradeView.showGradeView(
                vc: weakSelf,
                gradeValue: "≥\(infoModel!.limit_score)积分"
                )
                return
            }
            
            if !infoModel!.is_satisfy && statu == 3997 { ///如果是积分不够
               SQShowIntegralView.showIntegralView(
                vc: weakSelf,
                integralValue: infoModel!.limit_score,
                action: SQAccountScoreJudgementModel.action.read_article
                )
                return
            }
            
            if infoModel!.is_need_captcha  {///如果需要验证码
                weakSelf?.showCaptchaView.showCaptchaView()
                return
            }
            
            if infoModel!.limit_score > 0 {
                let scoreStr = "阅读文章扣\(infoModel!.limit_score)积分"
                weakSelf?.showToastMessage(scoreStr)
            }
            
            weakSelf?.tableHeaderView.infoModel = infoModel!
            ///底部评论view 添加评论数监听
            weakSelf?.commentView.addObserverByArticleID(
                infoModel!.article_id)
            weakSelf?.commentView.collectBtn.isSelected = infoModel!.collect_status
            ///同步阅读数量到一级页面
            let dict = [
                "read_number":infoModel!.read_number,
                "comment_number": infoModel!.comment_number
            ]
            
            var noti = Notification.init(name: Notification.Name(rawValue: infoModel!.article_id))
            noti.object = dict
            NotificationCenter.default.post(noti)
            
            ///监听通知 更换阅读数量和评论数量
            infoModel?.addObserver()
            
            ///解析html数据为富文本
            let parserModelArray =  SQDisassemblyAttriToHtml.htmlStrToParserModel(
                infoModel!.content,
                infoModel: infoModel!
            )
            
            weakSelf?.titleNavLabel.text = infoModel?.title
            weakSelf?.parserModelArray = parserModelArray
            ///显示富文本
            _ = weakSelf?.showTextView(modelArray: parserModelArray)
            
            guard let userStr: String = UserDefaults.standard.value(forKey: k_ud_user) as? String else {
                //weakSelf?.editArticleView.dissableEditAndDeleteView()
                return
            }
            
            /// 判断是否是文章作者在浏览文章 如果是 则开通删除和编辑功能
            let account = SQAccountModel.deserialize(from: userStr)
            if account!.account_id == infoModel!.account_id {
                //weakSelf?.editArticleView.dissableEditAndDeleteView()
                weakSelf?.typeEditArticleEventArrayM.insert(.delete, at: 0)
                weakSelf?.typeEditArticleEventArrayM.insert(.edit, at: 0)
            }
            
            ///如果是版主 则先获取版主权限
            if account!.is_moderator {
                weakSelf?.getModeratorArticleRules()
            }else{
                weakSelf?.getArticleRecommend()
            }
        })
        
    }
    
    ///审核文章
    func auditArticle(status: Int,reason: String) {
        
        weak var weakSelf = self
        SQHomeNewWorkTool.reviewArticle(articleId: article_id, status: status, reason: reason) { (model, statu, errorMessage) in
            if (errorMessage != nil) {
                return
            }
            
            weakSelf?.deleteAdultArticleList()
            weakSelf?.showToastMessage("审核成功")
            weakSelf?.navigationController?
                .popViewController(animated: true)
        }
        
    }
    
    ///获取版主权限
    func getModeratorArticleRules() {
        weak var weakSelf = self
        SQHomeNewWorkTool.getModeratorArticleRules(article_id) { (ruleModel, status, errorMessage) in
            if (errorMessage != nil) {
                return
            }
            
            ///能否删除文章
            if ruleModel!.can_delete_article {
                let containsDelete: Bool = weakSelf?.typeEditArticleEventArrayM.contains(.delete) ?? true
                if !containsDelete{ ///判断有没有删除文章按钮
                    weakSelf?.typeEditArticleEventArrayM.insert(.delete, at: 0)
                }
                
            }
            
            ///能否审核文章
            if ruleModel!.can_review {
                weakSelf?.typeEditArticleEventArrayM.append(.audit)
            }
            
            if ruleModel!.can_hide_article == 2 {
                weakSelf?.typeEditArticleEventArrayM.append(.hidden)
            }
            
            if ruleModel!.can_hide_article == 1 {
                weakSelf?.typeEditArticleEventArrayM.append(.hide)
            }
            
            ///能否禁止评论
            if ruleModel!.can_forbid_comment {
               SQHomeArticleInfoVC.isForbidComment = true
            }
            
            ///能否删除评论
            if ruleModel!.can_delete_comment {
                SQHomeArticleInfoVC.isDeleteComment = true
            }
            
            ///能否置顶文章
            if ruleModel!.can_set_article_top {
                weakSelf?.typeEditArticleEventArrayM.append(.topping)
            }
            
            weakSelf?.getArticleRecommend()
        }
    }
    
    ///改变文章隐藏状态 -4 隐藏文章 1取消隐藏
    func changeArticleHiddenState(state: Int, message: String) {
        SQHomeNewWorkTool.changeArticleHideState(
        article_id,
        state: state)
        {[weak self] (model, statu, errorMessage) in
            if (errorMessage != nil) {
                return
            }
            
            self?.showToastMessage(message)
            if state == -4 {
                self?.typeEditArticleEventArrayM
                    .removeAll(where: { $0 == .hide})
                self?.typeEditArticleEventArrayM.append(.hidden)
            }else{
                self?.typeEditArticleEventArrayM
                    .removeAll(where: { $0 == .hidden})
                self?.typeEditArticleEventArrayM.append(.hide)
            }
            
            self?.editArticleView = nil
        }
    }
    
    //置顶文章
    func toppingArticle() {
        let alertView = SQToppingArticleTipsView(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: k_screen_height))
        alertView.tipsView.textField.text = "\(self.tableHeaderView.infoModel.top_position)"
        alertView.sure = { [weak self] in
            if alertView.tipsView.textField.text == "" {
                self?.showToastMessage("请输入置顶排序")
                return
            }
            
            guard let position = Int(alertView.tipsView.textField.text ?? "0") else {
                self?.showToastMessage("只能输入0或正整数")
                return
                
            }
            if position < 0 {
                self?.showToastMessage("只能输入0或正整数")
                return
            }
            
            SQHomeNewWorkTool.toppingArticle(article_id: self?.article_id ?? "", top_position: position) { [weak self] (model, status, errorMessage) in
                if errorMessage != nil {
                    return
                }
                
                self?.tableHeaderView.infoModel.top_position = position
                self?.showToastMessage("置顶成功")
                let topArticleNoti =  "\(k_noti_top_article)_\(self?.tableHeaderView.infoModel.category_id ?? 0)"
                let noti = NSNotification.Name.init(topArticleNoti)
                NotificationCenter.default.post(name: noti, object: nil)
                alertView.removeFromSuperview()
            }
        }
        UIApplication.shared.keyWindow?.addSubview(alertView)
        
    }
    
    //下载视频积分判断
    func downloadOriginalUrl(videoID: Int) {
        
        /**
         1.跳出提示扣除积分界面
         2.先做积分判断 （需要扣积分 -> 3  不需要扣积分 -> 4
         3.如果积分够的话 就扣除积分获取下载原视频链接
         4.直接获取到下载原视频链接
         */
        
        
        SQHomeNewWorkTool.getAccountJudgement(action: .download_video, resources_id: "\(videoID)",article_id: article_id) { [weak self] (model, status, errorMessage) in
            if errorMessage != nil {
                return
            }
            
            
            //1.
            let alertView = SQDownloadTipsView(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: k_screen_height), title: "下载", message: "下载视频需要\(model!.limit_score)积分，确定要下载吗?")
            
            
            //2.
            alertView.sure = {
                if alertView.tipsView.needRemindBtn.isSelected {
                    UserDefaults.standard.set(self?.getTimeStamp(), forKey: "is_need_show_download_tips")
                    UserDefaults.standard.synchronize()
                }
                self?.startDownLoadVideo(videoID: videoID, alertView: alertView, limit_score: model!.limit_score)
            }
            
            //判断下载视频是否需要扣积分
            if model!.is_satisfy {
                //如果要扣积分弹出提示框
                /**
                    判断是否要弹出积分，若用户之前勾选了七天内不再提示，在有效时间内不弹出提示框直接扣积分开始下载
                 */
                let timeStampForNow = self?.getTimeStamp()
                let timeStampBefore = UserDefaults.standard.integer(forKey: "is_need_show_download_tips")
                let days =  TimeInterval((timeStampForNow! - timeStampBefore) / 86400)
                if days >= 7 {
                    UIApplication.shared.keyWindow?.addSubview(alertView)
                } else {
                    self?.startDownLoadVideo(videoID: videoID, alertView: alertView, limit_score: model!.limit_score)
                }
                
                
            } else {
                //如果不用扣积分直接开始下载
                self?.startDownLoadVideo(videoID: videoID, alertView: alertView, limit_score: model!.limit_score)
                
            }
            
            
           
        }
        
    }
    
    ///获取视频下载链接
    func startDownLoadVideo(videoID: Int, alertView: SQDownloadTipsView,limit_score: Int) {
        //3.扣除积分,获取到下载原视频链接
        SQHomeNewWorkTool.downloadOriginalUrl(vedioID: videoID, articleID: article_id) {[weak self] (model, status, errorMessage) in
            if errorMessage != nil {
                return
            }
            
            if !model!.is_satisfy {
                //积分不够，弹出提示界面
                SQShowIntegralView.showIntegralView(
                    vc: self,
                    integralValue: limit_score,
                    action: SQAccountScoreJudgementModel.action.download_video
                )
                
                return
            }
            
            let videoModel = self?.videoArray.first(where: { (videoView) -> Bool in
                return videoView.idStr == "video:\(videoID)"
            })
                
                
            if (videoModel != nil) {
                SQDownloadManager.appendDownload(filePath: model!.video_url,dispPath: videoModel!.dispLink, mineType: "video")
            }else{
               SQDownloadManager.appendDownload(filePath: model!.video_url,dispPath: "", mineType: "video")
            }
        }
    }
    
    ///获取当前时间戳
    func getTimeStamp() -> Int {
        let now = Date()
        let timeIntervial: TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeIntervial)
        return timeStamp
    }
    
    ///获取详情文章推荐列表
    func getArticleRecommend() {
        
        weak var weakSelf = self
        ///tableHeaderView.infoModel.article_id
        SQHomeNewWorkTool.getArticleRecommend(
            tableHeaderView.infoModel.article_id,
            tableHeaderView.infoModel.category_id ) { (infoModel, statu, errorMessage) in
                if errorMessage != nil{
                    if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: statu, handel: nil) {
                        return
                    }
                    return
                }
                
                for index in 0..<infoModel!.articles_info.count {
                    
                    let model = infoModel!.articles_info[index]
                    if index == 0 {
                        model.isFirstShow = true
                    }
                    
                    model.createArticleFrame()
                    weakSelf?.infoModelArray.append(model)
                }
                /**
                 新增一个空的model,然后该cell的位置用作广告位
                 */
                weakSelf?.infoModelArray.append(SQHomeArticleItemModel())
                
                weakSelf?.tableView.reloadData()
                weakSelf?.getComments()
        }
    }
    
    ///打赏列表
    func getRewardList() {
        SQHomeNewWorkTool.getRewardList(article_id: self.article_id, start: rewardModelArr.count, size: 20) { [weak self] (listModel, status, errorMessage) in
            if errorMessage != nil {
                return
            }
            
            self?.rewardModelArr.append(contentsOf: listModel!.reward_list)
            self?.tableView.reloadData()
            
        }
    }
    
    ///打赏文章
    func rewardArticle() {
        let rv = SQShowRewardView(frame: UIScreen.main.bounds, vc:self)
        rv.tipsView.rewardCallback = {[weak self,weak rv]  price in
            if rv?.tipsView.selectedBtn == nil {
                self?.showToastMessage("请选择打赏数量")
                return
            }
            TiercelLog(CFGetRetainCount(rv))
            
            
            if rv?.tipsView.selectedBtn?.tag == 123456 {
                if price == -2 {
                    self?.showToastMessage("请输入大于100的整数")
                    return
                } else if price == -1 {
                    self?.showToastMessage("请选择打赏数量")
                    return
                }
                
            }
            
            if price < 100 {
                self?.showToastMessage("打赏数量不可低于100")
                return
            }
            
            SQHomeNewWorkTool.rewardArticle(article_id: self?.article_id ?? "", reward_num: price) { [weak self] (model, status, errorMessage) in
                if errorMessage != nil {
                    return
                }
                //1.如果不够金币
                if model!.statu_netWork == 2994 {
                    let coin_num = model!.coin_num
                    let reward_num = model!.reward_num
                    let attrStr1 = NSMutableAttributedString(attributedString: NSAttributedString.init(string: "您当前金币总额为"))
                    let attrStr2 =  NSAttributedString.init(string: "\(coin_num)", attributes: [NSAttributedString.Key.foregroundColor : k_color_title_blue])
                    let attrStr3 =  NSAttributedString.init(string: ",不可支出")
                    let attrStr4 =  NSAttributedString.init(string: "\(reward_num)", attributes: [NSAttributedString.Key.foregroundColor : k_color_title_blue])
                    let attrStr5 =  NSAttributedString.init(string: "金币")
                    attrStr1.append(attrStr2)
                    attrStr1.append(attrStr3)
                    attrStr1.append(attrStr4)
                    attrStr1.append(attrStr5)
                    rv?.goldShortageTipsView.messageLabel.attributedText = attrStr1
                    rv?.goldShortageTipsView.isHidden = false
                    
                } else {
                //2.如果够金币
                    rv?.hiddenRewardView()
                    self?.showToastMessage("打赏成功！")
                    let model = SQRewardItemModel()
                    model.amount = price
                    model.head_url = SQAccountModel.getAccountModel().head_url
                    self?.rewardModelArr.insert(model, at: 0)
                    self?.tableView.reloadData()
                }
               
            }
                                
        }
        
        UIApplication.shared.keyWindow?.addSubview(rv)
    }
    
    ///获取评论列表
    func getComments() {
        
        ///如果文章已经被删除的话 就不需要获取评论
        if isDelete {
            return
        }
        weak var weakSelf = self
        var startTime: Int64 = 0
        let model = commentModelArray.last
        if model != nil {
            startTime = model!.updated_at
        }
        
        SQHomeNewWorkTool.getCommentList(article_id,start: startTime, size: 20) { (commentListModel, statu, errorMessage) in
            weakSelf?.endFooterReFresh()
            if (errorMessage != nil) {
                if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: statu, handel: nil) {
                    return
                }
                
                return
            }
            
            if commentListModel!.article_comments.count < 20 {
                weakSelf?.endFooterReFreshNoMoreData()
            }
            
            for index in 0...commentListModel!.article_comments.count {
                if index == commentListModel!.article_comments.count {
                    break
                }
                
                let model = commentListModel!.article_comments[index]
                if weakSelf?.commentModelArray.count == 0 {
                    model.isFirstView = true
                    model.totleNum    = commentListModel!.total_number
                }
                
                if model.commentator_id == SQAccountModel.getAccountModel().account_id {
                    SQHomeArticleInfoVC.isDeleteComment = true
                }
                
                model.getCommentFrame()
                weakSelf?.commentModelArray.append(model)
            }
            
            weakSelf?.tableView.reloadData()
            if weakSelf?.needJumpComment ?? false {
                weakSelf?.needJumpComment = false
                weakSelf?.scrollToCommentBtnClick(btn: UIButton())
            }
        }
    }
    
    ///删除文章
    func deleteArticleFromNetWork() {
        let dataDict = [
            "status": (-3),
            "article_id": article_id
            ] as [String : Any]
        weak var weakSelf = self
        SQHomeNewWorkTool.deleteArticle(dataDict) { (model, statu, errorMessage) in
            if errorMessage != nil {
                if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: statu, handel: nil) {
                    return
                }
                return
            }
            
            weakSelf?.deleteAdultArticleList()
            weakSelf?.showToastMessage("删除文章成功")
            
            ///发出删除文章通知
            var noti = Notification.init(name:  Notification.Name(rawValue: weakSelf?.article_id ?? ""))
            noti.object = ["isDeleted": true]
            NotificationCenter.default.post(noti)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 2), execute: {
                weakSelf!.navigationController?
                    .popViewController(animated: true)
            })
            
        }
    }

    ///获取用户评论权限
    func getAccountScoreJudgement(_ commentModel: SQCommentModel, _ replayCommentModel: SQCommentReplyModel?,_ isBottom: Bool = false) {
        weak var weakSelf = self
        SQHomeNewWorkTool.getAccountJudgement(action: SQAccountScoreJudgementModel.action.comment_article, resources_id: article_id) { (model, statu, errorMessage) in
            if (errorMessage != nil) {
                if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: statu, handel: nil) {
                    return
                }
                return
            }
            
            if model!.is_satisfy {
                if isBottom {///如果是底部 则处理底部评论逻辑
                    weakSelf?.jumpCommentVCByBottomCommentBtn(
                        commentModel,
                        replayCommentModel
                    )
                }else{
                   weakSelf?.jumpCommentViewController(
                    commentModel,
                    replayCommentModel
                    )
                }
    
            }else{
                SQShowIntegralView.showIntegralView(
                    vc: weakSelf!,
                    integralValue: model!.limit_score,
                    action: SQAccountScoreJudgementModel.action.comment_article)
            }
        }
    }
    
    
    func updateArticleInfoCollectStatu(_ collectBtn: UIButton) {
        weak var weakSelf = self
        SQHomeNewWorkTool.updateArticleInfoCollectState(article_id: article_id, collectStatu: collectBtn.isSelected) { (model, statu, errorMessage) in
            collectBtn.isEnabled = true
    
            if (errorMessage != nil) {
                let message = collectBtn.isSelected ? "收藏" : "取消收藏"
                SQToastTool.showToastMessage("\(message)失败")
                collectBtn.isSelected = !collectBtn.isSelected
                return
            }
            
            let message = collectBtn.isSelected ? "收藏成功" : "已取消收藏"
            SQToastTool.showToastMessage(message)
            let dict = [
                "collectState": collectBtn.isSelected,
                "article_id": weakSelf?.article_id ?? ""
                ] as [String : Any]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: k_noti_collect), object: dict)
        }
    }
    
    //MARK: ------------------处理文章详情显示验证码网络请求-------------------
    ///获取文章验证码
    func getArticleCaptcha() {
        weak var weakSelf = self
        SQHomeNewWorkTool.getArticleCaptcha(
        width: Int(SQShowCaptchaView.width),
        height: Int(SQShowCaptchaView.height))
        { (model, statu, errorMessage) in
            
            if (errorMessage != nil) {
                return
            }
            
            weakSelf?.showCaptchaView.updateShowCaptchaView(
                captchaModel: model!)
        }
    }
    
    ///验证文章验证码
    func vfArticleCaptcha() {
        weak var weakSelf = self
        let captchaID = showCaptchaView.getCaptchaModel().captcha
        if captchaID.count < 1 { ///判断captchaID不为空
            SQToastTool.showToastMessage("请点击刷新按钮")
            return
        }
        
        let captchaValue = showCaptchaView.getCaptchaModel().captchaValue
        SQHomeNewWorkTool.vfArticleCaptcha(
        captcha: captchaValue,
        captcha_id: captchaID)
        { (model, statu, errorMessage) in
            if (errorMessage != nil) {
                return
            }
            
            weakSelf?.showCaptchaView.hiddenCaptchaView()
            weakSelf?.getArticleInfo()
        }
    }
}


