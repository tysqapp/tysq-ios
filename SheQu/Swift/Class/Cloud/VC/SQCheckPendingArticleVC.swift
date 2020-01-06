//
//  SQCheckPendingArticleVC.swift
//  SheQu
//
//  Created by gm on 2019/8/27.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

///待审核文章
class SQCheckPendingArticleVC: SQViewController {
    
    ///删除审核文章通知
    static let noti_audit_article_delete = Notification.Name.init(rawValue: "noti_auditArticleKey")
    static let noti_audit_article_delete_key = "noti_audit_article_delete_key"
    
    ///版主未审核列表
    var auditArticleItemModelArrM = [SQAuditArticleItemModel]()
    
    /// 版主未审核model
    lazy var auditArticleListModel = SQAuditArticleListModel()
    
    lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.font            = k_font_title_11
        headerLabel.textColor       = k_color_title_gray
        headerLabel.frame           = CGRect.init(x: 20, y: 0, width: k_screen_width - 20, height: 30)
        return headerLabel
    }()
    
    lazy var tableHeaderView: UIView = {
        let tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: 30))
        tableHeaderView.backgroundColor = UIColor.colorRGB(0xf5f5f5)
        tableHeaderView.addSubview(headerLabel)
        return tableHeaderView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "待审核文章"
        addTableView(frame: view.bounds)
        tableView.tableHeaderView = tableHeaderView
        tableView.rowHeight  = SQCheckPendingArticleTableViewCell.height
        tableView.register(SQCheckPendingArticleTableViewCell.self, forCellReuseIdentifier: SQCheckPendingArticleTableViewCell.cellID)
        addFooter()
        getAuditAiticleList()
        addNoti()
    }
    
    private func addNoti() {
        let notiName  = SQCheckPendingArticleVC.noti_audit_article_delete
        NotificationCenter.default.addObserver(
              self,
              selector: #selector(reciveAuditArticleDelete(noti:)),
              name: notiName,
              object: nil)
    }
    
    @objc func reciveAuditArticleDelete(noti: NSNotification){
        
        guard let dict: [String: String] = noti.object as? [String : String] else {
            return
        }
        
        let articleID = dict[SQCheckPendingArticleVC.noti_audit_article_delete_key]
        
        auditArticleItemModelArrM.removeAll {$0.article_id == articleID}
        
        var num = auditArticleListModel.articles_num - 1
        if num < 0 {
            num = 0
        }
        
        headerLabel.text = "\(num)篇"
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = "待审核文章"
    }
    
    override func addMore() {
        getAuditAiticleList()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SQCheckPendingArticleVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return auditArticleItemModelArrM.count == 0 ? 1 : auditArticleItemModelArrM.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if auditArticleItemModelArrM.count == 0 {
            tableView.tableHeaderView = UIView()
            let cell = SQEmptyTableViewCell.init(style: .default, reuseIdentifier: SQEmptyTableViewCell.cellID, cellType: .auditArticleList)
            return cell
        }else {
            if indexPath.row == 0 {
                tableView.tableHeaderView = tableHeaderView
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SQCheckPendingArticleTableViewCell.cellID) as! SQCheckPendingArticleTableViewCell
        cell.itemModel = auditArticleItemModelArrM[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if auditArticleItemModelArrM.count == 0 {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
        let itemModel = auditArticleItemModelArrM[indexPath.row]
        let vc = SQHomeArticleInfoVC()
        vc.article_id = itemModel.article_id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if auditArticleItemModelArrM.count == 0 {
            return tableView.height()
        }
        
        return SQCheckPendingArticleTableViewCell.height
    }
    
}


extension SQCheckPendingArticleVC {
    
    func getAuditAiticleList() {
        weak var weakSelf = self
        SQCloudNetWorkTool.getAuditArticle(start: auditArticleItemModelArrM.count, size: 20) { (listModel, statu, errorMessage) in
            weakSelf?.endFooterReFresh()
            if errorMessage != nil {
                if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: statu, handel: nil) {
                    return
                }
                SQEmptyView.showUnNetworkView(statu: statu, handel: { (isClick) in
                    if isClick {
                        weakSelf?.getAuditAiticleList()
                    }else{
                        weakSelf?.navigationController?
                            .popViewController(animated: true)
                    }
                })
                return
            }
            
            weakSelf?.auditArticleListModel = listModel!
            weakSelf?.headerLabel.text = "\( weakSelf?.auditArticleListModel.articles_num ?? 0)篇"
            
            if listModel!.review_articles.count < 20 {
                weakSelf!.endFooterReFreshNoMoreData()
            }
            
            for model in listModel!.review_articles {
                weakSelf?.auditArticleItemModelArrM.append(model)
            }
            
            weakSelf?.tableView.reloadData()
        }
    }
    
}
