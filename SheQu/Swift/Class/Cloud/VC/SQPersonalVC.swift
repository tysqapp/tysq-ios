//
//  SQPersonalVC.swift
//  SheQu
//
//  Created by gm on 2019/9/16.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

private struct SQItemStruct {
    
    ///imageView
    static let imageViewW: CGFloat = 7.5
    static let imageViewH: CGFloat = 3.5
    
    static let menuTableViewH: CGFloat = 50
    static let menuTableViewW: CGFloat = 140
    static let menuTableViewRight: CGFloat = 20
}

/// 用户个人界面
class SQPersonalVC: SQPageSubVC {
    //登录成功后要刷新界面的通知
    static let noti = NSNotification.Name.init("personalvc_login_success")
    lazy var canSetContentOffest: Bool = false
    lazy var offset_y: CGFloat  = 0
    lazy var isNetWork = false
    lazy var isLogin = UserDefaults.standard.value(forKey: k_ud_user) as? String
    
    private var accountModel = SQAccountModel()
    lazy var tableHeaderView: SQPersonalHeaderView = {
        let tableHeaderView = SQPersonalHeaderView()
        tableHeaderView.callback = {[weak self] (title, accountID) in
            if title == "修改资料" {
                let vc = SQSettingAcountViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
                return
            }
            
            if title == "已关注" {
                self?.attention(attention_id: accountID, is_follow: false)
            }else {
                self?.attention(attention_id: accountID, is_follow: true)
            }
        }
        return tableHeaderView
    }()
    
    lazy var subVCArray: [SQPageSubVC] = {
        
        return [
            getSubVC(SQWZViewController()),
            getSubVC(SQPLViewController()),
            getSubVC(SQCollectViewController()),
            getSubVC(SQAttentionListVC()),
            getSubVC(SQFansListVC())
        ]
    }()
    
    lazy var pageContentScrollView: SGPageContentScrollView = {
        let pageContentScrollView = SGPageContentScrollView.init(frame: view.bounds, parentVC: self, childVCs: subVCArray,isScrollEnabled: false)
        pageContentScrollView.isScrollEnabled    = false
        pageContentScrollView.delegateScrollView = self
        return pageContentScrollView
    }()
    
    static let menuTypeArray = [
        SQMenuView.MenuType.forbid
    ]
    
    
    lazy var menuView: SQMenuView = {
        
        let typeArray = SQPersonalVC.menuTypeArray
        
        weak var weakSelf = self
        let tempFrameX = k_screen_width - SQItemStruct.menuTableViewW - SQItemStruct.menuTableViewRight
        let menuTableViewH = SQItemStruct.menuTableViewH * CGFloat(typeArray.count)
        let tempFrameH = SQItemStruct.imageViewH + menuTableViewH
        let tempFrame = CGRect.init(x: tempFrameX, y: k_nav_height - SQItemStruct.imageViewH, width: SQItemStruct.menuTableViewW, height: tempFrameH)
        let nemuView = SQMenuView.init(frame: tempFrame, typeArray: typeArray, trianglePosition: .right, handel: {[weak self] (type, title) in
            switch type {
            case .forbid:
                self?.startForbidAccount()
            default:
                break
           }
        })
        
        return nemuView
    }()
    
    private var rowNum: Int = 1
    
    /// 二级分类view
    lazy var pageTitleView: SGPageTitleView = {
        let configure = SGPageTitleViewConfigure()
        configure.selLineViewColor = k_color_normal_blue
        configure.indicatorAdditionalWidth = 5
        configure.titleAdditionalWidth     = 10
        configure.indicatorHeight          = 15
        configure.titleGradientEffect      = true
        configure.titleUnSelectedBGImageName = ""
        configure.titleSelectedBGImageName   = ""
        configure.titleColor              = k_color_title_black
        configure.titleSelectedColor      = k_color_normal_blue
        configure.titleFont               = k_font_title
        
        let frame = CGRect.init(
            x: 0,
            y: tableHeaderView.maxY(),
            width: k_screen_width,
            height: 45
        )
        
        let pageTitleView = SGPageTitleView.init(
            frame: frame,
            delegate: self,
            titleNames: [],
            configure: configure
        )
        
        pageTitleView.backgroundColor = k_color_bg
        pageTitleView.titleNames      = [
            getItemInfo(title: "文章(\(self.accountModel.asset.article_num))"),
            getItemInfo(title: "评论(\(self.accountModel.asset.comment_num))"),
            getItemInfo(title: "收藏(\(self.accountModel.asset.collect_num))"),
            getItemInfo(title: "关注(\(self.accountModel.asset.attention_num))"),
            getItemInfo(title: "粉丝(\(self.accountModel.asset.fan_num))")
        ]
        
        let lineView = UIView.init(frame: CGRect.init(x: 0, y: 44, width: k_screen_width, height: k_line_height))
        lineView.backgroundColor = k_color_line
        pageTitleView.addSubview(lineView)
        return pageTitleView
    }()
    
