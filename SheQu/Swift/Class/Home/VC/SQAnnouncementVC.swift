//
//  SQAnnouncementVC.swift
//  SheQu
//
//  Created by gm on 2019/8/21.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

///公告栏
class SQAnnouncementVC: SQViewController {
    
    lazy var announcementArray = [SQAnnouncementItemData]()
    
    lazy var tableHeaderView: UIView = {
        let tableHeaderView = UIView()
        tableHeaderView.frame = CGRect.init(x: 0, y: 0, width: k_screen_width, height: 10)
        return tableHeaderView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        tableView.register(SQAnnouncementTableViewCell.self, forCellReuseIdentifier: SQAnnouncementTableViewCell.cellID)
        addFooter()
        addMore()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "公告"
    }
    
    @objc override func addMore() {
        requestNetwork()
    }
}


extension SQAnnouncementVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcementArray.count == 0 ? 1 : announcementArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if announcementArray.count == 0 {
            let emptyCell: SQEmptyTableViewCell = SQEmptyTableViewCell.init(style: .default, reuseIdentifier: SQEmptyTableViewCell.cellID, cellType: .announcement)
            tableView.tableHeaderView = UIView()
            return emptyCell
        }else{
            if indexPath.row == 0 {
                tableView.tableHeaderView = tableHeaderView
            }
        }
        
        let cell = SQAnnouncementTableViewCell.init(style: .default, reuseIdentifier: SQAnnouncementTableViewCell.cellID, width: k_screen_width, imageX: 20)
        let model = announcementArray[indexPath.row]
        cell.customItemData = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if announcementArray.count == 0 {
            return tableView.height()
        }
        
        return SQAnnouncementTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if announcementArray.count == 0 {
            return
         }
        
        let itemData = announcementArray[indexPath.row]
        if itemData.jumpUrl.count < 1 {
            return
        }
        
        let articleID = itemData.getArticleID()
        if articleID.count > 0 {
            let artVC = SQHomeArticleInfoVC()
            navigationController?.pushViewController(artVC, animated: true)
            artVC.article_id = articleID
        }else{
            let webVC = SQWebViewController()
            if itemData.jumpUrl.hasPrefix("/api/") {
                webVC.urlPath = SQHostStruct.getLoaclHost() + itemData.jumpUrl
            } else {
                webVC.urlPath = itemData.jumpUrl
            }
            
            navigationController?.pushViewController(webVC, animated: true)
        }
        
    }
    
}

extension SQAnnouncementVC {
    
    ///获取公告栏数
    func requestNetwork() {
        weak var weakSelf = self
        let size = 10
        SQHomeNewWorkTool.getAnnouncement(
        announcementArray.count,size,SQAnnouncemenType.announcemen
        )
        { (listModel, statu, errorMessage) in
            
            weakSelf?.endFooterReFresh()
            if (errorMessage != nil) {
                return
            }
            
            if listModel!.announcement_list.count < size {
                weakSelf?.endFooterReFreshNoMoreData()
            }
            
            let tempArray = listModel!.announcement_list.filter { (itemModel) -> Bool in
                return itemModel.position == 1 || itemModel.position == 3
            }
            
            let count: Int = weakSelf?.announcementArray.count ?? 0
            for index in 0..<tempArray.count {
                let model = tempArray[index]
                let rawValue = (count + index) % 3 + 1
                let type = SQAnnouncementItemData.ImageNameType.init(rawValue: rawValue) ?? SQAnnouncementItemData.ImageNameType.blue
                let itemData = SQAnnouncementItemData.init(title: model.title, imageNameType: type, jumpUrl: model.url)
                weakSelf?.announcementArray.append(itemData)
            }
            
           weakSelf?.tableView.reloadData()
        }
    }
}
