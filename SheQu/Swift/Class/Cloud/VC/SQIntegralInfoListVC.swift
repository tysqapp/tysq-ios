//
//  SQIntegralInfoListVC.swift
//  SheQu
//
//  Created by gm on 2019/7/16.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQIntegralInfoListVC: SQViewController {
    
    enum State {
        case integral
        case gold
        case exten
    }
    
    lazy var tableHeaderView: SQIntegralInfoListTableHeaderView = {
        let frame = CGRect.init(
            x: 0,
            y: 0,
            width: SQIntegralInfoListTableHeaderView.width,
            height: SQIntegralInfoListTableHeaderView.height
        )
        
        weak var weakSelf = self
        let tableHeaderView = SQIntegralInfoListTableHeaderView.init(frame: frame, state: customState!, handel: { (event) in
            switch event {
            case .buy:
                weakSelf?.jumpBuyIntegralVC()
            case .list:
                if weakSelf?.customState  == .integral {
                    weakSelf?.jumpIntegralDetailVC()
                } else {
                    let vc = SQWebViewController()
                    vc.urlPath = WebViewPath.buyGold
                    weakSelf?.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .info:
                return
            }
        })
        
        return tableHeaderView
    }()
    
    lazy var coinModel = SQAccountCoinModel()
    lazy var infoModelArray = [SQAccountCoinDetailModel]()
    
    var customState: SQIntegralInfoListVC.State? {
        didSet {
            if (customState != nil) {
                addTableView(frame: CGRect.zero)
                tableView.tableHeaderView = tableHeaderView
                navigationItem.title = "我的积分"
                if customState! == SQIntegralInfoListVC.State.gold {
                    navigationItem.title = "我的金币"
                }
                updateCardViewValue(0)
                addFooter()
                requestNetwork()
            }
        }
    }
    
    private struct SQItemStruct {
        
        ///imageView
        static let imageViewW: CGFloat = 7.5
        static let imageViewH: CGFloat = 3.5
        
        static let menuTableViewH: CGFloat = 50
        static let menuTableViewW: CGFloat = 90
        static let menuTableViewRight: CGFloat = 20
    }
    
    static let menuTypeArray = [
        SQMenuView.MenuType.goldDescription,
        SQMenuView.MenuType.withdrawalsRecord,
        SQMenuView.MenuType.goldOrder
    ]
    
    /**我的金币顶部右边menu*/
    lazy var menuView: SQMenuView = {
        
        let typeArray = SQIntegralInfoListVC.menuTypeArray
        
        weak var weakSelf = self
        let tempFrameX = k_screen_width - SQItemStruct.menuTableViewW - SQItemStruct.menuTableViewRight
        let menuTableViewH = SQItemStruct.menuTableViewH * CGFloat(typeArray.count)
        let tempFrameH = menuTableViewH
        let tempFrame = CGRect.init(x: tempFrameX, y: k_nav_height, width: SQItemStruct.menuTableViewW, height: tempFrameH)
        let nemuView = SQMenuView.init(frame: tempFrame, typeArray: typeArray, trianglePosition: .right, handel: { (type, title) in
            switch type {
            case .goldDescription:
                weakSelf?.jumpInfoVC()
                
            case .withdrawalsRecord:
                weakSelf?.jumpIntegralDetailVC()
                
            case .goldOrder:
                weakSelf?.jumpGoldOrderListVC()
                
            default:
                break
           }
        })
        
        return nemuView
    }()
    
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
    
    override func viewDidLoad() {
            super.viewDidLoad()
            tableView.separatorStyle = .none
            tableView.backgroundColor = k_color_bg
            tableView.register(
                SQIntegralInfoListTableViewCell.self,
                forCellReuseIdentifier:
                SQIntegralInfoListTableViewCell.cellID)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.shadowImage = UIImage()
        
        if customState! == SQIntegralInfoListVC.State.gold {
            navigationItem.title = "我的金币"
            addRightNav()
        } else {
            navigationItem.title = "我的积分"
            let integralDescriptionBtn = UIButton()
            integralDescriptionBtn.setTitle("积分说明", for: .normal)
            integralDescriptionBtn.setTitleColor(k_color_black, for: .normal)
            integralDescriptionBtn.titleLabel?.font = k_font_title
            integralDescriptionBtn.sizeToFit()
            integralDescriptionBtn.addTarget(self, action: #selector(jumpInfoVC), for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: integralDescriptionBtn)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            tableView.frame = view.bounds
    }
    
    override func addMore() {
        requestNetwork()
    }
    
    
    
    ///金币 积分说明vc
    @objc func jumpInfoVC() {
        let vc = SQWebViewController()
        if customState! == SQIntegralInfoListVC.State.gold {
          vc.urlPath = WebViewPath.goldInfo
        }else{
          vc.urlPath = WebViewPath.integralInfo
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///购买积分订单
    func jumpBuyIntegralVC() {
        if customState! == SQIntegralInfoListVC.State.gold {
            if SQAccountModel.getAccountModel().email_status != 1 {
                let alertView = UIAlertView.init(title: "要先验证邮箱，才能提现哦！", message: "", delegate: self, cancelButtonTitle: "知道了", otherButtonTitles: "去验证邮箱")
                alertView.show()
                return
            }
            let vc = SQCoinToCashVC()
            vc.coinNum = coinModel.total_number
            weak var weakSelf = self
            vc.callBack = { vcTemp in
                weakSelf?.infoModelArray.removeAll()
                weakSelf?.getCoinFromNetWork()
            }
            navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = SQWebViewController()
            vc.urlPath = WebViewPath.buyIntegral
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    ///金币订单
    func jumpGoldOrderListVC() {
        let vc = SQGoldOrderListVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 积分订单
    func jumpIntegralDetailVC() {
        
        if customState! == SQIntegralInfoListVC.State.gold {
           let vc = SQQCoinToCashListVC()
           navigationController?.pushViewController(vc, animated: true)
        } else {
           let vc = SQIntegralOrderListVC()
           navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
    
extension SQIntegralInfoListVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoModelArray.count > 0 ? infoModelArray.count : 1
    }
        
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if infoModelArray.count == 0 {
            var type = SQEmptyTableViewCellType.goldInfo
            if customState! == .integral {
                type = SQEmptyTableViewCellType.integralInfo
            }
            let emptyCell = SQEmptyTableViewCell.init(style: .default, reuseIdentifier: SQEmptyTableViewCell.cellID, cellType: type)
            return emptyCell
        }
            let cell: SQIntegralInfoListTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: SQIntegralInfoListTableViewCell.cellID) as! SQIntegralInfoListTableViewCell
            cell.model = infoModelArray[indexPath.row]
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if infoModelArray.count == 0 {
            return tableView.height() - SQIntegralInfoListTableHeaderView.height
        }
        
        return SQIntegralInfoListTableViewCell.rowH
    }
    
}

extension SQIntegralInfoListVC {
    
    func requestNetwork() {
        if customState! == SQIntegralInfoListVC.State.gold {
            getCoinFromNetWork()
        }else{
            getIntegralFromNetWork()
        }
    }
    
    func getIntegralFromNetWork() {
        let start = infoModelArray.count
        let size  = 10
        weak var weakSelf = self
        SQCloudNetWorkTool.getAccountIntegral(start: start, size: size) { (integralModel, statu, errorMessage) in
            weakSelf?.endFooterReFresh()
            if (errorMessage != nil) {
                SQEmptyView.showUnNetworkView(statu: statu, handel: { (isClick) in
                    if isClick {
                      weakSelf?.getIntegralFromNetWork()
                    }else{
                        weakSelf?.navigationController?.popViewController(animated: true)
                    }
                })
                return
            }
            
            if weakSelf?.infoModelArray.count ?? 0 < 1 {
                weakSelf?.updateCardViewValue(integralModel!.score_sum)
            }
            
            if integralModel!.scoredetail_list.count < size {
                weakSelf?.endFooterReFreshNoMoreData()
            }
            
            for ditialModel in integralModel!.scoredetail_list {
                weakSelf?.infoModelArray.append(
                    ditialModel.toCoinModel())
            }
            
            weakSelf?.tableView.reloadData()
        }
        
        
    }
    
    func getCoinFromNetWork() {
        let start = infoModelArray.count
        let size  = 10
        weak var weakSelf = self
        SQCloudNetWorkTool.getAccountCoinInfo(start: start, size: size) { (coinModel, statu, errorMessage) in
            weakSelf?.endFooterReFresh()
            if (errorMessage != nil) {
                SQEmptyView.showUnNetworkView(statu: statu, handel: { (isClick) in
                    if isClick {
                      weakSelf?.getCoinFromNetWork()
                    }else{
                        weakSelf?.navigationController?.popViewController(animated: true)
                    }
                })
                return
            }
            
            if weakSelf?.infoModelArray.count ?? 0 < 1 {
              weakSelf?.coinModel = coinModel!
              weakSelf?.updateCardViewValue(
                coinModel!.total_number)
            }
            
            if coinModel!.details_info.count < size {
                weakSelf?.endFooterReFreshNoMoreData()
            }
            
            
            
            weakSelf?.infoModelArray.append(contentsOf: coinModel!.details_info)
            weakSelf?.tableView.reloadData()
        }
    }
    
    func updateCardViewValue(_ value: Int) {
        
        var unit = "金币"
        if customState! == SQIntegralInfoListVC.State.integral {
            unit = "积分"
        }
        
        tableHeaderView.cardView.updateValue(
            value,
            unit
        )
    }
}


extension SQIntegralInfoListVC: UIAlertViewDelegate {
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            let account = SQAccountModel.getAccountModel()
            let vc = SQVFEmailViewController.getVFEmailViewController(account.email, false) { (isVF) in
                
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
