//
//  SQTopArticleAniView.swift
//  DownloadApp
//
//  Created by gm on 2019/11/13.
//  Copyright © 2019 SmartInspection. All rights reserved.
//

import UIKit

class SQTopArticleAniView: UIView {
    
    private lazy var itemArray = [UILabel]()
    
    static let sharedInstance: SQTopArticleAniView = {
        let instance = SQTopArticleAniView()
        instance.backgroundColor = UIColor.white
        return instance
    }()
    
    lazy var jumpBtn: UIButton = {
        let jumpBtn = UIButton()
        jumpBtn.addTarget(self, action: #selector(jumpTotalTopArticleVC), for: .touchUpInside)
        jumpBtn.setImage(UIImage.init(named: "home_ac_inside"), for: .normal)
        jumpBtn.contentHorizontalAlignment = .right
        return jumpBtn
    }()
    
    private var titleArray = [SQTopArticleModel]()
    private var itemSize   = CGSize.zero
    private var itemWidth: CGFloat  = 0
    private var selIndex   = 0
    private var itemMaxNum = 0
    /// 动画时长
    private var aniDuration: TimeInterval = 0.25
    /// 等待时长 默认3
    private var waitDuration: TimeInterval = 3
    /// 所属vc
    private var vc: UIViewController?
    private var timer: Timer?
    /// 更新数据源
    /// - Parameter titleArray: 数据源
    /// - Parameter itemSize: item大小
    /// - Parameter vc: 所属vc
    /// - Parameter aniDuration: 动画时间
    /// - Parameter waitDuration: 等待时间
    /// - Parameter itemMaxNum: 内容展示最大数量
    /// - Parameter junmBtnNum: 触发显示跳转按钮数据
    /// - Parameter needCheck: 是否需要检测vc
    @discardableResult
    func updateArray(titleArray:[SQTopArticleModel]?, itemSize: CGSize, vc: UIViewController?, aniDuration: TimeInterval = 0.25, waitDuration: TimeInterval = 3, itemMaxNum: Int = 2, junmBtnNum: Int = 5, needCheck: Bool = false) -> Bool{
        
        if needCheck && vc != self.vc {
            return false
        }
        
        var count = titleArray?.count ?? 0
        if count > itemMaxNum {
            count = itemMaxNum
        }
        self.itemMaxNum = itemMaxNum
        
        for item in self.subviews {
            item.removeFromSuperview()
        }
        itemArray.removeAll()
        
        self.frame = CGRect.init(x: 0, y: 5, width: itemSize.width, height: itemSize.height * CGFloat(count) )
        let jumpBtnW: CGFloat = 40
        let jumpBtnX = itemSize.width - jumpBtnW - 20
        jumpBtn.frame = CGRect.init(x: jumpBtnX, y: 0, width: jumpBtnW, height: self.frame.size.height)
        itemWidth = jumpBtnX - 20
        addSubview(jumpBtn)
        self.layer.masksToBounds = true
        self.vc         = vc
        self.selIndex   = 0
        self.titleArray = titleArray ?? [SQTopArticleModel]()
        self.aniDuration = aniDuration
        self.itemSize    = itemSize
        removeTimer()
        initSubItem()
        return true
    }
    
    ///初始化控件
    private func initSubItem() {
        for index in 0...self.itemMaxNum {
            let item = UILabel.init(frame: CGRect.init(x: 20, y: itemSize.height * CGFloat(index), width: itemWidth, height: itemSize.height))
            item.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(jumpArticleInfoVC(tap:)))
            item.addGestureRecognizer(tap)
            item.tag = index
            if index >= titleArray.count {
                break
            }
            
            if index == self.itemMaxNum {
                item.frame = CGRect.init(x: 20, y: itemSize.height * -1, width: itemWidth, height: itemSize.height)
            }else{
                self.selIndex = index
            }
            
            item.attributedText = titleArray[index].title.toTopArticleTitle()
            itemArray.append(item)
            addSubview(item)
        }
        
        
        ///当数据超过2 则开始动画
        if titleArray.count > self.itemMaxNum {
            initTimer()
        }
    }
    
    ///开始动画
    private func startAni() {
        
        if (vc == nil) {
            return
        }
       
        if vc!.isViewLoaded && (vc!.view!.window != nil) {
            aniFinish()
            UIView.animate(withDuration: self.aniDuration, animations: {
                self.updateLabelFrame()
            }) { (isFinish) in
            }
        }
    }
    
    
    private func initTimer() {
        timer = Timer.init(timeInterval: self.waitDuration, repeats: true, block: {[weak self] (timer) in
            self?.startAni()
        })
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    private func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    ///更换动画frame
    private func updateLabelFrame(){
        for item in itemArray {
            let itemY = item.frame.origin.y - itemSize.height
            item.frame = CGRect.init(x: 20, y: itemY, width: itemWidth, height: itemSize.height)
        }
    }
    
    ///动画结束
    private func aniFinish() {
        
        for item in itemArray {
            if item.frame.origin.y < 0 {
               updateLastItem(item)
            }
        }
    }
    
    ///更新最下面label的位置和数据
    private func updateLastItem(_ item: UILabel) {
        item.frame = CGRect.init(
            x: 20,
            y: itemSize.height * CGFloat(self.itemMaxNum),
            width: itemWidth,
            height: itemSize.height
        )
        self.selIndex += 1
        if self.selIndex >= titleArray.count {
            self.selIndex = 0
        }
        
        item.attributedText = titleArray[self.selIndex].title.toTopArticleTitle()
        item.tag  = self.selIndex
    }
    
    @objc private func jumpArticleInfoVC(tap: UITapGestureRecognizer) {
        guard let label: UILabel = tap.view as? UILabel else {
            return
        }
        
        let tag = label.tag
        if tag < titleArray.count {
            let model = titleArray[tag]
            let articleVC = SQHomeArticleInfoVC()
            articleVC.article_id = model.article_id
            articleVC.hidesBottomBarWhenPushed = true
            vc?.navigationController?.pushViewController(articleVC, animated: true)
        }
    }
    
    @objc private func jumpTotalTopArticleVC() {
        
        if titleArray.count > 0 {
            let topVC = SQHomeTopArticleVC()
            let model = titleArray[0]
            topVC.parent_id = model.fatherID
            topVC.category_id = model.id
            topVC.hidesBottomBarWhenPushed = true
            vc?.navigationController?.pushViewController(topVC, animated: true)
        }
       
    }
}
