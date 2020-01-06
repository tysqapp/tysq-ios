//
//  SQAttentionListVC.swift
//  SheQu
//
//  Created by iMac on 2019/9/11.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQAttentionListVC: SQPageSubVC {
    lazy var isNeedRefresh = false
    var attentionListModelArr = [SQFanModel]()
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
        addMore()
        addFooter()
        tableView.register(SQFansCell.self, forCellReuseIdentifier: SQFansCell.cellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        title = "我的关注"
        if isNeedRefresh {
            attentionListModelArr.removeAll()
            getAttentionsList()
            isNeedRefresh = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isNeedRefresh = true
    }
    
}
///tableView
extension SQAttentionListVC {
    override func addMore() {
        getAttentionsList()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attentionListModelArr.count == 0 ? 1 : attentionListModelArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(attentionListModelArr.count == 0){
            tableView.tableHeaderView = UIView()
            let cell = SQEmptyTableViewCell.init(style: .default, reuseIdentifier: SQEmptyTableViewCell.cellID, cellType: .attentionList)
            return cell
        }else{
            if indexPath.row == 0 {
                tableView.tableHeaderView = headerView
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SQFansCell.cellID) as! SQFansCell
        cell.model = attentionListModelArr[indexPath.row]
        cell.toLoginCallback = { [weak self] in
            SQLoginViewController.jumpLoginVC(vc: self, state: 2999) { (isLogin) in
                if isLogin {
                    NotificationCenter.default.post(name: SQPersonalVC.noti, object: nil)
                }
                
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(attentionListModelArr.count == 0){
            return tableView.height()
        }
        
        return SQFansCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        if attentionListModelArr.count == 0 {
            return
        }
        
        let vc = SQPersonalVC()
        vc.accountID = attentionListModelArr[indexPath.row].account_id
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SQAttentionListVC {
    func getAttentionsList(){
        weak var weakSelf = self
        SQCloudNetWorkTool.getAttentionsList(account_id: accountID, start: attentionListModelArr.count, size: 20) { (listModel, status, errorMessage) in
            weakSelf?.endFooterReFresh()
            
            
            if errorMessage != nil {
                if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: status, handel: nil) {
                    return
                }
                
                SQEmptyView.showUnNetworkView(statu: status, handel: { (isClick) in
                    if isClick {
                        weakSelf?.getAttentionsList()
                    }else{
                        weakSelf?.navigationController?
                            .popViewController(animated: true)
                    }
                })
                return
            }
        
            
            
            if listModel!.account_follower_infos.count < 20{
                weakSelf?.endFooterReFreshNoMoreData()
            }
            
            weakSelf?.headerLabel.text = "\(listModel!.total_num)人"
            weakSelf?.attentionListModelArr.append(contentsOf: listModel!.account_follower_infos)
            weakSelf?.tableView.reloadData()
        }
    }
    
}
