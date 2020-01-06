//
//  SQHomeWriteArticleVC.swift
//  SheQu
//
//  Created by gm on 2019/5/6.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

///编辑文章
class SQHomeWriteArticleVC: SQViewController {
    
    lazy var parserModelArray = [SQParserModel]()
    ///控制是修改还是写文章
    lazy var isPut  = false
    lazy var isDraft  = false
    lazy var status = -100 //1发布 2草稿
    lazy var keyBoardFrame = CGRect.zero
    lazy var textViewH: CGFloat  = 155
    ///控制分类点击标记
    lazy var isCategoryClick = false
    lazy var article_id = ""
    lazy var cell: SQWriteArticleTableFootView = {
        let cell = SQWriteArticleTableFootView.init(frame: CGRect.init(
            x: 0,
            y: 0,
            width: k_screen_width,
            height: 150
            ))
        
        cell.textView.customDelegate = self
        return cell
    }()
    var model: [SQHomeCategoryInfo]? {
        didSet{
            if (model != nil) {
                writeArticleView.model = model
            }
        }
    }
    
    var editArticle: String?{
        didSet{
            getEditArticleInfo()
        }
    }
    
    lazy var saveDraftBtn: UIButton = {
        let saveDraftBtn = UIButton()
        saveDraftBtn.setTitle("保存草稿", for: .normal)
        saveDraftBtn.setTitleColor(k_color_black, for: .normal)
        saveDraftBtn.titleLabel?.font = k_font_title
        saveDraftBtn.addTarget(self, action: #selector(draftBtnClick), for: .touchUpInside)
        saveDraftBtn.sizeToFit()
        return saveDraftBtn
    }()
    
    /// 发布按钮
    lazy var publishBtn: SQDisableBtn = {
        let publishBtn = SQDisableBtn.init(frame: CGRect.init(x: saveDraftBtn.maxX() + 20, y: 0, width: 50, height: 30), enabled: false)
        publishBtn.setTitle("发布", for: .normal)
        publishBtn.titleLabel?.font = k_font_title
        publishBtn.setBtnBGImage()
        publishBtn.addTarget(self, action: #selector(publishBtnClick), for: .touchUpInside)
        return publishBtn
    }()
    
    ///编辑文章View
    lazy var writeArticleView: SQHomeWriteArticleView = {
        let writeArticleView   = SQHomeWriteArticleView()
        let viewH: CGFloat     = 155
        writeArticleView.frame = CGRect.init(
            x: 0,
            y: 0,
            width: k_screen_width,
            height: viewH
        )
        
        return writeArticleView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView(frame: view.bounds, needGroup: false)
        let height = writeArticleView.addMarksView.height() + writeArticleView.height()
        writeArticleView.setHeight(height: height)
        tableView.tableHeaderView = writeArticleView
        tableView.tableFooterView = cell
        addCallBack()
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardDisp(noti:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardHidden(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        //navigationItem.title = isPut ? "修改文章" : "写文章"
        addNav()
        //IQKeyboardManager.shared().isEnabled = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    @objc func keyBoardDisp(noti: Notification) {
        if cell.textView.isFirstResponder {
            keyBoardFrame = noti.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! CGRect
            
            
            UIView.animate(withDuration: TimeInterval.init(0.25), animations: {
                self.tableView.contentInset = UIEdgeInsets.init(top: self.writeArticleView.height() * -1, left: 0, bottom: 0, right: 0)
            }) { (isFinish) in
                if self.keyBoardFrame.size.height > 200 {
                    self.scrollTableViewToVisible()
                    let kboardHeight = self.keyBoardFrame.size.height
                    self.cell.setHeight(height: kboardHeight + self.textViewH)
                    self.tableView.tableFooterView = self.cell
                    
                }
            }
        }
    }
    
    @objc func keyBoardHidden(noti: Notification) {
        if cell.textView.isFirstResponder {
            keyBoardFrame = CGRect.zero
            UIView.animate(withDuration: TimeInterval.init(0.25)) {
                self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            }
            self.cell.setHeight(height: self.textViewH)
            self.tableView.tableFooterView = self.cell
        }
    }
    
    func scrollTableViewToVisible() {
        let selRect  = cell.textView.getSelectedFrame()
        let value    = selRect.maxY - (k_screen_width - keyBoardFrame.height - k_nav_height)
        if  value > 0  {
            UIView.performWithoutAnimation {
                self.tableView.setContentOffset(CGPoint.init(x: 0, y: value), animated: false)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}



extension SQHomeWriteArticleVC {
    
    func addCallBack() {
//        let viewH            = k_screen_height - k_nav_height
        weak var weakSelf    = self
        writeArticleView.heightCallBack = { height in
            
            weakSelf?.writeArticleView.setHeight(height: height)
            weakSelf?.tableView.tableHeaderView = weakSelf?.writeArticleView
        }
        ///编辑文章view自适应高度
        cell.textView.heightCallBack = { height in
            let kbHeight = weakSelf?.keyBoardFrame.size.height ?? 0
            weakSelf?.textViewH = height
            weakSelf?.cell.setHeight(height: height + kbHeight)
            weakSelf?.tableView.tableFooterView = weakSelf?.cell
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 1), execute: {
                weakSelf?.scrollTableViewToVisible()
            })
            
        }
        
        ///添加标签
        writeArticleView.btnClickCallBack = { tag in
            let vc = SQAddLabelViewController()
            vc.uploadDate(infoModelArray: weakSelf!.writeArticleView.titlesArrayM, handel: { (infoModelArray) in
                weakSelf!.writeArticleView.titlesArrayM = infoModelArray
                weakSelf!.writeArticleView.initMarksView()
            })
            
            weakSelf!.navigationController?.pushViewController(vc, animated: true)
        }
        
        ///选择分类按钮点击
        writeArticleView.categoryClickCallBack = { isClick in
            weakSelf!.isCategoryClick = true
            weakSelf!.checkPublishBtnState()
        }
        
        writeArticleView.titleTF.addTarget(self, action: #selector(titleChange(tf:)), for: .editingChanged)
    }
    
    @objc func titleChange(tf: UITextField) {
        checkPublishBtnState()
    }
    
    
    /// 控制发布按钮的可否点击状态
    func checkPublishBtnState() {
        if writeArticleView.titleTF.text!.count > 0 && isCategoryClick {
            publishBtn.isEnabled = true
            publishBtn.setBtnBGImage()
        }else{
            publishBtn.isEnabled = false
            publishBtn.setBtnBGImage()
        }
    }
}

//MARK: ------------添加callBack-------------------
extension SQHomeWriteArticleVC: SQWriteArticleTextViewDelegate{
    /// 获取文章的图片 视频 音频
    func writeArticleTextView(textView: SQWriteArticleTextView, inputAccessoryViewStyleChange style: SQWriteArticleInputAccessoryView.SQWriteArticleInputAccessoryViewStyle, handel: @escaping ([SQAccountFileItemModel]) -> ()) {
        let vc = SQHomeAccountListVCViewController()
        if style == .image {
            vc.type = .image
        }
        
        if style == .video {
            vc.type = .video
        }
        
        if style == .music {
            vc.type = .music
        }
        
        vc.callBack = { infoModleArray in
            handel(infoModleArray)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: ----------- 添加ui ---------------
extension SQHomeWriteArticleVC {
    
    ///添加左边和右边nav按钮
    func addNav(){
        let btn = UIButton.init()
        btn.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        btn.setImage(UIImage.init(named: "home_ac_close_sel"), for: .normal)
        btn.setTitleColor(k_color_black, for: .normal)
        btn.imageView?.contentMode = .left
        btn.addTarget(self, action: #selector(closeNav), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: btn)
        let rightNav = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 130, height: 30))
        rightNav.addSubview(saveDraftBtn)
        rightNav.addSubview(publishBtn)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightNav)
    }
    
    ///关闭写文章界面
    @objc func closeNav(){
        let vcArray = navigationController?.children
        let vc = vcArray![vcArray!.count - 2]
        if self.isPut {
            navigationController?.popViewController(animated: true)
        }else{
           SQPushTransition.popWithTransition(fromVC: self, toVC: vc, type: .formTop)
        }
        
    }
    
    ///获取用户权限
    func getAccountScoreJudgement() {
        weak var weakSelf = self
        SQHomeNewWorkTool.getAccountJudgement(action: SQAccountScoreJudgementModel.action.create_article, resources_id: "") { (model, status, errorMessage) in
            if (errorMessage != nil) {
                return
            }
            
            if model!.is_satisfy {
                weakSelf?.publishArticleNetWork()
            }else{
                if (weakSelf != nil) {
                    SQShowIntegralView.showIntegralView(
                        vc: weakSelf!,
                        integralValue: model!.limit_score,
                        action: SQAccountScoreJudgementModel.action.create_article
                    )
                }
            }
        }
    }
    
    ///发布文章
    @objc func publishBtnClick() {
        if !publishBtn.isEnabled {
            return
        }
        
        status = 1
        publishArticle()
    }
    
    ///发布草稿
    @objc func draftBtnClick() {
        status = 2
        publishArticle(2)
    }
    
    ///解析html标签为富文本
    func showTextView(modelArray: [SQParserModel],isPass: Bool = false) -> NSMutableAttributedString{
        let attStrM = NSMutableAttributedString()
        for model in modelArray {
            var attStr = NSAttributedString()

            if model.isImage || model.isAudio ||  model.isVideo{
                attStr = getAttachment(model, isPass, attStrM)
            }else{
                let attStrType = model.getAttStrType(size: view.size())
                attStr = attStrType.0
            }

            attStrM.append(attStr)
        }
        return attStrM
    }
    
    func getEditArticleInfo() {
        weak var weakSelf = self
        SQHomeNewWorkTool.getEditArticle(editArticle ?? "") { (infoModel, statu, errorMessage, dict) in
            if (errorMessage != nil) {
                if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: statu, handel: { loginSuccess in
                    if loginSuccess {
                        weakSelf?.getEditArticleInfo()
                    }else{
                        weakSelf?.navigationController?
                            .popViewController(animated: true)
                    }
                }) {
                    return
                }
                SQEmptyView.showEmptyView(handel: { (click) in
                    if click {
                        weakSelf?.getEditArticleInfo()
                    }else{
                        weakSelf?.navigationController?
                            .popViewController(animated: true)
                    }
                })
                return
                
            }
            
            ///判断是否删除
            if infoModel!.status == SQArticleAuditStatus.delete.rawValue {
                weakSelf?.showToastMessage("文章已被删除")
                return
            }
            
            ///5.2: 判断等级是否达到要求
            if !infoModel!.is_satisfy && statu == 3996 { ///如果是等级不够
               SQShowGradeView.showGradeView(
                vc: weakSelf,
                gradeValue: infoModel!.grade.toGradeName()
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
            
            
            weakSelf?.parserModelArray = parserModelArray
            ///显示富文本
            _ = weakSelf?.showTextView(modelArray: parserModelArray)
            weakSelf?.startEdit(infoModel: infoModel!)
        }
    }
    
    /// 发布文章
    ///
    /// - Parameter statu: 如果等于2 则为发送草稿
    func publishArticle(_ statu: Int = 1) {
        isDraft = (statu == 2)
        guard let publishAttS = cell.textView.attributedText  else {
            return
        }
        
        let valueStr = publishAttS.string.replacingOccurrences(of: " ", with: "")
        if valueStr.count == 0 {
            SQToastTool.showToastMessage("文章内容不能为空!")
            return
        }
        
        publishArticleNetWork()
    }
    
    
    func publishArticleNetWork() {
        let title = writeArticleView.titleTF.text!
        let category_id = writeArticleView.getCategory_id()
        
        ///添加分类id判断
        if category_id < 1 {
            showToastMessage("请选择文章分类")
            return
        }
        
        guard let publishAttS = cell.textView.attributedText  else {
            return
        }
        
        weak var weakSelf = self
        SQDisassemblyAttriToHtml
            .disassemblyAttriToHtml(publishAttS) { (htmlStr,imageArray,videoArray,musicArray) in
            let labels = weakSelf!.writeArticleView.getLabelArray()
            
            SQHomeNewWorkTool.publishArticle(
                title: title,
                category_id: category_id,
                content: htmlStr,
                images: imageArray,
                videos: videoArray,
                audios: musicArray,
                files: [NSNumber](),
                labels: labels,
                isPut: isPut,
                status: status,
                article_id: article_id,
                handler: { (model, statu, errorMessage, dataDict) in
                if errorMessage != nil {
                    if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: statu, handel: nil) {
                        return
                    }
                    return
                }
                
                if (weakSelf == nil) {
                    return
                }
                
               ///5.2 发布文章里面增加积分判断
                if (weakSelf != nil && model!.statu_netWork == 3997) {
                    weakSelf?.view.endEditing(true)
                    let limit_score: Int = dataDict?["limit_score"] as? Int ?? 0
                    SQShowIntegralView.showIntegralView(
                        vc: weakSelf!,
                        integralValue: limit_score,
                        action: SQAccountScoreJudgementModel.action.create_article
                    )
                    return
                }
                
                    
                ///判断是否需要审核 isReview true  为需要审核 false则为不需要
                var articleID: String = model!.article_id
                if model!.is_review {
                    var title = "文章已提交审核"
                    if model!.limit_score > 0 {
                        title += ",扣\(model!.limit_score)积分"
                    }
                    weakSelf?.article_id = articleID
                    let alert = UIAlertView.init(title: title, message: "\n文章会尽快审核，请耐心等待。审核状态请留意站内信息或邮件通知", delegate: weakSelf!, cancelButtonTitle: "返回首页", otherButtonTitles: "查看文章")
                    alert.show()
                    return
                }
                
                if articleID.count < 1 {
                    articleID = weakSelf?.article_id ?? ""
                }
                    
                weakSelf?.changeNavSort(
                        true,
                        articleID,
                        limitScore: model!.limit_score
                )
            })
    }
    }
}


extension SQHomeWriteArticleVC {
    func getVideoArray(videoIdArray: [NSNumber]) -> [Any] {
        
        var resultArray = [Any]()
        
        for infoModel in cell.textView.videoModelArray {
            
            let number = videoIdArray.first { (idNum) -> Bool in
                return idNum.int64Value == infoModel.id
            }
            
            if number == nil {
                continue
            }
            
            var dictM = ["video": (infoModel.id)] as [String: Any]
            var coverArray = [NSNumber]()
            for coverModel in infoModel.covers {
                coverArray.append(NSNumber.init(value: coverModel.id))
            }
            
            if coverArray.count > 0 {
                dictM["cover"] = coverArray
            }
            
            var screanArray = [NSNumber]()
            for screanModel in infoModel.screenshots {
                screanArray.append(NSNumber.init(value: screanModel.id))
            }
            
            if screanArray.count > 0 {
                dictM["screenshot"] = screanArray
            }
            
            resultArray.append(dictM)
        }
        
        return resultArray
    }
    
    
    func changeNavSort(_ needToast: Bool,_ articleID: String, limitScore: Int) {
        let vc = SQHomeArticleInfoVC()
        vc.hidesBottomBarWhenPushed = true
        ///这里是处理写完文章后 到详情界面后返回不再到写文章界面
        var tag = 2
        var message = "发布文章成功"
        if isPut {//这里是处理编辑文章后 返回不再回到编辑文章和原来文章界面
            tag = 3
            message = "修改文章成功"
        }
        
        
        if isDraft {
            message = "文章已保存为草稿"
        }
        
        var duration = 0.25
        if limitScore > 0 {
            message  =  message + ",扣\(limitScore)积分"
            duration = 2
        }
        
        if needToast {
            showToastMessage(message)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration, execute: {
            vc.article_id = articleID
            
            self.navigationController?.pushViewController(vc, animated: true)
            var children = [UIViewController]()
            for index in 0..<self.navigationController!.children.count {
                
                if index == self.navigationController!.children.count - tag {
                    continue
                }
                
                if index == self.navigationController!.children.count - 2 {
                    continue
                }
                children.append(self.navigationController!.children[index])
            }
            
            self.navigationController?
                .setViewControllers(children, animated: false)
        })
    }
}


extension SQHomeWriteArticleVC: UIAlertViewDelegate {
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0 {
            let tabvc: SQTabBarController = AppDelegate.getAppDelegate().window?.rootViewController as! SQTabBarController
         tabvc.selectedIndex = 0
         navigationController?
            .popToRootViewController(animated: true)
        }else{
            changeNavSort(
                true,
                article_id,
                limitScore: alertView.tag
            )
        }
    }
}
