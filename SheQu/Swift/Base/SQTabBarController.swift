//
//  SQTabBarController.swift
//  SheQu
//
//  Created by gm on 2019/4/11.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 0;
        let tabBarItem = UITabBarItem.appearance()
        tabBarItem.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: k_color_black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)],
                                          for: .selected)
        tabBarItem.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.colorRGB(0xcccccc),
             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)],
            for: .normal)
        
        let navBar = UINavigationBar.appearance()
        navBar.barTintColor = k_color_bg
        
        let homeVC  = SQHomeTableViewController()
        let homeNav = SQNavigationController.init(rootViewController: homeVC)
        homeVC.title = "首页"
        homeNav.isNavigationBarHidden = true
        set(vc: homeVC, title: "首页", imageName: "tabbar_home", selImageName: "tabbar_home_sel")
        self.addChild(homeNav)
        WebViewPath.updateHost()
        let promotionVC = SQWebViewController()
        promotionVC.urlPath = WebViewPath.recommend
        promotionVC.navTitle = "推广挣钱"
        let promotionNav = SQNavigationController.init(rootViewController: promotionVC)
        set(vc: promotionVC, title: "推广挣钱", imageName: "tabbar_recomand", selImageName: "tabbar_recomand_sel")
        self.addChild(promotionNav)
        
        let cloudVC  = SQCloudTableViewController()
        cloudVC.title = "我的"
        let cloudNav = SQNavigationController.init(rootViewController: cloudVC)
        set(vc: cloudVC, title: "我的", imageName: "tabbar_mine", selImageName: "tabbar_mine_sel")
        self.addChild(cloudNav)
        // Do any additional setup after loading the view.
    }
    
    func set(vc: UIViewController, title: String,  imageName: String, selImageName: String){
        vc.tabBarItem.title = title
        vc.tabBarItem.image = UIImage.init(named: imageName)?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage.init(named: selImageName)?.withRenderingMode(.alwaysOriginal)
    }
    


}


fileprivate let redDotTag: Int = 666

extension UITabBar {
    // MARK:- 显示小红点
    func showBadgOn(index itemIndex: Int, tabbarItemNums: CGFloat = 3.0) {
        // 移除之前的小红点
        self.removeBadgeOn(index: itemIndex)
        
        // 创建小红点
        let bageView = UIView()
        bageView.tag = itemIndex + redDotTag
        bageView.layer.cornerRadius = 4.5
        bageView.backgroundColor = UIColor.red
        let tabFrame = self.frame
        
        // 确定小红点的位置
        let percentX: CGFloat = (CGFloat(itemIndex) + 0.51) / tabbarItemNums
        let x: CGFloat = CGFloat(ceilf(Float(percentX * tabFrame.size.width)))
        let y: CGFloat = CGFloat(ceilf(Float(0.08 * tabFrame.size.height)))
        bageView.frame = CGRect(x: x, y: y, width: 9, height: 9)
        self.addSubview(bageView)
    }
    
    // MARK:- 隐藏小红点
    func hideBadg(on itemIndex: Int) {
        // 移除小红点
        self.removeBadgeOn(index: itemIndex)
    }
    
    // MARK:- 移除小红点
    fileprivate func removeBadgeOn(index itemIndex: Int) {
        // 按照tag值进行移除
        _ = subviews.map {
            if $0.tag == itemIndex + redDotTag {
                $0.removeFromSuperview()
            }
        }
    }
}



