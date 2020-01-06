//
//  SQQCoinToCashListVC.swift
//  SheQu
//
//  Created by gm on 2019/8/13.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit


/// 提现记录vc
class SQQCoinToCashListVC: SQViewController {
    
    lazy var goldToCashItemModelArray = [SQCoinToCashItemModel]()
    lazy var goldToCashListModel = SQCoinToCashListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        tableView.backgroundColor = k_color_line_light
        tableView.register(
            SQCoinToCashTableViewCell.self,
            forCellReuseIdentifier:
            SQCoinToCashTableViewCell.cellID)
        addFooter()
        addMore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "提现记录"

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func addMore() {
        requestNetWork()
    }
}

extension SQQCoinToCashListVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goldToCashItemModelArray.count > 0 ?  goldToCashItemModelArray.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if goldToCashItemModelArray.count == 0 {
            let emptyCell = SQEmptyTableViewCell.init(style: .default, reuseIdentifier: SQEmptyTableViewCell.cellID, cellType: SQEmptyTableViewCellType.goldToCashList)
            return emptyCell
        }
        
        let cell: SQCoinToCashTableViewCell = tableView.dequeueReusableCell(withIdentifier: SQCoinToCashTableViewCell.cellID, for: indexPath) as! SQCoinToCashTableViewCell
        cell.model = goldToCashItemModelArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if goldToCashItemModelArray.count == 0 {
            return tableView.height()
        }else{
            let model = goldToCashItemModelArray[indexPath.row]
            return model.itemFrame.timeValueLabelFrame.maxY + 10
        }
    }
}

extension SQQCoinToCashListVC {
    
    func requestNetWork() {
        let start = goldToCashItemModelArray.count
        let size  = 10
        weak var weakSelf = self
        SQCloudNetWorkTool.getGoldToCashList(start: start, size: size) { (model, statu, errorMessage) in
            weakSelf?.endFooterReFresh()
            if (errorMessage != nil) {
                SQEmptyView.showUnNetworkView(statu: statu, handel: { (isClick) in
                    if isClick {
                        weakSelf?.requestNetWork()
                    }else{
                        weakSelf?.navigationController?.popViewController(animated: true)
                    }
                })
                return
            }
            
            if model!.withdraw_review_list.count < size {
                weakSelf?.endFooterReFreshNoMoreData()
            }
            
            for itemModel in model!.withdraw_review_list {
                SQCoinToCashTableViewCell.createGoldToCashFrame(model: itemModel)
                weakSelf?.goldToCashItemModelArray.append(itemModel)
            }
            
            weakSelf?.tableView.reloadData()
        }
    }
}
