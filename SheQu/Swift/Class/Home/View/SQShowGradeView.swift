//
//  SQShowGradeView.swift
//  SheQu
//
//  Created by iMac on 2019/11/7.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    ///tipsView
    static let tipsViewW: CGFloat = 255
    static let tipsViewH: CGFloat = 365
    
    ///closeBtn
    static let closeBtnTop: CGFloat = 50
    static let closeBtnWH: CGFloat   = 30
}

fileprivate var gradeView: SQShowGradeView?

class SQShowGradeView: UIView {
    
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
    
    lazy var tipsView: SQGradeTipsView = {
        let tipsView = SQGradeTipsView()
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
                weakSelf?.jumpGradeVC()
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
            action: #selector(hiddenGradeView),
            for: .touchUpInside
        )
        
        return closeBtn
    }()
    
    weak var customVC: UIViewController?
    var value = ""
    
    class func showGradeView(vc: UIViewController?, gradeValue: String) {
        gradeView = SQShowGradeView.init(
            frame: UIScreen.main.bounds,
            vc: vc,
            integralValue: gradeValue
        )
        
        UIApplication.shared.keyWindow?.addSubview(gradeView!)
    }
    
    class func hiddenGradeView() {
        gradeView?.removeFromSuperview()
    }
    
    init(frame: CGRect, vc: UIViewController?, integralValue: String) {
        super.init(frame: frame)
        customVC     = vc
        value        = integralValue
        
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
        let tipsTitle  =  "很抱歉，您的等级太低，不能阅读了！！"
        
        
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
        SQShowGradeView.hiddenGradeView()
        let vc = SQWebViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.urlPath = WebViewPath.buyIntegral
        vc.action = .read_article
        customVC?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func jumpGradeVC() {
        SQShowGradeView.hiddenGradeView()
        let vc = SQWebViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.urlPath = WebViewPath.gradeInfo
        vc.action = .read_article
        customVC?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func hiddenGradeView() {
        SQShowGradeView.hiddenGradeView()
        customVC?.navigationController?.popViewController(animated: true)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
