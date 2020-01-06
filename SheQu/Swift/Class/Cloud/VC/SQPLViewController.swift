//
//  SQPLViewController.swift
//  SheQu
//
//  Created by gm on 2019/5/27.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQPLViewController: SQPageSubVC {
    
    lazy var isNeedRefresh = false
    var commentInfoArray = [SQAccountCommentInfoModel]()
    lazy var accountComment = SQAccountComment()
    
    lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.font            = k_font_title_11
        headerLabel.textColor       = k_color_title_gray
        headerLabel.frame           = CGRect.init(x: 20, y: 0, width: k_screen_width - 20, height: tableHeaderViewHeight)
        return headerLabel
    }()
    
    lazy var headerView: UIView = {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: tableHeaderViewHeight))
        headerView.backgroundColor = UIColor.colorRGB(0xf5f5f5)
        headerView.addSubview(headerLabel)
        return headerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let height = (tableHeaderViewHeight == 0) ? view.height() - 45 - k_nav_height : view.height()
        let frame = CGRect.init(x: 0, y: 0, width: k_screen_width, height: height)
        addTableView(frame: frame)
        tableView.separatorStyle = .none
        tableView.register(SQCloudCommentTableViewCell.self, forCellReuseIdentifier: SQCloudCommentTableViewCell.cellID)
        addFooter()
        getPLList(true)
    }
    
    
    override func addMore() {
        getPLList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "我的评论"
        if isNeedRefresh {
            getPLList(true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isNeedRefresh = true
    }
}


extension SQPLViewController {
    func getPLList(_ needFresh: Bool = false) {
        weak var weakSelf = self
        var start = commentInfoArray.count
        if needFresh {
            start = 0
        }
        
        SQCloudNetWorkTool.getPLList(start, start + 20 , true, accountID) { (plList, statu, errorMessage) in
            weakSelf!.endFooterReFresh()
            if (errorMessage != nil) {
                if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: statu, handel: nil) {
                    return
                }
                SQEmptyView.showUnNetworkView(statu: statu, handel: { (isClick) in
                    if isClick {
                        weakSelf?.getPLList()
                    }else{
                        weakSelf?.navigationController?.popViewController(animated: true)
                    }
                })
                return
            }
            
            if weakSelf?.commentInfoArray.count == 0 {
                weakSelf?.accountComment   = plList ?? SQAccountComment()
                weakSelf?.headerLabel.text = "\(plList!.total_num)条评论"
            }
            
            if needFresh {
                weakSelf?.commentInfoArray.removeAll()
                weakSelf?.headerLabel.text = "\(plList!.total_num)条评论"
            }
            
            
            if plList!.comment_info.count < 20 {
                weakSelf?.endFooterReFreshNoMoreData()
            }
            
            for model in plList!.comment_info {
                model.creatItemFrame()
                weakSelf?.commentInfoArray.append(model)
            }
            
            weakSelf?.tableView.reloadData()
        }
    }
    
    func deleteComment(_ indexPath: IndexPath) {
        weak var weakSelf = self
        let model = commentInfoArray[indexPath.row]
        SQHomeNewWorkTool.deleteComment(model.id) { (model, statu, errorMessage) in
            if (errorMessage != nil) {
                weakSelf?.showToastMessage("删除评论失败")
                return
            }
            
            weakSelf?.showToastMessage("删除评论成功")
            weakSelf?.accountComment.total_num -= 1
            weakSelf?.headerLabel.text = "\(weakSelf?.accountComment.total_num ?? 0)条评论"
            weakSelf?.commentInfoArray.remove(at: indexPath.row)
            if weakSelf?.commentInfoArray.count ?? 0 == 0 {
                weakSelf?.tableView.reloadData()
            }else{
                weakSelf?.tableView.deleteRows(
                    at: [indexPath],
                    with: .automatic
                )
            }
        }
    }
}

extension SQPLViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentInfoArray.count == 0 ? 1 : commentInfoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if commentInfoArray.count == 0 {
            let emptyCell: SQEmptyTableViewCell = SQEmptyTableViewCell.init(style: .default, reuseIdentifier: SQEmptyTableViewCell.cellID, cellType: .pl)
            tableView.tableHeaderView = UIView()
            return emptyCell
        }else{
            if indexPath.row == 0 {
                tableView.tableHeaderView = headerView
            }
        }
        
        let cell: SQCloudCommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: SQCloudCommentTableViewCell.cellID, for: indexPath) as! SQCloudCommentTableViewCell
        
        cell.commentModel = commentInfoArray[indexPath.row]
        cell.callBack = {[weak self] accountID in
            let vc = SQPersonalVC()
            vc.accountID = accountID
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if commentInfoArray.count == 0 {
            return tableView.height()
        }
        let model =  commentInfoArray[indexPath.row]
        return model.itemFrame.lineFrame.maxY
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if commentInfoArray.count == 0 {
            return
        }
        
        let model =  commentInfoArray[indexPath.row]
        let atricleVC = SQHomeArticleInfoVC()
        atricleVC.needJumpComment = true
        navigationController?.pushViewController(atricleVC, animated: true)
        atricleVC.article_id = model.article_id
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableHeaderViewHeight == 0 {
            return false
        }
        return commentInfoArray.count == 0 ? false : true
    }
    
    ///删除
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        weak var weakSelf = self
        let deleteAction = UITableViewRowAction.init(style: .default, title: "删除") { (action, deleteIndexPath) in
            weakSelf?.deleteComment(deleteIndexPath)
        }
        
        return [deleteAction]
    }
}
