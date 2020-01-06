//
//  SQNotiSettingModel.swift
//  SheQu
//
//  Created by iMac on 2019/9/6.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQNotiSettingModel: NSObject {
    var title = ""


//                       self?.settingFromNet.report_handler_system = model!.report_handler_system
//                       self?.settingFromNet.report_handler_email = model!.report_handler_email
//                       self?.settingFromNet.report_handled_system = model!.report_handled_system

    var subSettingModels = [SQSubNotiSettingModel]()

    static func getNotiSettingModel(settingFromNet: SQNotiSettingFromNetModel) -> [SQNotiSettingModel]{
        var settingModelArrM = [SQNotiSettingModel]()
        
        ///我的文章通过/驳回
        let articleIsPassSysNotiModel = SQSubNotiSettingModel()
        articleIsPassSysNotiModel.subTitle = "系统消息提醒"
        articleIsPassSysNotiModel.isSel = settingFromNet.article_reviewed_system

        
        let articleIsPassMailNotiModel = SQSubNotiSettingModel()
        articleIsPassMailNotiModel.subTitle = "邮件通知"
        articleIsPassMailNotiModel.isSel = settingFromNet.article_reviewed_email

        
        let model1 = SQNotiSettingModel()
        model1.title = "我的文章审核通过/驳回"
        model1.subSettingModels.append(articleIsPassSysNotiModel)
        model1.subSettingModels.append(articleIsPassMailNotiModel)
        
        ///有新文章需要我审核
        let articleToReviewSysNotiModel = SQSubNotiSettingModel()
        articleToReviewSysNotiModel.subTitle = "系统消息提醒"
        articleToReviewSysNotiModel.isSel = settingFromNet.article_review_system

        
        let articleToReviewMailNotiModel = SQSubNotiSettingModel()
        articleToReviewMailNotiModel.subTitle = "邮件通知"
        articleToReviewMailNotiModel.isSel = settingFromNet.article_review_email

        
        let model2 = SQNotiSettingModel()
        model2.title = "有新文章需要我审核"
        model2.subSettingModels.append(articleToReviewSysNotiModel)
        model2.subSettingModels.append(articleToReviewMailNotiModel)
        
        ///我发布的文章有新评论
        let articleNewCommentSysNotiModel = SQSubNotiSettingModel()
        articleNewCommentSysNotiModel.subTitle = "系统消息提醒"
        articleNewCommentSysNotiModel.isSel = settingFromNet.new_comment_system

        
        let model4 = SQNotiSettingModel()
        model4.title = "我发布的文章有新评论"
        model4.subSettingModels.append(articleNewCommentSysNotiModel)
        
        ///我发布的文章有新回复
        let articleNewReplySysNotiModel = SQSubNotiSettingModel()
        articleNewReplySysNotiModel.subTitle = "系统消息提醒"
        articleNewReplySysNotiModel.isSel = settingFromNet.new_reply_system

        
        let model5 = SQNotiSettingModel()

        model5.title = "我发布的评论有新回复"

        model5.subSettingModels.append(articleNewReplySysNotiModel)
        
        let reportHandlerSysNotiModel = SQSubNotiSettingModel()
        reportHandlerSysNotiModel.subTitle = "系统消息提醒"
        reportHandlerSysNotiModel.isSel = settingFromNet.report_handler_system
        
        let reportHandlerMailNotiModel = SQSubNotiSettingModel()
        reportHandlerMailNotiModel.subTitle = "邮件通知"
        reportHandlerMailNotiModel.isSel = settingFromNet.report_handler_email
        
        let model3 = SQNotiSettingModel()
        model3.title = "有新举报需要我处理"
        model3.subSettingModels.append(reportHandlerSysNotiModel)
        model3.subSettingModels.append(reportHandlerMailNotiModel)
        
        let reportHandledSysNotiModel = SQSubNotiSettingModel()
        reportHandledSysNotiModel.subTitle = "系统消息提醒"
        reportHandledSysNotiModel.isSel = settingFromNet.report_handled_system
        
        let model6 = SQNotiSettingModel()
        model6.title = "我提交的举报已处理"
        model6.subSettingModels.append(reportHandledSysNotiModel)

        
        settingModelArrM.append(model1)
        settingModelArrM.append(model2)
        settingModelArrM.append(model3)
        settingModelArrM.append(model6)
        settingModelArrM.append(model4)
        settingModelArrM.append(model5)
        
        
        return settingModelArrM
    }
    
}

class SQSubNotiSettingModel: NSObject{
    var subTitle = ""
    var isSel:Bool = false

}

class SQNotiSettingFromNetModel: SQBaseModel {
    var article_reviewed_system = true
    var article_reviewed_email = true
    var article_review_system = true
    var article_review_email = true
    var new_comment_system = true
    var new_reply_system = true
    var report_handler_system = true
    var report_handler_email = true
    var report_handled_system = true


}
