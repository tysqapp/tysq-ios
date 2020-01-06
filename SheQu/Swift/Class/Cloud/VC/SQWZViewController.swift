//
//  SQWZViewController.swift
//  SheQu
//
//  Created by gm on 2019/5/27.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
import MJRefresh

class SQWZViewController: SQPageSubVC {
    
    static let menuTypeArray = [
        SQMenuView.MenuType.all,
        SQMenuView.MenuType.draft,
        SQMenuView.MenuType.audit,
        SQMenuView.MenuType.publish,
        SQMenuView.MenuType.auditFail,
        SQMenuView.MenuType.hidden
    ]
    
    var wzModelArrM = [SQHomeArticleItemModel]()
    
    lazy var wzListModel = SQHomeArticlesListModel()
    
    lazy var status = SQArticleAuditStatus.expend
    
    lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.font            = k_font_title_11
        headerLabel.textColor       = k_color_title_gray
        headerLabel.frame           = CGRect.init(x: 20, y: 0, width: 150, height: tableHeaderViewHeight)
        return headerLabel
    }()
    
    lazy var menuView: SQMenuView = {
        
        let typeArray = SQWZViewController.menuTypeArray
        let nemuViewW: CGFloat = 100
        let nemuViewX = k_screen_width - 20 - nemuViewW
        let menuViewY = k_nav_height + headerLabel.maxY() - SQMenuView.imageViewH
        let frame = CGRect.init(
            x: nemuViewX,
            y: menuViewY,
            width: nemuViewW,
            height: 300
        )
        
        weak var weakSelf = self
        let nemuView = SQMenuView.init(frame: frame, typeArray: typeArray, trianglePosition: .right, handel: { (type, title) in
            var  status = SQArticleAuditStatus.expend
            switch type {
            case .all:
                break
            case .draft:
                status = SQArticleAuditStatus.draft
                break
            case .audit:
                status = SQArticleAuditStatus.audit
                break
            case .publish:
                status = SQArticleAuditStatus.publish
                break
            case .auditFail:
                status = SQArticleAuditStatus.aduitFail
                break
            case .hidden:
                status = SQArticleAuditStatus.hidden
                
            default:
                break
            }
            
            if weakSelf?.status == status{
                
            }else {
               weakSelf?.status = status
               weakSelf?.chooseBtn.setTitle(title, for: .normal)
               weakSelf?.wzModelArrM.removeAll()
               weakSelf?.addMore()
            }
        })
        
        return nemuView
    }()
    
    lazy var chooseBtn: SQImagePositionBtn = {
        let chooseBtnW: CGFloat = 60
        let chooseBtnX = k_screen_width - chooseBtnW - 20
        let chooseBtnFrame = CGRect.init(
            x: chooseBtnX,
            y: 0,
            width: chooseBtnW,
            height: tableHeaderViewHeight
        )
        
        let chooseBtn = SQImagePositionBtn.init(
            frame: chooseBtnFrame,
            position: .right,
            imageViewSize: CGSize.init(width: 7, height: 4),
            ritghtMargin: 5
        )
        
        chooseBtn.setImage(UIImage.init(named: "sq_wz_load_all"), for: .normal)
        chooseBtn.setTitle("全部", for: .normal)
        chooseBtn.setTitleColor(k_color_title_gray, for: .normal)
        chooseBtn.contentHorizontalAlignment = .right
        chooseBtn.titleLabel?.textAlignment = .right
        chooseBtn.titleLabel?.font = k_font_title_11
        chooseBtn.imageView?.contentMode = .right
        chooseBtn.addTarget(self, action: #selector(showLoadMoreView), for: .touchUpInside)
        return chooseBtn
    }()
    
    lazy var tableHeaderView: UIView = {
        let tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: tableHeaderViewHeight))
        tableHeaderView.backgroundColor = UIColor.colorRGB(0xf5f5f5)
        tableHeaderView.addSubview(headerLabel)
        tableHeaderView.addSubview(chooseBtn)
        return tableHeaderView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView(frame: view.bounds)
        tableView.separatorStyle = .none
        tableView.tableHeaderView = tableHeaderView
        tableView.register(SQArticleInfoTableViewCell.self, forCellReuseIdentifier: SQArticleInfoTableViewCell.cellID)
       
        if tableHeaderViewHeight == 0 {
            status = .publish
        }
         
        addFooter()
        addMore()
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
        navigationItem.title = "我的文章"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        menuView.hiddenMenuView()
    }
    
    @objc func showLoadMoreView() {
        if menuView.isShowing {
            menuView.hiddenMenuView()
        }else{
            menuView.showMenuView()
        }
    }
    
    @objc override func addMore() {
        getWZList(status)
    }
}


