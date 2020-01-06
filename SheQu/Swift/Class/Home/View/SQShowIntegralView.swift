//
//  SQShowIntegralViewControll.swift
//  SheQu
//
//  Created by gm on 2019/7/16.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    ///tipsView
    static let tipsViewW: CGFloat = 255
    static let tipsViewH: CGFloat = 350
    
    ///closeBtn
    static let closeBtnTop: CGFloat = 50
    static let closeBtnWH: CGFloat   = 30
}

fileprivate var integralView: SQShowIntegralView?

class SQShowIntegralView: UIView {
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage.init(named: "sq_integral_bg")
        return bgImageView
    }()
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = UIColor.black
        coverView.alpha = 0.7
        return coverView
    }()
    
    lazy var tipsView: SQIntegralTipsView = {
        let tipsView = SQIntegralTipsView()
        let tipsSzie = CGSize.init(
            width: SQItemStruct.tipsViewW,
            height: SQItemStruct.tipsViewH
        )
        
        tipsView.setSize(size: tipsSzie)
        let  radiSize = CGSize.init(width: 10, height: 10)
        tipsView.addRounded(corners: .allCorners,
                            radii: radiSize,
                            borderWidth: 0,
                            borderColor: UIColor.clear
        )
        
        weak var weakSelf = self
        tipsView.callBack = { state in
            if state == 0 {
                weakSelf?.jumpBuyIntegralVC()
            }else{
                weakSelf?.jumpIntegralVC()
            }
        }
        
        return tipsView
    }()
    
    lazy var closeBtn: UIButton = {
        let closeBtn = UIButton()
        closeBtn.setImage(
            UIImage.init(named: "sq_integral_close"),
            for: .normal
        )
        
        closeBtn.addTarget(
            self,
            action: #selector(hiddenIntegralVC),
            for: .touchUpInside
        )
        
        return closeBtn
    }()
    
    weak var customVC: UIViewController?
    var value: Int = 0
    var customAction =  SQAccountScoreJudgementModel.action.read_article
    
    class func showIntegralView(vc: UIViewController?, integralValue: Int, action: SQAccountScoreJudgementModel.action) {
        integralView = SQShowIntegralView.init(
            frame: UIScreen.main.bounds,
            vc: vc,
            integralValue: integralValue,
            action: action
        )
        
        UIApplication.shared.keyWindow?.addSubview(integralView!)
    }
    
    class func hiddenIntegralView() {
        integralView?.removeFromSuperview()
    }
    
    init(frame: CGRect, vc: UIViewController?, integralValue: Int, action: SQAccountScoreJudgementModel.action) {
        super.init(frame: frame)
        customVC     = vc
        value        = integralValue
        customAction = action
        if action == SQAccountScoreJudgementModel.action.read_article {
            bgImageView.isHidden = false
        }else{
            bgImageView.isHidden = true
        }
        
        addSubview(bgImageView)
        addSubview(coverView)
        addSubview(tipsView)
        addSubview(closeBtn)
        tipsView.updateTipsLabelValue(
            integralValue,
            tipsTitle: getTipsTitle()
        )
        
        addLayout()
    }
    
    fileprivate func getTipsTitle() -> String {
        var tipsTitle  =  ""
        switch customAction {
        case .comment_article:
            tipsTitle  =  "每发布一条评论需要扣"
            bgImageView.isHidden = true
        case .create_article:
            tipsTitle  =  "发布一篇新文章需扣"
            bgImageView.isHidden = true
        case .read_article:
            tipsTitle  =  "阅读该文章需扣"
        case .download_video:
            tipsTitle  =  "下载视频需扣"
        }
        
        return tipsTitle
    }
    
    fileprivate func addLayout() {
        bgImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.bottom.equalTo(snp.bottom)
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
        }
        
        coverView.snp.makeConstraints { (maker) in
            maker.top.equalTo(snp.top)
            maker.bottom.equalTo(snp.bottom)
            maker.left.equalTo(snp.left)
            maker.right.equalTo(snp.right)
        }
        
        tipsView.snp.makeConstraints { (maker) in
            maker.center.equalTo(snp.center)
            maker.height.equalTo(SQItemStruct.tipsViewH)
            maker.width.equalTo(SQItemStruct.tipsViewW)
        }
        
        closeBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(snp.centerX)
            maker.width.equalTo(SQItemStruct.closeBtnWH)
            maker.height.equalTo(SQItemStruct.closeBtnWH)
            maker.top.equalTo(tipsView.snp.bottom)
                .offset(SQItemStruct.closeBtnTop)
        }
    }
    
    func jumpBuyIntegralVC() {
        ///如果是写文章
        SQShowIntegralView.hiddenIntegralView()
        let vc = SQWebViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.urlPath = WebViewPath.buyIntegral
        vc.action  = customAction
        customVC?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func jumpIntegralVC() {
        SQShowIntegralView.hiddenIntegralView()
        let vc = SQWebViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.urlPath = WebViewPath.integralInfo
        vc.action  = customAction
        customVC?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func hiddenIntegralVC() {
        SQShowIntegralView.hiddenIntegralView()
        if customAction == SQAccountScoreJudgementModel.action.read_article {
            customVC?.navigationController?.popViewController(animated: true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
