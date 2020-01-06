//
//  SQEmptyView.swift
//  SheQu
//
//  Created by gm on 2019/6/20.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
enum SQEmptyTableViewCellType {
    
    /// 文章
    case wz
    
    ///文章列表
    case wzList
    
    ///收藏列表
    case collectList
    
    ///首页搜索
    case homeSearchEmpty
    /// 评论
    case pl
    
    ///详情页评论
    case comment
    
    /// 网络
    case wl
    
    /// 文章分类
    case fl
    
    /// 正在上传文件
    case uploadIngFile
    
    ///已经上传文件
    case uploadLoadFile
    
    ///云盘图片
    case cloudImage
    
    ///云盘视频
    case cloudVideo
    
    ///云盘音频
    case cloudAudio
    
    ///云盘附件
    case cloudOther
    
    ///金币明细
    case goldInfo
    
    ///提现明细
    case goldToCashList
    
    ///积分明细
    case integralInfo
    
    ///积分订单
    case integralOrder
    
    ///金币订单
    case goldOrder
    
    ///搜索词条为空
    case searchEmpty
    
    ///公告栏
    case announcement
    

    ///标签页
    case labels

    ///版主审核文章列表
    case auditArticleList
    
    ///关注列表
    case attentionList
    
    ///粉丝列表
    case fanList
    ///下载界面
    case download

}

class SQEmptyView: UIView {
    