extension SQWZViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wzModelArrM.count == 0 ? 1 : wzModelArrM.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if wzModelArrM.count == 0 {
            let emptyCell: SQEmptyTableViewCell = SQEmptyTableViewCell.init(style: .default, reuseIdentifier: SQEmptyTableViewCell.cellID, cellType: .wzList)
            //tableView.tableHeaderView = UIView()
            return emptyCell
        }
        
        let cell: SQArticleInfoTableViewCell = SQArticleInfoTableViewCell.init(style: .default, reuseIdentifier: SQArticleInfoTableViewCell.cellID)
        
        ///回调删除文章
        weak var weakSelf = self
        cell.deleteCallBack = { (isDeleted, articleID) in
            
            weakSelf?.wzModelArrM.removeAll(where: { $0.article_id == articleID})
            
            ///判断是否需要更新tableView
            weakSelf?.tableView.reloadData()
            weakSelf?.wzListModel.total_num -= 1
            weakSelf?.headerLabel.text = "\( weakSelf?.wzListModel.total_num ?? 0)篇文章"
        }
        
        let model = wzModelArrM[indexPath.row]
        cell.infoModel = model
        cell.bottomView.nikeNameBtn.setWidth(width: 0)
        cell.bottomView.timeLabel.text = model.created_time.formatStr("YYYY-MM-dd HH:mm")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if wzModelArrM.count == 0 {
            return tableView.height()
        }
        let model = wzModelArrM[indexPath.row]
        return model.articleFrame.line3ViewFrame.maxY
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if wzModelArrM.count == 0 {
            return
        }
        let model = wzModelArrM[indexPath.row]
        let atricleVC = SQHomeArticleInfoVC()
        navigationController?.pushViewController(atricleVC, animated: true)
        atricleVC.article_id = model.article_id
    }
}

extension SQWZViewController {
    
    func getWZList(_ status: SQArticleAuditStatus) {
        weak var weakSelf = self
        let start = wzModelArrM.count
        SQCloudNetWorkTool.getWZList(start, start + 20, true, status, accountID) { (wzList, statu, errorMessage) in
            weakSelf?.endFooterReFresh()
            
            if errorMessage != nil {
                if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: statu, handel: nil) {
                    return
                }
                SQEmptyView.showUnNetworkView(statu: statu, handel: { (isClick) in
                    if isClick {
                        weakSelf?.getWZList(status)
                    }else{
                        weakSelf?.navigationController?
                            .popViewController(animated: true)
                    }
                })
                return
            }
            
            weakSelf?.wzListModel.total_num = wzList!.total_num
            weakSelf?.headerLabel.text = "\( weakSelf?.wzListModel.total_num ?? 0)篇文章"
            
            if wzList!.articles_info.count < 20 {
                weakSelf?.endFooterReFreshNoMoreData()
            }
            
            for model in wzList!.articles_info {
                let homeArticleItemModel = model.toHomeArticleItemModel()
                weakSelf?.wzModelArrM.append(homeArticleItemModel)
            }
            
            weakSelf?.tableView.reloadData()
        }
    }
}

