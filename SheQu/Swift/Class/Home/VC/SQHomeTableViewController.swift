//
//  SQHomeTableViewController.swift
//  SheQu
//
//  Created by gm on 2019/4/11.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQHomeTableViewController: SQViewController {
    
    static let markTitlesViewH: CGFloat = 46
    static let pageTitleViewH: CGFloat  = 46
    
    ///一级分类model
    static var homeCategory: SQHomeCategory?
    
    ///分页view
    private var pageContentScrollView: SGPageContentScrollView? = nil
    
    ///一级分类view
    lazy var markTitlesView: SQMarkTitlesView = {
        let markTitlesView = SQMarkTitlesView()
        markTitlesView.backgroundColor = k_color_bg
        markTitlesView.frame = CGRect.init(x: 0, y: k_status_bar_height, width: k_screen_width, height: 46)
        markTitlesView.layoutSubviews()
        
        return markTitlesView
    }()
    
    /// 二级分类view
    lazy var pageTitleView: SGPageTitleView = {
        let configure = SGPageTitleViewConfigure()
//        configure.indicatorAdditionalWidth = 20
//        configure.indicatorHeight          = 15
        configure.titleGradientEffect      = true
        configure.titleColor              = k_color_title_gray_blue
        configure.titleSelectedColor      = UIColor.white
        configure.titleFont               = k_font_title
        
        let frame = CGRect.init(
            x: 0,
            y: markTitlesView.maxY(),
            width: k_screen_width,
            height: 45
        )
        
        let pageTitleView = SGPageTitleView.init(
            frame: frame,
            delegate: self,
            titleNames: [],
            configure: configure
        )
        
        pageTitleView.backgroundColor = k_color_bg
        return pageTitleView
    }()
    
    ///这个是刷新按钮
    lazy var sortTypeView: SQHomeSortTypeView  = {
        let sortTypeArray = [
            SQArticleSortType.synthesize,
            SQArticleSortType.newest,
            SQArticleSortType.hottest
        ]
        
        let sortTypeView = SQHomeSortTypeView.init(frame: CGRect.zero, sortTypeArray: sortTypeArray)
        sortTypeView.isHidden = true
        return sortTypeView
    }()
    
    /// 
    var showAnnouncementListView: SQShowAnnouncementListView!
    var currentSubVC: SQHomeSubViewController?
    
    ///是点击偏移还是滑动偏移
    var isClick = false
    var unreadNotificationsCount = 0 {
        didSet {
            if unreadNotificationsCount > 0 {
                tabBarController?.tabBar.showBadgOn(index: 2)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        /// 监听网络状态
        NetWorkManager.shared().startListeningNetWork { (state) in
            TiercelLog("NetWorkState\(state)")
        }
        
        getCategory()
        addCallBack()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        getUnreadNotinums()
    }
    
    override func viewDidLayoutSubviews() {
        markTitlesView.frame = CGRect.init(x: 0, y: k_status_bar_height, width: k_screen_width, height: 46)
        
        pageTitleView.frame  = CGRect.init(x: 0, y: markTitlesView.maxY(), width: k_screen_width, height: 45)
    }
    
    /// 需要通过网络请求来获取一级二级菜单栏目
    func initSubView(_ categoryModel: SQHomeCategory) {
        view.addSubview(sortTypeView)
        view.addSubview(pageTitleView)
        view.addSubview(markTitlesView)
        appendCallBack()
        ///创建服务器默认数据
        var categoryInfoArrayM = [SQHomeCategoryInfo]()
        let recommendModel     = SQHomeCategoryInfo()
        recommendModel.name    = "推荐"
        recommendModel.id      = -1
        
        let subModel = recommendModel.createAllCategorySubInfo()
        recommendModel.subcategories = [subModel]
        categoryInfoArrayM.append(recommendModel)
        for model in categoryModel.category_info {
            let allModel = model.createAllCategorySubInfo()
            var categorySubInfoArrayM = [SQHomeCategorySubInfo]()
            categorySubInfoArrayM.append(allModel)
            categorySubInfoArrayM.append(contentsOf: model.subcategories)
            let tempModel  = SQHomeCategoryInfo()
            tempModel.name = model.name
            tempModel.id   = model.id
            tempModel.subcategories = categorySubInfoArrayM
            categoryInfoArrayM.append(tempModel)
        }
        
        markTitlesView.categoryInfoArray = categoryInfoArrayM
    }
    
    
    func jumpEditArticleVC() {
        let vc = SQHomeWriteArticleVC()
        vc.hidesBottomBarWhenPushed = true
        vc.model = SQHomeTableViewController.homeCategory?.category_info
        SQPushTransition.pushWithTransition(fromVC: self, toVC: vc, type: .fromBottom)
    }
    
    func addCallBack() {
        weak var weakSelf = self
        SQAnnouncementBannerView.sharedInstance.loadMoreCallBack = { annBanner in
           weakSelf?.jumpAnnouncementVC()
        }
        
        SQAnnouncementBannerView.sharedInstance.selectedCallBack = { itemData in
            weakSelf?.goAnnouncementLinkVC(itemData: itemData)
        }
        
        sortTypeView.sortCallBack = { sortType in
            weakSelf?.sortArticelFromSubVC(sortType)
        }
        
        ///这里是处理首页搜索功能
        sortTypeView.searchCallBack = { sortView in
            let vc = SQHomeSearchVC()
            vc.hidesBottomBarWhenPushed = true
            weakSelf?.navigationController?.pushViewController(
                vc,
                animated: true
            )
        }
    }
    
    func goAnnouncementLinkVC(itemData: SQAnnouncementItemData) {
        if itemData.jumpUrl.count < 1 {
            return
        }
        
        let articleID = itemData.getArticleID()
        if articleID.count > 0 {
            let artVC = SQHomeArticleInfoVC()
            artVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(artVC, animated: true)
            artVC.article_id = articleID
        }else{
            let webVC = SQWebViewController()
            webVC.urlPath = SQHostStruct.getLoaclHost() + itemData.jumpUrl
            webVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    func jumpAnnouncementVC() {
        let vc = SQAnnouncementVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

///MARK: --------------- callBack(跳转分类 和 写文章) ---------------
extension SQHomeTableViewController {
    func appendCallBack() {
        weak var weakSelf = self
        markTitlesView.callback = { (needFresh,index, modelArray) in
            if needFresh {
                weakSelf!.pageContentScrollView?.removeFromSuperview()
                weakSelf!.setupSGPagingView(modelArray,selIndex: index)
            }
            
            weakSelf?.pageContentScrollView?
                .setPageContentScrollView(index: index)
        }
        
        
        //一级分类回调
        markTitlesView.navPageView.callBack = { (index, modelArray) in
            let categoryModelSubInfo = modelArray
            let udKey = k_ud_Level2_sel_key + "\(modelArray.first!.parent_id)"
            let selID = UserDefaults.standard.integer(forKey: udKey)
            var index = modelArray.firstIndex(where: { $0.id == selID})
            if index == nil || index! >= modelArray.count {
                index = 0
                UserDefaults.standard.set(index, forKey: udKey)
                UserDefaults.standard.synchronize()
            }
            
            weakSelf!.pageTitleView.index = index!
            weakSelf?.pageTitleView.titleNames = categoryModelSubInfo
            if categoryModelSubInfo.count == 1 { ///当子view只有一个时 就隐藏
                weakSelf?.pageTitleView.isHidden = true
                weakSelf?.sortTypeView.frame = CGRect.init(x: 0, y: weakSelf!.markTitlesView.maxY(), width: k_screen_width, height: 45)
            }else{
                weakSelf?.pageTitleView.isHidden = false
                weakSelf?.sortTypeView.frame = CGRect.init(x: 0, y: weakSelf!.pageTitleView.maxY(), width: k_screen_width, height: 45)
            }
            
            weakSelf?.markTitlesView.needRefresh = true
        }
        
        markTitlesView.navPageView.navPageViewClickCallBack = { (clickState, modelArray) in
            if modelArray != nil {
                if clickState == .menu {
                    let vc = SQHomeCategoryDetailViewController()
                    vc.hidesBottomBarWhenPushed = true
                    vc.setCategoryModel(modelArray!, { (subInfo) in
                        let selId = UserDefaults.standard.integer(forKey: k_ud_Level1_sel_key)
                        weakSelf!.markTitlesView
                            .navPageView
                            .titlesCollectionView
                            .scrollToIndex(selId)
                    })
                    
                    weakSelf!.navigationController!.pushViewController(vc, animated: true)
                } else {//需要判断用户是否登录
                    let loginStr = UserDefaults.standard.object(forKey: k_ud_user)
                    if (loginStr != nil) {
                        /**5.2期中点击写文章，不用做积分判断；未登录跳转登录界面，登录后则直接进入写文章*/
                        //weakSelf?.getAccountScoreJudgement()
                        weakSelf?.jumpEditArticleVC()
                    }else{
                       let nav = SQLoginViewController.getLoginVC()
                        weakSelf!.present(nav, animated: true, completion: {
                            
                        })
                    }
                    
                }
            }
        }
    }
    
    
    func sortArticelFromSubVC(_ sortType: SQArticleSortType) {
        currentSubVC?.sortArticleData(sortType,true)
    }
    
    func updateSubVC(subVC: SQHomeSubViewController?) {
        currentSubVC = subVC
        currentSubVC?.parentVC = self
        if (currentSubVC != nil) {
            let frame = currentSubVC!.getSortViewFrame()
            if frame.maxY >= sortTypeView.maxY(){
                sortTypeView.isHidden = true
            }else{
                sortTypeView.isHidden = false
            }
        }
        
        sortTypeView.updateSelBtn(
            currentSubVC?.sortTypeView.selBtn.tag
        )
        
        
        SQAnnouncementBannerView.sharedInstance
            .removeFromSuperview()
        subVC?.advView.addSubview(
            SQAnnouncementBannerView.sharedInstance
        )
        
        SQTopArticleAniView.sharedInstance.removeFromSuperview()
        subVC?.topArticleView.addSubview(
            SQTopArticleAniView.sharedInstance
        )
        SQTopArticleAniView.sharedInstance.updateArray(titleArray: subVC?.topArticleArray, itemSize: CGSize.init(width: k_screen_width, height: 30), vc: subVC)
    }
}

extension SQHomeTableViewController {
    
    private func setupSGPagingView(_ modelArray: [SQHomeCategorySubInfo], selIndex: Int) {
        var vcArray = [SQHomeSubViewController]()
        weak var weakSelf = self
        
        for index in 0..<modelArray.count {
            let model = modelArray[index]
            ///二级菜单容器key = 一级菜单id + 二级菜单id
            let level2Key = "\(model.parent_id)_\(model.id)"
            var vc: SQHomeSubViewController? = SQCacheContainerTool.shareInstance
                .getContainer(byLevelId: level2Key) as? SQHomeSubViewController
            
            ///当二级菜单为空时 初始化二级菜单
            if vc == nil {
                vc = SQHomeSubViewController()
                vc?.isPageTitleViewHidden = modelArray.count == 1
                SQCacheContainerTool.shareInstance
                    .cacheContainer(byLevelId: level2Key, vc: vc!)
            }
            
            ///这里是回调隐藏一级分类列表 和 二级分类列表
            vc!.callBack = { (isSortViewShow,SortViewShow) in
                weakSelf?.sortTypeView.isHidden = !isSortViewShow
                weakSelf?.sortTypeView.updateSelBtn(
                    SortViewShow.selBtn.tag
                )
            }
            
            vc!.showPageTitleViewCallBack = { isShowPage in
                weakSelf?.pageTitleView(hiddenBy: isShowPage)
            }
            
            vc!.model = model
            vcArray.append(vc!)
        }
        
        let contentViewHeight = (self.tabBarController?.tabBar.top())! - k_status_bar_height
        let contentRect = CGRect(
            x: 0,
            y: k_status_bar_height,
            width: view.frame.size.width,
            height: contentViewHeight
        )
        
        ///判断一级vc的缓存
        let level1Key = "\(modelArray.first!.parent_id)"
        let pageVC: SGPageContentScrollView? = SQCacheContainerTool.shareInstance
            .getContainer(byLevelId: level1Key) as? SGPageContentScrollView
        
        if pageVC == nil {
            pageContentScrollView =
                SGPageContentScrollView(frame: contentRect, parentVC: self, childVCs: vcArray)
            pageContentScrollView?.delegateScrollView = self
            SQCacheContainerTool.shareInstance.cacheContainer(byLevelId: level1Key, vc: self.pageContentScrollView!)
        }else{
            pageContentScrollView?.updateFrame(contentRect)
            pageContentScrollView = pageVC
        }
        
        if pageContentScrollView!.childVCs.count > selIndex {
            updateSubVC(subVC: pageContentScrollView!.childVCs[selIndex] as? SQHomeSubViewController)
        }
        
        view.addSubview(pageContentScrollView!)
        view.bringSubviewToFront(sortTypeView)
        view.bringSubviewToFront(pageTitleView)
        view.bringSubviewToFront(markTitlesView)
    }
    
    func pageTitleView(hiddenBy isPageTitleViewShow: Bool) {
        if pageTitleView.isHidden {
            return
        }
        if isPageTitleViewShow {
            if pageTitleView.top() >= markTitlesView.maxY() { //如果已经显示出来
                return
            }
            UIView.animate(withDuration: TimeInterval.init(0.25), animations: {
                self.pageTitleView.frame = CGRect.init(x: 0, y: self.markTitlesView.maxY(), width: k_screen_width, height: 45)
                self.sortTypeView.frame  = CGRect.init(x: 0, y: self.pageTitleView.maxY(), width: k_screen_width, height: 45)
            })
        }else{
            if pageTitleView.top() < markTitlesView.maxY() { //如果已经隐藏
                return
            }
            
            UIView.animate(withDuration: TimeInterval.init(0.25), animations: {
                self.pageTitleView.frame = CGRect.init(x: 0, y: self.markTitlesView.maxY() - 45, width: k_screen_width, height: 45)
                self.sortTypeView.frame  = CGRect.init(x: 0, y: self.pageTitleView.maxY(), width: k_screen_width, height: 45)
            })
        }
    }
}

extension SQHomeTableViewController: SGPageTitleViewDelegate, SGPageContentScrollViewDelegate {
    
    func pageTitleView(pageTitleView: SGPageTitleView, index: Int) {
        isClick = true
        pageContentScrollView?
            .setPageContentScrollView(index: index)
        //二级菜单控制
        if index < pageContentScrollView?.childVCs.count ?? 0 {
            let subVC: SQHomeSubViewController? = pageContentScrollView?.childVCs[index] as? SQHomeSubViewController
            updateSubVC(subVC: subVC)
        }
        
        weak var weakSelf = self
        if self.markTitlesView.callback != nil {
            let cacheLavel1 = UserDefaults.standard.integer(forKey: k_ud_Level1_sel_key)
            let catModel = weakSelf!.markTitlesView.categoryInfoArray!.first { (model) -> Bool in
                return model.id == cacheLavel1
            }
            if (catModel == nil) {
                return
            }
            
            var indexTemp = index
            if catModel!.subcategories.count <= index {
                indexTemp = 0
            }
            
            let selModel = catModel!.subcategories[indexTemp]
            let ud = UserDefaults.standard
            let level2Key = k_ud_Level2_sel_key + "\(selModel.parent_id)"
            ud.set(selModel.id, forKey: level2Key)
            weakSelf!.markTitlesView.callback!(
                weakSelf!.markTitlesView.needRefresh,
                index,
                pageTitleView.titleNames!
            )
            
            weakSelf!.markTitlesView.needRefresh = false
        }
    }
    
    func pageContentScrollView(pageContentScrollView: SGPageContentScrollView, progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        if isClick {
            isClick = false
            return
        }
        pageTitleView.setPageTitleView(progress: progress, originalIndex: originalIndex, targetIndex: targetIndex)
        let subVC: SQHomeSubViewController? = pageContentScrollView.childVCs[targetIndex] as? SQHomeSubViewController
        if (subVC != nil) {
            pageTitleView(hiddenBy: true)
        }
        
        updateSubVC(subVC: subVC)
    }
    
}

extension SQHomeTableViewController {
    
    ///获取未读通知数量
    func getUnreadNotinums() {
        SQCloudNetWorkTool.getUnreadNotificationsCount { [weak self] (model, status, errorMessage) in
            if errorMessage != nil {
                return
            }         
            if model!.unread_count > 0 {
                self?.unreadNotificationsCount = model!.unread_count
            }
            
            
        }
    }
    
    /// 获取分类信息
    func getCategory() {
        weak var weakSelf = self
        SQHomeNewWorkTool.getCategory { (categoryModel, index, errorMessage) in
            if (errorMessage != nil) {
                SQEmptyView.showEmptyView(handel: { (click) in
                    if click {
                     weakSelf?.getCategory()
                    }
                })
                return
            }
            
            weakSelf?.getAnnouncement(categoryModel)
        }
    }
    
    ///获取用户权限
    func getAccountScoreJudgement() {
        weak var weakSelf = self
        SQHomeNewWorkTool.getAccountJudgement(action: SQAccountScoreJudgementModel.action.create_article, resources_id: "") { (model, status, errorMessage) in
            if (errorMessage != nil) {
                if status == 2999 || status == 2998 {
                    let loginNav = SQLoginViewController.getLoginVC()
                    weakSelf?.present(loginNav, animated: true, completion: nil)
                    return
                }
                return
            }
            
            if model!.is_satisfy {
                weakSelf?.jumpEditArticleVC()
            }else{
             SQShowIntegralView.showIntegralView(
                vc: weakSelf!,
                integralValue: model!.limit_score,
                action: SQAccountScoreJudgementModel.action.create_article
                )
            }
        }
    }
    
    
    ///获取公告栏数据
    func getAnnouncement(_ homeCategory: SQHomeCategory?) {
        weak var weakSelf = self
        SQHomeNewWorkTool.getAnnouncement { (listModel, statu, errorMessage) in
            if (errorMessage != nil) {
                return
            }
            var announcementItemArray = [SQAnnouncementItemData]()
            var bannerItemArray = [SQAnnouncementItemData]()
            for index in 0..<listModel!.announcement_list.count {
                let model = listModel!.announcement_list[index]
                if model.position == SQAnnouncemenType.popUp.rawValue
                    || SQAnnouncemenType.all.rawValue == model.position {
                    let rawValue = announcementItemArray.count % 3 + 1
                    let type = SQAnnouncementItemData.ImageNameType.init(rawValue: rawValue) ?? SQAnnouncementItemData.ImageNameType.blue
                    let itemData = SQAnnouncementItemData.init(title: model.title, imageNameType: type, jumpUrl: model.url)
                    announcementItemArray.append(itemData)
                }
                
                if model.position == SQAnnouncemenType.announcemen.rawValue
                    || SQAnnouncemenType.all.rawValue == model.position {
                    let rawValue = bannerItemArray.count % 3 + 1
                    let type = SQAnnouncementItemData.ImageNameType.init(rawValue: rawValue) ?? SQAnnouncementItemData.ImageNameType.blue
                    let itemData = SQAnnouncementItemData.init(title: model.title, imageNameType: type, jumpUrl: model.url)
                    bannerItemArray.append(itemData)
                }
            }
            
            SQAnnouncementBannerView.sharedInstance.itemDataArray = bannerItemArray
            weakSelf?.showAnnouncementListView = SQShowAnnouncementListView.init(
                frame: UIScreen.main.bounds,
                itemDataArray: announcementItemArray
            )
            
            weakSelf?.showAnnouncementListView.selectedCallBack = { itemData in
                weakSelf?.goAnnouncementLinkVC(itemData: itemData)
                weakSelf?.showAnnouncementListView.hiddenAnnouncementView()
            }
            
            if announcementItemArray.count > 0 {
                weakSelf?.showAnnouncementListView.showAnnouncementView()
            }
            
            SQHomeTableViewController.homeCategory = homeCategory!
            weakSelf?.initSubView(homeCategory!)
        }
    }
}
