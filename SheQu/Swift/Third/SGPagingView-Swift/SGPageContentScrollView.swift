//
//  SGPageContentScrollView.swift
//  SGPagingViewSwiftExample
//
//  Created by kingsic on 2018/9/12.
//  Copyright © 2018年 kingsic. All rights reserved.
//

import UIKit

@objc protocol SGPageContentScrollViewDelegate: NSObjectProtocol {
    /**
     *  联动 SGPageTitleView 的方法
     *
     *  @param SGPageContentScrollView      SGPageContentScrollView
     *  @param progress             SGPageContentScrollView 内部视图滚动时的偏移量
     *  @param originalIndex        原始视图所在下标
     *  @param targetIndex          目标视图所在下标
     */
    @objc optional func pageContentScrollView(pageContentScrollView: SGPageContentScrollView, progress: CGFloat, originalIndex: Int, targetIndex: Int)
    
    /**
     *  获取 pageContentScrollView 当前子控制器的下标值
     *
     *  @param pageContentScrollView     pageContentScrollView
     *  @param index                         pageContentScrollView 当前子控制器的下标值
     */
    @objc optional func pageContentScrollView(pageContentScrollView: SGPageContentScrollView, index: Int)

    /// SGPageContentScrollView 内容开始拖拽方法
    @objc optional func pageContentScrollViewWillBeginDragging()
    /// SGPageContentScrollView 内容结束拖拽方法
    @objc optional func pageContentScrollViewDidEndDecelerating()
}

class SGPageContentScrollView: UIView {
    /**
     *  拓展 init 方法
     *
     *  @param frame        frame
     *  @param parentVC     当前控制器
     *  @param childVCs     子控制器个数
     */
    init(frame: CGRect, parentVC: UIViewController, childVCs: [UIViewController],isScrollEnabled: Bool = true) {
        super.init(frame: frame)
        self.isScrollEnabled = isScrollEnabled
        self.parentVC = parentVC
        self.childVCs = childVCs
        self.setupSubViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 给外界提供的属性
    /// SGPageContentCollectionViewDelegate
    weak var delegateScrollView: SGPageContentScrollViewDelegate?
    /// SGPageContentCollectionView 是否可以滚动，默认为 true
    var isScrollEnabled: Bool = true
    /// 点击标题触发动画切换滚动内容，默认为 false
    var isAnimated: Bool = false
    
    // MARK: - 私有属性
    // 外界父控制器
    private weak var parentVC: UIViewController?
    var childVCs: [UIViewController] = []
    private var startOffsetX: CGFloat = 0.0
    private var previousCVC: UIViewController?
    var previousCVCIndex: Int = -1
    private var scroll: Bool?
    private var firstAdd: Bool = false
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.bounds
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        var contentWidth: CGFloat = CGFloat(self.childVCs.count) * scrollView.frame.size.width
        if !self.isScrollEnabled {
            contentWidth = scrollView.frame.size.width
        }
        scrollView.contentSize = CGSize(width: contentWidth, height: 0)
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        return scrollView
    }()
    
    func updateFrame(_ frame: CGRect) {
        self.frame = frame
        self.scrollView.frame = self.bounds
    }
}

