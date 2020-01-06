//
//  SQBannedCommantsVC.swift
//  Shequ
//
//  Created by iMac on 2019/9/2.
//  Copyright © 2019 iMac. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    static let btnH: CGFloat = 30 //tag的高度
}

class SQForbinCommentListVC: SQViewController{

    private var account = ""
    private var oneTimer: Timer?
    //禁止评论列表model
    lazy var moderatorForbinCommentListModel = SQModeratorForbinCommentListModel()
    
    //禁止评论的用户列表
    lazy var mooderatorForbinCommentItemModelList = [SQModeratorForbinCommentItemModel]()
    
    //拼接好数据后的用户模型数组
    var itemArray = [ItemModel]()
    
    lazy var searchView:SQForbinCommentListSearchView = {
        let sv = SQForbinCommentListSearchView()
        addChangeTarget(sv.textField)
        return sv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.title = "禁止评论列表"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getForbinCommentList(isFirstCall: true)    
        addTableView(frame: view.bounds)
        tableView.separatorStyle = .none
        tableView.backgroundColor =  k_color_bg_gray
        addFooter()
        tableView.register(SQForbinCommentListCell.self, forCellReuseIdentifier: SQForbinCommentListCell.cellID)
        view.addSubview(searchView)
        view.addSubview(tableView)
        


        setupLayout()
        view.layoutIfNeeded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    func setupLayout() {
        
        searchView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
                .offset(k_nav_height)
            make.left.right.equalTo(self.view)
            make.height.equalTo(60)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.top.equalTo(searchView.snp.bottom)
            make.bottom.equalTo(view.snp.bottom)
        }
    }

    override func tfChanged(tf: UITextField) {
        account = tf.text ?? ""
        mooderatorForbinCommentItemModelList.removeAll()
        itemArray.removeAll()
        startgetForbinCommentList()
    }
    
}
///TableView
extension SQForbinCommentListVC{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count == 0 ? 1 : itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if itemArray.count == 0 {
            tableView.tableHeaderView = UIView()
            let cell = SQEmptyTableViewCell.init(style: .default, reuseIdentifier: SQEmptyTableViewCell.cellID, cellType: .auditArticleList)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SQForbinCommentListCell.cellID, for: indexPath) as! SQForbinCommentListCell
        cell.setTitle(title: itemArray[indexPath.row].account)
        //cell.setTags(Tags: itemArray[indexPath.row].forbiddenCategories)
        cell.tagsView.setTags(tags: itemArray[indexPath.row].forbiddenCategories)
        weak var weakSelf = self
        cell.btnClick = { 
            let vc = SQForbinCommentVC()
            vc.update(accountID: weakSelf?.itemArray[indexPath.row].account_id ?? 0, accountName: weakSelf?.itemArray[indexPath.row].account ?? "", handel: { (accountID,b) in
                weakSelf?.updateCell(account_id: accountID)
            })
            
            weakSelf?.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if itemArray.count == 0 {
            return tableView.height()
        }

        return itemArray[indexPath.row].rowH
    }
    
    override func addMore() {
        getForbinCommentList(isFirstCall: false)
    }
    
}

///修改之后
extension SQForbinCommentListVC{
    func updateCell(account_id: Int) {
        //account_id在user_id数组中的位置
        var p:Int = -1
        
        for i in 0..<itemArray.count{
            if itemArray[i].account_id == account_id{
                p = i
            }
            
        }
        if p == -1{
            return
        }
        
        weak var weakSelf = self
        SQHomeNewWorkTool.getForbinComment(account_id) { (listModel, status, errorMessage) in
            if (errorMessage != nil) {
                return
            }
            
            if((listModel?.forbid_categorys.isEmpty)!){
                weakSelf?.itemArray.remove(at: p)
                weakSelf?.mooderatorForbinCommentItemModelList.remove(at: p)
                if((weakSelf?.itemArray.count)! >= 1){
                weakSelf?.tableView.deleteRows(at: [IndexPath(row: p, section: 0)], with: .automatic)
                }else{
                    weakSelf?.tableView.reloadData()
                    weakSelf?.searchView.isHidden = true
                }
                
                return
            }else{
                var categoryItems = [String]()
                for model in listModel!.forbid_categorys{
                    if (model.category_id != 0){
                        categoryItems.append(model.category_name)
                    }else{
                        for secondModel in model.sub_category{
                            let spliceCategory = "\(model.category_name)--\(secondModel.category_name)"
                            categoryItems.append(spliceCategory)
                        }
                        
                    }
                    
                }
                weakSelf?.itemArray[p].forbiddenCategories = categoryItems
                weakSelf?.tableView.reloadRows(at: [IndexPath(row: p, section: 0)], with: .automatic)
                weakSelf?.tableView.cellForRow(at: IndexPath(row: p, section: 0))?.setHeight(height: weakSelf?.itemArray[p].rowH ?? 0)
            }
            
        
        }

    }
    
}

