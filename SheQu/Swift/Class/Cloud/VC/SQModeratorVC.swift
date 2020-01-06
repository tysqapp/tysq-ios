//
//  SQModeratorVC.swift
//  SheQu
//
//  Created by gm on 2019/8/27.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

///版主中心
class SQModeratorVC: SQViewController {
    lazy var itemModelArray = SQSettingModel.getModeratorItemModel()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line_light
        lineView.setSize(size: CGSize.init(
            width: k_screen_width,
            height: k_line_height_big
        ))
        return lineView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView(frame: view.bounds)
        tableView.separatorStyle = .none
        tableView.rowHeight = SQCloudTableViewCell.height
        tableView.backgroundColor = k_color_line_light
        tableView.tableHeaderView = lineView
        
        tableView.register(SQCloudTableViewCell.self, forCellReuseIdentifier: SQCloudTableViewCell.cellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "版主中心"
    }
    
}


extension SQModeratorVC {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemModelArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SQCloudTableViewCell.init(
            style: .value1,
            reuseIdentifier: SQCloudTableViewCell.cellID
        )
        
        let model = itemModelArray[indexPath.row]
        cell.textLabel?.text = model.title
        
        if (itemModelArray.count - 1) == indexPath.row {
            cell.lineView.isHidden = true
        }else{
            cell.lineView.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = itemModelArray[indexPath.row]
        let vc = model.vc.init()
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension SQModeratorVC {
    func getAuditAiticleList() {
        weak var weakSelf = self
        SQCloudNetWorkTool.getAuditArticle(start: 0, size: 20) { (listModel, statu, errorMessage) in
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
            
            weakSelf?.tableView.reloadData()
        }
    }
}
