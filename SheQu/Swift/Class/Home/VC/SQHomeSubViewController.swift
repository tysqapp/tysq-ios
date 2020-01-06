//
//  SQHomeSubViewController.swift
//  SheQu
//
//  Created by gm on 2019/4/26.
//  Copyright © 2019 sheQun. All rights reserved.
//
import WebKit
import UIKit
import MJRefresh
typealias SQHomeSubViewControllerCallBack = ((_ isSortTypeViewShow: Bool,_ sortTypeView: SQHomeSortTypeView) -> ())
class SQHomeSubViewController: SQViewController {
    static var isFirst = true
    lazy var isPageTitleViewHidden: Bool = false
    lazy var tableViewY: CGFloat       = 0
    lazy var detailArray = [SQHomeInfoDetailItemModle]()
    lazy var canSetContentOffest: Bool = false
    lazy var isDecelerate              = false
    lazy var offsetY: CGFloat = 0
    lazy var sortType = SQArticleSortType.synthesize
    lazy var isShowPageTitleView       = false
    lazy var currentPage = 1
    lazy var emptyTableHeaderViewH: CGFloat = 0
    lazy var topArticleArray = [SQTopArticleModel]()
    weak var parentVC: SQHomeTableViewController?
    var model: SQHomeCategorySubInfo?
    var callBack: SQHomeSubViewControllerCallBack?
    var showPageTitleViewCallBack: ((Bool) -> ())?
    fileprivate var needScroolToTop = false
    
    lazy var advView: SQBannerAdvView = {
        let advView = SQBannerAdvView()
        advView.setHeight(height: SQAnnouncementBannerView.height)
        advView.setWidth(width: SQAnnouncementBannerView.width)
        return advView
    }()
    
    lazy var topArticleView: UIView = {
        let topArticleView = UIView()
        return topArticleView
    }()
    
    lazy var sortTypeView: SQHomeSortTypeView  = {
        let sortTypeArray = [
            SQArticleSortType.synthesize,
            SQArticleSortType.newest,
            SQArticleSortType.hottest
        ]
        
        let sortTypeView = SQHomeSortTypeView.init(frame: CGRect.zero, sortTypeArray: sortTypeArray)
        sortTypeView.lineView.isHidden = true
        weak var weakSelf = self
        sortTypeView.sortCallBack = { sortType in
            weakSelf?.sortArticleData(sortType)
        }
        
        sortTypeView.searchCallBack = { sortView in
            let vc = SQHomeSearchVC()
            vc.hidesBottomBarWhenPushed = true
            weakSelf?.navigationController?.pushViewController(
                vc,
                animated: true
            )
        }
        
        return sortTypeView
    }()
    
    lazy var emptyTableHeaderView: UIView = {
        let emptyTableHeaderView = UIView()
        return emptyTableHeaderView
    }()
    
    lazy var line1View: UIView = {
        let line1View = UIView()
        line1View.backgroundColor = k_color_line_light
        return line1View
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line_light
        return lineView
    }()
    
    lazy var topArticleLineView: UIView = {
        let topArticleLineView = UIView()
        topArticleLineView.backgroundColor = UIColor.colorRGB(0xcccccc)
        return topArticleLineView
    }()
    
