//
//  SQWebViewController.swift
//  SheQu
//
//  Created by gm on 2019/7/22.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
import WebKit

enum WebViewType: String {
    ///html 返回navgation Title
    case comment_js_handel = "comment_js_handel"
    ///关闭html页面 返回原生界面
    case closeAction    = "close_action"
}

struct WebViewPath {
    ///购买积分
    static private(set) var buyIntegral  = "\(SQHostStruct.host.replacingOccurrences(of: SQHostStruct.apiVersion, with: "/api/pages/"))buy_score"
    ///购买金币
    static private(set) var buyGold      = "\(SQHostStruct.host.replacingOccurrences(of: SQHostStruct.apiVersion, with: "/api/pages/"))buy_coin"
    ///积分说明
    static private(set) var integralInfo = "\(SQHostStruct.host.replacingOccurrences(of: SQHostStruct.apiVersion, with: "/api/pages/"))score_coin_guide/0"
    ///等级说明
    static private(set) var gradeInfo    = "\(SQHostStruct.host.replacingOccurrences(of: SQHostStruct.apiVersion, with: "/api/pages/"))score_coin_guide/1"
    ///金币说明
    static private(set) var goldInfo     = "\(SQHostStruct.host.replacingOccurrences(of: SQHostStruct.apiVersion, with: "/api/pages/"))score_coin_guide/2"
    ///用户说明
    static private(set) var agreement    = "\(SQHostStruct.host.replacingOccurrences(of: SQHostStruct.apiVersion, with: "/api/pages/"))agreement"
    ///邀请好友验证码
    static private(set) var inviteFriend = "\(SQHostStruct.host.replacingOccurrences(of: SQHostStruct.apiVersion, with: "/api/pages/"))invite_friend"
    ///邀请好友详情
    static private(set) var invitationInfo          = "\(SQHostStruct.host.replacingOccurrences(of: SQHostStruct.apiVersion, with: ""))/h5/html/invitation.html"
    ///首页广告
    static private(set) var homeADUrl = SQHostStruct.getLoaclHost() + "/html5/activityPage/app_home.html"
    ///文章详情广告
    static private(set) var articleDetailADUrl = SQHostStruct.getLoaclHost() + "/html5/activityPage/app_articleInfo.html"
    ///首页搜索广告
    static private(set) var homeSearchADUrl =  SQHostStruct.getLoaclHost() + "/html5/activityPage/app_search.html"
    ///首页推广挣钱
    static private(set) var recommend = "\(SQHostStruct.host.replacingOccurrences(of: SQHostStruct.apiVersion, with: "/api/pages/"))promotion"
    
    static func updateHost() {
        buyIntegral  = "\(SQHostStruct.host.replacingOccurrences(of: SQHostStruct.apiVersion, with: "/api/pages/"))buy_score"
        
        buyGold      = "\(SQHostStruct.host.replacingOccurrences(of: SQHostStruct.apiVersion, with: "/api/pages/"))buy_coin"
        
        integralInfo = "\(SQHostStruct.host.replacingOccurrences(of: SQHostStruct.apiVersion, with: "/api/pages/"))score_coin_guide/0"
        
        gradeInfo    = "\(SQHostStruct.host.replacingOccurrences(of: SQHostStruct.apiVersion, with: "/api/pages/"))score_coin_guide/1"
        
        goldInfo     = "\(SQHostStruct.host.replacingOccurrences(of: SQHostStruct.apiVersion, with: "/api/pages/"))score_coin_guide/2"
        
        agreement    = "\(SQHostStruct.host.replacingOccurrences(of: SQHostStruct.apiVersion, with: "/api/pages/"))agreement"
        
        inviteFriend = "\(SQHostStruct.host.replacingOccurrences(of: SQHostStruct.apiVersion, with: "/api/pages/"))invite_friend"
        
        invitationInfo          = "\(SQHostStruct.host.replacingOccurrences(of: SQHostStruct.apiVersion, with: ""))/h5/html/invitation.html"
        
        homeADUrl = SQHostStruct.getLoaclHost() + "/html5/activityPage/app_home.html"
        
        articleDetailADUrl = SQHostStruct.getLoaclHost() + "/html5/activityPage/app_articleInfo.html"
        
        homeSearchADUrl =  SQHostStruct.getLoaclHost() + "/html5/activityPage/app_search.html"
        
        recommend = "\(SQHostStruct.host.replacingOccurrences(of: SQHostStruct.apiVersion, with: "/api/pages/"))promotion"
    }
}

private struct SQItemStruct {
    
    ///imageView
    static let imageViewW: CGFloat = 7.5
    static let imageViewH: CGFloat = 3.5
    
    static let menuTableViewH: CGFloat = 50
    static let menuTableViewW: CGFloat = 140
    static let menuTableViewRight: CGFloat = 20
}

