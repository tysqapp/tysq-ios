//
//  SQHomeArticleInfoVC.swift
//  SheQu
//
//  Created by gm on 2019/5/17.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
import WebKit
/// 文章详情页
class SQHomeArticleInfoVC: SQViewController {
    
    ///需要跳转到评论view
    var needJumpComment       = false
    
    ///是否需要减速动画
    var isDecelerate          = false
    
    ///是否删除
    var isDelete              = false
    
    ///
    lazy var textViewHeight: CGFloat   = 0
    
    /// 是否刷新了wkWebview
    var isRefreshWKWebview           = true
    
    ///能否禁止评论
   static var isForbidComment       = false
    
    ///能够删除评论
   static var isDeleteComment       = false
    
    ///底部栏按钮事件权限
    lazy var typeEditArticleEventArrayM = [SQEditArticleEvent.copy,SQEditArticleEvent.report]
    
    lazy var parserModelArray = [SQParserModel]()
    
    var article_id: String = "" {
        didSet {
            if article_id.count > 0 {
                initSubView()
                getArticleInfo()
            }
        }
    }
    
    var xmlParser: XMLParser?
    lazy var audioArray    = [SQContentDrawAttStrAudioView]()
    lazy var videoArray    = [SQContentDrawAttStrVideoView]()
    
    /// 已加载好图片缓存
    lazy var drawViewArrayM       = [SQContentDrawAttStrImageView]()
    
    /// 评论列表
    lazy var commentModelArray    = [SQCommentModel]()
    
    ///打赏列表
    lazy var rewardModelArr = [SQRewardItemModel]()
    
    ///推荐评论列表
    lazy var infoModelArray = [SQHomeArticleItemModel]()
    
    
    /// 显示文章详情验证码
    lazy var showCaptchaView: SQShowCaptchaView = {
        weak var weakSelf = self
        let showCaptchaView = SQShowCaptchaView.init(frame: UIScreen.main.bounds, handel: { (event) in
            switch event {
            case .cancel:
                weakSelf?.captchaViewCancel()
            case .submit:
                weakSelf?.captchaViewSubmit()
            case .refreshCaptcha:
                weakSelf?.captchaViewRefresh()
            }
        })
        
        return showCaptchaView
    }()
    
