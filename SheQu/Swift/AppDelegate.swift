//
//  AppDelegate.swift
//  SheQu
//
//  Created by gm on 2019/4/11.
//  Copyright © 2019 SmartInspection. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    class func getAppDelegate() -> AppDelegate {
        let appDele: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
        return appDele
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let cacheLavel1 = UserDefaults.standard.integer(forKey: k_ud_Level1_sel_key)
        if cacheLavel1 == 0 {
            UserDefaults.standard.set(-1, forKey: k_ud_Level1_sel_key)
            UserDefaults.standard.synchronize()
        }
        
        
        initWindowFirst()
        initLogSystem()
        YYWebImageManager_AddCookie.addCookie()
        FirebaseApp.configure()
        
        return true
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        SQMutableDownloadManager.shareInstance.totalCache()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if !LocalServer.shareInstance.isLocalServerOpen {
            ///4.1版本不需要开启本地服务器 所以注释掉
            LocalServer.shareInstance.startLocaLServer()
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        SQMutableDownloadManager.shareInstance.totalCache()
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
}


//初始化tabbar
extension AppDelegate {
    
    final func initWindow(){
        let host = SQHostStruct.getLoaclHost()
        if host.count < 1 {
            let vc = SQDatasourceVC()
            self.window?.rootViewController = vc
        }else{
            SQHostStruct.appendVersion(SQHostStruct.getLoaclHost())
            let vc = SQCheckUpdateVC()
            self.window?.rootViewController = vc
        }
        
    }
    
    class func goToHomeVC() {
        let tab = SQTabBarController()
        AppDelegate.getAppDelegate().window?.rootViewController = tab
    }
        
    /// 初始化tabbar 并且设置为window的rootViewController
    final func initWindowFirst(){
        initWindow()
        window?.makeKeyAndVisible()
    }
    
    final func initLogSystem(){
        //日志文件地址
//        let cachePath = FileManager.default.urls(for: .documentDirectory,
//                                                 in: .userDomainMask)[0]
//        let logURL = cachePath.appendingPathComponent("log.txt")
        //日志对象设置
//        SQLog.log.setup(level: .verbose,
//                        showThreadName: true,
//                        showLevel: true,
//                        showFileNames: true,
//                        showLineNumbers: true,
//                        writeToFile: logURL,
//                        fileLevel: .verbose)
        
    }
}
