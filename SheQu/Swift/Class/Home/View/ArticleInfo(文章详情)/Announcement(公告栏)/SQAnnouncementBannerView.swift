//
//  SQAnnouncementBannerView.swift
//  SheQu
//
//  Created by gm on 2019/8/20.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    ///announcementImageView
    static let announcementImageViewWH: CGFloat = SQAnnouncementBannerView.topViewH
    static let loadMoreBtnH: CGFloat = announcementImageViewWH
    static let loadMoreBtnW: CGFloat = 150
    ///cycleScrollView
    static let cycleScrollViewTop: CGFloat = announcementImageViewWH
    static let cycleScrollViewW: CGFloat   = k_screen_width
    static let cycleScrollViewH: CGFloat   = SQAnnouncementBannerView.bottomViewH
}

class SQAnnouncementBannerView: UIView {
    static let topViewH: CGFloat   = 35
    static let bottomViewH: CGFloat   = 65
    static let height: CGFloat = topViewH + bottomViewH
    static let width: CGFloat = k_screen_width
    
    static let sharedInstance: SQAnnouncementBannerView = {
        let instance = SQAnnouncementBannerView()
        instance.setSize(size: CGSize.init(
            width: SQAnnouncementBannerView.width,
            height: SQAnnouncementBannerView.height
        ))
        return instance
    }()
    
    lazy var announcementImageView: UIImageView = {
        let announcementImageView = UIImageView()
        announcementImageView.image = UIImage.init(named: "sq_announcement")
        announcementImageView.contentMode = .left
        return announcementImageView
    }()
    
    lazy var loadMoreBtn: SQImagePositionBtn = {
        let loadMoreBtn = SQImagePositionBtn.init(
            frame: CGRect.zero,
            position: .right,
            imageViewSize: CGSize.init(width: 10, height: 30)
        )
        
        loadMoreBtn.contentVerticalAlignment   = .center
        loadMoreBtn.imageView?.contentMode     = .right
        loadMoreBtn.titleLabel?.textAlignment  = .right
        let infoTitleColor = k_color_title_gray_blue
        loadMoreBtn.setTitleColor(infoTitleColor, for: .normal)
        loadMoreBtn.titleLabel?.font = k_font_title_12
        loadMoreBtn.setImage(
            UIImage.init(named: "sq_home_loadmore"),
            for: .normal
        )
        loadMoreBtn.setTitle("查看更多", for: .normal)
        loadMoreBtn.addTarget(
            self,
            action: #selector(loadMoreBtnClick(btn:)),
            for: .touchUpInside
        )
        
        return loadMoreBtn
    }()
    
    lazy var cycleScrollView: SDCycleScrollView = {
        let frame = CGRect.init(
            x: 0,
            y: SQItemStruct.cycleScrollViewTop,
            width: SQItemStruct.cycleScrollViewW,
            height: SQItemStruct.cycleScrollViewH
        )
        
        let cycleScrollView = SDCycleScrollView.init(
            frame: frame,
            delegate: self,
            placeholderImage: UIImage.init(named: "")
        )
        
        cycleScrollView?.autoScrollTimeInterval  = 5
        cycleScrollView?.pageControlBottomOffset = -5
        cycleScrollView?.currentPageDotImage = UIImage.init(named: "sq_banner_sel")
        cycleScrollView?.pageDotImage = UIImage.init(named: "sq_banner")

        return cycleScrollView!
    }()
    
    var loadMoreCallBack:((SQAnnouncementBannerView) -> ())?
    var selectedCallBack: ((SQAnnouncementItemData) -> ())?
    var itemDataArray: [SQAnnouncementItemData]? {
        didSet{
            if itemDataArray!.count == 0 {
                cycleScrollView.isHidden = true
                return
            }
            var titleArray = [String]()
            for index in 0..<itemDataArray!.count {
                titleArray.append("\(index)")
            }
            cycleScrollView.imageURLStringsGroup = titleArray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(announcementImageView)
        addSubview(loadMoreBtn)
        addSubview(cycleScrollView)
        addLayout()
    }
    
    private func addLayout(){
        announcementImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left).offset(20)
            maker.height
                .equalTo(SQItemStruct.announcementImageViewWH)
            maker.width
                .equalTo(SQItemStruct.announcementImageViewWH)
            maker.top.equalTo(snp.top)
        }
        
        loadMoreBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.right.equalTo(snp.right).offset(-20)
            maker.width.equalTo(SQItemStruct.loadMoreBtnW)
            maker.height.equalTo(SQItemStruct.loadMoreBtnH)
        }
        
        cycleScrollView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
                .offset(SQItemStruct.cycleScrollViewTop)
            maker.left.equalTo(snp.left)
            maker.height.equalTo(SQItemStruct.cycleScrollViewH)
            maker.width.equalTo(SQItemStruct.cycleScrollViewW)
        }
        
    }
    
    @objc func loadMoreBtnClick(btn: UIButton) {
        if (loadMoreCallBack != nil) {
            loadMoreCallBack!(self)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension SQAnnouncementBannerView: SDCycleScrollViewDelegate {
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        if (selectedCallBack != nil) {
            selectedCallBack!(itemDataArray![index])
        }
    }
    
    func customCollectionViewCellClass(for view: SDCycleScrollView!) -> AnyClass! {
        return SQAnnouncementCard.self
    }
    
    func setupCustomCell(_ cell: UICollectionViewCell!, for index: Int, cycleScrollView view: SDCycleScrollView!) {
        guard  let cell: SQAnnouncementCard = cell as? SQAnnouncementCard else {
            return
        }
        
        if itemDataArray?.count ?? 0 > index {
            cell.customItemData = itemDataArray![index]
        }
    }
}
