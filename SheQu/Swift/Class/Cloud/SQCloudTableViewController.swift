//
//  SQCloudTableViewController.swift
//  SheQu
//
//  Created by gm on 2019/4/11.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQCloudTableViewController: SQViewController {
    
    lazy var tableHeaderView: SQClouldTableHeaderView = {
        let height = SQClouldTableHeaderView.height
        let tableHeaderView = SQClouldTableHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: height))
        tableHeaderView.jumpSetAccountBtn.addTarget(self, action: #selector(jumpSetAccountBtnClick), for: .touchUpInside)
        tableHeaderView.gradeBtn.addTarget(self, action: #selector(jumpGradeInfoVC), for: .touchUpInside)
        weak var weakSelf = self
        tableHeaderView.callBack = { event in
            switch event {
            case .integral:
                weakSelf?.jumpIntegralVC()
            case .gold:
                weakSelf?.jumpGoalVC()
            case .wz:
                weakSelf?.jumpWZVC()
            case .pl:
                weakSelf?.jumpPlVC()
            case .nameLabel:
                weakSelf?.nameLabelClick()
            case .collect:
                weakSelf?.collectBtnClick()
            }
        }
        return tableHeaderView
    }()
    
    lazy var settingModelSectionArray = SQSettingModel.getMineItemModel(false)
    
    
    var unreadNotificationsCount = 0 {
        didSet {
            if unreadNotificationsCount > 0 {
                tabBarController?.tabBar.showBadgOn(index: 2)
            } else {
                tabBarController?.tabBar.hideBadg(on: 2)
            }
            
        }
    }
    
    private var timer: Timer!
    

    
    
    
    
    lazy var rec_register_success = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView(frame: view.bounds)
        tableView.setHeight(height: k_screen_height - k_bottom_h - k_tabbar_height)
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        
        tableView.register(
            SQCloudTableViewCell.self,
            forCellReuseIdentifier: SQCloudTableViewCell.cellID
        )
        
        tableView.tableHeaderView = tableHeaderView
        tableView.rowHeight       = SQCloudTableViewCell.height
        initLoginView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        getAccountInfo()
        getUnreadNotinums()
    }
    
    func initLoginView() {
        guard let loginStr: String  = UserDefaults.standard.value(forKey: k_ud_user) as? String else {
            initTableHeaderView()
            return
        }
        
        if loginStr.count < 5 {
            initTableHeaderView()
            return
        }
        
        updateAccountInfoView()
    }
    
    func initTableHeaderView(){
        tableHeaderView.plView.valueBtn.setTitle("\(0)", for: .normal)
        tableHeaderView.wzView.valueBtn.setTitle("\(0)", for: .normal)
        tableHeaderView.collectView.valueBtn.setTitle("\(0)", for: .normal)
        tableHeaderView.iconImageView.image      = k_image_ph_account
        tableHeaderView.jumpSetAccountBtn.isHidden = true
        tableHeaderView.accountNameLabel.text    = "登录"
        tableHeaderView.integralCardView.valueLabel.text = "\(0)"
        tableHeaderView.goldCardView.valueLabel.text = "\(0)"
        tableHeaderView.accountNameLabel.snp.updateConstraints { (maker) in
            maker.width.equalTo(SQClouldTableHeaderView
                .accountNameLabelMaxW)
        }
        
        updateTableViewItem(SQAccountModel())
        tableHeaderView.gradeBtn.isHidden  = true
    }
    
    func checkIsLogin(_ needJump: Bool = true) -> Bool{
        guard let _: String  = UserDefaults.standard.value(forKey: k_ud_user) as? String else {
            if needJump {
                let nav = SQLoginViewController.getLoginVC()
                present(nav, animated: true, completion: nil)
            }
            return false
        }
        
        return true
    }
}


