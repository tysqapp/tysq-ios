//
//  SQForbinCommentVC.swift
//  SheQu
//
//  Created by gm on 2019/9/2.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQForbinCommentVC: SQViewController {
    
    lazy var categoryItemModelArray = [SQModeratorCategoryItemModel]()
    lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.font            = k_font_title_11
        headerLabel.textColor       = k_color_title_gray
        headerLabel.frame           = CGRect.init(x: 20, y: 0, width: k_screen_width - 20, height: 30)
        return headerLabel
    }()
    
    lazy var headerView: UIView = {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: 30))
        headerView.backgroundColor = UIColor.colorRGB(0xf5f5f5)
        headerView.addSubview(headerLabel)
        return headerView
    }()
    
    /// 完成按钮
    lazy var publishBtn: SQDisableBtn = {
        let publishBtn = SQDisableBtn.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 30), enabled: true)
        publishBtn.setTitle("完成", for: .normal)
        publishBtn.titleLabel?.font = k_font_title
        publishBtn.setBtnBGImage()
        publishBtn.addTarget(self, action: #selector(changeNikeNameBtnClick), for: .touchUpInside)
        return publishBtn
    }()
    
    private var callBack: ((Int,[SQForbinCommentCategoryInfo]) -> ())?
    
    func update(accountID: Int, accountName: String, handel:((_ accountID: Int,_ categoryInfo: [SQForbinCommentCategoryInfo]) -> ())?) {
        callBack = handel
        self.accountID = accountID
        
        addTableView(frame: view.bounds)
        tableView.register(SQForbinCommentCell.self, forCellReuseIdentifier: SQForbinCommentCell.cellID)
        tableView.register(SQForbinCommentTableHeaderView.self, forHeaderFooterViewReuseIdentifier: SQForbinCommentTableHeaderView.cellID)
        tableView.register(SQForbinCommentTableFooterView.self, forHeaderFooterViewReuseIdentifier: SQForbinCommentTableFooterView.cellID)
        tableView.rowHeight = SQForbinCommentView.height
        tableView.sectionHeaderHeight = SQForbinCommentView.height
        tableView.sectionFooterHeight = 10
        tableView.separatorStyle = .none
        tableView.backgroundColor = k_color_line_light
        getForbinComment()
        headerLabel.text =  "\(accountName)禁止在以下模块评论或回复(不勾选，则允许评论)"
        
        
    }
    
    private var accountID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: publishBtn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "禁止评论"
    }
    
    @objc func changeNikeNameBtnClick() {
        
        var categoryIDS = [SQForbinCommentCategoryInfo]()
        for item in categoryItemModelArray {
            let categoryInfo = SQForbinCommentCategoryInfo()
            if item.isSel {
                categoryInfo.parent_id = item.category_id
            }else{
                categoryInfo.parent_id = 0
                for subItem in  item.sub_category {
                    if subItem.isSel {
                         categoryInfo.sub_id.append(subItem.category_id)
                    }
                }
            }
            
            if categoryInfo.sub_id.count != 0 || categoryInfo.parent_id != 0 {
               categoryIDS.append(categoryInfo)
            }
        }
        
        uploadValue(categoryIDS: categoryIDS)
    }
    
    deinit {
        
    }
    
}

extension SQForbinCommentVC {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if categoryItemModelArray.count > 0 {
            tableView.tableHeaderView = headerView
        }else{
            tableView.tableHeaderView = UIView()
        }
        
        return categoryItemModelArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = categoryItemModelArray[section]
        return model.isUnwind ? model.sub_category.count : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerTableHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SQForbinCommentTableHeaderView.cellID) as! SQForbinCommentTableHeaderView
        let model = categoryItemModelArray[section]
        headerTableHeaderView.itemModel = model
        
        weak var weakSelf = self
        headerTableHeaderView.forbinCommentViewEventCallBack = { (btn,event) in
            switch event {
            case .sel:
                model.isSel = btn.isSelected
                if !model.isSel {
                    return
                }
                
                for itemModel in model.sub_category {
                    itemModel.isSel = true
                }
            case .unwind:
              model.isUnwind = btn.isSelected
            }
            
            weakSelf?.tableView.reloadData()
        }
        
        return headerTableHeaderView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SQForbinCommentCell.cellID, for: indexPath) as! SQForbinCommentCell
        let model = categoryItemModelArray[indexPath.section]
        let itemModel = model.sub_category[indexPath.row]
        cell.itemSubModel = itemModel
        
        weak var weakSelf = self
        cell.forbinCommentViewEventCallBack = { ( btn, event ) in
            itemModel.isSel = btn.isSelected
            if !itemModel.isSel {
                if model.isSel == false {
                    return
                }
                
                model.isSel = false
                weakSelf?.tableView.reloadData()
            }
        }
        
        return cell
    }
}


extension SQForbinCommentVC {
    
    /// 获取版主模块列表
    func getModeratorsCategorys(_ forbinCommentListModel: SQForbinCommentListModel) {
        
        weak var weakSelf = self
        SQHomeNewWorkTool.getModeratorsCategorys { (listModel, statu, errorMessage) in
            
            if (errorMessage != nil) {
                return
            }
            
            for model in listModel!.categorys {
                for subItem in forbinCommentListModel.forbid_categorys {
                    if subItem.position_id == model.category_id {
                        for subModel in model.sub_category {
                            let selModel = subItem.sub_category.first(where: { (selModelTemp) -> Bool in
                                return selModelTemp.category_id == subModel.category_id
                            })
                            
                            if (selModel != nil) {
                                subModel.isSel = true
                            }
                        }
                    }else{
                        ///选中所有一级分类
                        if subItem.category_id == model.category_id {
                            model.isSel = true
                            for subModel in model.sub_category {
                                subModel.isSel = true
                            }
                        }
                    }
                }
                
                weakSelf?.categoryItemModelArray.append(model)
            }
            
            
            weakSelf?.tableView.reloadData()
        }
        
    }
    
    
    /// 获取被禁用户列表
    func getForbinComment() {
        weak var weakSelf = self
        SQHomeNewWorkTool.getForbinComment(accountID) { (listModel, status, errorMessage) in
            if (errorMessage != nil) {
                return
            }
            
            weakSelf?.getModeratorsCategorys(listModel!)
        }
    }
    
    
    func uploadValue(categoryIDS: [SQForbinCommentCategoryInfo]) {
        weak var weakSelf = self
        SQCloudNetWorkTool.uploadForbinCommentCategoryList(accountID: accountID, categoryInfo: categoryIDS) { (model, status, errorMessage) in
            if (errorMessage != nil) {
                return
            }
            
            if ((weakSelf?.callBack) != nil) {
                weakSelf!.callBack!(weakSelf!.accountID, categoryIDS)
            }
            
            weakSelf?.navigationController?.popViewController(animated: true)
        }
    }
}