    /// 文章标题标签等信息头部
    lazy var tableHeaderView: SQArticleTableHeaderView = {
        let tableHeaderView = SQArticleTableHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: SQArticleTableHeaderView.defaultH))
        return tableHeaderView
    }()
    
    ///编辑view
    var editArticleView: SQEditArticleInfoView?
    
    dynamic lazy var textView: YYTextView = {
        let frame    = CGRect.init(
            x: 20,
            y: 0,
            width: k_screen_width - 40,
            height: view.height()
        )
    
        let textView = YYTextView.init(frame: frame)
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.delegate        = nil
        textView.delegate        = self
        return textView
    }()
    
    lazy var textViewCell: UITableViewCell = {
        let textViewCell            = UITableViewCell()
        textViewCell.selectionStyle = .none
        textViewCell.addSubview(textView)
        return textViewCell
    }()
    
    lazy var titleNavLabel: UILabel  = {
        let titleNavLabel = UILabel()
        titleNavLabel.setSize(size: CGSize.init(
            width: k_screen_width - 30,
            height: 30
        ))
        
        titleNavLabel.alpha         = 0
        titleNavLabel.isHidden      = true
        titleNavLabel.textColor     = k_color_black
        titleNavLabel.font          = SQArticleTableHeaderView.titleLabelFont
        return titleNavLabel
    }()
    
    ///文章审核view
    lazy var auditView: SQShowAuditView = {
        let auditView = SQShowAuditView.init(frame: UIScreen.main.bounds)
        return auditView
    }()
    
    ///底部评论view
    lazy var commentView: SQCommentView = {
         let height = SQCommentView.defaultH
         let Y      = k_screen_height - k_bottom_h - height
         let frame = CGRect.init(x: 0, y: Y, width: k_screen_width, height: height)
        let commentView = SQCommentView.init(frame: frame)
        commentView.commentBtn.addTarget(self, action: #selector(scrollToCommentBtnClick(btn:)), for: .touchUpInside)
        commentView.editArticleBtn.addTarget(self, action: #selector(editArticleBtnClick), for: .touchUpInside)
        commentView.placeHolderBtn.addTarget(self, action: #selector(jumpCommentVC), for: .touchUpInside)
        commentView.collectBtn.addTarget(self, action: #selector(collectBtnClick(btn:)), for: .touchUpInside)
        return commentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRewardList()
        /**
         监听通知来改变收藏按钮状态
        （因为推荐列表可以无限下去，文章详情界面可能展示多次，
         然后在某个文章详情界面点击收藏按钮）
         */
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(collectStateNoti(_:)),
            name: NSNotification.Name(rawValue: k_noti_collect),
            object: nil
        )
    }
    
    @objc func collectStateNoti(_ noti: Notification) {
        guard  let dict: [String: Any] = noti.object as? [String : Any]  else {
            return
        }
        
        let collectState: Bool     = dict["collectState"] as! Bool
        let article_id: String     = dict["article_id"] as! String
        if article_id != self.article_id {
            return
        }
        
        if collectState == commentView.collectBtn.isSelected {
            return
        }
        
        commentView.collectBtn.isSelected = collectState
    }
    
    func initSubView() {
        view.addSubview(commentView)
        let tableViewFrame = CGRect.init(x: 0, y: 0, width: view.width(), height: commentView.top())
        addTableView(frame: tableViewFrame,needGroup: true)
        tableView.tableHeaderView = tableHeaderView
        tableView.separatorStyle  = .none
        tableView.register(SQArticleInfoTableViewCell.self, forCellReuseIdentifier: SQArticleInfoTableViewCell.cellID)
        tableView.register(SQCommentTableViewCell.self, forCellReuseIdentifier: SQCommentTableViewCell.cellID)
        tableView.register(SQCommentEmptyTableViewCell.self, forCellReuseIdentifier: SQCommentEmptyTableViewCell.cellID)
        tableView.register(SQAdvertisementCell.self, forCellReuseIdentifier: SQAdvertisementCell.cellID)
        tableView.register(SQArticleInfoRewardCell.self, forCellReuseIdentifier: SQArticleInfoRewardCell.cellID)
        addCallBack()
        textView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        addFooter()
    }
    
    ///切换到文章被删除状态
    func updateDeleteArticleState() {
        commentView.isHidden = true
        tableView.frame = view.bounds
        tableView.tableHeaderView = UIView()
        tableView.mj_footer?.removeFromSuperview()
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
        
        if !isPass {
           textView.attributedText = attStrM
        }
        
        return attStrM
    }
    
    ///通过id 获取链接详情数据
    func audioModelFromModelId(findId: Int) -> SQArticelItemModel?{
        let model = tableHeaderView.infoModel.audios.first { (findModel) -> Bool in
            return findModel.id == findId
        }
        return model
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.titleView = titleNavLabel
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard  let contentSize: CGSize = change![NSKeyValueChangeKey.newKey] as? CGSize else{
            return
        }
        TiercelLog("contentSize =" + contentSize.debugDescription)
        let height = contentSize.height + 20
        if height <= textViewHeight {
            TiercelLog("刷新好了 =" + contentSize.debugDescription + "\(textViewHeight)")
            return
        }
        textViewHeight = height
        tableView.reloadRows(at: [NSIndexPath.init(row: 0, section: 0) as IndexPath], with: .none)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.shadowImage = nil
        if titleNavLabel.alpha == 0 {
            titleNavLabel.isHidden = true
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ///这里是处理音频在其它界面 不给播放
        for audioAttm in audioArray {
            audioAttm.manuelPause()
        }
    }

    deinit {
        for audioAttm in audioArray {
            audioAttm.removePlayerTool()
        }
        NotificationCenter.default.removeObserver(self)
        textView.removeObserver(self, forKeyPath: "contentSize")
    }
    
}

//callBack
extension SQHomeArticleInfoVC {
    
    func addCallBack() {
        weak var weakSelf = self
        tableHeaderView.callBack = { height in
            if weakSelf?.isDelete ?? false  {
                return
            }
            weakSelf?.tableView.tableHeaderView = weakSelf?.tableHeaderView ?? UIView()
        }
        
        tableHeaderView.accountIDCallBack = { accountID in
            let vc = SQPersonalVC()
            vc.accountID = accountID
            weakSelf?.navigationController?
                .pushViewController(vc, animated: true)
        }
        ///文章审核回调
        auditView.submitStateCallBack = { (status, reason) in
            weakSelf?.auditArticle(status: status, reason: reason)
        }
        
        
    }
    
}

//MARK ----------tableViewDelegate ----------------
extension SQHomeArticleInfoVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var commentNum = commentModelArray.count > 0 ? commentModelArray.count : 1
        
        if isDelete { ///如果文章已经被删除 那么评论为空不需要显示
            commentNum = 0
        }
        
        return 1 + infoModelArray.count + commentNum + 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            tableView.cellForRow(at: indexPath)?.isSelected = false
            return
        }
        
        if indexPath.row > 1 && indexPath.row <= infoModelArray.count {
            /**
             如果点击的是广告位
             */
            if indexPath.row == infoModelArray.count + 1{
               
                return
            }
            
            let model = infoModelArray[indexPath.row - 2]
            let vc    = SQHomeArticleInfoVC()
            navigationController?.pushViewController(vc, animated: true)
            vc.article_id = model.article_id
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            if isDelete { ///显示文章被删除
                let cell = SQEmptyTableViewCell.init(style: .default, reuseIdentifier: SQEmptyTableViewCell.cellID, cellType: .wz)
                return cell
            }else{
                let cell = textViewCell
                textView.frame = CGRect.init(
                    x: 20,
                    y: 0,
                    width: k_screen_width - 40,
                    height: textView.contentSize.height
                )
                return cell
            }
        }
        
        ///处理打赏
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SQArticleInfoRewardCell.cellID) as! SQArticleInfoRewardCell
            cell.vc = self
            cell.article_id = article_id
            cell.rewardModelArr = rewardModelArr
            cell.rewardClickCallback = { [weak self] in
                self?.rewardArticle()
            }
            return cell
        }
        
        ///处理推荐列表
        let articleInfoCount = infoModelArray.count
        if indexPath.row <= articleInfoCount + 1 {
            /**
             如果是广告位时：
             */
            if indexPath.row == infoModelArray.count + 1 {
                let adcell = tableView.dequeueReusableCell(withIdentifier: SQAdvertisementCell.cellID) as! SQAdvertisementCell
                if isRefreshWKWebview {
                    adcell.vc = self
                    adcell.url = WebViewPath.articleDetailADUrl
                    isRefreshWKWebview = false
                }
                
                return adcell
            }
            
            let cell: SQArticleInfoTableViewCell = SQArticleInfoTableViewCell.init(style: .default, reuseIdentifier: SQArticleInfoTableViewCell.cellID)
            
            if indexPath.row == 2 {
                cell.needShowTipsLabel = true
            } else {
                cell.needShowTipsLabel = false
            }
            
            cell.infoModel = infoModelArray[indexPath.row - 2]
            return cell
        }
        
        let count = 1 + infoModelArray.count + 1
        
        if  commentModelArray.count == 0 {
            let cell = SQCommentEmptyTableViewCell.init(
                style: .default,
                reuseIdentifier: SQCommentEmptyTableViewCell.cellID
            )
            
            return cell
        }
        
        let cell: SQCommentTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: SQCommentTableViewCell.cellID,
            for: indexPath
            ) as! SQCommentTableViewCell
        
        cell.commentModel = commentModelArray[indexPath.row - count]
        cell.tableFooterView.tag = indexPath.row - count
        cell.bottomView.deleteBtn.titleLabel?.text = cell.commentModel!.id
        cell.bottomView.replayBtn.titleLabel?.text = cell.commentModel!.id
        cell.tableFooterView.addTarget(
            self,
            action: #selector(getModelComment(btn:)),
            for: .touchUpInside
        )
        
        cell.bottomView.deleteBtn.addTarget(
            self,
            action: #selector(deleteBtnClick(btn:)),
            for: .touchUpInside
        )
        
        cell.bottomView.replayBtn.addTarget(
            self,
            action: #selector(replyBtnClick(btn:)),
            for: .touchUpInside
        )
        
        weak var weakSelf = self
        cell.fobinCommentCallBack = { (accountID,name) in
            let vc = SQPersonalVC()
            vc.accountID = accountID
            vc.hidesBottomBarWhenPushed = true
            weakSelf?.navigationController?
                .pushViewController(vc, animated: true)
        }
        
        cell.callBack = { (commentModel,replyCommentModel) in
           weakSelf!.replyComment(commentModel, replyCommentModel)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        
        if indexPath.row == 0 { //textView 高度
            if isDelete {
               return 255
            }else{
               return textViewHeight
            }
        }
        
        if indexPath.row == 1 { //打赏view高度
            if rewardModelArr.count == 0{
                return 110
            } else {
                return 200
            }
            
        }
        
        if indexPath.row <= infoModelArray.count + 1 {//带有提示的cell高度
            /**
             如果是广告位时：
             */
            if indexPath.row == infoModelArray.count + 1 {
                return SQAdvertisementView.advertiesViewHeight
            }
            
            let model = infoModelArray[indexPath.row - 2]
            return model.articleFrame.line2ViewFrame.maxY
        }
        
        if commentModelArray.count == 0 {
            return 150
        }
        
        let count = 1 + infoModelArray.count + 1
        let model = commentModelArray[indexPath.row - count]
        height = model.commentFrame.line2ViewFrame.maxY
        return height
    }
}




