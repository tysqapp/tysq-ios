//
//  SQWebViewMenuView.swift
//  SheQu
//
//  Created by gm on 2019/8/23.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

private struct SQItemStruct {
    
    ///imageView
    static let imageViewW: CGFloat = 7.5
    static let imageViewH: CGFloat = SQMenuView.imageViewH
    
    static let aniDuration: CGFloat = 0.25
}

class SQMenuView: UIView {
    enum MenuType: Int {
        case screenshots = 0
        case link = 1
        case all  = 2
        case draft = 3
        case audit = 4
        case publish = 5
        case auditFail = 6
        case article = 7
        case account = 8
        case tag = 9
        case forbid = 10
        case hidden = -4
        case goldDescription = 11
        case withdrawalsRecord = 12
        case goldOrder = 13
        case refresh = 14
    }
    
    enum TrianglePosition {
        case left
        case center
        case right
    }
    
    static let imageViewH: CGFloat = 3.5
    private var contentViewFrame: CGRect!
    lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(coverViewClick))
        coverView.addGestureRecognizer(tap)
        return coverView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "sq_webview_ triangle")
        return imageView
    }()
    
    lazy var menuTableView: UITableView = {
        let menuTableView = UITableView()
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.backgroundColor = UIColor.colorRGB(0x666666)
        menuTableView.rowHeight       = 50
        menuTableView.separatorStyle  = .none
        return menuTableView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    lazy var isShowing = false
    
    private lazy var itemModelArrayM = [SQWebViewMenuItemModel]()
    private var trianglePosition = SQMenuView.TrianglePosition.left
    private var customTypeArray: [SQMenuView.MenuType]!
    private var callback: ((SQMenuView.MenuType, String) -> ())!
    
    init(frame: CGRect,
         typeArray: [SQMenuView.MenuType],
         trianglePosition: SQMenuView.TrianglePosition,
         handel: @escaping ((SQMenuView.MenuType, String) -> ())
        ) {
        super.init(frame: UIScreen.main.bounds)
        self.trianglePosition = trianglePosition
        customTypeArray = typeArray
        contentViewFrame = frame
        alpha = 0
        callback = handel
        for index in 0..<typeArray.count {
            let type = typeArray[index]
            itemModelArrayM.append(getItemModel(type))
        }
        
        addSubview(coverView)
        addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(menuTableView)
        
        menuTableView.setSize(size: CGSize.init(
            width: frame.size.width,
            height: frame.size.height - SQItemStruct.imageViewH
        ))
        
        menuTableView.addRounded(corners: .allCorners, radii: k_corner_radiu_size, borderWidth: 0, borderColor: UIColor.clear)
        
        addLayout()
    }
    
    private func addLayout() {
        
        coverView.snp.makeConstraints { (maker) in
            maker.right.equalTo(snp.right)
            maker.left.equalTo(snp.left)
            maker.top.equalTo(snp.top)
            maker.bottom.equalTo(snp.bottom)
        }
        
        contentView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top).offset(contentViewFrame.origin.y)
            maker.left.equalTo(snp.left).offset(contentViewFrame.origin.x)
            maker.height.equalTo(contentViewFrame.size.height)
            maker.width.equalTo(contentViewFrame.size.width)
        }
        
        
        switch trianglePosition {
        case .left:
            imageView.snp.makeConstraints { (maker) in
                maker.right.equalTo(contentView.snp.left).offset(10)
            }
        case .center:
            imageView.snp.makeConstraints { (maker) in
                maker.right.equalTo(contentView.snp.centerX)
            }
        case .right:
            imageView.snp.makeConstraints { (maker) in
                maker.right.equalTo(contentView.snp.right).offset(-10)
            }
        }
        
        imageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView.snp.top)
            maker.height.equalTo(SQItemStruct.imageViewH)
            maker.width.equalTo(SQItemStruct.imageViewW)
        }
        
        
        menuTableView.snp.makeConstraints { (maker) in
            maker.right.equalTo(contentView.snp.right)
            maker.top.equalTo(imageView.snp.bottom)
            maker.left.equalTo(contentView.snp.left)
            maker.bottom.equalTo(contentView.snp.bottom)
        }
        
    }
    
    @objc private func coverViewClick() {
        hiddenMenuView()
    }
    
    func showMenuView() {
        isShowing = true
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: TimeInterval.init(SQItemStruct.aniDuration)) {
            self.alpha = 1
        }
    }
    
    func hiddenMenuView() {
        isShowing = false
        self.alpha = 0
        self.removeFromSuperview()
    }
    
    private func getItemModel(_ type: SQMenuView.MenuType) -> SQWebViewMenuItemModel{
        var itemModel = SQWebViewMenuItemModel()
        switch type {
        case .screenshots:
            itemModel = SQWebViewMenuItemModel.init(imageName: "sq_webview_screenshot", title: "截屏", textAlignment: .left)
        case .link:
            itemModel = SQWebViewMenuItemModel.init(imageName: "sq_webview_browser", title: "浏览器打开", textAlignment: .left)
        case .all:
            itemModel = SQWebViewMenuItemModel.init(imageName: "", title: "全部", textAlignment: .center)
        case .draft:
            itemModel = SQWebViewMenuItemModel.init(imageName: "", title: "草稿", textAlignment: .center)
        case .audit:
            itemModel = SQWebViewMenuItemModel.init(imageName: "", title: "待审核", textAlignment: .center)
        case .publish:
            itemModel = SQWebViewMenuItemModel.init(imageName: "", title: "已发布", textAlignment: .center)
        case .auditFail:
            itemModel = SQWebViewMenuItemModel.init(imageName: "", title: "审核驳回", textAlignment: .center)
        case .article:
            itemModel = SQWebViewMenuItemModel.init(imageName: "", title: "文章", textAlignment: .center)
        case .account:
            itemModel = SQWebViewMenuItemModel.init(imageName: "", title: "用户", textAlignment: .center)
        case .tag:
            itemModel = SQWebViewMenuItemModel.init(imageName: "", title: "标签", textAlignment: .center)
        case .hidden:
            itemModel = SQWebViewMenuItemModel.init(imageName: "", title: "已隐藏", textAlignment: .center)
        case .forbid:
            itemModel = SQWebViewMenuItemModel.init(imageName: "sq_menu_forbid", title: "禁止评论", textAlignment: .left)
        case .goldDescription:
            itemModel = SQWebViewMenuItemModel.init(imageName: "", title: "金币说明", textAlignment: .center)
        case .withdrawalsRecord:
            itemModel = SQWebViewMenuItemModel.init(imageName: "", title: "提现记录", textAlignment: .center)
        case .goldOrder:
            itemModel = SQWebViewMenuItemModel.init(imageName: "", title: "金币订单", textAlignment: .center)
        case .refresh:
            itemModel = SQWebViewMenuItemModel.init(imageName: "sq_webview_refresh", title: "刷新", textAlignment: .left)
        }
        
        return itemModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension SQMenuView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemModelArrayM.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SQCloudTableViewCell.init(
            style: .default,
            reuseIdentifier: SQCloudTableViewCell.cellID,
            lineLeft: 0
        )
        
        if indexPath.row == itemModelArrayM.count - 1 {
            cell.lineView.isHidden = true
        }
        
        cell.backgroundColor  = UIColor.clear
        cell.selectionStyle   = .none
        cell.selectionStyle   = .none
        cell.accessoryView = nil
        let itemModel         = itemModelArrayM[indexPath.row]
        cell.textLabel?.textAlignment = itemModel.textAlignment
        cell.imageView?.image  = UIImage.init(named: itemModel.imageName)
        cell.textLabel?.text      = itemModel.title
        cell.textLabel?.font      = k_font_title
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = customTypeArray[indexPath.row]
        let itemModel = itemModelArrayM[indexPath.row]
        callback(type,itemModel.title)
        hiddenMenuView()
    }
}



fileprivate struct SQWebViewMenuItemModel {
    var imageName = ""
    var title = ""
    var textAlignment = NSTextAlignment.left
}
