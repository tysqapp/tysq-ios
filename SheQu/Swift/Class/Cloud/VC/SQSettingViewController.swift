//
//  SQSettingViewController.swift
//  SheQu
//
//  Created by gm on 2019/5/27.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQSettingViewController: SQViewController {
    
    static let rowH: CGFloat = 60
    
    lazy var itemModelArray = SQSettingViewControllerModel.getSettingViewControllerModelArray()
    
    lazy var tableHeaderView: UIView = {
        let tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: 10))
        tableHeaderView.backgroundColor = k_color_line_light
        return tableHeaderView
    }()
    
    lazy var tableFooterView: UIView = {
        let rowTotleH = SQSettingViewController.rowH * CGFloat(itemModelArray.count)
        let viewH = k_screen_height - rowTotleH - tableHeaderView.height() - k_bottom_h - k_nav_height
        let tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: viewH))
        
        let loginOutButtonH: CGFloat = 50
        let loginOutButtonY = viewH - 100 - loginOutButtonH
        let loginOutButton  = UIButton.init(frame: CGRect.init(x: 0, y: loginOutButtonY, width: k_screen_width, height: loginOutButtonH))
        tableFooterView.addSubview(loginOutButton)
        loginOutButton.titleLabel?.font = k_font_title
        loginOutButton.backgroundColor  = UIColor.white
        loginOutButton.setTitle("退出", for: .normal)
        loginOutButton.setTitleColor(UIColor.colorRGB(0xee0000), for: .normal)
        loginOutButton.addTarget(self, action: #selector(loginOut), for: .touchUpInside)
        tableFooterView.backgroundColor = k_color_line_light
        return tableFooterView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView(frame: view.bounds)
        tableView.rowHeight       = SQSettingViewController.rowH
        tableView.tableHeaderView = tableHeaderView
        tableView.tableFooterView = tableFooterView
        tableView.register(
            SQSettingTableViewCell.self,
            forCellReuseIdentifier: SQSettingTableViewCell.cellID
        )
    }
    
    
    @objc func loginOut() {
        SQAccountModel.clearLoginCache()
        //AppDelegate.getAppDelegate().downLoadSessionManager.totalSuspend()
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "设置"
    }
    
    deinit {
        
    }
}

extension SQSettingViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemModelArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = itemModelArray[indexPath.row]
        if indexPath.row == 0 {
            let btn = UIButton()
            if SQAccountModel.getAccountModel().email_status == 1 {
               btn.setTitle("已验证", for: .normal)
               btn.isHidden = true
            }else{
                btn.setTitle("未验证", for: .normal)
                btn.isHidden = false
            }
            
            btn.titleLabel?.font = k_font_title_12
            btn.setTitleColor(k_color_bg, for: .normal)
            btn.setSize(size: CGSize.init(width: 50, height: 20))
            btn.updateBGColor(10)
            btn.addTarget(self,
                          action: #selector(vfBtnClick(btn:)),
                          for: .touchUpInside
            )
            
            let cell  = SQSettingTableViewCell.init(
                style: .default,
                reuseIdentifier: SQSettingTableViewCell.cellID,
                rightView: btn
            )
            
            cell.titleLabel.text = model.title
            cell.valueLabel.text = model.value
            cell.layoutIfNeeded()
            return cell
        }
        
        if indexPath.row == 1 {
            let image     = UIImage.init(named: "home_ac_inside")
            let imageView = UIImageView.init(image: image)
            imageView.contentMode = .right
            
            let cell  = SQSettingTableViewCell.init(
                style: .default,
                reuseIdentifier: SQSettingTableViewCell.cellID,
                rightView: imageView
            )
            
            cell.titleLabel.text = model.title
            cell.valueLabel.text = model.value
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = itemModelArray[indexPath.row]
        if (model.isClass) {
            navigationController?.pushViewController(model.customClass.init(), animated: true)
        }
        
    }
    
    @objc func vfBtnClick(btn: UIButton) {
        let model = itemModelArray[0]
        weak var weakSelf = self
        let vc = SQVFEmailViewController.getVFEmailViewController(model.value, false) { (isVF) in
            weakSelf?.tableView.reloadData()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

class SQSettingViewControllerModel: NSObject{
    var title: String     = ""
    var value: String     = ""
    var customClass       = UIViewController.self
    var isClass           = false
    
    class func getSettingViewControllerModelArray() -> [SQSettingViewControllerModel]{
        
        let model = SQSettingViewControllerModel()
        model.title = "账号"
        model.value = SQAccountModel.getAccountModel().email
        
        let passwordModel = SQSettingViewControllerModel()
        passwordModel.title = "密码"
        passwordModel.value = "已设置"
        passwordModel.customClass = SQChangePasswordViewController.self
        passwordModel.isClass     = true
        return [model,passwordModel]
    }
    
}
