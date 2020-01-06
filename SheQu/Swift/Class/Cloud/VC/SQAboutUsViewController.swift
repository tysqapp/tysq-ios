//
//  SQAboutUsViewController.swift
//  SheQu
//
//  Created by gm on 2019/5/27.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQAboutUsViewController: SQViewController {
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line_light
        lineView.setSize(size: CGSize.init(width: k_screen_width, height: k_line_height_big))
        return lineView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView(frame: view.bounds)
        tableView.tableHeaderView = lineView
        tableView.backgroundColor = k_color_line_light
        tableView.separatorStyle  = .none
        tableView.rowHeight       = SQCloudTableViewCell.height
        tableView.register(SQCloudTableViewCell.self, forCellReuseIdentifier: SQCloudTableViewCell.cellID)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "关于我们"
    }

}


extension SQAboutUsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SQCloudTableViewCell.init(style: .value1, reuseIdentifier: SQCloudTableViewCell.cellIDStr)
        if indexPath.row == 0 {
            cell.textLabel?.text = "版本号"
            guard let sysDict = Bundle.main.infoDictionary else {
                return cell
            }
            
            let version: String = sysDict["CFBundleShortVersionString"] as! String
            //let buildVersion: String = sysDict["CFBundleVersion"] as! String
            cell.detailTextLabel?.font = k_font_title
            cell.detailTextLabel?.text = "V\(version)"
            cell.detailTextLabel?.textColor = k_color_title_gray_blue
        }else {
            cell.textLabel?.text  = "检查更新"
            let imageView         = UIImageView.init(image: UIImage.init(named: "home_ac_inside"))
            imageView.sizeToFit()
            cell.accessoryView    = imageView
            cell.lineView.isHidden = true
        }
        
        cell.textLabel?.font = k_font_title
        

        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 1 {
            requestNetWork()
        }
    }
    
    func requestNetWork() {
        weak var weakSelf = self
        SQCheckUpdateNetworkTool.getVersion { (model, statu, errorString) in
            
            if (errorString != nil) {
                
                return
            }
            
            let updataState = model!.checkNeedUpdate()
            if updataState.forceUpdate || updataState.update {
                let _ =  SQShowUpdateAppView.init(frame: UIScreen.main.bounds, version: model!.latest_version, tipsArray: model!.new_features,isForce: updataState.forceUpdate, handel: { (showViewTemp) in
                })
            }else{
                weakSelf?.showToastMessage("当前已是最新版本")
            }
        }
    }
    
    func jumpHomeVC() {
        AppDelegate.goToHomeVC()
    }
}
