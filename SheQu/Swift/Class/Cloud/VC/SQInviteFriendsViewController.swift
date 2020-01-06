//
//  SQInviteFriendsViewController.swift
//  SheQu
//
//  Created by gm on 2019/7/18.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

///邀请好友
class SQInviteFriendsViewController: SQViewController {
    lazy var infoArray = [SQInviteFriendItemModel]()
    lazy var tableHeaderView: SQIntegralInfoListTableHeaderView = {
        let frame = CGRect.init(
            x: 0,
            y: 0,
            width: SQIntegralInfoListTableHeaderView.width,
            height: SQIntegralInfoListTableHeaderView.height
        )
        
        let tableHeaderView = SQIntegralInfoListTableHeaderView.init(frame: frame, state: SQIntegralInfoListVC.State.exten, handel: { (event) in
            
        })
        
        tableHeaderView.checkWayBtn.addTarget(
            self,
            action: #selector(jumpInviteFriendsInfoVC),
            for: .touchUpInside
        )
        return tableHeaderView
    }()
    
    lazy var contentView: SQFriendContentView = {
        let frame = CGRect.init(
            x: 0,
            y: SQIntegralInfoListTableHeaderView.height,
            width: SQFriendContentView.width,
            height: SQFriendContentView.height
        )

        let contentView = SQFriendContentView.init(frame: frame, handel: { (event, contentView) in
            
        })
        
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let headerView = UIView()
        let height = SQIntegralInfoListTableHeaderView.height + SQFriendContentView.height
        headerView.setSize(size: CGSize.init(width: k_screen_width, height: height))
        headerView.addSubview(tableHeaderView)
        headerView.addSubview(contentView)
        addTableView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView
        
        let tableFootView = UIView()
        tableFootView.setWidth(width: k_screen_width)
        tableFootView.setHeight(height: 50)
        tableView.tableFooterView = tableFootView
        
        tableView.register(SQInviteFriendsTableViewCell.self, forCellReuseIdentifier: SQInviteFriendsTableViewCell.cellID)
        tableView.rowHeight = SQInviteFriendsTableViewCell.height
        addFooter()
        addMore()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.title = "邀请好友"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    override func addMore() {
        requestNetWork()
    }
}

extension SQInviteFriendsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SQInviteFriendsTableViewCell = tableView.dequeueReusableCell(withIdentifier: SQInviteFriendsTableViewCell.cellID) as! SQInviteFriendsTableViewCell
        let model = infoArray[indexPath.row]
        cell.titleLabel.text = model.email
        cell.timeLabel.text = model.created_at.formatStr("yyyy-MM-dd")
        return cell
    }
    
}


extension SQInviteFriendsViewController {
    
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
                        weakSelf?.navigationController?.popViewController(animated: true)
                    }
                })
                return
            }
            
            if  weakSelf?.infoArray.count ?? 0 < 1 {
                weakSelf?.contentView.model = model
                model?.referral_link = model!.referral_link + "?type=3&client_type=2"
                weakSelf?.tableHeaderView.cardView
                    .updateTipsLabelValue(model!.score_number)
            }
            
            if model!.referral_list.count < size {
                weakSelf?.endFooterReFreshNoMoreData()
            }
            
            weakSelf?.infoArray.append(contentsOf: model!.referral_list)
            weakSelf?.tableView.reloadData()
        }
    }
    
    @objc func jumpInviteFriendsInfoVC() {
        let webViewVC = SQWebViewController()
        webViewVC.urlPath = WebViewPath.invitationInfo
        navigationController?.pushViewController(webViewVC, animated: true)
    }
    
}


class SQInviteFriendsTableViewCell: UITableViewCell {
    
    static let cellID = "SQInviteFriendsTableViewCellID"
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
