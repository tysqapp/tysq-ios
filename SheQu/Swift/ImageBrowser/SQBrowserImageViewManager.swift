//
//  SQBrowserImageViewManager.swift
//  SheQu
//
//  Created by gm on 2019/9/3.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
fileprivate struct SQItemStruct {
    static let aniDuration: CGFloat = 0.7
}
class SQBrowserImageViewManager: UIView {
    
    static let sharedInstance: SQBrowserImageViewManager = {
        let instance = SQBrowserImageViewManager()
        return instance
    }()
    
    lazy var coverView: UIView = {
        let cover = UIView()
        cover.backgroundColor = UIColor.black
        return cover
    }()
    ///动画时间
    private var aniDuration: CGFloat = SQItemStruct.aniDuration
    
    lazy var collectionView: SQBrowserImageViewCollectionView = {
        let collectionView = SQBrowserImageViewCollectionView()
        weak var weakSelf  = self
        collectionView.collectionViewCallBack = { (view,item)  in
            weakSelf?.hiddenBrowserImageView(item)
        }
        
        return collectionView
    }()
    
    
   
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = UIColor.clear
        coverView.frame = self.bounds
        addSubview(coverView)
        addSubview(collectionView)
    }
    
    /// 展示图片浏览器
    open class func showBrowserImageView(
        browserImageViewItemArray: [SQBrowserImageViewItem],
        selIndex: Int,
        duration: CGFloat = SQItemStruct.aniDuration) {
        let manager = SQBrowserImageViewManager.init(frame: UIScreen.main.bounds)
        
        let selFrame = browserImageViewItemArray[selIndex].oldFrame
        manager.collectionView.frame = selFrame
        manager.collectionView.update(
            browserImageViewItemArray: browserImageViewItemArray,
            selIndex: selIndex
        )
        
        UIApplication.shared.keyWindow?.addSubview(manager)
        manager.aniDuration = 0.2
        manager.coverView.alpha = 0.2
        let aniTimeInterval = TimeInterval.init(manager.aniDuration)
        UIView.animate(withDuration: aniTimeInterval, animations: {
            manager.coverView.alpha = 1
            manager.collectionView.frame = manager.bounds
        }) { (isFinish) in
            if isFinish {
                
            }
        }
        
        
    }
    
    ///隐藏图片浏览器
    private func hiddenBrowserImageView(_ cell: SQBrowserImageViewCollectionViewCell) {
        let aniTimeInterval = TimeInterval.init(aniDuration)
        cell.bottomView.isHidden = true
        UIView.animate(withDuration: aniTimeInterval, animations: {
            self.coverView.alpha = 0.2
            cell.backgroundColor = UIColor.clear
            cell.browserImageView.imageView.frame = cell.item.oldFrame
            
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