class SQWebViewController: SQViewController {
    
    lazy var isFrist = true
    
    var navTitle: String?
    
    static let menuTypeArray = [
        SQMenuView.MenuType.screenshots,
        SQMenuView.MenuType.link,
        SQMenuView.MenuType.refresh
    ]
    
    lazy var closeBtn: UIButton = {
        ///添加左边nav按钮
        let btn = UIButton.init()
        btn.frame = CGRect.init(x: 20, y: k_status_bar_height + 7, width: 30, height: 30)
        btn.setImage(UIImage.init(named: "home_ac_close_sel"), for: .normal)
        btn.imageView?.contentMode = .left
        btn.addTarget(self, action: #selector(closeNav), for: .touchUpInside)
        return btn
    }()
    
    lazy var menuView: SQMenuView = {
        
        let typeArray = SQWebViewController.menuTypeArray
        
        weak var weakSelf = self
        let tempFrameX = k_screen_width - SQItemStruct.menuTableViewW - SQItemStruct.menuTableViewRight
        let menuTableViewH = SQItemStruct.menuTableViewH * CGFloat(typeArray.count)
        let tempFrameH = SQItemStruct.imageViewH + menuTableViewH
        let tempFrame = CGRect.init(x: tempFrameX, y: k_nav_height - SQItemStruct.imageViewH, width: SQItemStruct.menuTableViewW, height: tempFrameH)
        let nemuView = SQMenuView.init(frame: tempFrame, typeArray: typeArray, trianglePosition: .right, handel: { (type, title) in
            switch type {
            case .screenshots:
                weakSelf?.screenshots()
            case .link:
                weakSelf?.jumpSafari()
            case .refresh:
                weakSelf?.refreshWebView()
            default:
                break
           }
        })
        
        return nemuView
    }()
    
    lazy var wkWebView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        ///注入js方法 h5通过这个判断是不是内置html
        let scriptStr = "function openIniOS(){}"
        let userScript = WKUserScript.init(
            source: scriptStr,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: true
        )
        webConfiguration.userContentController
            .addUserScript(userScript)
        
        let cookies = HTTPCookieStorage.shared.cookies
        if (cookies != nil) {
            for cookie in cookies! {
                if cookie.name == "_session_" {
                    let valueStr = "document.cookie = '_session_=\(cookie.value)'"
                    
                    let cookieScript = WKUserScript.init(
                        source: valueStr,
                        injectionTime: .atDocumentStart,
                        forMainFrameOnly: true
                    )
                webConfiguration.userContentController.addUserScript(cookieScript)
                    break
                }
            }
        }
        
//        let preferences = WKPreferences();
//        preferences.javaScriptCanOpenWindowsAutomatically = true;
//        preferences.minimumFontSize = 40.0;
//        webConfiguration.preferences = preferences;
        let wkWebView = WKWebView.init(frame: view.bounds, configuration: webConfiguration)
        wkWebView.uiDelegate = self
        wkWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        return wkWebView
    }()
    
    lazy var progressView: UIProgressView = {
        let progressView =
            UIProgressView.init(frame: CGRect.init(x: 0, y: k_nav_height, width: k_screen_width, height: 10))
        progressView.progress = 0
        progressView.trackTintColor = k_color_bg_gray
        progressView.progressTintColor = k_color_normal_blue
        return progressView
    }()
    
    var action = SQAccountScoreJudgementModel.action.comment_article
    
    var isReadSheQuMessage = false
    
