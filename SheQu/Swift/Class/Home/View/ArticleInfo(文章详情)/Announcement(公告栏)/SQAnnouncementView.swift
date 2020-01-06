////
////  SQAnnouncementView.swift
////  SheQu
////
////  Created by gm on 2019/7/25.
////  Copyright © 2019 sheQun. All rights reserved.
////
//
//import UIKit
//
//fileprivate struct SQItemStruct {
//    
//    static let margin = k_margin_x
//    
//    ///lineView
//    static let lineViewH: CGFloat = k_line_height_big
//    
//    ///announcementImageView
//    static let announcementImageViewW: CGFloat = 24
//    static let announcementImageViewH: CGFloat = 15
//    
//    ///
//    static let advertScrollViewLeft: CGFloat = 13
//    
//}
//
//class SQAnnouncementView: UIView {
//    static let announcementViewH: CGFloat = 80 + SQItemStruct.lineViewH
//    static let announcementViewW: CGFloat = k_screen_width
//    lazy var advertisement_list = [SQAdvertisementItem]()
//    weak var vc: UIViewController?
//    
//   private lazy var lineView: UIView = {
//        let frame    = CGRect.init(
//            x: 0,
//            y: 0,
//            width: SQAnnouncementView.announcementViewW,
//            height: SQItemStruct.lineViewH
//        )
//        let lineView = UIView.init(frame: frame)
//        lineView.backgroundColor = k_color_line_light
//        return lineView
//    }()
//    
//   private lazy var announcementImageView: UIImageView = {
//        
//        let announcementImageY = lineView.maxY() + (SQAnnouncementView.announcementViewH - SQItemStruct.announcementImageViewH - lineView.maxY()) * 0.5
//        let frame = CGRect.init(
//            x: SQItemStruct.margin,
//            y: announcementImageY,
//            width: SQItemStruct.announcementImageViewW,
//            height: SQItemStruct.announcementImageViewH
//        )
//        
//        let announcementImageView = UIImageView.init(frame: frame)
//        announcementImageView.image = UIImage.init(named: "sq_announcement")
//        return announcementImageView
//    }()
//    
//   private lazy var advertScrollView: SGAdvertScrollView = {
//        let advertScrollX = announcementImageView.maxX() + SQItemStruct.advertScrollViewLeft
//        let frame = CGRect.init(
//            x: advertScrollX,
//            y: lineView.maxY(),
//            width: SQAnnouncementView.announcementViewW - advertScrollX,
//            height: SQAnnouncementView.announcementViewH - lineView.maxY()
//        )
//        
//        let advertScrollView = SGAdvertScrollView.init(frame: frame)
//        advertScrollView.titleColor = k_color_black
//        advertScrollView.titleFont  = k_font_title_12
//        advertScrollView.delegate   = self
//        return advertScrollView
//    }()
//    
//    static let sharedInstance: SQAnnouncementView = {
//        let instance = SQAnnouncementView()
//        instance.setSize(size: CGSize.init(
//            width: SQAnnouncementView.announcementViewW,
//            height: SQAnnouncementView.announcementViewH
//        ))
//        return instance
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(lineView)
//        addSubview(announcementImageView)
//        addSubview(advertScrollView)
//        //requestNetWork()
//    }
//    
//    
//    func requestNetWork() {
//        weak var weakSelf = self
//        NetWorkManager.request(path: k_url_advertisement, parameters: nil, method: .get, needShowTips: false, responseClass: SQAdvertisementList.self,  successHandler: { (model, dataDict) in
//            weakSelf?.advertisement_list = model!.advertisement_list
//            weakSelf?.initSubViews()
//        }) { (statu,errorMessage) in
//            
//        }
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    func initSubViews() {
//        var titlesArray = [String]()
//        var imageNamesArray = [String]()
//        for index in 0..<advertisement_list.count {
//            let titleStr = advertisement_list[index].content
//            titlesArray.append(titleStr)
//            imageNamesArray.append("sq_announcement_arrow")
//        }
//        advertScrollView.scrollTimeInterval = 5;
//        advertScrollView.signImages = imageNamesArray
//        advertScrollView.topTitles = titlesArray
//    }
//}
//
//extension SQAnnouncementView: SGAdvertScrollViewDelegate {
//    func advertScrollView(_ advertScrollView: SGAdvertScrollView!, didSelectedItemAt index: Int) {
//        let model = advertisement_list[index]
//        if model.is_app {
//            let wbVC = SQWebViewController()
//            wbVC.urlPath = model.app_url
//            wbVC.hidesBottomBarWhenPushed = true
//            vc?.navigationController?.pushViewController(wbVC, animated: true)
//        }else{
//            guard let url = URL.init(string: model.app_url) else {
//                SQToastTool.showToastMessage("网络链接错误")
//                return
//            }
//            
//            let dict = [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly: false]
//            UIApplication.shared.open(
//                url,
//                options: dict,
//                completionHandler: nil
//            )
//        }
//    }
//}
//
//
//
//
//
//
//
//
//class SQAdvertisementList: SQBaseModel {
//    var advertisement_list = [SQAdvertisementItem]()
//}
//
//class SQAdvertisementItem: SQBaseModel {
//    var content  = ""
//    var pc_url   = ""
//    var app_url  = ""
//    var position = 1
//    var is_app   = false
//}
