//
//  SQHomeTool.swift
//  SheQu
//
//  Created by gm on 2019/4/26.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQCacheContainerTool: NSObject {
    static var instance: SQCacheContainerTool? = nil
    
    static let shareInstance: SQCacheContainerTool = {
        if SQCacheContainerTool.instance == nil {
            SQCacheContainerTool.instance = SQCacheContainerTool()
        }
        return SQCacheContainerTool.instance!
    }()
    
    lazy var cacheContainerDict: Dictionary<String, Any> = {
        let cacheContainerDict = [String: Any]()
        return cacheContainerDict
    }()
    
    
    /// 根据id存储容器
    ///
    /// - Parameters:
    ///   - levelID: 一级菜单的id为 一级菜单id 二级菜单id为一级菜单+二级菜单
    ///   - vc: 视图容器
    func cacheContainer(byLevelId levelID: String, vc: Any) {
        let realKey = levelID + "containerID"
        cacheContainerDict[realKey] = vc
    }
    
    
    /// 根据id返回容器
    ///
    /// - Parameter levelID: 一级菜单的id为 一级菜单id 二级菜单id为一级菜单+二级菜单
    /// - Returns: 返回容器
    func getContainer(byLevelId levelID: String) -> Any? {
        let realKey = levelID + "containerID"
        if cacheContainerDict.keys.contains(realKey) {
            return cacheContainerDict[realKey]
        }else{
            return nil
        }
    }
    
    
    /// 清楚一级二级菜单栏缓存
    func clearAllcaches() {
        cacheContainerDict.removeAll()
    }
}

