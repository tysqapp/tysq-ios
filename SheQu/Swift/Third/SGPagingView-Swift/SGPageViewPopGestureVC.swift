//
//  SGPageViewPopGestureVC.swift
//  SGPagingViewSwiftExample
//
//  Created by kingsic on 2018/9/12.
//  Copyright © 2018年 kingsic. All rights reserved.
//

import UIKit

class SGPageViewPopGestureVC: UIViewController {

    private var _delegate: UIGestureRecognizerDelegate? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (navigationController?.viewControllers.count)! > 1 {
            // 记录系统返回手势的代理
            _delegate = navigationController?.interactivePopGestureRecognizer?.delegate
            // 设置系统返回手势的代理为当前控制器
            navigationController?.interactivePopGestureRecognizer?.delegate = self
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 设置系统返回手势的代理为我们刚进入控制器的时候记录的系统的返回手势代理
        navigationController?.interactivePopGestureRecognizer?.delegate = _delegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UIGestureRecognizerDelegate
extension SGPageViewPopGestureVC: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController!.children.count > 1
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController!.children.count > 1
    }
}

