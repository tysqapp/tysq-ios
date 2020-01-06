//
//  SQNotificationVC.swift
//  SheQu
//
//  Created by gm on 2019/8/27.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

///通知中心
class SQNotificationVC: SQViewController {
    
    var notificationListItemModelArr = [SQNotificationListItemModel]()
    
    
    lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.font            = k_font_title_11
        headerLabel.textColor       = k_color_title_gray
        headerLabel.frame           = CGRect.init(x: 20, y: 0, width: k_screen_width - 20, height: 30)
        return headerLabel
    }()
    
    lazy var readAllBtn: UIButton = {
        let readAllBtn = UIButton()
        readAllBtn.setTitle("全部标记为已读", for: .normal)
        readAllBtn.titleLabel?.font = k_font_title_11
        readAllBtn.setTitleColor(k_color_normal_blue, for: .normal)
        readAllBtn.frame = CGRect.init(x: k_screen_width - 100, y: 0, width: 80, height: 30)
        readAllBtn.addTarget(self, action: #selector(readAllNotifications), for: .touchUpInside)
        return readAllBtn
    }()
    
    
    lazy var tableHeaderView: UIView = {
        let tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: 30))
        tableHeaderView.backgroundColor = UIColor.colorRGB(0xf5f5f5)
        tableHeaderView.addSubview(headerLabel)
        tableHeaderView.addSubview(readAllBtn)
        return tableHeaderView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView(frame: view.bounds)
        tableView.register(SQNotificationInfoTableViewCell.self, forCellReuseIdentifier: SQNotificationInfoTableViewCell.cellID)
        tableView.tableHeaderView = tableHeaderView
        tableView.separatorStyle = .none
        addRightNav()
        addFooter()
        addMore()
    }
    
    private func addRightNav() {
        let settingBtn = UIButton()
        settingBtn.setTitle("设置", for: .normal)
        settingBtn.setTitleColor(k_color_black, for: .normal)
        settingBtn.titleLabel?.font = k_font_title
        settingBtn.sizeToFit()
        settingBtn.addTarget(self, action: #selector(goNotiSettingVC), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: settingBtn)
    }
    
    @objc func goNotiSettingVC() {
        let vc = SQNotiSettingVC()
        navigationController?.pushViewController(vc, animated: true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "通知"
    }
    
    override func addMore() {
        getNotificationList()
    }
}

extension SQNotificationVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationListItemModelArr.count == 0 ? 1 : notificationListItemModelArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if notificationListItemModelArr.count == 0 {
            tableView.tableHeaderView = UIView()
            let cell = SQEmptyTableViewCell.init(style: .default, reuseIdentifier: SQEmptyTableViewCell.cellID, cellType: .auditArticleList)
            return cell
        } else {
            tableView.tableHeaderView = tableHeaderView
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SQNotificationInfoTableViewCell.cellID) as! SQNotificationInfoTableViewCell
        cell.model = notificationListItemModelArr[indexPath.row]
        cell.jumpPersonalCallback = { [weak self] senderID in
            let vc = SQPersonalVC()
            vc.accountID = senderID
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if notificationListItemModelArr.count == 0 {
            return tableView.height()
        }
        
        return SQNotificationInfoTableViewCell.getRowHeight(FromMessage: notificationListItemModelArr[indexPath.row].content)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(notificationListItemModelArr.count == 0){
            return
        }
        let cell =  tableView.cellForRow(at: indexPath) as! SQNotificationInfoTableViewCell
        cell.isSelected = false
        notificationListItemModelArr[indexPath.row].is_read = true
        cell.redPointView.isHidden = true
        //设置通知已读
        SQCloudNetWorkTool.setNotiReaded(notify_id: notificationListItemModelArr[indexPath.row].notify_id) { (model, status, errorMessage) in
            
            if errorMessage != nil {
                return
            }
            
        }
        
        switch notificationListItemModelArr[indexPath.row].action {
        case "article_review", "article_new_comment", "review_pass", "review_unpass", "comment_new_reply", "new_report_handler" :
            let vc = SQHomeArticleInfoVC()
            vc.article_id = notificationListItemModelArr[indexPath.row].article_id
            navigationController?.pushViewController(vc, animated: true)
            
        case "effective_report_handler", "invalid_report_handler":
            let vc = SQReportDetailVC()
            vc.reportID = notificationListItemModelArr[indexPath.row].report_id
            navigationController?.pushViewController(vc, animated: true)
        /**5.2期新增：分类删除通知，点击进入文章编辑页面；*/
            //--ToDo
        case "delete_category":
            let vc = SQHomeWriteArticleVC()
            vc.editArticle = notificationListItemModelArr[indexPath.row].article_id
            navigationController?.pushViewController(vc, animated: true)
            
            
        default:
            break
        }
        
    }
    
    ///通过推送增加行
    func addRow(item: SQNotificationListItemModel){
        if(notificationListItemModelArr.count == 0){
            notificationListItemModelArr.append(item)
            tableView.reloadData()
            return
        }
        
        var indexPathsArr = [IndexPath]()
        let indexPath = IndexPath(row: 0, section: 0)
        indexPathsArr.append(indexPath)
        //这个位置应该在修改tableView之前将数据源先进行修改,否则会崩溃........必须向tableView的数据源数组中相应的添加一条数据
        notificationListItemModelArr.append(item)
        tableView.beginUpdates()
        tableView.insertRows(at: indexPathsArr, with: .automatic)
        tableView.endUpdates()
    }
    
    
}


extension SQNotificationVC {
    func getNotificationList(){
        weak var weakSelf = self
        SQCloudNetWorkTool.getNotificationsList(start: notificationListItemModelArr.count, size: 20) { (listModel, status, errorMessage) in
            weakSelf?.endFooterReFresh()
            
            if errorMessage != nil {
                if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: status, handel: nil) {
                    return
                }
                
                SQEmptyView.showUnNetworkView(statu: status, handel: { (isClick) in
                    if isClick {
                        weakSelf?.getNotificationList()
                    }else{
                        weakSelf?.navigationController?
                            .popViewController(animated: true)
                    }
                })
                return
            }
            
            if listModel!.notify_info.count < 20{
                weakSelf?.endFooterReFreshNoMoreData()
            }
            weakSelf?.headerLabel.text = "\(listModel!.total_number)条通知"
            weakSelf?.notificationListItemModelArr.append(contentsOf: listModel!.notify_info)
            weakSelf?.tableView.reloadData()
        }
        
        
        
    }
    /**5.2：全部设置已读*/
    @objc func readAllNotifications() {
        SQCloudNetWorkTool.setNotiAllReaded { [weak self] (model, status, errorMessage) in
            if errorMessage != nil {
                return
            }
            
            let isUnReaded = model!.is_un_read
            
            if !isUnReaded {
                self?.showToastMessage("当前没有未读通知")
                return
            } else {
                self?.notificationListItemModelArr.removeAll()
                self?.getNotificationList()
                self?.showToastMessage("标记成功")
            }
            
        }
    }

}
