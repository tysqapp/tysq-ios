//
//  SQCheckUpdateNetworkTool.swift
//  SheQu
//
//  Created by gm on 2019/8/23.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQCheckUpdateNetworkTool: NSObject {
    
    ///获取文章标题
    class func getVersion(_ needShowTips: Bool = false,_ handler: @escaping ((SQVersionModel?,Int32,String?)->())){
        let parameters = [
            "time": "\(NSDate().timeIntervalSince1970)"
        ]
        NetWorkManager.request(path: k_url_version, parameters: parameters, method: .get, needShowTips: needShowTips, responseClass: SQVersionModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
//    class func getVersionInfo(handel: @escaping ((SQVersionModel) -> ())) {
//
//        NetWorkManager.shared().downLoad("config/IosUpdate.json") { (data, statu) in
//            if statu {
//                let jsonStr = String.init(data: data, encoding: .utf8)
//                let versionModel = SQVersionModel.deserialize(from: jsonStr)
//                handel(versionModel!)
//            }
//        }
//    }
    
}

class SQVersionModel: SQBaseModel {
    var minimum_support_version = ""
    var latest_version          = ""
    var new_features            = [String]()
    
    func checkNeedUpdate() -> (forceUpdate: Bool, update: Bool) {
        guard let sysDict = Bundle.main.infoDictionary else {
            return (false,false)
        }
        
        let version: String = sysDict["CFBundleShortVersionString"] as! String
        let minState = minimum_support_version.compare(version).rawValue
        let maxState = latest_version.compare(version).rawValue
        var update = false
        if maxState > 0 {
            update = true
        }
        var forceUpdate = false
        if minState > 0 {
            forceUpdate = true
        }
        return (forceUpdate,update)
    }
}