// MARK: - 给外界提供的方法
extension SGPageContentScrollView {
    /// 根据 SGPageTitleView 标题选中时的下标并显示相应的子控制器
    func setPageContentScrollView(index: Int) {
        let offsetX = CGFloat(index) * scrollView.frame.size.width
     
        // 2、切换子控制器的时候，执行上个子控制器的 viewWillDisappear 方法
        if previousCVC != nil && previousCVCIndex != index {
            previousCVC?.beginAppearanceTransition(false, animated: false)
        }
        
        // 3、添加子控制器及子控制器的 view 到父控制器以及父控制器 view 中
        if previousCVCIndex != index {
            if index >= childVCs.count {
                return
            }
            let childVC: UIViewController = childVCs[index]
            
            firstAdd = false
            if !(parentVC?.children.contains(childVC))! {
                parentVC?.addChild(childVC)
                firstAdd = true
            }
            
            childVC.beginAppearanceTransition(true, animated: false)
            
            if (firstAdd) {
                scrollView.addSubview(childVC.view)
                childVC.view.frame = CGRect(x: offsetX, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            }
            
            // 1.1、切换子控制器的时候，执行上个子控制器的 viewDidDisappear 方法
            if previousCVC != nil && previousCVCIndex != index {
                previousCVC?.endAppearanceTransition()
            }
            childVC.endAppearanceTransition()
            
            if (firstAdd) {
                childVC.didMove(toParent: parentVC)
            }
            
            // 3.1、记录上个子控制器
            previousCVC = childVC
            
            // 4、处理内容偏移
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: isAnimated)
        }
        // 3.2、记录上个子控制器下标
        previousCVCIndex = index
        // 3.3、重置 _startOffsetX
        startOffsetX = offsetX
        
        // 5、pageContentScrollView:index:
        if delegateScrollView != nil && (delegateScrollView?.responds(to: #selector(delegateScrollView?.pageContentScrollView(pageContentScrollView:index:))))! {
            delegateScrollView?.pageContentScrollView!(pageContentScrollView: self, index: index)
        }
    }
}

// MARK: - 添加子控件
extension SGPageContentScrollView {
    private func setupSubViews() {
        let tempView = UIView()
        self.addSubview(tempView)
        self.addSubview(self.scrollView)
    }
}

// MARK：- UIScrollViewDelegate
extension SGPageContentScrollView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetX = scrollView.contentOffset.x
        scroll = true
        if delegateScrollView != nil && (delegateScrollView?.responds(to: #selector(delegateScrollView?.pageContentScrollViewWillBeginDragging)))! {
            delegateScrollView?.pageContentScrollViewWillBeginDragging!()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scroll = false
        // 1、根据标题下标计算 pageContent 偏移量
        let offsetX: CGFloat = scrollView.contentOffset.x
        // 2、切换子控制器的时候，执行上个子控制器的 viewWillDisappear 方法
        if startOffsetX != offsetX {
            previousCVC?.beginAppearanceTransition(false, animated: false)
        }
        // 3、获取当前显示子控制器的下标
        let index: Int = Int(offsetX / scrollView.frame.size.width)
        // 4、添加子控制器及子控制器的 view 到父控制器以及父控制器 view 中
        let childVC: UIViewController = childVCs[index]
        
        firstAdd = false

        if !(parentVC?.children.contains(childVC))! {
            parentVC?.addChild(childVC)
            firstAdd = true
        }
        
        childVC.beginAppearanceTransition(true, animated: false)
        
        if (firstAdd) {
            scrollView.addSubview(childVC.view)
            childVC.view.frame = CGRect(x: offsetX, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        }
        
        // 2.1、切换子控制器的时候，执行上个子控制器的 viewDidDisappear 方法
        if startOffsetX != offsetX {
            previousCVC?.endAppearanceTransition()
        }
        childVC.endAppearanceTransition()
        
        if (firstAdd) {
            childVC.didMove(toParent: parentVC)
        }
        
        // 4.1、记录上个展示的子控制器、记录当前子控制器偏移量
        previousCVC = childVC
        previousCVCIndex = index
        
        // 5、pageContentScrollView:index:
        if delegateScrollView != nil && (delegateScrollView?.responds(to: #selector(delegateScrollView?.pageContentScrollView(pageContentScrollView:index:))))! {
            delegateScrollView?.pageContentScrollView!(pageContentScrollView: self, index: index)
        }
        
        // 6、pageContentScrollViewDidEndDecelerating
        if delegateScrollView != nil && (delegateScrollView?.responds(to: #selector(delegateScrollView?.pageContentScrollViewDidEndDecelerating)))! {
            delegateScrollView?.pageContentScrollViewDidEndDecelerating!()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isAnimated == true && scroll == false {
            return
        }
        
        // 1、定义获取需要的数据
        var progress: CGFloat = 0.0
        var originalIndex: Int = 0
        var targetIndex: Int = 0
        
        // 2、判断是左滑还是右滑
        let currentOffsetX: CGFloat = scrollView.contentOffset.x
        let scrollViewW: CGFloat = scrollView.bounds.size.width
        if currentOffsetX > startOffsetX { // 左滑
            // 1、计算 progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
            // 2、计算 originalIndex
            originalIndex = Int(currentOffsetX / scrollViewW);
            // 3、计算 targetIndex
            targetIndex = originalIndex + 1;
            if targetIndex >= childVCs.count {
                progress = 1;
                targetIndex = originalIndex;
            }
            // 4、如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1;
                targetIndex = originalIndex;
            }
        } else { // 右滑
            // 1、计算 progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
            // 2、计算 targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW);
            // 3、计算 originalIndex
            originalIndex = targetIndex + 1;
            if originalIndex >= childVCs.count {
                originalIndex = childVCs.count - 1;
            }
        }
        
        // 3、pageContentScrollViewDelegate; 将 progress／sourceIndex／targetIndex 传递给 SGPageTitleView
        if delegateScrollView != nil && (delegateScrollView?.responds(to: #selector(delegateScrollView?.pageContentScrollView(pageContentScrollView:progress:originalIndex:targetIndex:))))! {
            delegateScrollView?.pageContentScrollView!(
                pageContentScrollView: self,
                progress: progress,
                originalIndex: originalIndex,
                targetIndex: targetIndex
            )
        }
    }
}

