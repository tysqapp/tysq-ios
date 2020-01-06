//
//  SQFirstCommentViewController.swift
//  SheQu
//
//  Created by gm on 2019/5/23.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQFirstCommentViewController: SQViewController {
    var callBack: ((String,Bool,[SQCommentReplyModel])->())?
    var modelArray = [SQCommentReplyModel]()
    var commentModel = SQCommentModel()
    
    lazy var tableHeaderView: SQFristCommentTableHeaderView = {
        let tableHeaderView = SQFristCommentTableHeaderView.init(frame: CGRect.zero, style: .plain)
        tableHeaderView.fobinCommentCallBack = {[weak self] (accountID, accountName) in
            let vc = SQPersonalVC()
            vc.accountID = accountID
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return tableHeaderView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "评论详情"
        addTableView(frame: view.bounds)
        tableView.register(SQCommentReplyViewCell.self, forCellReuseIdentifier: SQCommentReplyViewCell.cellID)
    }
}

extension SQFirstCommentViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SQCommentReplyViewCell = tableView.dequeueReusableCell(withIdentifier: SQCommentReplyViewCell.cellID, for: indexPath) as! SQCommentReplyViewCell
        cell.replyModel = modelArray[indexPath.row]
        cell.bottomView.deleteBtn.addTarget(self, action: #selector(replyDeleteBtnClick(_:)), for: .touchUpInside)
        cell.bottomView.replayBtn.addTarget(self, action: #selector(replyReplyBtnClick(_:)), for: .touchUpInside)
        cell.bottomView.deleteBtn.titleLabel?.text = cell.replyModel?.id
        cell.bottomView.replayBtn.titleLabel?.text = cell.replyModel?.id
        
        weak var weakSelf = self
        cell.fobinCommentCallBack = { (accountID, name) in
            let vc = SQPersonalVC()
            vc.accountID = accountID
            vc.hidesBottomBarWhenPushed = true
            weakSelf?.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = modelArray[indexPath.row]
        return model.replayViewFrame.lineViewFrame.maxY
    }
}

extension SQFirstCommentViewController {
    
    func requestNetWork(_ article_id: String,_ comment_id: String) {
        
        weak var weakSelf = self
        var startTime: Int64 = 0
        let model = modelArray.last
        if model != nil {
            startTime = model!.updated_at
        }
        
        SQHomeNewWorkTool.getFirstCommentList(article_id, comment_id,20,startTime) { (model, statu, errorMessage) in
            if errorMessage != nil {
                return
            }
            
            
            if weakSelf!.commentModel.article_id.count < 1 {
                weakSelf!.commentModel = model!.article_comments.first!
                weakSelf!.commentModel.isHeaderView = true
                weakSelf!.commentModel.getCommentFrame()
                weakSelf!.tableHeaderView.setHeight(height: weakSelf!.commentModel.commentFrame.line2ViewFrame.maxY + SQFristCommentTableHeaderView.footViewH)
                weakSelf!.tableHeaderView.commentModelArray = [weakSelf!.commentModel]
                weakSelf!.tableView.tableHeaderView =  weakSelf!.tableHeaderView
                let indexPath = NSIndexPath.init(row: 0, section: 0)
                guard let cell: SQCommentTableViewCell = weakSelf!.tableHeaderView.cellForRow(at: indexPath as IndexPath) as? SQCommentTableViewCell else {
                    return
                }
                cell.bottomView.deleteBtn.titleLabel?.text = weakSelf!.commentModel.id
                cell.bottomView.replayBtn.titleLabel?.text = weakSelf?.commentModel.id
                cell.bottomView.deleteBtn.addTarget(weakSelf!, action: #selector(weakSelf!.deleteBtnClick(_:)), for: .touchUpInside)
                cell.bottomView.replayBtn.addTarget(weakSelf!, action: #selector(weakSelf!.replyBtnClick(_:)), for: .touchUpInside)
            }
            
            for replayModel in model!.article_comments.first!.reply {
                replayModel.createReplayViewFrame(true)
                weakSelf!.modelArray.append(replayModel)
            }
            
            weakSelf!.tableHeaderView.totleNumLabel.text = "\(weakSelf!.modelArray.count)条回复"
            weakSelf!.tableView.reloadData()
        }
        
    }
    
}

extension SQFirstCommentViewController {
    
    ///获取文章积分权限
    func getArticleScoreJudgement(_ commentModel: SQCommentModel, _ replyCommentModel: SQCommentReplyModel?) {
        weak var weakSelf = self
        SQHomeNewWorkTool.getAccountJudgement(
            action: SQAccountScoreJudgementModel.action.comment_article,
            resources_id: commentModel.article_id)
        { (model, statu, errorMessage) in
            if (errorMessage != nil) {
                if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: statu, handel: nil) {
                    return
                }
                return
            }
            
            if model!.is_satisfy {
                weakSelf?.commentFromNetwork(commentModel, replyCommentModel)
            }else{
               SQShowIntegralView.showIntegralView(
                vc: weakSelf!,
                integralValue: model!.limit_score,
                action: SQAccountScoreJudgementModel.action.comment_article
                )
                
            }
        }
    }
    
    
    func commentFromNetwork(_ commentModel: SQCommentModel, _ replyCommentModel: SQCommentReplyModel?) {
        let vc = SQCommentViewController()
        navigationController?.pushViewController(vc, animated: true)
        
        weak var weakSelf = self
        vc.getCommentBy(commentModel, replyCommentModel) { (replyModel) in
            replyModel.createReplayViewFrame(true)
            if weakSelf!.modelArray.count > 0 {
                weakSelf!.modelArray.insert(replyModel, at: 0)
            }else{
                weakSelf!.modelArray.append(replyModel)
            }
            
            UIView.performWithoutAnimation {
                weakSelf!.tableView.reloadData()
            }
            
            if weakSelf!.callBack != nil {
                let tempModel = replyModel.copyReplyCommentModel()
                weakSelf!.callBack!("",false,[tempModel])
            }
            
            weakSelf!.tableHeaderView.totleNumLabel.text = "\(weakSelf!.modelArray.count)条回复"
        }
    }
    
    @objc func deleteBtnClick(_ btn: UIButton) {
        weak var weakSelf = self
        let alertView = SQAlertView.sharedInstance
        alertView.showAlertView(title: "你确定要删除这条评论吗?", message: "", cancel: "取消", sure: "确定") { (index,tfStr1,tfStr2) in
            if index == 1 {
               weakSelf!.deleteComment(btn)
            }
        }
    }
    
    func deleteComment(_ btn: UIButton) {
        weak var weakSelf = self
        SQHomeNewWorkTool.deleteComment(btn.titleLabel!.text!) { (resultModel, statu, errorMessage) in
            if (errorMessage != nil) {
                return
            }
            
            let count = (weakSelf?.commentModel.reply.count ?? 0) + 1
            let dict = [
                "comment_num": count,
                "article_id": weakSelf?.commentModel.article_id ?? ""
                ] as [String : Any]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: k_noti_comment_num), object: dict)
            self.navigationController?.popViewController(animated: true)
            if self.callBack != nil {
                self.callBack!(btn.titleLabel!.text!,true, self.modelArray)
            }
        }
    }
    
    @objc func replyBtnClick(_ btn: UIButton) {
         replyComment(commentModel, nil)
    }
    
    func replyComment(_ commentModel: SQCommentModel, _ replyCommentModel: SQCommentReplyModel?) {
        guard let _: String = UserDefaults.standard.object(forKey: k_ud_user) as? String else {
            let loginVC = SQLoginViewController.getLoginVC()
            present(loginVC, animated: true, completion: nil)
            return
        }
        
        getArticleScoreJudgement(commentModel, replyCommentModel)
    }
    
    @objc func replyDeleteBtnClick(_ btn: UIButton) {
        weak var weakSelf = self
        let alertView = SQAlertView.sharedInstance
        alertView.showAlertView(title: "你确定要删除这条评论吗?", message: "", cancel: "取消", sure: "确定") { (index,tfStr1,tfStr2) in
            if index == 1 {
                weakSelf!.replyDeleteComment(btn)
            }
        }
    }
    
    func replyDeleteComment(_ btn: UIButton) {
        weak var weakSelf = self
        SQHomeNewWorkTool.deleteComment(btn.titleLabel!.text!) { (resultModel, statu, errorMessage) in
            if (errorMessage != nil) {
                return
            }
            
            var num = 0
            weakSelf?.modelArray.removeAll(where: { (temp) -> Bool in
                let isDelte: Bool = (temp.id == btn.titleLabel!.text! || temp.father_id == btn.titleLabel!.text!)
                
                if isDelte {
                    num = num + 1
                }
                
                return isDelte
            })
            
            let dict = [
                "comment_num": num,
                "article_id": weakSelf?.commentModel.article_id ?? ""
                ] as [String : Any]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: k_noti_comment_num), object: dict)
            UIView.performWithoutAnimation {
                self.tableView.reloadData()
            }
            
            self.tableHeaderView.totleNumLabel.text = "\(self.modelArray.count)条回复"
            if self.callBack != nil {
                var tempArray = [SQCommentReplyModel]()
                for model in self.modelArray {
                    tempArray.append(model.copyReplyCommentModel())
                }
                self.callBack!(btn.titleLabel!.text!,true,tempArray)
            }
            
        }
    }
    
    @objc func replyReplyBtnClick(_ btn: UIButton) {
        let replyModel = modelArray.first { (findModel) -> Bool in
            return findModel.id == btn.titleLabel!.text
        }
        
        replyComment(commentModel, replyModel)
    }
    
}