    lazy var backBtn: UIButton = {
        let btn = UIButton()
        btn.frame.size = CGSize.init(width: 30, height: 30)
        btn.setImage(UIImage.init(named: "nav_back"), for: .normal)
        btn.addTarget(self, action: #selector(navPop), for: .touchUpInside)
        btn.imageView?.contentMode = .left
        return btn
    }()
    
    lazy var emptyImageView: UIImageView = {
        let emptyImageView = UIImageView()
        emptyImageView.contentMode = .bottom
        return emptyImageView
    }()
    
    lazy var emptyTipsLabel: UILabel = {
        let emptyTipsLabel = UILabel()
        emptyTipsLabel.textAlignment = .center
        emptyTipsLabel.textColor     = k_color_title_gray
        emptyTipsLabel.font          = k_font_title
        return emptyTipsLabel
    }()
    
    lazy var refreshBtn: UIButton = {
        let refreshBtn = UIButton()
        refreshBtn.setSize(size: CGSize.init(width: 100, height: 30))
        refreshBtn.layer.cornerRadius = 15
        refreshBtn.layer.borderWidth  = 1
        refreshBtn.layer.borderColor  = k_color_normal_blue.cgColor
        refreshBtn.setTitle("刷新", for: .normal)
        refreshBtn.setTitleColor(k_color_title_blue, for: .normal)
        refreshBtn.addTarget(self, action: #selector(refreshNow), for: .touchUpInside)
        return refreshBtn
    }()
    
    private var customCellType: SQEmptyTableViewCellType!
    
    var callBack:((Bool)->())?
    
    @objc func refreshNow() {
        if (callBack != nil) {
            removeFromSuperview()
            callBack!(true)
        }
    }
    
    @objc func navPop() {
        if callBack != nil {
            removeFromSuperview()
            callBack!(false)
        }
    }
    
    init(frame: CGRect, cellType: SQEmptyTableViewCellType) {
        super.init(frame: frame)
        customCellType = cellType
        backgroundColor = UIColor.white
        addSubview(emptyImageView)
        addSubview(emptyTipsLabel)
        var title     = ""
        var imageName = ""
        switch cellType {
            
        case .wz:
            title     = "文章不存在,再看看别的吧"
            imageName = "sq_empty_wz"
        case .wzList:
            title     = "亲,你的文章列表空空的哦!"
            imageName = "sq_empty_wz_list"
        case .pl:
            title     = "亲,你的评论列表空空的哦!"
            imageName = "sq_empty_pl"
        case .comment:
            title     = "快来抢占沙发吧!"
            imageName = "sq_empty_pl"
        case .wl:
            title     = "网络不太顺畅哦!"
            imageName = "sq_empty_wl"
            addSubview(refreshBtn)
            addSubview(backBtn)
        case .fl:
            title     = "没有相关的文章哦!换个分类试试"
            imageName = "sq_empty_fl"
        case .uploadLoadFile:
            title     = "暂无已上传的文件"
            imageName = "sq_empty_upload"
        case .uploadIngFile:
            title     = "暂无上传中的文件"
            imageName = "sq_empty_upload"
        case .cloudImage:
            title     = "亲,您的云盘没有图片哦"
            imageName = "sq_empty_upload"
        case .cloudVideo:
            title     = "亲,您的云盘没有视频文件哦"
            imageName = "sq_empty_upload"
        case .cloudAudio:
            title     = "亲,您的云盘没有音频文件哦"
            imageName = "sq_empty_upload"
        case .cloudOther:
            title     = "亲,您的云盘没有附件文件哦"
            imageName = "sq_empty_upload"
        case .goldInfo:
            title     = "暂无金币明细"
            imageName = "sq_empty_wz_list"
        case .integralInfo:
            title     = "暂无积分明细"
            imageName = "sq_empty_wz_list"
        case .integralOrder:
            title     = "暂无积分订单"
            imageName = "sq_empty_wz_list"
        case .goldOrder:
            title     = "暂无金币订单"
            imageName = "sq_empty_wz_list"
        case .searchEmpty:
            title     = "没有满足条件的数据，换个词语试试吧!"
            imageName = "sq_empty_upload"
        case .collectList:
            title     = "亲,你的收藏列表空空的哦!"
            imageName = "sq_empty_wz_list"
        case .goldToCashList:
            title     = "暂无提现记录"
            imageName = "sq_empty_wz_list"
        case .announcement:
            title     = "暂无公告"
            imageName = "sq_empty_wz_list"
        case .homeSearchEmpty:
            title     = "没有相关内容"
            imageName = "sq_empty_search"
        case .labels:
            title     = "没有满足条件的数据"
            imageName = "sq_empty_wz_list"
        case .auditArticleList:
            title     = "暂无数据"
            imageName = "sq_empty_wz_list"
        case .attentionList:
            title     = "亲,您还没有关注的人哦"
            imageName = "sq_empty_wl"
        case .fanList:
            title     = "亲,暂时还没有人关注你哦"
            imageName = "sq_empty_wl"
        case .download:
            title     = "亲,您的云盘没有下载视频文件哦"
            imageName = "sq_empty_upload"
        }
        
        emptyTipsLabel.text = title
        emptyImageView.image = UIImage.init(named: imageName)
        addLayout()
    }
    
    func addLayout() {
        
        var top: CGFloat = -80
        if customCellType == SQEmptyTableViewCellType.fl {
            top = -120
        }
        if customCellType == SQEmptyTableViewCellType.homeSearchEmpty {
            top = 0
        }
            
        emptyImageView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(snp.centerX)
            maker.centerY.equalTo(snp.centerY).offset(top)
            maker.height.equalTo(62.5)
            maker.width.equalTo(70)
        }
        
        emptyTipsLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(emptyImageView.snp.bottom).offset(20)
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
            maker.height.equalTo(30)
        }
        
        if emptyTipsLabel.text == "网络不太顺畅哦!" {
            
            refreshBtn.snp.makeConstraints { (maker) in
                maker.centerX.equalTo(emptyTipsLabel.snp.centerX)
                maker.top.equalTo(emptyTipsLabel.snp.bottom).offset(10)
                maker.width.equalTo(100)
                maker.height.equalTo(30)
            }
            
            backBtn.snp.makeConstraints { (maker) in
                maker.left.equalTo(snp.left).offset(20)
                maker.top.equalTo(snp.top).offset(k_status_bar_height + 10)
                maker.width.equalTo(30)
                maker.height.equalTo(30)
            }
        }
    }
    
    class func showEmptyView(handel: @escaping ((Bool)->())){
        let emptyView = SQEmptyView.init(frame: UIScreen.main.bounds, cellType: .wl)
        emptyView.callBack = handel
        UIApplication.shared.keyWindow?.addSubview(emptyView)
    }
    
    class func showUnNetworkView(statu:Int32, handel: @escaping ((Bool)->())){
        if statu != 404 {
            return
        }
        let emptyView = SQEmptyView.init(frame: UIScreen.main.bounds, cellType: .wl)
        emptyView.callBack = handel
        
        UIApplication.shared.keyWindow?.addSubview(emptyView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
