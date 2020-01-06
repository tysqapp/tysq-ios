//
//  SQSettingModel.swift
//  SheQu
//
//  Created by gm on 2019/5/27.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

struct SQSettingModel {
    var title       = ""
    var imageName   = ""
    var vc          = UIViewController.self
    var isNeedLogin = true
    
    ///获取我的首页的配置model
    static func getMineItemModel(_ is_moderator: Bool) -> [[SQSettingModel]]{
        var settingModelSectionArrM = [[SQSettingModel]]()
        
        var settingModelArrM1 =  [SQSettingModel]()
        let notiModel = SQSettingModel.init(title: "通知", imageName: "sq_cloud_noti", vc: SQNotificationVC.self, isNeedLogin: true)
        settingModelArrM1.append(notiModel)
        
        
        
        let friendModel = SQSettingModel.init(title: "邀请好友", imageName: "sq_cloud_friend", vc: SQFriendVC.self, isNeedLogin: true)
        settingModelArrM1.append(friendModel)
        
        if is_moderator {
            let moderatorModel = SQSettingModel.init(title: "版主中心", imageName: "sq_cloud_moderator", vc: SQModeratorVC.self, isNeedLogin: true)
            settingModelArrM1.append(moderatorModel)
        }
        
        let cloudModel = SQSettingModel.init(title: "我的云盘", imageName: "sq_cloud_cloud", vc: SQCloudManagerVC.self, isNeedLogin: true)
        settingModelArrM1.append(cloudModel)
        
        settingModelSectionArrM.append(settingModelArrM1)
        
        var settingModelArrM2 =  [SQSettingModel]()
        
        let attentionModel = SQSettingModel.init(title: "关注", imageName: "sq_cloud_attentions", vc: SQAttentionListVC.self, isNeedLogin: true)
        settingModelArrM2.append(attentionModel)
        
        let fansModel = SQSettingModel.init(title: "粉丝", imageName: "sq_cloud_fans", vc: SQFansListVC.self, isNeedLogin: true)
        settingModelArrM2.append(fansModel)
        
        settingModelSectionArrM.append(settingModelArrM2)
        
        var settingModelArrM3 =  [SQSettingModel]()
        
        let settingModel = SQSettingModel.init(title: "设置", imageName: "sq_cloud_sz", vc: SQSettingViewController.self, isNeedLogin: true)
        settingModelArrM3.append(settingModel)
        
        let datasource  = SQSettingModel.init(title: "当前访问", imageName: "sq_cloud_datasource", vc: SQCloudDataSourceVC.self, isNeedLogin: false)
        settingModelArrM3.append(datasource)
        
        let aboutUsModel = SQSettingModel.init(title: "关于我们", imageName: "sq_cloud_about", vc: SQAboutUsViewController.self, isNeedLogin: false)
        settingModelArrM3.append(aboutUsModel)
        settingModelSectionArrM.append(settingModelArrM3)
        
        return settingModelSectionArrM
    }
    
    ///获取版本设置的model
    static func getModeratorItemModel() -> [SQSettingModel]{
        var settingModelArrM =  [SQSettingModel]()
        
        let notiModel = SQSettingModel.init(title: "待审核文章", imageName: "", vc: SQCheckPendingArticleVC.self, isNeedLogin: false)
        settingModelArrM.append(notiModel)
        
        let friendModel = SQSettingModel.init(title: "已禁止评论", imageName: "", vc: SQForbinCommentListVC.self, isNeedLogin: false)
        settingModelArrM.append(friendModel)
        
        return settingModelArrM
    }
    
    
}
