//
//  SQCloudManagerVC.swift
//  SheQu
//
//  Created by gm on 2019/10/28.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

protocol SQCloudManagerUploadDelegate: class {
    func uploadModels(uploadModel: SQAccountFileItemModel)
}

class SQCloudManagerVC: SQViewController {
    weak var uploadDelegate: SQCloudManagerUploadDelegate?
    lazy var subVCArray: [UIViewController] = {
        let detailsVC  = SQCloudDetailsVC()
        let uploadVC   = SQCloudUploadVC()
        uploadVC.uploadFinishDelegate = detailsVC
        self.uploadDelegate = uploadVC
        let downloadVC = SQCloudDownloadVC()
        
        weak var weakSelf = self
        ///处理已上传总数据回调
        detailsVC.totalNumCallBack = { totalNum in
            weakSelf?.updateTotalNumToPageTitleView(
                0,
                totalNum,
                title: "已上传"
            )
        }
        
        ///处理正在上传总数回调
        uploadVC.totalNumCallBack = { totalNum in
            weakSelf?.updateTotalNumToPageTitleView(
                1,
                totalNum,
                title: "上传中"
            )
        }
        
        ///处理正在下载总数回调
        downloadVC.totalNumCallBack =  { totalNum in
            weakSelf?.updateTotalNumToPageTitleView(
                2,
                totalNum,
                title: "正在下载"
            )
        }

        
    return [
        detailsVC,
        uploadVC,
        downloadVC
        ]
    }()
    
    lazy var pageContentScrollView: SGPageContentScrollView = {
        let pageContentScrollView = SGPageContentScrollView.init(frame: view.bounds, parentVC: self, childVCs: subVCArray,isScrollEnabled: false)
        pageContentScrollView.isScrollEnabled    = false
        pageContentScrollView.delegateScrollView = self
        return pageContentScrollView
    }()
    
    
    lazy var bottomView: SQCloudBottomView = {
        let bottomViewH = SQCloudBottomView.cloudBottomViewH
        let bottomViewY = k_screen_height - k_bottom_h - bottomViewH
        let frame = CGRect.init(
            x: 0,
            y: bottomViewY,
            width: k_screen_width,
            height: bottomViewH
        )
        
        let bottomView = SQCloudBottomView.init(frame: frame)
        bottomView.backgroundColor = UIColor.white
        bottomView.sureBtn.setTitle("上传", for: .normal)
        bottomView.sureBtn.isEnabled = true
        bottomView.sureBtn.addTarget(
            self,
            action: #selector(uploadFile),
            for: .touchUpInside
        )
        
        return bottomView
    }()
    
    lazy var bottomXView: UIView = {
        let bottomXView = UIView()
        bottomXView.backgroundColor = UIColor.white
        bottomXView.frame = CGRect.init(
            x: 0,
            y: bottomView.maxY(),
            width: k_screen_width,
            height: k_bottom_h
        )
        return bottomXView
    }()
    
    /// 二级分类view
    lazy var pageTitleView: SGPageTitleView = {
        let configure = SGPageTitleViewConfigure()
        configure.selLineViewColor = k_color_normal_blue
        configure.indicatorAdditionalWidth = 5
        configure.titleMarginWidth         = 30
        configure.indicatorHeight          = 15
        configure.btnWidth                 = k_screen_width / 3
        configure.titleGradientEffect      = true
        configure.titleUnSelectedBGImageName = ""
        configure.titleSelectedBGImageName   = ""
        configure.titleColor              = k_color_title_black
        configure.titleSelectedColor      = k_color_normal_blue
        configure.titleFont               = k_font_title
        
        let frame = CGRect.init(
            x: 0,
            y: k_nav_height,
            width: k_screen_width,
            height: k_page_title_view_height
        )
        
        let pageTitleView = SGPageTitleView.init(
            frame: frame,
            delegate: self,
            titleNames: [],
            configure: configure
        )
        
        pageTitleView.backgroundColor = k_color_bg
        pageTitleView.titleNames      = [
            getItemInfo(title: "已上传"),
            getItemInfo(title: "上传中"),
            getItemInfo(title: "正在下载")
        ]
        
        let lineView = UIView.init(frame: CGRect.init(x: 0, y: 44, width: k_screen_width, height: k_line_height))
        lineView.backgroundColor = k_color_line
        pageTitleView.addSubview(lineView)
        return pageTitleView
    }()
    
    
    func getItemInfo(title: String) -> SQHomeCategorySubInfo {
        let info = SQHomeCategorySubInfo()
        info.name = title
        return info
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "我的云盘"
        view.addSubview(pageTitleView)
        view.addSubview(pageContentScrollView)
        view.addSubview(bottomView)
        view.addSubview(bottomXView)
        NotificationCenter.default.addObserver(self, selector: #selector(initDatasourceArray), name: k_noti_download, object: nil)
        initDatasourceArray()
    }
    
    @objc func initDatasourceArray() {
       DispatchQueue.main.async {
        let count: Int = SQMutableDownloadManager.shareInstance.itemArray.count
        self.updateTotalNumToPageTitleView(2, count, title: "正在下载")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageTitleView.frame = CGRect.init(
            x: 0,
            y: k_nav_height,
            width: k_screen_width,
            height: 45
        )
        
        
        let height = bottomView.top() - pageTitleView.maxY()
        
        pageContentScrollView.frame = CGRect.init(
            x: 0,
            y: pageTitleView.maxY(),
            width: k_screen_width,
            height: height
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "我的云盘"
        var selIndex = 0
        if pageContentScrollView.previousCVCIndex >= 0 {
           selIndex = pageContentScrollView.previousCVCIndex
        }
        
        pageContentScrollView.previousCVCIndex = -1
        pageContentScrollView.setPageContentScrollView(index: selIndex)
    }
    
    private func updateTotalNumToPageTitleView(_ index: Int,_ totalNum: Int, title: String) {
        var titleTemp = title
        if totalNum != 0 {
            titleTemp += "(\(totalNum))"
        }
        
        pageTitleView.resetTitle(title: titleTemp, index: index)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension SQCloudManagerVC: SGPageContentScrollViewDelegate {
    func pageContentScrollView(pageContentScrollView: SGPageContentScrollView, progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        navigationItem.title = "我的云盘"
        pageTitleView.setPageTitleView(progress: progress, originalIndex: originalIndex, targetIndex: targetIndex)
    }
}


extension SQCloudManagerVC: SGPageTitleViewDelegate {
    
    func pageTitleView(pageTitleView: SGPageTitleView, index: Int) {
        navigationItem.title = "我的云盘"
        pageContentScrollView.setPageContentScrollView(index: index)
    }
}

