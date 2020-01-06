//
//  SQAdvertisementView.swift
//  SheQu
//
//  Created by iMac on 2019/10/25.
//  Copyright © 2019 sheQun. All rights reserved.
//
import WebKit
import UIKit

class SQAdvertisementView: UIView {
    static let advertiesViewHeight = (k_screen_width / 375) * 145
    weak var viewController: UIViewController?
    var urlString = "" {
        didSet {
            guard let url = URL(string: urlString) else { return }
            webView.load(URLRequest(url: url))
            addSubview(progressView)
        }
    }
    
    lazy var progressView: UIProgressView = {
        let progressView =
            UIProgressView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: 10))
        progressView.progress = 0
        progressView.trackTintColor = k_color_bg_gray
        progressView.progressTintColor = k_color_normal_blue
        return progressView
    }()
    
    private var webView: WKWebView = {
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
        
        let webView = WKWebView(frame: CGRect.zero, configuration: webConfiguration)
        webView.scrollView.isScrollEnabled = false
        webView.isUserInteractionEnabled = true
        return webView
    }()
    
    init(frame: CGRect, vc: UIViewController?) {
        super.init(frame: frame)
        viewController = vc
        backgroundColor = .white
        webView.frame = CGRect.init(x: 0, y: 0, width: k_screen_width, height: SQAdvertisementView.advertiesViewHeight)
        addSubview(webView)
        webView.uiDelegate = self
        webView.configuration.userContentController
        .removeScriptMessageHandler(forName: WebViewType.comment_js_handel.rawValue)
        webView.configuration.userContentController.add(self, name: WebViewType.comment_js_handel.rawValue)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        
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
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
}


extension SQAdvertisementView: WKScriptMessageHandler, WKUIDelegate {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        guard let bodyDict: Dictionary<String, Any> = message.body as? Dictionary<String, Any>  else {
            return
        }
        
        let typeStr: String = bodyDict["type"] as! String

        
        if typeStr == "linkAction" {
            guard let data = bodyDict["data"] as? Dictionary<String, Any> else { return }
            let isNeedLogin = data["isNeedLogin"] as? Bool ?? false
            ///判断是否需要登录
            if isNeedLogin {
                if let _: String  = UserDefaults.standard.value(forKey: k_ud_user) as? String {

                } else {
                    SQLoginViewController.jumpLoginVC(vc: viewController, state: 2999) { (isLogin) in
                        
                    }
                    
                    return
                }
            }
            
            guard let urlPath = data["navigationLink"] as? String else { return };
            if urlPath == "native://invite" {
                let nativeVC = SQInviteFriendsViewController()
                nativeVC.hidesBottomBarWhenPushed = true
                viewController?.navigationController?.pushViewController(nativeVC, animated: true)
            } else if urlPath.hasPrefix("/api/pages/article/") {
                let article_id = urlPath.replacingOccurrences(of: "/api/pages/article/", with: "")
                let articleVC = SQHomeArticleInfoVC()
                articleVC.article_id = article_id
                viewController?.navigationController?.pushViewController(articleVC, animated: true)
            } else {
                let vc = SQWebViewController()
                vc.hidesBottomBarWhenPushed = true
                ///如果不是全路径
                if urlPath.hasPrefix("/api/") {
                  vc.urlPath = SQHostStruct.getLoaclHost() + urlPath
                }else{
                    vc.urlPath = urlPath
                }
                
                viewController?.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
        
    }
    
    
}


