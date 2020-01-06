//
//  SQAnnouncementTableView.swift
//  SheQu
//
//  Created by gm on 2019/8/19.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
fileprivate struct SQItemStruct {
    
    ///cell
    static var cellWidth: CGFloat   = SQShowAnnouncementListView.announcementListViewW
    static let cellHeight: CGFloat  = SQAnnouncementTableView.rowH
    
    ///jumpBtn
    static let jumpBtnW: CGFloat    = 40
    static let jumpBtnH: CGFloat    = 20
    static let jumpBtnRightMargin: CGFloat = -10
    
    ///titleLabel
    static let titleLabelX: CGFloat = 10
    static let titleLabelRightMargin: CGFloat = -10 - jumpBtnW + jumpBtnRightMargin
    static let titleLabelRightMarginMin: CGFloat = -10
    static let titleLabelHeight: CGFloat = 50
    static let titleLabelFont = k_font_title
    
    ///bgImageView
    static let bgImageViewTop: CGFloat    = 5
    static let bgImageViewBottom: CGFloat = -5
    static var bgImageViewX: CGFloat      = 7.5
    static var bgImageViewRight: CGFloat  = -7.5
}

class SQAnnouncementTableView: UITableView {
    
    static let rowH: CGFloat = SQAnnouncementTableViewCell.height
    
    lazy var customTableHeaderView: UIView = {
        let customTableHeaderView = UIView()
        
        return customTableHeaderView
    }()
    
    var selectedCallBack: ((SQAnnouncementItemData) -> ())?
    
    fileprivate var customItemDataArray:[SQAnnouncementItemData]!
    
    init(frame: CGRect, style: UITableView.Style, itemDataArray: [SQAnnouncementItemData]) {
        super.init(frame: frame, style: style)
        separatorStyle = .none
        backgroundColor = UIColor.clear
        register(
            SQAnnouncementTableViewCell.self,
            forCellReuseIdentifier: SQAnnouncementTableViewCell.cellID
        )
        
        customItemDataArray = itemDataArray
        tableHeaderView = customTableHeaderView
        delegate   = self
        dataSource = self
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SQAnnouncementTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customItemDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = SQAnnouncementTableViewCell.init(style: .default, reuseIdentifier: SQAnnouncementTableViewCell.cellID, width: SQShowAnnouncementListView.announcementListViewW, imageX: 7.5)
        cell.customItemData = customItemDataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (selectedCallBack != nil) {
            selectedCallBack!(customItemDataArray[indexPath.row])
        }
    }
}

struct SQAnnouncementItemData {
    enum ImageNameType: Int {
        ///蓝色
        case blue = 1
        ///绿色
        case green  = 2
        ///棕色
        case brown = 3
    }
    var title     = ""
    var imageNameType = ImageNameType.blue
    var jumpUrl   = ""
    func getArticleID() -> String{
       let strPrefix =  SQHostStruct.host.replacingOccurrences(of: SQHostStruct.apiVersion, with: "") + "/#/article/info?article_id="
        if jumpUrl.hasPrefix(strPrefix) {
            return jumpUrl.replacingOccurrences(of: strPrefix, with: "")
        }
        return ""
    }
}

///公告栏单个公告栏页
class SQAnnouncementTableViewCell: UITableViewCell {
    static let cellID = "SQAnnouncementTableViewCellID"
    static let height: CGFloat = 75
    lazy var jumpBtn: UIButton = {
        let jumpBtn = UIButton()
        jumpBtn.setImage(UIImage.init(named: "sq_announcement_jump"), for: .normal)
        jumpBtn.isUserInteractionEnabled = false
        return jumpBtn
    }()
    
    lazy var titleLabel: UILabel  = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.font          = SQItemStruct.titleLabelFont
        titleLabel.textColor     = UIColor.white
        return titleLabel
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        
        bgImageView.contentMode = .scaleAspectFill
        
        let bgImageViewW = SQItemStruct.cellWidth - SQItemStruct.bgImageViewX + SQItemStruct.bgImageViewRight
        let bgImageViewH = SQItemStruct.cellHeight - SQItemStruct.bgImageViewTop + SQItemStruct.bgImageViewBottom
        
        bgImageView.setSize(size: CGSize.init(width: bgImageViewW, height: bgImageViewH))
        bgImageView.addRounded(
            corners: .allCorners,
            radii: k_corner_radiu_size_10,
            borderWidth: 0,
            borderColor: UIColor.clear
        )
        return bgImageView
    }()
    
    var customItemData: SQAnnouncementItemData? {
        didSet {
            if (customItemData != nil) {
                
                if customItemData!.jumpUrl.count > 0 {
                    jumpBtn.isHidden = false
                }else{
                    jumpBtn.isHidden = true
                }
            
                let imageName = "sq_announcement_bg\(customItemData!.imageNameType.rawValue)"
                titleLabel.text   = customItemData?.title
                bgImageView.image = UIImage.init(named: imageName)
                layoutIfNeeded()
            }
        }
    }
    
        
    
     init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, width: CGFloat, imageX: CGFloat) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        SQItemStruct.bgImageViewX = imageX
        SQItemStruct.bgImageViewRight = imageX * -1
        SQItemStruct.cellWidth    = width
        self.selectionStyle = .none
        backgroundColor = UIColor.clear
        
        addSubview(bgImageView)
        addSubview(jumpBtn)
        addSubview(titleLabel)
        addLayout()
    }
    
    func addLayout() {
        bgImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
                .offset(SQItemStruct.bgImageViewTop)
            maker.left.equalTo(snp.left)
                .offset(SQItemStruct.bgImageViewX)
            maker.right.equalTo(snp.right)
                .offset(SQItemStruct.bgImageViewRight)
            maker.bottom.equalTo(snp.bottom)
                .offset(SQItemStruct.bgImageViewBottom)
        }
        
        jumpBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(SQItemStruct.jumpBtnW)
            maker.height.equalTo(SQItemStruct.jumpBtnH)
            maker.centerY.equalTo(snp.centerY)
            maker.right.equalTo(bgImageView.snp.right)
                .offset(SQItemStruct.jumpBtnRightMargin)
        }
        
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(SQItemStruct.titleLabelHeight)
            maker.centerY.equalTo(snp.centerY)
            maker.right.equalTo(bgImageView.snp.right)
                .offset(SQItemStruct.titleLabelRightMargin)
            maker.left.equalTo(bgImageView.snp.left)
                .offset(SQItemStruct.titleLabelX)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
