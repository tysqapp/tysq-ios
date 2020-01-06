//
//  SQHomeNewWorkTool.swift
//  SheQu
//
//  Created by gm on 2019/4/28.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
import Alamofire

///0：最新，1：最热，2：综合
enum SQArticleSortType: Int {
    ///综合 2
    case synthesize = 0
    ///最新 0
    case newest     = 1
    ///最热 1
    case hottest    = 2
}

///1.公告栏 2.弹窗 3.都显示
enum SQAnnouncemenType: Int {
    ///公告栏
    case announcemen = 1
    ///弹窗
    case popUp = 2
    ///都显示
    case all   = 3
}

class SQHomeNewWorkTool: NSObject {
    
    //MARK: ------------- 首页 ---------------------------
    ///获取公告列表
    class func getAnnouncement(
        _ start:Int = 0,
        _ size:Int = 20,
        _ announcementType: SQAnnouncemenType = SQAnnouncemenType.all,
        _ handler: @escaping ((SQAnnouncementListModel?,Int32,String?)->())){
        let parameters = [
            "size": "\(size)",
            "start": "\(start)",
            "position": "\(announcementType.rawValue)"
        ]
        NetWorkManager.request(path: k_url_announcement, parameters: parameters, responseClass: SQAnnouncementListModel.self, successHandler: { (listModel, dataDict) in
            handler(listModel,0,nil)
        }){ (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    ///获取版主对这篇文章的权限权限
    class func getModeratorArticleRules(_ articleId: String,_ handler: @escaping ((SQModeratorArticleRulesModel?,Int32,String?)->())) {
        let parameters = ["article_id": articleId]
        NetWorkManager.request(path: k_url_permission_judgement, parameters: parameters, responseClass: SQModeratorArticleRulesModel.self, successHandler: { (categoryModel, dataDict) in
            handler(SQModeratorArticleRulesModel.deserialize(from: dataDict),0,nil)
        }){ (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    ///获取分类数据
    class func getCategory(_ handler: @escaping ((SQHomeCategory?,Int32,String?)->())){
        NetWorkManager.request(path: k_url_category, parameters: nil, responseClass: SQHomeCategory.self, successHandler: { (categoryModel, dataDict) in
            handler(categoryModel,0,nil)
        }){ (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    ///获取首页展示文章列表
    class func getArticleList(_ parent_id: Int, _ category_id: Int = -100, _ size: Int = -100,_ start: Int = -100,_ sortType: SQArticleSortType, _ handler: @escaping ((SQHomeInfoDetailListModel?,Int32,String?)->())){
        var parameters = [
            "parent_id": "\(parent_id)"
        ]
        
        if category_id != -100 {
            parameters["category_id"] = "\(category_id)"
        }
        
        if size != -100 {
            parameters["size"] = "\(size)"
        }
        
        if start != -100 {
            parameters["start"] = "\(start)"
        }
        
        parameters["type"] = "\(sortType.rawValue)"
        
        NetWorkManager.request(path: k_url_article_list, parameters: parameters, method: .get, responseClass: SQHomeInfoDetailListModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    /*置顶文章列表
     parent_id    int    一级分类id
     category_id    int    二级分类id
     */
    class func getTopArticleList(parent_id: Int, category_id: Int = -100, handler: @escaping ((SQTopArticleListModel?,Int32,String?)->())) {
        var parameters = [
            "parent_id": "\(parent_id)"
        ]
        
        if category_id != -100 {
            parameters["category_id"] = "\(category_id)"
        }
        
        NetWorkManager.request(path: k_url_top_article_list, parameters: parameters, method: .get, responseClass: SQTopArticleListModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
        
    }
    
    ///打赏文章
    class func rewardArticle(article_id: String, reward_num: Int, handler: @escaping ((SQRewardArticleModel?,Int32,String?)->())) {
        let parameters = ["article_id" : article_id,
                          "reward_num" : reward_num
            ] as [String : Any]
        
        NetWorkManager.request(path: k_url_reward_article, parameters: parameters, method: .post, responseClass: SQRewardArticleModel.self,  successHandler: { (model, dataDict) in
            handler(SQRewardArticleModel.deserialize(from: dataDict),0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
        
        
    }
    
    ///文章 --- 打赏记录
    class func getRewardList(article_id: String, start: Int, size: Int, handler: @escaping ((SQRewardListModel?,Int32,String?)->())) {
        let path = "articles/\(article_id)/reward_records"
        let parameters = ["start" : "\(start)",
                          "size" : "\(size)"
        ]
        
        NetWorkManager.request(path: path, parameters: parameters, method: .get, responseClass: SQRewardListModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
        
    }
    
    
    //MARK: ---------首页搜索------------
    class func homeSearch(type: String, keyword: String, start: Int, size: Int, handler: @escaping ((SQHomeSearchListModel?,Int32,String?)->())) {
        
        let parameters = ["type" : type,
                          "keyword" : keyword,
                          "start" : "\(start)",
                          "size" : "\(size)"
            ]
        
        NetWorkManager.request(path: k_url_home_search, parameters: parameters, method: .get, responseClass: SQHomeSearchListModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
        
    }
    
    
    
    
    
    
    //MARK: ---------写文章------------
    
    ///获取标题数据
    class func getLabel(_ start: Int, _ size: Int,_ name: String = "",_ handler: @escaping ((SQLabelModel?,Int32,String?)->())) {
        var parameters = [
            "size": "\(size)",
            "start": "\(start)"
        ]
        
        if name.count > 0 {
            parameters["name"] = name
        }
        
        NetWorkManager.request(path: k_url_label, parameters: parameters, method: .get, responseClass: SQLabelModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
        
    }
    
    ///获取评论禁止列表
    class func getForbinComment(_ accountID: Int,_ handler: @escaping ((SQForbinCommentListModel?,Int32,String?)->())) {
        let parameters = ["uid": "\(accountID)"]
        NetWorkManager.request(path: k_url_account_forbid_categorys, parameters: parameters, method: .get, responseClass: SQForbinCommentListModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
   
    ///禁止评论
    class func forbinComment(_ accountID: Int,category_ids:[Int],_ handler: @escaping ((SQBaseModel?,Int32,String?)->())){
        let parameters = [
            "account_id": accountID,
            "category_ids":category_ids
            ] as [String : Any]
        
        NetWorkManager.request(path: k_url_article_forbid_comment, parameters: parameters, method: .post, responseClass: SQBaseModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    ///获取版主权限列表
    class func getModeratorsCategorys(_ handler: @escaping ((SQModeratorCategoryListModel?,Int32,String?)->())) {
        NetWorkManager.request(path: k_url_moderator_categorys, parameters: nil, method: .get, responseClass: SQModeratorCategoryListModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    

    /// 审核文章 status 1 文章审核通过 -2 审核驳回
    ///
    /// - Parameters:
    ///   - articleId: 文章id
    ///   - status: 审核状态 1 文章审核通过 -2 审核驳回
    ///   - reason: 驳回原因
    ///   - handler: 审核成功或者失败
    class func reviewArticle(articleId: String, status: Int, reason: String,handler: @escaping ((SQBaseModel?,Int32,String?) ->())){
        let parameters = [
            "article_id": articleId,
            "status": status,
            "reason": reason
            ] as [String : Any]
        
        NetWorkManager.request(path: k_url_article_review, parameters: parameters, method: .put, responseClass: SQBaseModel.self,  successHandler: { (baseModel, dataDict) in
            handler(baseModel,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    ///发布文章
    class func publishArticle(title: String,category_id: UInt64,content: String,images: [NSNumber],videos: [Any], audios: [NSNumber], files: [NSNumber], labels: [NSNumber], isPut: Bool,status: Int,article_id: String,handler: @escaping ((SQBaseScoreModel?,Int32,String?,[String: Any]?)->())){
        var parameters = [
            "title": title,
            "category_id": (category_id)
            ] as [String : Any]
        if content.count > 0 {
            parameters["content"] = content
        }
        if images.count > 0 {
            parameters["images"] = images
        }
        if videos.count > 0 {
            parameters["videos"] = videos
        }
        if audios.count > 0 {
            parameters["audios"] = audios
        }
        if labels.count > 0 {
            parameters["label"] = labels
        }
        if files.count > 0 {
            parameters["files"]  = files
        }
        
        parameters["status"] = (status)
//        if status != -100 {
//            parameters["status"] = NSNumber.init(value: status)
//        }
       
        if isPut {
            parameters["article_id"] = article_id
        }
        
        let method = isPut ? HTTPMethod.put : HTTPMethod.post
        NetWorkManager.request(path: k_url_article_publish, parameters: parameters, method: method, responseClass: SQBaseScoreModel.self,  successHandler: { (baseModel, dataDict) in
            handler(SQBaseScoreModel.deserialize(from: dataDict),0,nil,dataDict)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage,nil)
        }
    }
    
    ///获取云盘列表
    class func getAccountFileList(_ fileType: SQAccountFileListType, _ start: Int = -1, _ size: Int = -1,_ filename: String,_ handler: @escaping ((SQAccountFileListModel?,Int32,String?)->())) {
        var fileTypeTemp = 1
        if fileType == .video {
            fileTypeTemp = 2
        }
        if fileType == .music {
            fileTypeTemp = 3
        }
        if fileType == .others {
            fileTypeTemp = 4
        }
        
        var parameters = ["file_type": "\(fileTypeTemp)"]
        if start >= 0 {
            parameters["start"] = "\(start)"
        }
        
        parameters["size"] = "\(size)"
        
        if filename.count > 0 {
            parameters["filename"] = filename
        }
        
        NetWorkManager.request(path: k_url_file_list, parameters: parameters, method: .get, responseClass: SQAccountFileListModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    ///获取文章标题
    class func getArticleLabel(_ handler: @escaping ((SQHomeLabelinfoModel?,Int32,String?)->())){
        NetWorkManager.request(path: k_url_article_label, parameters: nil, method: .get, needShowTips: false, responseClass: SQHomeLabelinfoModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    
    class func deleteArticle(_ parameters: [String: Any], _ handler: @escaping ((SQBaseModel?,Int32,String?)->())) {
        NetWorkManager.request(path: k_url_article_publish, parameters: parameters, method: .delete,responseClass: SQBaseModel.self, successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    //MARK: ----------展示文章详情 ---------------
    
    ///获取文章详情列表
    class func getArticle(_ article_id: String,_ handler: @escaping ((SQArticleInfoModel?, Int32, String?, [String: Any])->())) {
        let parameters = ["article_id": article_id]
        NetWorkManager.request(path: k_url_article_info, parameters: parameters, method: .get, needShowTips: true, responseClass: SQArticleInfoModel.self,  successHandler: { (model, dataDict) in
            let statu: Int32 = dataDict!["statu_netWork"] as! Int32
            handler(model,statu,nil,dataDict!)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage,[String: Any]())
        }
    }
    
    ///获取编辑文章详情列表
    class func getEditArticle(_ article_id: String,_ handler: @escaping ((SQArticleInfoModel?, Int32, String?, [String: Any])->())) {
        let parameters = ["article_id": article_id]
        NetWorkManager.request(path: k_url_article_edit, parameters: parameters, method: .get, needShowTips: true, responseClass: SQArticleInfoModel.self,  successHandler: { (model, dataDict) in
            let statu: Int32 = dataDict!["statu_netWork"] as! Int32
            handler(model,statu,nil,dataDict!)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage,[String: Any]())
        }
    }
    
    
    ///获取文章详情推荐列表 写死3条
    class func getArticleRecommend(_ article_id: String,_ category_id: Int,_ handler: @escaping ((SQHomeArticlesListModel?,Int32,String?)->())){
        let parameters = [
            "article_id": article_id,
            "category_id": "\(category_id)",
            "size": "\(3)"
        ]
        NetWorkManager.request(path: k_url_article_recommend, parameters: parameters, method: .get, needShowTips: false, responseClass: SQHomeArticlesListModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    ///获取文章评论列表
    class func getCommentList(_ article_id: String,start: Int64,size: Int,handler: @escaping ((SQCommentListModel?,Int32,String?)->())){
        let parameters = [
            "article_id": article_id,
            "start_time": "\(start)",
            "size": "\(size)"
        ]
        
        NetWorkManager.request(path: k_url_comment_list, parameters: parameters, method: .get, needShowTips: false, responseClass: SQCommentListModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    ///获取一级评论展开列表
    class func getFirstCommentList(_ article_id: String,_ comment_id: String,_ size: Int,_ start: Int64,handler: @escaping ((SQCommentListModel?,Int32,String?)->())) {
        
        let parameters = [
            "article_id": article_id,
            "comment_id": comment_id,
            "start_time": "\(start)",
            "size":  "\(size)"
        ]
        
        NetWorkManager.request(path: k_url_subcomment_list, parameters: parameters, method: .get, needShowTips: false, responseClass: SQCommentListModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
   class func deleteComment(_ comment_id: String,handler: @escaping ((SQBaseModel?,Int32,String?)->())) {
        let parameters = ["comment_id":comment_id]
        NetWorkManager.request(path: k_url_delete_comment, parameters: parameters, method: .delete, needShowTips: false, responseClass: SQBaseModel.self,  successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    class func publishComment(_ article_id: String, _ content: String, _ at_account_id: Int, _ parent_id: String, _ father_id: String, image_id: [NSNumber],handler: @escaping ((SQCommentReplyResponse?,Int32,String?)->())) {
        var parameters = [
            "article_id"   : article_id,
            "content"      : content,
            "at_account_id": (at_account_id),
            ] as [String : Any]
        
        if parent_id.count > 0 {
            parameters["parent_id"] = parent_id
        }
        
        if father_id.count > 0 {
            parameters["father_id"] = father_id
        }
        
        if image_id.count > 0 {
            parameters["image_id"] = image_id
        }
        
        NetWorkManager.request(path: k_url_publish_comment, parameters: parameters, method: .post, responseClass: SQCommentReplyResponse.self,  successHandler: { (baseModel, dataDict) in
            handler(SQCommentReplyResponse.deserialize(from: dataDict),0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    class func updateArticleInfoCollectState(article_id: String,collectStatu: Bool,handler: @escaping ((SQBaseModel?,Int32,String?)->())) {
        let statu = collectStatu ? 2 : 1
        let parameters = [
            "article_id": article_id,
            "collect_status": (statu)
            ] as [String : Any]
        
        NetWorkManager.request(path: k_url_article_collect, parameters: parameters, method: .put,responseClass: SQBaseModel.self, successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    class func getAccountJudgement(action: SQAccountScoreJudgementModel.action, resources_id: String = "",article_id: String = "",handler: @escaping ((SQAccountScoreJudgementModel?,Int32,String?)->())) {
        var parameters = [
            "action"        : action.rawValue
            ]
        
        if resources_id.count > 0 {
            parameters["resources_id"] = resources_id
        }
        
        ///5.2 下载文章新增文章id
        if article_id.count > 0 {
            parameters["article_id"] = article_id
        }
        
        NetWorkManager.request(path: k_url_account_judgement, parameters: parameters, responseClass: SQAccountScoreJudgementModel.self, successHandler: { (baseModel, dataDict) in
            handler(SQAccountScoreJudgementModel.deserialize(from: dataDict),0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    //MARK: ------------------处理文章详情显示验证码网络请求-------------------
    
    class func getArticleCaptcha(
        width: Int,
        height: Int,
        handler: @escaping ((SQCaptchaStruct?,Int32,String?)->())) {
        
        let sacle: Int = Int(UIScreen.main.scale)
        let parameters = [
            "captcha_type" : "article",
            "width": "\(width * sacle)",
            "height": "\(height * sacle)"
        ]
        
        NetWorkManager.request(path: k_url_article_captcha, parameters: parameters, responseClass: SQCaptchaStruct.self, successHandler: { (baseModel, dataDict) in
            handler(SQCaptchaStruct.deserialize(from: dataDict),0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
        
    }
    
    class func vfArticleCaptcha(
        captcha: String,
        captcha_id: String,
        handler: @escaping ((SQBaseModel?,Int32,String?)->())) {
        
        let parameters = [
            "captcha": captcha,
            "captcha_id": captcha_id
        ]
        
        NetWorkManager.request(path: k_url_vf_article_captcha, parameters: parameters, method: .post,responseClass: SQBaseModel.self, successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    class func downloadOriginalUrl(
        vedioID: Int,
        articleID: String,
        handler: @escaping ((SQFileWithJudgementModel?,Int32,String?)->())) {
        let api = "original_videos/\(vedioID)/judgement"
        let parameters = ["article_id": articleID]
        NetWorkManager.request(path: api, parameters: parameters, method: .get,responseClass: SQFileWithJudgementModel.self, successHandler: { (model, dataDict) in
            handler(SQFileWithJudgementModel.deserialize(from: dataDict),0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    /// 更改文章隐藏状态 -4 隐藏 1取消隐藏
    class func changeArticleHideState(_ article: String, state: Int,handler: @escaping ((SQBaseModel?,Int32,String?)->())) {
        
        let path = "articles/\(article)/state"
        let parameters = [
            "status":(state)
        ]
        
        NetWorkManager.request(path: path, parameters: parameters, method: .put,responseClass: SQBaseModel.self, successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
    }
    
    ///置顶文章
    class func toppingArticle(article_id: String, top_position: Int, handler: @escaping ((SQBaseModel?,Int32,String?)->())) {
        
        let path = "articles/\(article_id)/top"
        let parameters = [
            "top_position":(top_position)
        ]
        
        NetWorkManager.request(path: path, parameters: parameters, method: .put,responseClass: SQBaseModel.self, successHandler: { (model, dataDict) in
            handler(model,0,nil)
        }) { (statu,errorMessage) in
            handler(nil,statu,errorMessage)
        }
        
    }
    
    //MARK: ------------------处理文章详情显示验证码网络请求结束-------------------
    
}
