//
//  SQEditArticleInfoView.swift
//  SheQu
//
//  Created by gm on 2019/5/28.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

enum SQEditArticleEvent {
    ///编辑
    case edit
    ///删除
    case delete
    ///复制
    case copy
    ///审核
    case audit
    ///举报
    case report
    ///隐藏
    case hide
    ///已隐藏
    case hidden
    ///置顶
    case topping
}

fileprivate struct SQItemStruct {
    
    ///itemBtn
    static let itemBtnW: CGFloat  = 60
    static let itemBtnH: CGFloat  = 75
    static let itemBtnY: CGFloat  = 30
    
    ///shouHuiBtn
    static let shouHuiBtnWH: CGFloat = 30
    static let shouHuiBtnTop: CGFloat = 25
    
    ///bottomView
    static let bottomViewH: CGFloat = 175
    static let bottomViewY = k_screen_height - k_bottom_h - bottomViewH
    
}

class SQEditArticleInfoView: UIView {
    static let itemW: CGFloat = 90
    static let itemH: CGFloat = 70
    lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = UIColor.black
        coverView.alpha           = 0.3
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hiddenBottomView))
        coverView.addGestureRecognizer(tap)
        return coverView
    }()
    
    fileprivate var callBack:((SQEditArticleEvent) -> ())!
    
    lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.setSize(size: CGSize.init(width: k_screen_width, height: 175))
        bottomView.layer.cornerRadius = 10
        bottomView.layer.masksToBounds = true
        bottomView.backgroundColor = UIColor.white
        return bottomView
    }()
    
    lazy var shouHuiBtn: UIButton = {
        let shouHuiBtn = UIButton()
        shouHuiBtn.setImage(UIImage.init(named: "home_ac_shouhui"), for: .normal)
        shouHuiBtn.addTarget(self, action: #selector(hiddenBottomView), for: .touchUpInside)
        shouHuiBtn.contentVerticalAlignment = .top
        shouHuiBtn.imageView?.contentMode = .top
        return shouHuiBtn
    }()
    
    lazy var scroolView: UIScrollView = {
        let scroolView = UIScrollView()
        scroolView.showsHorizontalScrollIndicator = false
        return scroolView
    }()
    
    lazy var dimView: UIView = {
        let dimView = UIView()
        return dimView
    }()
    
    init(frame: CGRect, typeArray:[SQEditArticleEvent],handel:@escaping ((SQEditArticleEvent) -> ())) {
        super.init(frame: frame)
        addSubview(coverView)
        addSubview(bottomView)
        coverView.frame = bounds
        
        bottomView.frame = CGRect.init(
            x: 0,
            y: frame.size.height,
            width: k_screen_width,
            height: SQItemStruct.bottomViewH
        )
        
        scroolView.frame = CGRect.init(
            x: 0,
            y: 0,
            width: k_screen_width,
            height: SQItemStruct.itemBtnH + SQItemStruct.itemBtnY + 10
        )
        
        bottomView.addSubview(scroolView)
        
        let dimViewW: CGFloat = 40
        let dimViewX: CGFloat = k_screen_width - dimViewW
        dimView.frame = CGRect.init(
            x: dimViewX,
            y: 0,
            width: dimViewW,
            height: bottomView.maxY()
        )
        
        bottomView.addSubview(dimView)
        let gradientColors = [
            UIColor.white.withAlphaComponent(0).cgColor,
            UIColor.white.withAlphaComponent(0.8).cgColor,
            UIColor.white.cgColor
        ]
        
        let gradientLocations = [(0),(0.4),(1)]
        
        dimView.addGradientColor(
            gradientColors: gradientColors,
            gradientLocations: gradientLocations as [NSNumber],
            startPoint: CGPoint.init(x: 0, y: 1),
            endPoint: CGPoint.init(x: 1, y: 1)
        )
        
        
        
        let shouHuiBtnW = SQItemStruct.shouHuiBtnWH
        let shouHuiBtnH = SQItemStruct.shouHuiBtnWH
        let shouHuiBtnY = SQItemStruct.itemBtnY + SQItemStruct.itemBtnH + SQItemStruct.shouHuiBtnTop
        let shouHuiBtnX = (k_screen_width - SQItemStruct.shouHuiBtnWH) * 0.5
        shouHuiBtn.frame = CGRect.init(x: shouHuiBtnX, y: shouHuiBtnY, width: shouHuiBtnW, height: shouHuiBtnH)
        bottomView.addSubview(shouHuiBtn)
        
        let btnW: CGFloat     = SQItemStruct.itemBtnW
        let btnH: CGFloat     = SQItemStruct.itemBtnH
        let btnY: CGFloat     = SQItemStruct.itemBtnY
        let marginX: CGFloat  = 20
        var tempFrame         = CGRect.zero
        for event in typeArray {
            let btnX     = tempFrame.maxX + marginX
            let btnFrame = CGRect.init(x: btnX, y: btnY, width: btnW, height: btnH)
            let btn = getItemBtn(event)
            btn.frame  = btnFrame
            scroolView.addSubview(btn)
            tempFrame = btn.frame
        }
        
        scroolView.contentSize = CGSize.init(width: tempFrame.maxX + marginX, height: tempFrame.maxY)
        callBack = handel
    }
    
    func getItemBtn(_ event: SQEditArticleEvent) -> SQButtonView {
        weak var weakSelf = self
        var buttonView = SQButtonView.init(frame: CGRect.zero, imageName: "sq_ai_bottom_edit", title: "修改文章", handel: { (tag) in
            weakSelf!.callBack(.edit)
            weakSelf!.hiddenBottomView()
        })
        
        switch event {
        case .edit:
             break
        case .delete:
            buttonView = SQButtonView.init(frame: CGRect.zero, imageName: "sq_ai_bottom_delete", title: "删除文章", handel: { (tag) in
                weakSelf!.callBack(.delete)
                weakSelf!.hiddenBottomView()
            })
        case .copy:
            buttonView = SQButtonView.init(frame: CGRect.zero, imageName: "sq_ai_bottom_copy", title: "复制链接", handel: { (tag) in
                weakSelf!.callBack(.copy)
                weakSelf!.hiddenBottomView()
            })
        case .audit:
            buttonView = SQButtonView.init(frame: CGRect.zero, imageName: "sq_ai_bottom_audit", title: "审核文章", handel: { (tag) in
                weakSelf!.callBack(.audit)
                weakSelf!.hiddenBottomView()
            })
        case .report:
            buttonView = SQButtonView.init(frame: CGRect.zero, imageName: "sq_ai_bottom_report", title: "举报文章", handel: { (tag) in
                weakSelf!.callBack(.report)
                weakSelf!.hiddenBottomView()
            })
        case .hide:
            buttonView = SQButtonView.init(frame: CGRect.zero, imageName: "sq_ai_bottom_hide", title: "隐藏文章", handel: { (tag) in
                weakSelf!.callBack(.hide)
                weakSelf!.hiddenBottomView()
            })
        case .hidden:
            buttonView = SQButtonView.init(frame: CGRect.zero, imageName: "sq_ai_bottom_hidden", title: "取消隐藏", handel: { (tag) in
                weakSelf!.callBack(.hidden)
                weakSelf!.hiddenBottomView()
            })
        case .topping:
            buttonView = SQButtonView.init(frame: CGRect.zero, imageName: "sq_ai_bottom_topping", title: "置顶文章", handel: { (tag) in
                weakSelf!.callBack(.topping)
                weakSelf!.hiddenBottomView()
            })
        }
        
        return buttonView
    }
    
    
    
    
    func showBottomView() {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: TimeInterval.init(0.25)) {
            self.bottomView.transform = CGAffineTransform.init(
                translationX: 0,
                y: SQItemStruct.bottomViewH * -1
            )
        }
    }
    
    @objc fileprivate func hiddenBottomView() {
        UIView.animate(withDuration: TimeInterval.init(0.25), animations: {
            self.bottomView.transform = CGAffineTransform.identity
        }) { (isFinish) in
            if isFinish {
                self.removeFromSuperview()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