extension SQHomeArticleInfoVC: YYTextViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDecelerate = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        absorbTheTop(false)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isDecelerate = decelerate
        absorbTheTop(true)
    }
    
    ///吸顶动画
    func absorbTheTop(_ isFinish: Bool) {
        if tableView.contentSize.height < tableView.height() {
            return
        }
        let frame = tableView.convert(tableHeaderView.frame, to: UIApplication.shared.keyWindow)
        let offsetY = (frame.origin.y - k_nav_height) * -1
        
        if frame.origin.y > k_nav_height {
            return
        }
        var alpha   =  offsetY / tableHeaderView.height()
        TiercelLog(frame.debugDescription + "\(alpha)")
        if alpha < 0.1 {
            alpha = 0
        }
        
        alpha = CGFloat(fabsf(Float(alpha)))
        if alpha > 1 {
            alpha = 1
        }
        
        titleNavLabel.font          = UIFont.systemFont(ofSize: CGFloat(20 * alpha), weight: .bold)
        titleNavLabel.alpha         = alpha
        titleNavLabel.isHidden      = false
        if !isFinish {
            return
        }
        
        if offsetY > tableHeaderView.height() {
            return
        }
        
        let initialOffsetY = k_nav_height * -1
        if offsetY < tableHeaderView.height() * 0.5 {
            tableView.setContentOffset(CGPoint.init(x: 0, y: initialOffsetY), animated: true)
        }else{
            tableView.setContentOffset(CGPoint.init(x: 0, y:  initialOffsetY + tableHeaderView.height()), animated: true)
        }
    }
}