    lazy var pagingView: SQHomeInfoDetailTableFooterView = {
        var pagingView = SQHomeInfoDetailTableFooterView()
        pagingView.frame = CGRect.init(
            x: 0,
            y: 0,
            width: k_screen_width,
            height: SQHomeInfoDetailTableFooterView.height
        )
        
        weak var weakSelf = self
        pagingView.callBack = { (currentPage,size) in
            weakSelf?.currentPage = currentPage
            let startPage = (currentPage - 1) * size
            weakSelf?.needScroolToTop = true
            weakSelf?.requestNetWork(startPage: startPage)
        }
        
        return pagingView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        addTableView(frame: CGRect.zero)
        tableView.register(SQHomeInfoDetailCell.self, forCellReuseIdentifier: "homeInfoDetailID")
        tableView.register(SQAdvertisementCell.self, forCellReuseIdentifier: SQAdvertisementCell.cellID1)
        tableView.register(SQAdvertisementCell.self, forCellReuseIdentifier: SQAdvertisementCell.cellID2)
        tableView.register(SQAdvertisementCell.self, forCellReuseIdentifier: SQAdvertisementCell.cellID3)
        tableView.tableFooterView = pagingView
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        addRefresh()
        tableView.mj_header?.beginRefreshing()
        
        var keyID: Int = model?.parent_id ?? 0
        if model?.id ?? 0 > 0 {
            keyID = model?.id ?? 0
        }
        
        ///添加置顶某分类文章通知
        let notiName = NSNotification.Name.init("\(k_noti_top_article)_\(keyID)")
        NotificationCenter.default.addObserver(self, selector: #selector(getTopArticleList), name: notiName, object: nil)
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initSubViews()
    }
    
    func initTableHeaderView() {
        emptyTableHeaderView.frame = CGRect.init(
            x: 0, y: 0, width: k_screen_width, height: emptyTableHeaderViewH)
                
        line1View.frame = CGRect.init(
            x: 0,
            y: emptyTableHeaderView.maxY() - 3,
            width: k_screen_width,
            height: k_line_height_big
        )
       
       
        advView.frame = CGRect.init(
            x: 0,
            y: line1View.maxY(),
            width: k_screen_width,
            height: SQAnnouncementBannerView.height
        )
        
        if(SQAnnouncementBannerView.sharedInstance
            .itemDataArray?.count ?? 0 < 1) {
            advView.setHeight(height: SQAnnouncementBannerView.topViewH)
            SQAnnouncementBannerView.sharedInstance
                .cycleScrollView.isHidden = true
        }
        
        lineView.frame = CGRect.init(x: 0, y: advView.maxY(), width: k_screen_width, height: k_line_height_big)

        sortTypeView.frame = CGRect.init(x: 0, y: lineView.maxY(), width: k_screen_width, height: SQHomeSortTypeView.sortTypeViewH)
       
       var count = topArticleArray.count
        if count > 2 {
            count = 2
        }
        
       var topArticleHeight: CGFloat = CGFloat(30 * count) + 10
        if count == 0 {
            topArticleHeight = 0
            topArticleLineView.frame = CGRect.init(x: 0, y: sortTypeView.maxY(), width: k_screen_width, height: 0)
        }else {
            topArticleLineView.frame = CGRect.init(x: 0, y: sortTypeView.maxY(), width: k_screen_width, height: k_line_height)
        }
       
       topArticleView.frame = CGRect.init(x: 0, y: topArticleLineView.maxY(), width: k_screen_width, height: topArticleHeight)
        let needAdd = SQTopArticleAniView.sharedInstance.updateArray(titleArray: self.topArticleArray, itemSize: CGSize.init(width: k_screen_width, height: 30), vc: self, needCheck: true)
        if needAdd {
            SQTopArticleAniView.sharedInstance.removeFromSuperview()
            topArticleView.addSubview(
                SQTopArticleAniView.sharedInstance
            )
        }
        let tableHeaderView = UIView.init(frame: CGRect.init(
            x: 0,
            y: 0,
            width: k_screen_width,
            height: topArticleView.maxY()
        ))
       
        tableHeaderView.addSubview(emptyTableHeaderView)
        tableHeaderView.addSubview(line1View)
        tableHeaderView.addSubview(advView)
        tableHeaderView.addSubview(lineView)
        tableHeaderView.addSubview(sortTypeView)
        tableHeaderView.addSubview(topArticleLineView)
        tableHeaderView.addSubview(topArticleView)
        
        tableView.tableHeaderView = tableHeaderView
    }
    
    func initSubViews() {
         var tableHeightViewH: CGFloat = 90
         if isPageTitleViewHidden {
             tableHeightViewH = SQHomeTableViewController.markTitlesViewH
         }else{
             tableHeightViewH = SQHomeTableViewController.pageTitleViewH +  SQHomeTableViewController.markTitlesViewH
         }
         
//         if SQHomeSubViewController.isFirst {
//             if tableHeightViewH < 50  {
//                 tableHeightViewH = 0
//                 tableViewY       = -8
//             }else{
//                 tableHeightViewH = tableHeightViewH - 54
//             }
//
//             if #available(iOS 12.0, *) {
//
//             }else {
//                let offsetY: CGFloat = k_status_bar_height > 20 ? 15 : 0
//                tableViewY = tableViewY - k_nav_height + 19 + offsetY
//             }
//
//             SQHomeSubViewController.isFirst = false
//         }
        
        emptyTableHeaderViewH = tableHeightViewH
        
        initTableHeaderView()
        
         let height = k_screen_height  - k_status_bar_height - k_tabbar_height - tableViewY
         tableView.frame = CGRect.init(x: 0, y: tableViewY, width: k_screen_width, height: height)
        
    }
    
    ///更新文章
    func sortArticleData(_ sortTypeTemp: SQArticleSortType, _ needScroolToTop: Bool = false) {
        if sortType == sortTypeTemp  {
            return
        }
        
        sortType = sortTypeTemp
        if needScroolToTop {
           self.needScroolToTop = needScroolToTop
           sortTypeView.updateSelBtn(sortType.rawValue)
        }
        sortType = sortTypeTemp
        detailArray.removeAll()
        
        startRefresh()
    }
    
    final func addRefresh(){
        tableView.mj_header = MJRefreshNormalHeader.init(
            refreshingTarget: self,
            refreshingAction: #selector(startRefresh)
        )
    }
    
    final func stopRefresh(){
        tableView.mj_header?.endRefreshing()
//        tableView.mj_footer.endRefreshing()
    }
    
    @objc func startRefresh(){
        currentPage = 1
        requestNetWork(startPage: 0)
    }
    
    
    
    @objc  override func addMore(){
        //requestNetWork(false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}


extension SQHomeSubViewController {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if detailArray.count == 0 {
            return tableView.height()
        }
        
        let model = detailArray[indexPath.row]
        if model.cellType == .advertisement {
            return SQAdvertisementView.advertiesViewHeight
        }
        
        return model.itemFrame.rowH
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailArray.count == 0 ? 1 : detailArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if detailArray.count == 0 {
            let emptyCell: SQEmptyTableViewCell = SQEmptyTableViewCell.init(style: .default, reuseIdentifier: SQEmptyTableViewCell.cellID, cellType: .fl)
            pagingView.isHidden = true
            return emptyCell
        }else{
            pagingView.isHidden = false
        }
        
        let model = detailArray[indexPath.row]
        /*
          如果是广告位：
          */
        if model.cellType == .advertisement{
            
            //let adcell = SQAdvertisementCell.init(style: .default, reuseIdentifier: SQAdvertisementCell.cellID, vc: self)
            var adcell: SQAdvertisementCell?
            if indexPath.row == 6 {
                adcell = tableView.dequeueReusableCell(withIdentifier: SQAdvertisementCell.cellID1) as? SQAdvertisementCell
                adcell?.vc = self
                if model.needRefresh {
                   adcell?.url = WebViewPath.homeADUrl
                   model.needRefresh = false
                }
            } else if indexPath.row == 13 {
                adcell = tableView.dequeueReusableCell(withIdentifier: SQAdvertisementCell.cellID2) as? SQAdvertisementCell
                adcell?.vc = self
                if model.needRefresh {
                   adcell?.url = WebViewPath.homeADUrl
                   model.needRefresh = false
                }
                
            } else if indexPath.row == 20 {
                adcell = tableView.dequeueReusableCell(withIdentifier: SQAdvertisementCell.cellID3) as? SQAdvertisementCell
                adcell?.vc = self
               if model.needRefresh {
                   adcell?.url = WebViewPath.homeADUrl
                   model.needRefresh = false
                }
            }
            
//            adcell.url = "https://demo0.tysqapp.com/html5/advertisement/app_home.html"
            return adcell ?? SQAdvertisementCell()
         }
       
        
        let cell: SQHomeInfoDetailCell = tableView.dequeueReusableCell(withIdentifier: "homeInfoDetailID") as! SQHomeInfoDetailCell
        
        cell.homeArticlesInfo = model
 
        
        ///删除文章
        weak var weakSelf = self
        cell.articleDeleteCallBack = { (isDeleted, articleID) in
            weakSelf?.detailArray.removeAll(where: {$0.id == articleID})
            weakSelf?.tableView.reloadData()
        }
        
        cell.jumpAuthorCallBack = { authorId in
            let vc = SQPersonalVC()
            vc.accountID = authorId
            vc.hidesBottomBarWhenPushed = true
            weakSelf?.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        if callBack != nil {
//            callBack!(0)
//        }
        offsetY = scrollView.contentOffset.y
        canSetContentOffest = true
        isDecelerate        = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        TiercelLog("offsetY\(offsetY)")
        ///如果内容高度小于tableview高度 则不需要隐藏二级分类
        if tableView.contentSize.height < (tableView.height() - sortTypeView.height()) {
            return
        }
        
        if isDecelerate {
            let localOffsetY = scrollView.contentOffset.y
            let offsetValue  = offsetY - localOffsetY
            if offsetValue  > 0 { ///大于0为下拉
                absorbTheTop(true,false)
            }else{ ///触发隐藏二级分类栏
                absorbTheTop(true,true)
            }
        }
    }
    
    

    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        if callBack != nil {
//            callBack!(1)
//        }
    }
    
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isDecelerate = decelerate
        ///如果内容高度小于tableview高度 则不需要隐藏二级分类
        if tableView.contentSize.height < (tableView.height() - sortTypeView.height()) {
            return
        }
        let localOffsetY = scrollView.contentOffset.y
        let offsetValue  = offsetY - localOffsetY
        if offsetValue  > 0 { ///大于0为下拉
            if (showPageTitleViewCallBack != nil) {
                showPageTitleViewCallBack!(true)
            }
            absorbTheTop(true,false)
        }else{ ///触发隐藏二级分类栏
            let frame = tableView.convert(advView.frame, from: tableView.superview)
            if frame.origin.y > 20 {
                if (showPageTitleViewCallBack != nil) {
                    showPageTitleViewCallBack!(false)
                }
            }
            
            absorbTheTop(true,true)
        }
        
    }
    
    func absorbTheTop(_ isFinish: Bool,_ isPullUp: Bool) {
        if tableView.mj_header?.isRefreshing ?? false {
            return
        }
        
        if !canSetContentOffest {
            return
        }
        
        if needScroolToTop {
            return
        }
        
        if tableView.contentSize.height < tableView.height() + sortTypeView.maxY() - k_status_bar_height {
            return
        }
        
        let frame = tableView.convert(sortTypeView.frame, to: UIApplication.shared.keyWindow)
        let top = SQHomeTableViewController.markTitlesViewH + k_status_bar_height
        if isPullUp { ///上拉为吸顶效果
            let  maxTop = SQHomeSortTypeView.sortTypeViewH + top
            ///如果是在一级栏目里面的话 则不触发吸顶动画 返回不隐藏首页排序view
            if frame.maxY  < top {
                callBack!(true,sortTypeView)
                return
            }
            
            ///如果是在一级栏目外面的话 则不触发 返回不隐藏首页排序view
            if frame.origin.y < maxTop { ///触发吸顶效果
                canSetContentOffest = false
                tableView.setContentOffset(CGPoint.init(x: 0, y: sortTypeView.maxY() - maxTop + k_status_bar_height), animated: true)
                callBack!(true,sortTypeView)
            }else{
               // callBack!(isPullUp,false,sortTypeView)
            }
        }else{ ///下拉则为隐藏排序按钮
            let  maxTop = SQHomeSortTypeView.sortTypeViewH + top
            
            if frame.minY > maxTop {
                callBack!(false,sortTypeView)
                return
            }
            
            if frame.maxY > top {
                canSetContentOffest = false
                tableView.setContentOffset(CGPoint.init(x: 0, y: sortTypeView.maxY() - maxTop - SQHomeSortTypeView.sortTypeViewH + k_status_bar_height), animated: true)
                callBack!(false,sortTypeView)
            }else{
                //callBack!(isPullUp,true,sortTypeView)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if detailArray.count == 0 {
            return
        }
        let model     = detailArray[indexPath.row]
        /*
         如果是广告位：
         */
        
        if  model.cellType == .advertisement {

            return
        }
        
        let vc        = SQHomeArticleInfoVC()
        
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        vc.article_id = model.id
    }
}

extension SQHomeSubViewController {
    
    func requestNetWork(startPage: Int) {
        weak var weakSelf = self
        detailArray.removeAll()
        SQHomeNewWorkTool.getArticleList(model!.parent_id, model!.id, SQHomeInfoDetailTableFooterView.pageSize, startPage, sortType) { (model, statu, errorMesaage) in
            weakSelf?.stopRefresh()
            if errorMesaage != nil {
               SQEmptyView.showEmptyView(handel: { (click) in
                   if click {
                    weakSelf?.requestNetWork(startPage: startPage)
                   }
               })
               weakSelf?.tableView.reloadData()
               return
            }
                        
            weakSelf?.pagingView.update(currentPage: weakSelf?.currentPage, totalNum: model!.total_num)
            
            /**
                        每6篇文章中插入一条广告，预留位置即可，具体广告内容读取静态页面，修改静态页面即可修改对应的广告内容；

                        随机抓取该类型的广告展示，不是每次都是展示同一条广告；

                        如该类型静态页面广告没有，则显示默认的广告（@设计师和运营提供默认广告内容）；

                        广告不纳入列表数量计算，如每页展示30条数据，则是每页展示30篇文章，不包括广告；
                        */
            let detailArrayCount = weakSelf?.detailArray.count ?? 0
            for (index,model) in model!.articles.enumerated() {
                model.createItemFrame()
                weakSelf?.detailArray.append(model)
                if (detailArrayCount + index + 1) % 6 == 0 {
                    let addModel = SQHomeInfoDetailItemModle()
                    addModel.cellType = .advertisement
                   weakSelf?.detailArray.append(addModel)
                }
            }
           
            weakSelf?.getTopArticleList()
            weakSelf?.tableView.reloadData()
            if weakSelf?.needScroolToTop ?? false {
                weakSelf?.scrollToFirstCell()
            }
        }
    }
    
    @objc func getTopArticleList() {
        ///推荐板块就不需要了
        if model!.parent_id == -1 {
            return
        }
        
        if sortType != .synthesize {
            self.topArticleArray.removeAll()
            initTableHeaderView()
            return
        }
        
        SQHomeNewWorkTool.getTopArticleList(parent_id: model!.parent_id, category_id: model!.id) {[weak self] (listModel, statu, errorMessage) in
            if (errorMessage != nil) {
                return
            }
            
            self?.topArticleArray.removeAll()
            TiercelLog(listModel!.toJSONString())
            for item in listModel!.articles {
                item.fatherID = self?.model?.parent_id ?? 0
                item.id       = self?.model?.id ?? 0
                self?.topArticleArray.append(item)
            }
            
            self?.initTableHeaderView()
        }
    }
    
    func getSortViewFrame() -> CGRect {
        if detailArray.count == 0 {
            return CGRect.init(x: 0, y: 200, width: 0, height: 0)
        }
        let frame = tableView.convert(sortTypeView.frame, to: UIApplication.shared.keyWindow)
        return frame
    }
    
    func scrollToFirstCell() {
        //let point = sortTypeView.convert(sortTypeView.origin(), from: tableView)
        tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
        if detailArray.count > 0 {
            tableView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
        }
        parentVC?.sortTypeView.isHidden = true
        parentVC?.pageTitleView(hiddenBy: true)
        needScroolToTop = false
    }
}


class SQBannerAdvView: UIView {
    
}