extension SQCloudTableViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingModelSectionArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingModelSectionArray[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let gapView = UIView()
        gapView.backgroundColor = k_color_line_light
        gapView.frame = CGRect.init(x: 0, y: 0, width: k_screen_width, height: 10)
        return gapView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SQCloudTableViewCell.init(
            style: .value1,
            reuseIdentifier: SQCloudTableViewCell.cellID
        )
        
        let model = settingModelSectionArray[indexPath.section][indexPath.row]
        cell.imageView?.image = UIImage.init(named: model.imageName)
        cell.textLabel?.text  = model.title
        let imageView         = UIImageView.init(image: UIImage.init(named: "home_ac_inside"))
        imageView.sizeToFit()
        cell.accessoryView    = imageView
        cell.textLabel?.font  = k_font_title
        if model.title == "邀请好友" || model.title == "当前访问" || model.title == "关注" || model.title == "粉丝"  {
            if model.title == "邀请好友" {
                cell.detailTextLabel?.text = "送积分"
            } else if model.title == "关注" {
                cell.detailTextLabel?.text = "\(SQAccountModel.getAccountModel().asset.attention_num)"
            } else if model.title == "粉丝" {
                cell.detailTextLabel?.text = "\(SQAccountModel.getAccountModel().asset.fan_num)"
            } else {
                cell.detailTextLabel?.text = SQHostStruct.getLoaclHost()
            }
            
            cell.detailTextLabel?.font = k_font_title
            cell.detailTextLabel?.textColor = k_color_title_gray_blue
        } else if model.title == "通知" {
            
            cell.notiNum = unreadNotificationsCount
            if unreadNotificationsCount > 0 {
                tabBarController?.tabBar.showBadgOn(index: 2)
            } else {
                tabBarController?.tabBar.hideBadg(on: 2)
            }
            
        } else {
            cell.detailTextLabel?.text = ""
        }
        
        if model.title == "我的云盘" || model.title == "粉丝" {
            cell.lineView.isHidden = true
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = settingModelSectionArray[indexPath.section][indexPath.row]
        if model.isNeedLogin {
            if checkIsLogin() {
                let vc    = model.vc.init()
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }else{
            let vc    = model.vc.init()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
}


extension SQCloudTableViewController {
    
    
    func getAccountInfo() {
        if !checkIsLogin(false) {
            initTableHeaderView()
            return
        }
        
        weak var weakSelf = self
        SQCloudNetWorkTool.getAccountInfo { (accountModel, statu, errorMessage) in
            if (errorMessage != nil) {
                weakSelf?.initLoginView()
                return
            }
            
            ///缓存更新用户信息
            SQAccountModel.updateAccountModel(accountModel)
            weakSelf?.updateAccountInfoView()
        }
    }
    
    ///更新用户信息view上面
    func updateAccountInfoView() {
        let accountModel = SQAccountModel.getAccountModel()
        updateTableViewItem(accountModel)
        tableHeaderView.iconImageView.sq_yysetImage(with: accountModel.head_url, placeholder: k_image_ph_account)
        tableHeaderView.accountNameLabel.text = accountModel.account
        tableHeaderView.jumpSetAccountBtn.isHidden = false
        var width = accountModel.account.calcuateLabSizeWidth(font: SQClouldTableHeaderView.accountNameLabelFont, maxHeight: 30) + 10
        if width > SQClouldTableHeaderView.accountNameLabelMaxW {
            width = SQClouldTableHeaderView.accountNameLabelMaxW
        }
        
        tableHeaderView.accountNameLabel.snp.updateConstraints({ (maker) in
            maker.width.equalTo(width)
        })
        
        tableHeaderView.accountNameLabel.layoutIfNeeded()
        tableHeaderView.gradeBtn.isHidden = false
        let accountImage = UIImage.init(named: "sq_grade_\(accountModel.asset.grade)")
        tableHeaderView.gradeBtn.setImage(accountImage, for: .normal)
        tableHeaderView.integralCardView.valueLabel.text = "\(accountModel.asset.score.toEuropeanType(3))"
        tableHeaderView.goldCardView.valueLabel.text = "\(accountModel.asset.hot_coin.toEuropeanType(3))"
        tableHeaderView.goldCardView.rmbLabel.text = "=\(String(format: "%.2f",(Double(accountModel.asset.hot_coin) / 1000)))元"
        tableHeaderView.plView.valueBtn
            .setTitle("\(accountModel.asset.comment_num)",
                for: .normal)
        tableHeaderView.collectView.valueBtn
            .setTitle("\(accountModel.asset.collect_num)",
                for: .normal)
        tableHeaderView.wzView.valueBtn
            .setTitle("\(accountModel.asset.article_num)", for:
                .normal)
    }
    
    /// 刷新我的界面tableView 的cell
    private func updateTableViewItem(_ accountModel: SQAccountModel?) {
        ///判断版主模块有没有添加进去
        let setModel = settingModelSectionArray[0].first(where: { (setModelTemp) -> Bool in
            return setModelTemp.title == "版主中心"
        })
        
        
        if accountModel!.is_moderator {
            if (setModel == nil) {
                settingModelSectionArray = SQSettingModel.getMineItemModel(true)
                tableView.reloadData()
            }
        }else{
            if (setModel != nil) {
                settingModelSectionArray = SQSettingModel.getMineItemModel(false)
                tableView.reloadData()
            }
        }
    }
    
    
    ///获取未读通知数量
    func getUnreadNotinums() {
        SQCloudNetWorkTool.getUnreadNotificationsCount { [weak self] (model, status, errorMessage) in
            if errorMessage != nil {
                if errorMessage == "账号尚未登录!" {
                    self?.unreadNotificationsCount = 0
                    self?.tableView.reloadData()
                }
                
                return
            }
            
            self?.unreadNotificationsCount = model!.unread_count
            self?.tableView.reloadData()
        }
    }
}

extension SQCloudTableViewController {
    
    func nameLabelClick(){
        _ = checkIsLogin()
    }
    
    func collectBtnClick(){
        if checkIsLogin() {
            let vc = SQCollectViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func jumpSetAccountBtnClick() {
        if checkIsLogin() {
            let vc = SQPersonalVC()
            vc.accountID = Int(SQAccountModel.getAccountModel().account_id)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func jumpIntegralVC() {
        if checkIsLogin() {
            let vc = SQIntegralInfoListVC()
            vc.customState = SQIntegralInfoListVC.State.integral
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func jumpGoalVC(){
        if checkIsLogin() {
            let vc = SQIntegralInfoListVC()
            vc.customState = SQIntegralInfoListVC.State.gold
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func jumpPlVC() {
        if checkIsLogin() {
            let plVC = SQPLViewController()
            plVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(plVC, animated: true)
        }
    }
    
    @objc func jumpGradeInfoVC() {
        let vc = SQWebViewController()
        vc.urlPath = WebViewPath.gradeInfo
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func jumpWZVC() {
        if checkIsLogin() {
            let wzVC = SQWZViewController()
            wzVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(wzVC, animated: true)
        }
    }
}


