//
//  SQCollectViewController.swift
//  SheQu
//
//  Created by gm on 2019/8/12.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQCollectViewController: SQPageSubVC {
    
    var collectModelArrM = [SQHomeArticleItemModel]()
    
    lazy var collectListModel = SQHomeArticlesListModel()
    
    lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.font            = k_font_title_11
        headerLabel.textColor       = k_color_title_gray
        headerLabel.frame           = CGRect.init(x: 20, y: 0, width: k_screen_width - 20, height: tableHeaderViewHeight)
        return headerLabel
    }()
    
    lazy var tableHeaderView: UIView = {
        let tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: tableHeaderViewHeight))
        tableHeaderView.backgroundColor = UIColor.colorRGB(0xf5f5f5)
        tableHeaderView.addSubview(headerLabel)
        return tableHeaderView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView(frame: view.bounds)
        tableView.separatorStyle = .none
        tableView.register(SQArticleInfoTableViewCell.self, forCellReuseIdentifier: SQArticleInfoTableViewCell.cellID)
        addFooter()
        addMore()
        
        ///监听收藏按钮通知
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
        
        ///这里是新增收藏 刷新当前数据
        if collectState {
            getCollectList(true)
            return
        }
        
        ///如果是取消收藏
        var deleteIndex = -1
        for index in 0..<collectModelArrM.count {
            let model = collectModelArrM[index]
            if model.article_id == article_id {
                deleteIndex = index
                break
            }
        }
        
        if deleteIndex >= 0 {
            collectModelArrM.remove(at: deleteIndex)
            if collectModelArrM.count == 0 {
                tableView.reloadData()
            }else{
                let deleteIndexArray = [IndexPath.init(row: deleteIndex, section: 0)]
               tableView.deleteRows(at: deleteIndexArray, with: .none)
            }
            
            headerLabel.text = "\(collectListModel.total_num)篇文章"
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = (tableHeaderViewHeight == 0) ? view.height() - 45 - k_nav_height : view.height()
        let frame = CGRect.init(x: 0, y: 0, width: k_screen_width, height: height)
        tableView.frame = frame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "我的收藏"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc override func addMore() {
        getCollectList()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SQCollectViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectModelArrM.count == 0 ? 1 : collectModelArrM.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if collectModelArrM.count == 0 {
            let emptyCell: SQEmptyTableViewCell = SQEmptyTableViewCell.init(style: .default, reuseIdentifier: SQEmptyTableViewCell.cellID, cellType: .collectList)
            tableView.tableHeaderView = UIView()
            return emptyCell
        }else{
            if indexPath.row == 0 {
                tableView.tableHeaderView = tableHeaderView
            }
        }
        
        let cell: SQArticleInfoTableViewCell = SQArticleInfoTableViewCell.init(style: .default, reuseIdentifier: SQArticleInfoTableViewCell.cellID,true)
        
        ///回调删除文章
        weak var weakSelf = self
        cell.deleteCallBack = { (isDeleted, articleID) in
            weakSelf?.collectModelArrM.removeAll(where: {$0.article_id == articleID})
            weakSelf?.tableView.reloadData()
            weakSelf?.collectListModel.total_num -= 1
            weakSelf?.headerLabel.text = "\( weakSelf?.collectListModel.total_num ?? 0)篇文章"
        }
        
        let model = collectModelArrM[indexPath.row]
        model.created_time = model.create_time
        cell.infoModel = model
        cell.bottomView.nikeNameBtn.setWidth(width: 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if collectModelArrM.count == 0 {
            return tableView.height()
        }
        
        let model = collectModelArrM[indexPath.row]
        return model.articleFrame.line2ViewFrame.maxY
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if collectModelArrM.count == 0 {
            return
        }
        
        let model = collectModelArrM[indexPath.row]
        let atricleVC = SQHomeArticleInfoVC()
        navigationController?.pushViewController(atricleVC, animated: true)
        atricleVC.article_id = model.article_id
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableHeaderViewHeight == 0 {
            return false
        }
        return collectModelArrM.count == 0 ? false : true
    }
    
    ///删除
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        weak var weakSelf = self
        let deleteAction = UITableViewRowAction.init(style: .default, title: "取消收藏") { (action, deleteIndexPath) in
            weakSelf?.cancelCollectFromNetwork(deleteIndexPath)
        }
        
        return [deleteAction]
    }
}

extension SQCollectViewController {
    
    func cancelCollectFromNetwork(_ indexPath: IndexPath) {
        
        let model = collectModelArrM[indexPath.row]
        weak var weakSelf = self
        SQHomeNewWorkTool.updateArticleInfoCollectState(article_id: model.article_id, collectStatu: false) { (model, statu, errorMessage) in
            
            
            if (errorMessage != nil) {
                SQToastTool.showToastMessage("取消收藏失败")
                return
            }
            
            SQToastTool.showToastMessage("已取消收藏")
            weakSelf?.collectListModel.total_num -= 1
            weakSelf?.headerLabel.text = "\( weakSelf?.collectListModel.total_num ?? 0)篇文章"
            weakSelf?.collectModelArrM.remove(at: indexPath.row)
            if weakSelf?.collectModelArrM.count == 0 {
                weakSelf?.tableView.reloadData()
            }else{
                weakSelf?.tableView.deleteRows(
                    at: [indexPath],
                    with: .automatic
                )
            }
        }
        
    }
    
    func getCollectList(_ isFresh: Bool = false) {
        weak var weakSelf = self
        var start = collectModelArrM.count
        if isFresh {
            start = 0
        }
        SQCloudNetWorkTool.getCollectList(start, start + 20, true, accountID) { (collectList, statu, errorMessage) in
            weakSelf?.endFooterReFresh()
            if errorMessage != nil {
                if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: statu, handel: nil) {
                    return
                }
                
                SQEmptyView.showUnNetworkView(statu: statu, handel: { (isClick) in
                    if isClick {
                        weakSelf?.getCollectList()
                    }else{
                        weakSelf?.navigationController?.popViewController(
                            animated: true)
                    }
                })
                return
            }
            
            if isFresh {
                weakSelf?.collectModelArrM.removeAll()
            }
            
            weakSelf?.collectListModel = collectList ?? SQHomeArticlesListModel()
            weakSelf?.headerLabel.text = "\( weakSelf?.collectListModel.total_num ?? 0)篇文章"
            if collectList!.articles_info.count < 20 {
                weakSelf?.endFooterReFreshNoMoreData()
            }
            
            for model in collectList!.articles_info {
                model.createArticleFrame()
                weakSelf?.collectModelArrM.append(model)
            }
            
            weakSelf?.tableView.reloadData()
        }
    }
}



