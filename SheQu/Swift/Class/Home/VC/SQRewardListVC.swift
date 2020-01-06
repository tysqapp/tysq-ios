//
//  SQRewardListVC.swift
//  SheQu
//
//  Created by iMac on 2019/11/8.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQRewardListVC: SQViewController {
    var rewardModelArr = [SQRewardItemModel]()
    var article_id = ""
    
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



    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        title = "打赏记录"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView(frame: view.bounds)
        tableView.register(SQRewardListCell.self, forCellReuseIdentifier: SQRewardListCell.cellID)
        tableView.tableHeaderView = headerView
        addMore()
        addFooter()
    }
    
    

    

}


extension SQRewardListVC {
    override func addMore() {
        getRewardList()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewardModelArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SQRewardListCell.cellID) as! SQRewardListCell
        cell.vc = self
        cell.model = rewardModelArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    
}

extension SQRewardListVC {
    func getRewardList() {
        SQHomeNewWorkTool.getRewardList(article_id: self.article_id, start: rewardModelArr.count, size: 20) { [weak self] (listModel, status, errorMessage) in
            self?.endFooterReFresh()
            if errorMessage != nil {
                return
            }
            
            if listModel!.reward_list.count < 20{
                self?.endFooterReFreshNoMoreData()
            }
            
            self?.headerLabel.text = "\(listModel!.total_num)人打赏"
            self?.rewardModelArr.append(contentsOf: listModel!.reward_list)
            self?.tableView.reloadData()
            
        }
    }
    
    
}
