//
//  SQCloudNetWorkTool.swift
//  SheQu
//
//  Created by gm on 2019/5/27.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQForbinCommentCategoryInfo: SQBaseModel {
    
    ///一级分类id
    var parent_id: Int = 0
    
    ///二级分类id
    var sub_id = [Int]()
    
}

class SQCloudNetWorkTool: NSObject {
    
    ///category_ids
    class func uploadForbinCommentCategoryList(accountID: Int, categoryInfo: [SQForbinCommentCategoryInfo],handler: @escaping((SQBaseModel?,Int32,String?)->())) {
        
        let parameters = [
             "account_id": accountID,
             "category_ids": categoryInfo.toJSON()
            ] as [String : Any]
        
        NetWorkManager.request(path: k_url_comment_blacklist, parameters: parameters, method: .post, needShowTips: false, responseClass: SQBaseModel.self, successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }, failureHandler: { (status, errorMessage) in
            handler(nil,status,errorMessage)
        })
    }
    
    ///获取未读通知数量
    class func getUnreadNotificationsCount(handler: @escaping((SQUnreadNotificationsCountModel?,Int32,String?)->())) {
        let path = k_url_unread_notifications_count
        
       NetWorkManager.request(path: path, parameters: nil, method: .get, needShowTips: false, responseClass: SQUnreadNotificationsCountModel.self, successHandler: { (model, dataDict) in
       
       handler(SQUnreadNotificationsCountModel.deserialize(from: dataDict),0,nil)
       
       }, failureHandler: { (status, errorMessage) in
          handler(nil,status,errorMessage)
       })
        
    }
    
    ///举报详情
    class func getReportDetail(targetID: String, handler: @escaping((SQReportDetailModel?,Int32,String?)->())) {
        let path = k_url_report_detail+targetID
        
        NetWorkManager.request(path: path, parameters: nil, method: .get, needShowTips: false, responseClass: SQReportDetailModel.self, successHandler: { (model, dataDict) in
            
            handler(SQReportDetailModel.deserialize(from: dataDict),0,nil)
            
            }, failureHandler: { (status, errorMessage) in
               handler(nil,status,errorMessage)
            })
    }
    
    
    ///举报文章
    class func reportArticle(articleID: String, reportType: String, note: String, handler: @escaping((SQBaseModel?,Int32,String?)->())) {
        let parameters = [
            "id" : "\(articleID)",
            "report_type" : "\(reportType)",
            "note" : "\(note)"
        ]
        
        NetWorkManager.request(path: k_url_report_article, parameters: parameters, method: .post, needShowTips: true, responseClass: SQBaseModel.self, successHandler: { (model, dataDict) in
                   handler(model,0,nil)
               }, failureHandler: { (status, errorMessage) in
                   handler(nil,status,errorMessage)
               })
    }
    
    ///添加关注/取消关注
    class func attention(attention_id: Int, is_follow: Bool, handler: @escaping((SQBaseModel?,Int32,String?)->())){
        let parameters = [
            "attention_id": (attention_id),
            "is_follow": (is_follow)
            ] as [String : Any]
        
        NetWorkManager.request(path: k_url_attention, parameters: parameters, method: .post, needShowTips: true, responseClass: SQBaseModel.self, successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }, failureHandler: { (status, errorMessage) in
            handler(nil,status,errorMessage)
        })
    }
    
    ///获取粉丝列表
    class func getFansList(account_id: Int, start: Int, size: Int, handler: @escaping((SQFansListModel?,Int32,String?)->())){
        var parameters = [
            "start":"\(start)",
            "size":"\(size)"
            ]
        if account_id != -1 {
            parameters["account_id"] = "\(account_id)"
        }
        
        NetWorkManager.request(path: k_url_fan_list, parameters: parameters, method: .get, needShowTips: false, responseClass: SQFansListModel.self, successHandler: { (model, dataDict) in
            handler(SQFansListModel.deserialize(from: dataDict),0,nil)
        }, failureHandler: { (status, errorMessage) in
            handler(nil,status,errorMessage)
        })
        
    }
    
    ///获取关注列表
    class func getAttentionsList(account_id: Int, start: Int, size: Int, handler: @escaping((SQFansListModel?,Int32,String?)->())){
        var parameters = [
            "start":"\(start)",
            "size":"\(size)"
            ]
        
        if account_id != -1 {
            parameters["account_id"] = "\(account_id)"
        }
        
        NetWorkManager.request(path: k_url_attention_list, parameters: parameters, method: .get, needShowTips: false, responseClass: SQFansListModel.self, successHandler: { (model, dataDict) in
            handler(SQFansListModel.deserialize(from: dataDict),0,nil)
        }, failureHandler: { (status, errorMessage) in
            handler(nil,status,errorMessage)
        })
        
    }
    ///获取用户订阅配置
    class func getNotiConfig(handler: @escaping((SQNotiSettingFromNetModel?,Int32,String?)->())){
        
        NetWorkManager.request(path: k_url_notifigation_get_config, parameters: nil, method: .get, needShowTips: false, responseClass: SQNotiSettingFromNetModel.self, successHandler: { (model, dataDict) in
            handler(SQNotiSettingFromNetModel.deserialize(from: dataDict),0,nil)
        }, failureHandler: { (status, errorMessage) in
            handler(nil,status,errorMessage)
        })
        
    }
    
    ///更新用户订阅配置
    class func updateNotiConfig(notiSetting: SQNotiSettingFromNetModel, handler: @escaping((SQBaseModel?,Int32,String?)->())){
        
        let parameters = [
            "article_reviewed_system": notiSetting.article_reviewed_system,
            "article_reviewed_email": notiSetting.article_reviewed_email,
            "article_review_system": notiSetting.article_review_system,
            "article_review_email": notiSetting.article_review_email,
            "new_comment_system": notiSetting.new_comment_system,
            "new_reply_system": notiSetting.new_reply_system,
            "report_handler_system": notiSetting.report_handler_system,
            "report_handler_email": notiSetting.report_handler_email,
            "report_handled_system": notiSetting.report_handled_system
            ] as [String : Any]
        
        NetWorkManager.request(path: k_url_notifigation_update_config, parameters: parameters, method: .put, needShowTips: false, responseClass: SQBaseModel.self, successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }, failureHandler: { (status, errorMessage) in
            handler(nil,status,errorMessage)
        })
        
    }
    
    ///获取通知列表
    class func getNotificationsList(start: Int, size: Int, handler: @escaping((SQNotificationListModel?,Int32,String?)->())){
        let parameters = [
            "start":"\(start)",
            "size":"\(size)"
        ]
        
        NetWorkManager.request(path: k_url_notification_list, parameters: parameters, method: .get, needShowTips: false, responseClass: SQNotificationListModel.self, successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }, failureHandler: { (status, errorMessage) in
            handler(nil,status,errorMessage)
        })
        
    }
    
    //设置通知已读
    class func setNotiReaded(notify_id: String, handler: @escaping((SQBaseModel?,Int32,String?)->())) {
        let parameters = [
            "notify_id":(notify_id)
        ]
        
        NetWorkManager.request(path: k_url_notification_readed, parameters: parameters, method: .put, needShowTips: false, responseClass: SQBaseModel.self, successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }, failureHandler: { (status, errorMessage) in
            handler(nil,status,errorMessage)
        })
        
    }
    
    ///设置通知全部已读
    class func setNotiAllReaded(handler: @escaping((SQNotiAllreadedModel?,Int32,String?)->())) {
        NetWorkManager.request(path: k_url_notification_allreaded, parameters: nil, method: .put, needShowTips: true, responseClass: SQNotiAllreadedModel.self, successHandler: { (model, dataDict) in
            handler(SQNotiAllreadedModel.deserialize(from: dataDict),0,nil)
        }, failureHandler: { (status, errorMessage) in
            handler(nil,status,errorMessage)
        })
        
    }
    
    ///获取禁止评论列表
    class func getBannedCommentsList(start: Int, size: Int, account: String , handler: @escaping((SQModeratorForbinCommentListModel?,Int32,String?)->())){
        let parameters = [
            "start":"\(start)",
            "size":"\(size)",
            "account":"\(account)"
        ]
        
        NetWorkManager.request(path: k_url_article_comment_blacklistSQForbinCommentListModel, parameters: parameters, method: .get, needShowTips: false, responseClass: SQModeratorForbinCommentListModel.self, successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }, failureHandler: { (status, errorMessage) in
            handler(nil,status,errorMessage)
        })
        
        
    }
    
    
    
    
    ///获取版主未审核列表
    class func getAuditArticle(start: Int, size: Int, handler: @escaping ((SQAuditArticleListModel?,Int32,String?)->())) {
        let parameters = [
            "start":"\(start)",
            "size": "\(size)",
            "status": "\(-1)"
        ]
        
        NetWorkManager.request(path: k_url_review_articles, parameters: parameters, method: .get, needShowTips: false,responseClass: SQAuditArticleListModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    /// 用户提现
    class func withdraw(withdraw_url: String,coin_amount: Int,email: String,captcha_id: String,captcha: String,note: String,_ handler: @escaping ((SQCoinToCashItemModel?,Int32,String?)->())) {
        let parameters = [
            "withdraw_url": withdraw_url,
            "coin_amount":(coin_amount),
            "email": email,
            "captcha_id": captcha_id,
            "captcha": captcha,
            "note": note
            ] as [String : Any]
        
        NetWorkManager.request(path: k_url_account_withdraw, parameters: parameters, method: .post, responseClass: SQCoinToCashItemModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    ///获取金币兑换数据
    class func getBtcRate(_ coin_amount: String, _ handler: @escaping ((SQBtcRateModel?,Int32,String?)->())) {
        let parameters = [
            "coin_amount": coin_amount
        ]
        
        NetWorkManager.request(path: k_url_account_btc_rate, parameters: parameters, method: .get, needShowTips: false, responseClass: SQBtcRateModel.self,  successHandler: { (model, dataDict) in
            handler(SQBtcRateModel.deserialize(from: dataDict),0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    ///获取金币订单列表
    class func getCoinOrderList(start: Int, size: Int, handler: @escaping ((SQCoinOrderListModel?,Int32,String?)->())) {
        let parameters = [
            "start":"\(start)",
            "size": "\(size)"
        ]
        
        NetWorkManager.request(path: k_url_account_coin_order, parameters: parameters, method: .get, needShowTips: false,responseClass: SQCoinOrderListModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    /// 获取个人收藏文章数
    class func getCollectList(
        _ start: Int,
        _ size: Int,
        _ needShowTips: Bool = false,
        _ accountID: Int     = -1,
        _ handler: @escaping ((SQHomeArticlesListModel?,Int32,String?)->())){
        var parameters = [
            "start": "\(start)",
            "size": "\(size)",
        ]
        
        if accountID != -1 {
            parameters["account_id"] = "\(accountID)"
        }
        
        NetWorkManager.request(path: k_url_account_collect, parameters: parameters, method: .get, needShowTips: needShowTips, responseClass: SQHomeArticlesListModel.self,  successHandler: { (model, dataDict) in
            model?.articles_info = model!.collects
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    /// 获取个人文章数
    class func getWZList(
        _ start: Int,
        _ size: Int,
        _ needShowTips: Bool = false,
        _ status: SQArticleAuditStatus,
        _ accountID: Int = -1,
        _ handler: @escaping ((SQWZListModel?,Int32,String?)->())){
        var parameters = [
            "start": "\(start)",
            "size": "\(size)",
            "status": "\(status.rawValue)"
        ]
        
        if accountID != -1 {
            parameters["account_id"] = "\(accountID)"
        }
        
        NetWorkManager.request(path: k_url_account_wz, parameters: parameters, method: .get, needShowTips: needShowTips, responseClass: SQWZListModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    ///  获取个人评论数
    class func getPLList(
        _ start: Int,
        _ size: Int,
        _ needShowTips:Bool = false,
        _ accountID: Int    = -1,
        _ handler: @escaping ((SQAccountComment?,Int32,String?)->())){
        var parameters = [
            "start": "\(start)",
            "size": "\(size)",
        ]
        
        if accountID != -1 {
            parameters["account_id"] = "\(accountID)"
        }
        
        NetWorkManager.request(path: k_url_account_pl, parameters: parameters, method: .get, needShowTips: needShowTips, responseClass: SQAccountComment.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    /// 修改密码
    class func changePassword(_ old_password: String,_ new_password: String,_ handler: @escaping ((SQBaseModel?,Int32,String?)->())) {
        let parameters = [
            "old_password": old_password,
            "new_password": new_password
        ]
        
        NetWorkManager.request(path: k_url_change_pwd, parameters: parameters, method: .put, needShowTips: false, responseClass: SQBaseModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    /// 修改账号名称
    class func changeAccountName(_ value: String,_ type: AccountInfoChangeType,_ handler: @escaping ((SQAccountModel?,Int32,String?)->())) {
        var parameters:Dictionary<String, Any>
        switch type {
        case .account:
            parameters = [
                "icon_id": SQAccountModel.getAccountModel().icon_id,
                "account": value,
                "home_address": SQAccountModel.getAccountModel().home_address,
                "personal_profile": SQAccountModel.getAccountModel().personal_profile,
                "career": SQAccountModel.getAccountModel().career,
                "trade": SQAccountModel.getAccountModel().trade
            ]
            break
        case .home_address:
            parameters = [
                "icon_id": SQAccountModel.getAccountModel().icon_id,
                "account": SQAccountModel.getAccountModel().account,
                "home_address": value,
                "personal_profile": SQAccountModel.getAccountModel().personal_profile,
                "career": SQAccountModel.getAccountModel().career,
                "trade": SQAccountModel.getAccountModel().trade
            ]
            break
        case .personal_profile:
            parameters = [
                "icon_id": SQAccountModel.getAccountModel().icon_id,
                "account": SQAccountModel.getAccountModel().account,
                "home_address": SQAccountModel.getAccountModel().home_address,
                "personal_profile": value,
                "career": SQAccountModel.getAccountModel().career,
                "trade": SQAccountModel.getAccountModel().trade
            ]
            break
        case .career:
            parameters = [
                "icon_id": SQAccountModel.getAccountModel().icon_id,
                "account": SQAccountModel.getAccountModel().account,
                "home_address": SQAccountModel.getAccountModel().home_address,
                "personal_profile": SQAccountModel.getAccountModel().personal_profile,
                "career": value,
                "trade": SQAccountModel.getAccountModel().trade
            ]
            break
        case .trade:
            parameters = [
                "icon_id": SQAccountModel.getAccountModel().icon_id,
                "account": SQAccountModel.getAccountModel().account,
                "home_address": SQAccountModel.getAccountModel().home_address,
                "personal_profile": SQAccountModel.getAccountModel().personal_profile,
                "career": SQAccountModel.getAccountModel().career,
                "trade": value
            ]
            break
        }
        

        NetWorkManager.request(path: k_url_account_info, parameters: parameters, method: .put, needShowTips: false, responseClass: SQAccountModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    /// 修改头像信息
    class func changeHeadUrl(_ headUrlId: Int,_ handler: @escaping ((SQAccountModel?,Int32,String?)->())) {
        let parameters = [
            "icon_id": NSNumber.init(value: headUrlId),
            "account": SQAccountModel.getAccountModel().account,
            "home_address": SQAccountModel.getAccountModel().home_address,
            "personal_profile": SQAccountModel.getAccountModel().personal_profile,
            "career": SQAccountModel.getAccountModel().career,
            "trade": SQAccountModel.getAccountModel().trade
            ] as [String : Any]
        NetWorkManager.request(path: k_url_account_info, parameters: parameters, method: .put, needShowTips: false, responseClass: SQAccountModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
     ///获取云盘列表
    class func getAccountFileList(_ start: Int = -1, _ size: Int = -1,_ handler: @escaping ((SQAccountFileListModel?,Int32,String?)->())) {

        var parameters = [String: String]()
        if start >= 0 {
            parameters["start"] = "\(start)"
        }
        
        parameters["size"] = "\(size)"
        parameters["type"] = "\(1)"
        
        NetWorkManager.request(path: k_url_file_list, parameters: parameters, method: .get, responseClass: SQAccountFileListModel.self,  successHandler: { (model, dataDict) in
            model?.total_number = dataDict!["total_number"] as! Int
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    /// w更新文件名
    class func updateFileName(file_id: Int32,_ fileName: String,_ handler: @escaping ((SQBaseModel?,Int32,String?)->())) {
        let requestStr = "files/\(file_id)"
        let parameters = ["file_name": fileName]
        NetWorkManager.request(path: requestStr, parameters: parameters, method: .put, responseClass: SQBaseModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    ///删除云盘文件
    class func deleteAccountFile(file_id: Int32, _ handler: @escaping ((SQBaseModel?,Int32,String?)->())) {
        let parameters = ["file_id": NSNumber.init(value: file_id)]
        NetWorkManager.request(path: k_url_file_list_delete, parameters: parameters, method: .delete, responseClass: SQBaseModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    ///检查文件是否上传
    class func checkAccountFile(_ hash: String,_ filename: String,_ handler: @escaping ((SQRespondFileModel?,Int32,String?)->())) {
        let parameters = ["hash": hash,"filename": filename]
        NetWorkManager.request(path: k_url_file_info, parameters: parameters, method: .get, needShowTips: false,responseClass: SQRespondFileModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    ///上传视频封面
    class func uploadCoverImage(_ videoId: Int,_ cover_id: Int,_ handler: @escaping ((SQBaseModel?,Int32,String?)->())){
        let parameters = [
            "video_id":NSNumber.init(value: videoId),
            "cover_id":NSNumber.init(value: cover_id)
        ]
        NetWorkManager.request(path: k_url_file_cover, parameters: parameters, method: .post, responseClass: SQBaseModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    ///合并文件 total_chunks 文件被分成块的总数
    class func combineFile(_ hash: String,_ total_chunks: Int, _ handler: @escaping ((SQAccountFileItemModel?,Int32,String?)->())){
        let parameters = [
            "hash": hash,
            "total_chunks": NSNumber.init(value: total_chunks)
            ] as [String : Any]
        
        NetWorkManager.request(path: k_url_file_combine, parameters: parameters, method: .put, needShowTips: false, responseClass: SQAccountFileItemModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    /// 获取用户信息
    class func getAccountInfo(_ accountID: Int = -1,_ handler: @escaping ((SQAccountModel?,Int32,String?)->())) {
        var parameters = [String: String]()
        if accountID != -1 {
            parameters["account_id"] = "\(accountID)"
        }
        
        NetWorkManager.request(path: k_url_account_info, parameters: parameters, method: .get, needShowTips: false,responseClass: SQAccountModel.self,  successHandler: { (model, dataDict) in
            
            if dataDict!.keys.contains("asset"){
                var dict:[String: Any] = dataDict!["account_info"] as! [String : Any]
                dict["asset"] = dataDict!["asset"]
                let accountModel = SQAccountModel.deserialize(from: dict)
                handler(accountModel,0,nil)
            }else{
             handler(model,0,nil)
            }
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    ///获取提现列表
    class func getGoldToCashList(start: Int, size: Int, handler: @escaping ((SQCoinToCashListModel?,Int32,String?)->())) {
        let parameters = [
            "start":"\(start)",
            "size": "\(size)"
        ]
        
        NetWorkManager.request(path: k_url_account_withdraws, parameters: parameters, method: .get, needShowTips: false,responseClass: SQCoinToCashListModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    
    class func getAccountCoinInfo(start: Int, size: Int, handler: @escaping ((SQAccountCoinModel?,Int32,String?)->())) {
        let parameters = [
            "start":"\(start)",
            "size": "\(size)"
        ]
        NetWorkManager.request(path: k_url_account_coin, parameters: parameters, method: .get, needShowTips: false,responseClass: SQAccountCoinModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    class func getAccountIntegral(start: Int, size: Int, handler: @escaping ((SQAccountIntegralModel?,Int32,String?)->())) {
        let parameters = [
            "start":"\(start)",
            "size": "\(size)"
        ]
        NetWorkManager.request(path: k_url_account_integral, parameters: parameters, method: .get, needShowTips: false,responseClass: SQAccountIntegralModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    ///获取积分列表
    class func getAccountIntegralDetail(start: Int, size: Int, handler: @escaping ((SQScoresorderModel?,Int32,String?)->())) {
        let parameters = [
            "start":"\(start)",
            "size": "\(size)"
        ]
        
        NetWorkManager.request(path: k_url_account_integral_order, parameters: parameters, method: .get, needShowTips: false,responseClass: SQScoresorderModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    ///获取邀请好友列表
    class func getAccountInviteFriend(start: Int, size: Int, handler: @escaping ((SQInviteFriendModel?,Int32,String?)->())) {
        let parameters = [
            "start":"\(start)",
            "size": "\(size)"
        ]
        NetWorkManager.request(path: k_url_invite_friend, parameters: parameters, method: .get, needShowTips: false,responseClass: SQInviteFriendModel.self,  successHandler: { (model, dataDict) in
            handler(SQInviteFriendModel.deserialize(from: dataDict),0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    
}

