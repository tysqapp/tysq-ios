//
//  SQAnnouncementListView.swift
//  SheQu
//
//  Created by gm on 2019/8/19.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    
    ///SQAnnouncementHeaderView
    static let headerViewX: CGFloat = 0
    static let headerViewW: CGFloat = k_screen_width - headerViewX * 2
    static let headerViewH: CGFloat = 53
    
    ///closeBtn
    static let closeBtnWH: CGFloat    = 30
    static let closeBtnRight: CGFloat = -20
    
    
    ///contentView
    static let contentViewX: CGFloat     = SQShowAnnouncementListView.contentViewX
    static let contentViewRight: CGFloat = contentViewX * -1
    
    ///announcementListView
    static let announcementListViewTop: CGFloat = 20
    static let announcementListViewX: CGFloat = SQShowAnnouncementListView.announcementListViewX
    static let announcementListViewRight = announcementListViewX * -1
    
    ///SQAnnouncementHeaderView --->imageView
    static let imageViewX: CGFloat = 30
    static let imageViewW: CGFloat = 63
    static let imageViewH: CGFloat = 53
    
    ///SQAnnouncementBGView ---->circleView
    static let circleViewWidth: CGFloat        = SQShowAnnouncementListView.contentViewW
    static let circleViewHeight: CGFloat       = 15
    static let circleViewBorderWidth: CGFloat  = 4
}

///1.重新打开app显示公告栏 2.切换数据源 将显示公告栏
class SQShowAnnouncementListView: UIView {
    