    lazy var titleNavLabel: UILabel  = {
        let titleNavLabel = UILabel()
        titleNavLabel.setSize(size: CGSize.init(
            width: k_screen_width - 30,
            height: 30
        ))
        
        titleNavLabel.textColor     = k_color_black
        titleNavLabel.font          = k_font_title_weight
        return titleNavLabel
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView(frame: view.bounds)
        tableView.isFirstView = true
        canScroll             = true
        automaticallyAdjustsScrollViewInsets = false
        tableView.rowHeight = view.height()
        requestNetwork()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reciveScroolStateChange), name: SQControlEventTableView.noti, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginStateChange), name: SQPersonalVC.noti, object: nil)
    }
    
    @objc private func  reciveScroolStateChange() {
        canScroll = true
        for subVC in subVCArray {
            subVC.canScroll = false
        }
    }
    
    @objc private func loginStateChange() {
        requestNetwork()
    }
    
    func addTableHeaderView(_ tableViewHeight: CGFloat) {
        let headerView = UIView()
        
        tableHeaderView.setSize(size: CGSize.init(
            width: k_screen_width,
            height: tableViewHeight))
        headerView.addSubview(tableHeaderView)
        headerView.addSubview(pageTitleView)
        headerView.setSize(size: CGSize.init(
            width: k_screen_width,
            height: pageTitleView.maxY()
        ))
        
        tableView.tableHeaderView = headerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.titleView = titleNavLabel
        if isNetWork {
         var selIndex = 0
            if pageContentScrollView.previousCVCIndex >= 0 {
                selIndex = pageContentScrollView.previousCVCIndex
            }
         pageContentScrollView.previousCVCIndex = -1
         pageContentScrollView.setPageContentScrollView(index: selIndex)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    func getItemInfo(title: String) -> SQHomeCategorySubInfo {
        let info = SQHomeCategorySubInfo()
        info.name = title
        return info
    }
    
    private func getSubVC(_ subVC: SQPageSubVC) -> SQPageSubVC {
        subVC.accountID = self.accountID
        subVC.tableHeaderViewHeight = 0
        return subVC
    }
}


extension SQPersonalVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return rowNum
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.addSubview(pageContentScrollView)
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isNetWork {
            return
        }
        
        
        
        let nameFrame = tableHeaderView.convert(tableHeaderView.nameAndVipLabel.frame, to: UIApplication.shared.keyWindow)
        if nameFrame.maxY <= k_nav_height - 5 {
            titleNavLabel.text = accountModel.account
        }else{
            titleNavLabel.text = ""
        }
        
        if (scrollView == self.tableView) {
            self.offset_y = scrollView.contentOffset.y;
            let headerOffset: CGFloat = k_nav_height * -1 + tableHeaderView.maxY()
            /* 关键 */
            if (self.offset_y >= headerOffset) {
                scrollView.contentOffset = CGPoint.init(x: 0, y: headerOffset);
                if (self.canScroll) {
                    self.canScroll = false;
                    for subVC in subVCArray {
                        subVC.canScroll = true;
                    }
                }
            }else{
                if (!self.canScroll) {
                    scrollView.contentOffset = CGPoint.init(x: 0, y: headerOffset);
                }
            }
        }
        
        tableView.showsVerticalScrollIndicator = canScroll
    }
}

///版主权限
extension SQPersonalVC {
    func addRightNav() {
        let  btn = UIButton()
        btn.setSize(size: CGSize.init(width: 100, height: 30))
        btn.contentHorizontalAlignment = .right
        btn.setImage(
            UIImage.init(named: "sq_web_open_menu"),
            for: .normal
        )
        
        btn.addTarget(
            self,
            action: #selector(showMenu),
            for: .touchUpInside
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
    }
    
    @objc func showMenu() {
        if !menuView.isShowing {
          menuView.showMenuView()
        }else{
            menuView.hiddenMenuView()
        }
    }
    
    ///禁止用户
    func startForbidAccount() {
       let vc = SQForbinCommentVC()
       vc.update(accountID: accountModel.account_id, accountName: accountModel.account) { (statu, subInfo) in
           
       }
       
       navigationController?.pushViewController(vc, animated: true)
    }
}

extension SQPersonalVC {
    
    func requestNetwork() {
        SQCloudNetWorkTool.getAccountInfo(accountID) {[weak self] (accountModel, statu, errorMessage) in
            if (errorMessage != nil) {
                
                return
            }
            let height = SQPersonalHeaderView.getPersonalHeaderViewHeight(
                accountModel: accountModel!
            )
            self?.isNetWork = true
            self?.accountModel = accountModel!
            self?.addTableHeaderView(height)
            self?.tableHeaderView.updateTableHeader(accountModel: accountModel!)
            if SQAccountModel.getAccountModel().is_moderator {
                self?.addRightNav()
            }
        }
    }
    
    func checkIsLogin(_ needJump: Bool = true) -> Bool{
        guard let _: String  = UserDefaults.standard.value(forKey: k_ud_user) as? String else {
            if needJump {
                SQLoginViewController.jumpLoginVC(vc: self, state: 2999) { (isLogin) in
                    if isLogin {
                        NotificationCenter.default.post(name: SQPersonalVC.noti, object: nil)
                    }
                    
                }
                
            }
            return false
        }
        
        return true
    }
    
    func attention(attention_id: Int, is_follow: Bool) {
        if !checkIsLogin() {
            
            return
        }
        SQCloudNetWorkTool.attention(attention_id: attention_id, is_follow: is_follow) {[weak self] (model, statu, errorMessage) in
            if (errorMessage != nil) {
                self?.showToastMessage("操作失败,请重试")
               return
            }
            
            self?.accountModel.is_follow = is_follow
            self?.tableHeaderView.updateRightBtn(self?.accountModel)
        }
    }
}

extension SQPersonalVC: SGPageTitleViewDelegate {
    func pageTitleView(pageTitleView: SGPageTitleView, index: Int) {
        pageContentScrollView.setPageContentScrollView(index: index)
    }
}

extension SQPersonalVC: SGPageContentScrollViewDelegate {
    
    func pageContentScrollView(pageContentScrollView: SGPageContentScrollView, progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        pageTitleView.setPageTitleView(progress: progress, originalIndex: originalIndex, targetIndex: targetIndex)
    }
    
}

