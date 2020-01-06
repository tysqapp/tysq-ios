//
//  QIntegralOrderListVC.swift
//  SheQu
//
//  Created by gm on 2019/7/16.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQIntegralOrderListVC: SQViewController {
    
    lazy var infoModelArray = [SQScoresorderDetailModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        tableView.backgroundColor = k_color_line_light
        tableView.register(
            SQIntegralOrderListTableViewCell.self,
            forCellReuseIdentifier:
            SQIntegralOrderListTableViewCell.cellID)
        addFooter()
        addMore()
        addleftNavBtn()
    }
    
    func addleftNavBtn() {
        let btn = UIButton()
        btn.setSize(size: CGSize.init(width: 50, height: 30))
        btn.setTitle("说明", for: .normal)
        btn.setTitleColor(k_color_black, for: .normal)
        btn.addTarget(self, action: #selector(infoBtnClick), for: .touchUpInside)
        btn.titleLabel?.font = k_font_title
        btn.contentHorizontalAlignment = .right
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
    }
    
    lazy var showTipsView: SQIntegralShowTipsView = {
        let titleArray = [
            "订单只有两种状态:\"待支付\"和\"已支付\"。", "下单后(或支付后),订单状态显示\"待支付\",待商家确认收到支付金额后,才会变为\"已支付\"。",
            "状态变为\"已支付\",其购买的积分才会显示在积分明细,且添加到积分账户余额。",
            " 注:为方便商家尽快确认收款信息,支付后请点击\"已支付\"按钮。"
        ]
        let showTipsView = SQIntegralShowTipsView.init(frame: UIScreen.main.bounds, titleArray: titleArray)
        return showTipsView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "积分订单"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func addMore() {
        requestNetWork()
    }
    
    @objc func infoBtnClick() {
        showTipsView.showTipsView()
    }
}

extension SQIntegralOrderListVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoModelArray.count > 0 ? infoModelArray.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if infoModelArray.count == 0 {
            let emptyCell = SQEmptyTableViewCell.init(style: .default, reuseIdentifier: SQEmptyTableViewCell.cellID, cellType: .integralOrder)
            return emptyCell
        }
        
        let cell: SQIntegralOrderListTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: SQIntegralOrderListTableViewCell.cellID) as! SQIntegralOrderListTableViewCell
        cell.model = infoModelArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if infoModelArray.count == 0 {
            return tableView.height()
        }
        
        return SQIntegralOrderListTableViewCell.rowH
    }
    
}


extension SQIntegralOrderListVC {
    func requestNetWork() {
        let start = infoModelArray.count
        let size  = 10
        weak var weakSelf = self
        SQCloudNetWorkTool.getAccountIntegralDetail(start: start, size: size) { (model, statu, errorMessage) in
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
            
            if model!.scoresorder_list.count < size {
                weakSelf?.endFooterReFreshNoMoreData()
            }
            
            weakSelf?.infoModelArray.append(contentsOf: model!.scoresorder_list)
            weakSelf?.tableView.reloadData()
            
        }
        
    }
}