    static let contentViewX: CGFloat = 2.5
    ///相对contentView
    static let announcementListViewX: CGFloat = 7
    static let contentViewW = k_screen_width - contentViewX * 2
    static let announcementListViewW = contentViewW - announcementListViewX * 2
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = UIColor.black
        coverView.alpha = 0.5
        return coverView
    }()
    
    fileprivate lazy var headerView: SQAnnouncementHeaderView = {
        let headerView = SQAnnouncementHeaderView.init(frame: CGRect.init(
            x: SQItemStruct.headerViewX,
            y: 0,
            width: SQItemStruct.headerViewW,
            height: SQItemStruct.headerViewH
        ))

        return headerView
    }()
    
    var announcementListView: SQAnnouncementTableView!
    
    fileprivate var bgView: SQAnnouncementBGView!
    
    var selectedCallBack: ((SQAnnouncementItemData) -> ())?
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
     lazy var itemDataArray = [SQAnnouncementItemData]()
    
    init(frame: CGRect, itemDataArray: [SQAnnouncementItemData]) {
        super.init(frame: frame)
        addSubview(coverView)
        addSubview(contentView)
        self.itemDataArray = itemDataArray
        announcementListView = SQAnnouncementTableView.init(
            frame: CGRect.zero,
            style: .plain,
            itemDataArray: itemDataArray
        )
        announcementListView.rowHeight = SQAnnouncementTableView.rowH
        
        let contentViewW = k_screen_width - SQItemStruct.contentViewX * 2
        var count        = itemDataArray.count
        if count > 5 {
            count = 5
        }
        
        let contentViewH = SQAnnouncementTableView.rowH * CGFloat(count) + 20 + SQItemStruct.headerViewH + SQItemStruct.announcementListViewTop
        
        contentView.setSize(size: CGSize.init(
            width: contentViewW,
            height: contentViewH
        ))
        
        bgView  = SQAnnouncementBGView.init(frame: CGRect.init(
            x: 0,
            y: 0,
            width: contentViewW,
            height: contentViewH - SQItemStruct.headerViewH
        ))
        
        contentView.addSubview(headerView)
        contentView.addSubview(bgView)
        contentView.addSubview(announcementListView)
        
        addLayout(contentViewH: contentViewH)
        addCallBack()
    }
    
    private func addLayout(contentViewH: CGFloat) {
        
        coverView.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left)
            maker.top.equalTo(snp.top)
            maker.bottom.equalTo(snp.bottom)
            maker.right.equalTo(snp.right)
        }
        
        contentView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(snp.centerY)
            maker.right.equalTo(snp.right)
                .offset(SQItemStruct.contentViewRight)
            maker.left.equalTo(snp.left)
                .offset(SQItemStruct.contentViewX)
            maker.height.equalTo(contentViewH)
        }
        
        headerView.snp.makeConstraints { (maker) in
            maker.left.equalTo(contentView.snp.left)
            maker.right.equalTo(contentView.snp.right)
            maker.top.equalTo(contentView.snp.top)
            maker.height.equalTo(SQItemStruct.headerViewH)
        }
        
        bgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(headerView.snp.bottom)
            maker.left.equalTo(contentView.snp.left)
            maker.right.equalTo(contentView.snp.right)
            maker.bottom.equalTo(contentView.snp.bottom)
        }
        
        announcementListView.snp.makeConstraints { (maker) in
            maker.left.equalTo(bgView.snp.left)
                .offset(SQItemStruct.announcementListViewX)
            maker.right.equalTo(bgView.snp.right)
                .offset(SQItemStruct.announcementListViewRight)
            maker.top.equalTo(bgView.snp.top)
                .offset(SQItemStruct.announcementListViewTop)
            maker.bottom.equalTo(contentView.snp.bottom)
                .offset(-20)
        }
        
    }
    
    private func addCallBack() {
        weak var weakSelf = self
        headerView.hiddenCallBack = { tempHeaderView in
            weakSelf?.hiddenAnnouncementView()
        }
        
        announcementListView.selectedCallBack = { itemData in
            if ((weakSelf?.selectedCallBack) != nil) {
                weakSelf!.selectedCallBack!(itemData)
            }
        }
    }
    
    func showAnnouncementView() {
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    func hiddenAnnouncementView() {
        removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


/// 公告栏头部view
fileprivate class SQAnnouncementHeaderView: UIView {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "sq_announcement_horn")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var hiddenCallBack: ((SQAnnouncementHeaderView) -> ())?
    
    lazy var closeBtn: UIButton = {
        let closeBtn = UIButton()
        closeBtn.setImage(
            UIImage.init(named: "sq_integral_close"),
            for: .normal
        )
        
        closeBtn.addTarget(
            self,
            action: #selector(hiddenAnnouncementView),
            for: .touchUpInside
        )
        
        return closeBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(closeBtn)
        addLayout()
    }
    
    func addLayout() {
        
        closeBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.height.equalTo(SQItemStruct.closeBtnWH)
            maker.width.equalTo(SQItemStruct.closeBtnWH)
            maker.right.equalTo(snp.right)
                .offset(SQItemStruct.closeBtnRight)
        }
        
        imageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left)
                .offset(SQItemStruct.imageViewX)
            maker.top.equalTo(snp.top)
            maker.width.equalTo(SQItemStruct.imageViewW)
            maker.height.equalTo(SQItemStruct.imageViewH)
        }
        
    }
    
    
    @objc func hiddenAnnouncementView() {
        if (hiddenCallBack != nil) {
            hiddenCallBack!(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


///公告栏背景view
fileprivate class SQAnnouncementBGView: UIView {
    ///61 124 235 29 103 220
    lazy var circleView: UIView = {
        let circleView = UIView()
        circleView.setSize(size: CGSize.init(
            width: SQItemStruct.circleViewWidth,
            height: SQItemStruct.circleViewHeight
        ))
        
        circleView.backgroundColor = UIColor.init(red: 29/255.0, green: 103/255.0, blue: 220/255.0, alpha: 1)
        circleView.layer.borderColor = UIColor.init(red: 61/255.0, green: 124/255.0, blue: 235/255.0, alpha: 1).cgColor
        circleView.layer.borderWidth = SQItemStruct.circleViewBorderWidth
        circleView.layer.cornerRadius = SQItemStruct.circleViewHeight * 0.5
        return circleView
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.frame = CGRect.zero
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(circleView)
        addSubview(bgView)
        bgView.setSize(size: CGSize.init(
            width: frame.size.width - SQItemStruct.announcementListViewX * 2,
            height: frame.size.height - SQItemStruct.circleViewHeight * 0.5
        ))
        
        bgView.addRounded(
            corners: [.bottomLeft,.bottomRight],
            radii: k_corner_radiu_size_10,
            borderWidth: 0,
            borderColor: UIColor.clear
        )
        addLayout()
    }
    
    fileprivate func addLayout() {
        circleView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.left.equalTo(snp.left)
            maker.width.equalTo(SQItemStruct.circleViewWidth)
            maker.height.equalTo(SQItemStruct.circleViewHeight)
        }
        
        bgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(circleView.snp.left)
                .offset(SQItemStruct.announcementListViewX)
            maker.right.equalTo(circleView.snp.right)
                .offset(SQItemStruct.announcementListViewX * -1)
            maker.bottom.equalTo(snp.bottom)
            maker.top.equalTo(circleView.snp.top)
                .offset(SQItemStruct.circleViewHeight * 0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
