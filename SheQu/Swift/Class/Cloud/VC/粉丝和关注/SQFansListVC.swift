//
//  SQFansListVC.swift
//  SheQu
//
//  Created by iMac on 2019/9/10.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQFansListVC: SQPageSubVC {
    var isNeedRefresh = false
    var fansListModelArr = [SQFanModel]()
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
        title = "我的粉丝"
        navigationController?.isNavigationBarHidden = false
        if isNeedRefresh {
            fansListModelArr.removeAll()
            getFansList()
            isNeedRefresh = false
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isNeedRefresh = true
    }

}
///tableView
extension SQFansListVC {
   override func addMore() {
        getFansList()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fansListModelArr.count == 0 ? 1 : fansListModelArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(fansListModelArr.count == 0){
            tableView.tableHeaderView = UIView()
            let cell = SQEmptyTableViewCell.init(style: .default, reuseIdentifier: SQEmptyTableViewCell.cellID, cellType: .fanList)
            return cell
        }else{
            if indexPath.row == 0 {
                tableView.tableHeaderView = headerView
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SQFansCell.cellID) as! SQFansCell
        cell.model = fansListModelArr[indexPath.row]
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
        if(fansListModelArr.count == 0){
            return tableView.height()
        }
        return SQFansCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        if fansListModelArr.count == 0 {
            return
        }
        
        let vc = SQPersonalVC()
        vc.accountID = fansListModelArr[indexPath.row].account_id
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension SQFansListVC {
    func getFansList(){
        weak var weakSelf = self
        SQCloudNetWorkTool.getFansList(account_id: accountID, start: fansListModelArr.count, size: 20) { (listModel, status, errorMessage) in
            weakSelf?.endFooterReFresh()
            
            if errorMessage != nil {
                if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: status, handel: nil) {
                    return
                }
                
                SQEmptyView.showUnNetworkView(statu: status, handel: { (isClick) in
                    if isClick {
                        weakSelf?.getFansList()
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
            weakSelf?.fansListModelArr.append(contentsOf: listModel!.account_follower_infos)
            weakSelf?.tableView.reloadData()
        }
    }
    
}