extension SQForbinCommentListVC{
    //获取数据
    func getForbinCommentList( isFirstCall : Bool ){
        weak var weakSelf = self
        SQCloudNetWorkTool.getBannedCommentsList(start: itemArray.count, size: 20, account: self.account) { (listModel, status, errorMessage) in
            
            weakSelf?.endFooterReFresh()
            
            if errorMessage != nil {
                if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: status, handel: nil) {
                    return
                }
                SQEmptyView.showUnNetworkView(statu: status, handel: { (isClick) in
                    if isClick {
                        weakSelf?.getForbinCommentList(isFirstCall: isFirstCall)
                    }else{
                        weakSelf?.navigationController?
                            .popViewController(animated: true)
                    }
                })
                return
            }
            
            weakSelf?.moderatorForbinCommentListModel = listModel!
            
            if listModel!.forbid_comment.count < 20{
                weakSelf?.endFooterReFreshNoMoreData()
            }
            
            for model in listModel!.forbid_comment {
                if(!(model.category_list.isEmpty)){
                    weakSelf?.mooderatorForbinCommentItemModelList.append(model)
                }
                
            }
            if( isFirstCall && weakSelf?.mooderatorForbinCommentItemModelList.isEmpty ?? false){
                weakSelf?.searchView.isHidden = true
            }
            
            weakSelf?.organizeData()
            weakSelf?.tableView.reloadData()
        }
        
    }
    //组装数据
    func organizeData(){
        for model in mooderatorForbinCommentItemModelList{
            var item = ItemModel()
            item.account = model.account
            item.account_id = model.account_id
            var categoryItems = [String]()
            
            for item in model.category_list{
                
                if(item.category_id != 0){
                    //只显示 【一级分类】
                    categoryItems.append(item.category_name)
                }else{
                    //显示 【一级分类--二级分类】
                    for secondItem in item.sub_category{
                        let spliceCategory = "\(item.category_name)--\(secondItem.category_name)"
                        categoryItems.append(spliceCategory)
                    }
                }
                
            }

            item.forbiddenCategories = categoryItems
            itemArray.append(item)
        }
        
    }
    
}



struct ItemModel {
    
    var account           = ""
    var account_id: Int   = 0
    var forbiddenCategories = [String](){
        didSet{
            self.getRowH(tags: self.forbiddenCategories)
        }
        
    }
    var rowH: CGFloat = 0
    
    mutating func getRowH(tags:[String]) {
        
        let count = tags.count
        var isRowFirst: Bool = true
        var tempWidth: CGFloat = 0
        var row: Int = 0
        let btnGap: CGFloat = 30
        for i in 0..<count {
            
            let titleWidth = tags[i].calcuateLabSizeWidth(font: UIFont.systemFont(ofSize: 14), maxHeight: SQItemStruct.btnH) + btnGap
            
            if(tempWidth + titleWidth + btnGap < UIScreen.main.bounds.size.width){
                if(isRowFirst){
                    isRowFirst = false
                }
                
                tempWidth += titleWidth + btnGap
                
            }else{
                tempWidth = 0
                isRowFirst = true
                row += 1
                isRowFirst = false
                tempWidth += titleWidth + btnGap
            }
            
         
        }
        let rowHeight: CGFloat = (CGFloat(row) + 1) * SQItemStruct.btnH + 40 + CGFloat(row) * 15
        self.rowH = rowHeight + 60
    }

}


extension SQForbinCommentListVC {
    func startgetForbinCommentList() {
        ///处理一秒之内不多做网络请求
        if (oneTimer == nil) {
            oneTimer = Timer.init(timeInterval: 1, repeats: false, block: {[weak self] (time) in
                self?.getForbinCommentList(isFirstCall: false)
                self?.oneTimer?.invalidate()
                self?.oneTimer = nil
            })
            
            RunLoop.main.add(oneTimer!, forMode: .common)
        }else{
            oneTimer?.invalidate()
            oneTimer = nil
            startgetForbinCommentList()
        }
        
    }
}