    var urlPath: String? {
        didSet {
            if (urlPath == nil) {
                return
            }
            
            guard let requestUrl = URL.init(string: urlPath!) else {
                return
            }
            
            let request = URLRequest.init(url: requestUrl, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
            wkWebView.load(request)
            view.addSubview(wkWebView)
            view.addSubview(progressView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRightNav()
    }
    
    func addRightNav() {
        let  btn = UIButton()
        btn.setSize(size: CGSize.init(width: 100, height: 30))
        btn.contentHorizontalAlignment = .right
        btn.setImage(
            UIImage.init(named: "sq_web_open_menu"),
            for: .normal
        )
        
        btn.addTarget(
            self,
            action: #selector(showMenu),
            for: .touchUpInside
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
    }
    
    @objc func showMenu() {
        if !menuView.isShowing {
          menuView.showMenuView()
        }else{
            menuView.hiddenMenuView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if !isFrist {
            return
        }
        isFrist = false
        
        if isReadSheQuMessage {
             UIApplication.shared.keyWindow?.addSubview(closeBtn)
            return
        }
        
        if action == SQAccountScoreJudgementModel.action.read_article {
            var vcArray = navigationController?.children
            if (vcArray != nil) {
                vcArray!.remove(at: vcArray!.count - 2)
                navigationController?
                    .setViewControllers(vcArray!, animated: true)
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let value: CGFloat = change![NSKeyValueChangeKey.newKey] as! CGFloat
        let progress: Float = Float(value)
        progressView.setProgress( progress, animated: true)
        if progress >= 1 {
            UIView.animate(withDuration: TimeInterval.init(0.25)) {
                self.progressView.alpha = 0
            }
        }
    }
   
    @objc func closeNav() {
        dismiss(animated: true, completion: nil)
    }
    
    /// 这里需要移除才能够
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = navTitle
        wkWebView.configuration.userContentController.add(self, name: WebViewType.comment_js_handel.rawValue)
//        wkWebView.configuration.userContentController.add(self, name: WebViewType.closeAction.rawValue)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        wkWebView.configuration.userContentController
        .removeScriptMessageHandler(forName: WebViewType.comment_js_handel.rawValue)
//        wkWebView.configuration.userContentController
//            .removeScriptMessageHandler(forName: WebViewType.closeAction.rawValue)
        closeBtn.removeFromSuperview()
        menuView.hiddenMenuView()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        wkWebView.frame = view.bounds
    }
    
    deinit {
        ///5.2 处理 wkWebView没有创建导致崩溃的问题
        if urlPath?.count ?? 0 > 0 {
          wkWebView.removeObserver(self, forKeyPath: "estimatedProgress")
        }
    }
    
    
    func screenshots() {
        let image = wkWebView.getImage()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func image(image: UIImage, didFinishSavingWithError: NSError?,contextInfo: AnyObject)
    {
        if didFinishSavingWithError != nil
        {
            SQToastTool.showToastMessage("保存截图失败")
            return
        }
        
        SQToastTool.showToastMessage("保存截图成功")
        menuView.hiddenMenuView()
    }
    
    func jumpSafari() {
        var shareUrl = wkWebView.url
        if shareUrl == nil {
            shareUrl = URL.init(string: urlPath ?? "")
        }

        UIApplication.shared.open(shareUrl!, options: [:], completionHandler: nil)
        menuView.hiddenMenuView()
    }
    
    func refreshWebView() {
        progressView.progress = 0
        progressView.alpha = 1
        menuView.hiddenMenuView()
        if wkWebView.url != nil {
            wkWebView.reloadFromOrigin()
            return
        }
        
        guard let requestUrl = URL.init(string: urlPath!) else {
            return
        }
        
        let request = URLRequest.init(url: requestUrl, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        wkWebView.load(request)
        
    }
}


extension SQWebViewController:  WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
}

extension SQWebViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertViewControll = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        let actionCancel = UIAlertAction.init(title: "关闭", style: .default) { (alert) in
            
        }
        alertViewControll.addAction(actionCancel)
        present(alertViewControll, animated: true, completion: nil)
        completionHandler()
    }
    
}

extension SQWebViewController: WKScriptMessageHandler {
    
    ///处理html,json回调
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let bodyDict: Dictionary<String, Any> = message.body as? Dictionary<String, Any>  else {
            return
        }
        
        let typeStr: String = bodyDict["type"] as! String
        if  typeStr == "title" {
            navigationTitle(dataDict: bodyDict["data"] as! [String : Any])
        }
        
        if  typeStr == "close_action" {
            navigationController?.popViewController(animated: true)
        }
        
        if typeStr == "linkAction" {
            guard let data = bodyDict["data"] as? Dictionary<String, Any> else { return }
            let isNeedLogin = data["isNeedLogin"] as? Bool ?? false
            ///判断是否需要登录
            if isNeedLogin {
                if let _: String  = UserDefaults.standard.value(forKey: k_ud_user) as? String {

                } else {
                    SQLoginViewController.jumpLoginVC(vc: self, state: 2999) { (isLogin) in
                        
                    }
                    
                    return
                }
            }
            
            guard let urlPath = data["navigationLink"] as? String else { return };
            if urlPath == "native://invite" {
                let nativeVC = SQFriendVC()
                nativeVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(nativeVC, animated: true)
            } else if urlPath.hasPrefix("/api/pages/article/") {
                let article_id = urlPath.replacingOccurrences(of: "/api/pages/article/", with: "")
                let articleVC = SQHomeArticleInfoVC()
                articleVC.article_id = article_id
                navigationController?.pushViewController(articleVC, animated: true)
            } else {
                let vc = SQWebViewController()
                vc.hidesBottomBarWhenPushed = true
                ///如果不是全路径
                if urlPath.hasPrefix("/api/") {
                  vc.urlPath = SQHostStruct.getLoaclHost() + urlPath
                }else{
                    vc.urlPath = urlPath
                }
                
                navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
    }
    
    func navigationTitle(dataDict: [String: Any?]) {
        navTitle = dataDict["navigationTitle"] as? String;
        navigationItem.title = navTitle
    }
}
