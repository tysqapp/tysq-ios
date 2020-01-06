//
//  SQFriendVC.swift
//  SheQu
//
//  Created by iMac on 2019/9/24.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQFriendVC: SQWebViewController {
    
    lazy var segmentView: SQFriendSegmentView = {
        let segmentView = SQFriendSegmentView(frame: CGRect.init(x: (k_screen_width / 2) - 90, y: k_nav_height - 45, width: 180, height: 40))
        segmentView.callBack = { [weak self]view in
            if view.inviteBtn.isSelected{
                self?.tableView.isHidden = true
                self?.wkWebView.isHidden = false
                self?.addRightNav()
            }else{
                self?.tableView.isHidden = false
                self?.wkWebView.isHidden = true
                self?.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: UIView())
            }
        }
        
        return segmentView
    }()
    

    lazy var infoArray = [SQInviteFriendItemModel]()
    
    lazy var tableHeaderView:SQFriendTableHeaderView = {
        let hv = SQFriendTableHeaderView()
        hv.setSize(size: CGSize.init(width: k_screen_width, height: 45))
        return hv
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segmentView.removeFromSuperview()
        UIApplication.shared.keyWindow?.addSubview(segmentView)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        segmentView.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        addTableView(frame: view.bounds)
        tableView.separatorStyle = .none
        tableView.register(SQFriendsCell.self, forCellReuseIdentifier: SQFriendsCell.cellID)
        tableView.isHidden = true
        self.urlPath = WebViewPath.inviteFriend
        tableView.tableHeaderView = tableHeaderView
        addFooter()
        addMore()
    }
}

extension SQFriendVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SQFriendsCell = tableView.dequeueReusableCell(withIdentifier: SQFriendsCell.cellID) as! SQFriendsCell
        let model = infoArray[indexPath.row]
        cell.titleLabel.text = model.email
        cell.timeLabel.text = model.created_at.formatStr("yyyy-MM-dd")
        return cell
    }
    
    override func addMore() {
        requestNetWork()
    }
    
}

extension SQFriendVC {
    func requestNetWork() {
        let start = infoArray.count
        let size  = 10
        weak var weakSelf = self
        SQCloudNetWorkTool.getAccountInviteFriend(start: start, size: size) { (model, statu, errorMessage) in
            weakSelf?.endFooterReFresh()
            if (errorMessage != nil) {
                if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: statu, handel: nil) {
                    return
                }
                
                SQEmptyView.showUnNetworkView(statu: statu, handel: { (isClick) in
                    if isClick {
                        weakSelf?.requestNetWork()
                    }else{
                        weakSelf?.navigationController?
                            .popViewController(animated: true)
                    }
                })
                return
            }
            
            if  weakSelf?.infoArray.count ?? 0 < 1 {
                model?.referral_link = model!.referral_link + "&type=3&client_type=2"
            }
            
            if model!.referral_list.count < size {
                weakSelf?.endFooterReFreshNoMoreData()
            }
            weakSelf?.tableHeaderView.titleLabel.text = "你成功邀请了\(model!.total_num.getShowString())人"
            weakSelf?.infoArray.append(contentsOf: model!.referral_list)
            weakSelf?.tableView.reloadData()
        }
    }
}


//tableHeaderView
 class SQFriendTableHeaderView: UIView {
    var blueView = UIView()
    var titleLabel = UILabel()
    var lineView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        blueView.backgroundColor = k_color_normal_blue
        blueView.frame = CGRect.init(x: 20, y: 15, width: 4, height: 15)
        
       
        titleLabel.frame = CGRect.init(x: 30, y: 15, width: 350, height: 15)
        titleLabel.font = k_font_title_weight
        titleLabel.textColor = k_color_black
        titleLabel.text      = "你成功邀请了0人"
        
        
        lineView.frame = CGRect.init(x: 0, y: 45, width: k_screen_width, height: 1)
        lineView.backgroundColor = k_color_line_light
        
        addSubview(blueView)
        addSubview(titleLabel)
        addSubview(lineView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



//成功邀请好友cell

class SQFriendsCell: UITableViewCell {
    
    static let cellID = "SQInviteFriendsCellID"
    static let height: CGFloat = 34
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = k_font_title
        return titleLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = k_font_title
        return timeLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(timeLabel)
        addSubview(titleLabel)
        addSubview(lineView)
        addLayout()
    }
    
    func addLayout() {
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left).offset(20)
            maker.height.equalTo(14)
            maker.centerY.equalTo(snp.centerY)
        }
        
        timeLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(snp.right).offset(-20)
            maker.height.equalTo(titleLabel.snp.height)
            maker.centerY.equalTo(snp.centerY)
        }
        
        lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left).offset(20)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(k_line_height)
            maker.bottom.equalTo(snp.bottom).offset(k_line_height * -1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SQFriendVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewWillAppear(true)
    }
}
