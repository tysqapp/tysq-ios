//
//  CommonColor.swift
//  SheQu
//
//  Created by gm on 2019/4/22.
//  Copyright © 2019 sheQun. All rights reserved.
//
import Foundation
import UIKit






//MARK: ------------------网络请求-------------------

///获取图片登录验证码 get
let k_url_captcha = "captcha/image?captcha_type=login"

///获取base64验证码 get
let k_url_base64_captcha = "captcha/base64"

///登录账号 post
let k_url_login   = "account/login"

///账号注册 post
let k_url_register = "account/register"

///重置密码 put
let k_url_reset_pwd = "account/password/reset"

///修改密码 put
let k_url_change_pwd = "account/password"

///获取用户信息 get 更改用户信息 put
let k_url_account_info      = "account/info"

///获取验证码 get
let k_url_email_pin = "captcha/email"

///校验邮箱 get
let k_url_email_verify = "account/email/verify"

///绑定邮箱
let k_url_email_bind = "account/email"

///个人金币明细
let k_url_account_coin = "account/coin"

///个人金币订单
let k_url_account_coin_order = "account/coin_order"

/// 金币比特币汇率
let k_url_account_btc_rate = "account/btc_rate"

///用户提现
let k_url_account_withdraw = "account/withdraw"


///个人提现明细
let k_url_account_withdraws = "account/withdraws"
///个人积分明细
let k_url_account_integral = "account/score_detail"
///个人积分详情
let k_url_account_integral_order = "account/score_order"
///好友邀请界面
let k_url_invite_friend          = "account/invite/friend"
///邀请好友能得多少积分
let k_url_configuration          = "account/configuration"
// ------------------------home 首页-------------------

///获取首页分类 get
let k_url_category     = "article/category"

///获取首页数据 get
let k_url_article_list  = "article/list"

///获取置顶文章列表 get
let k_url_top_article_list = "top_articles"

///打赏文章 post
let k_url_reward_article = "article/reward"
///获取标签列表
let k_url_article_label = "article/label"

///获取附件列表
let k_url_file_list     = "account/file/list"

///删除附件
let k_url_file_list_delete     = "account/file"

///获取标签列表
let k_url_label     = "article/label"

///获取搜索结果
let k_url_home_search = "search"

///发布文章 post 发布文章 put 更新 删除
let k_url_article_publish = "article"

///审核文章 put方法 
let k_url_article_review  = "article/review"

///版主分类权限
let k_url_article_forbid_comment = "account/forbid_comment"

///版主 获取待审核文章列表
let k_url_review_articles =  "account/review_articles"

///禁止评论
let k_url_moderator_categorys = "account/moderator_categorys"

/// 禁止评论列表 模糊查询
let k_url_article_comment_blacklistSQForbinCommentListModel = "account/comment_blacklist"

/// 禁止评论 post
let k_url_comment_blacklist = "account/forbid_comment"

/// 禁止评论列表 禁用用户评论时使用
let k_url_account_forbid_categorys = "account/forbid_categorys"

/// 获取通知列表
let k_url_notification_list = "notify/notifications"

///设置通知已读
let k_url_notification_readed = "notify/read"

///设置通知全部已读
let k_url_notification_allreaded = "notify/state"

///获取用户订阅配置
let k_url_notifigation_get_config = "notify/sub_configs"

///更新用户订阅配置
let k_url_notifigation_update_config = "notify/sub_configs"

///获取关注列表
let k_url_attention_list = "account/attentions"

///获取粉丝列表
let k_url_fan_list = "account/fans"

///添加关注/取消关注
let k_url_attention = "account/attentions"

///举报文章
let k_url_report_article = "reports"

///举报详情
let k_url_report_detail = "reports/"

///获取未读通知数量
let k_url_unread_notifications_count = "notify/unread_count"

/// 收藏文章接口 .put collect_status 收藏状态    非空    1:取消收藏，2:收藏
let k_url_article_collect = "article/collect"

///获取文章详情 get
let k_url_article_info = "article/info"

///获取编辑文章详情
let k_url_article_edit = "article/edit"

///广告栏
let k_url_advertisement = "article/advertisement"

///公告栏
let k_url_announcement  = "article/announcements"

///详情文章推荐
let k_url_article_recommend     = "article/recommend/list"

/// 文章评论
let k_url_comment_list          = "article/comment/list"

/// 一级评论展开
let k_url_subcomment_list       = "article/subcomment/list"


/// 删除评论
let k_url_delete_comment        = "article/comment"

///发布评论
let k_url_publish_comment       = "article/comment"

///获取文章
let k_url_account_judgement     = "account/score/judgement"

///获取文章验证码
let k_url_article_captcha       = "article/captcha"
/// 验证文章验证码
let k_url_vf_article_captcha    = "article/captcha"

/// 获取版本号
let k_url_version               = "config/ios.json"

/// 获取版主权限
let k_url_permission_judgement  = "account/permission/judgement"

//---------------- cloud ----------------

///个人文章数据
let k_url_account_wz            = "account/articles"

///个人收藏文章数
let k_url_account_collect       = "account/collects"

///个人文章数据
let k_url_account_pl            = "account/comments"

/// 查询文件是否上传
let k_url_file_info             = "upload_file/info"

///合并文件
let k_url_file_combine          = "upload_file"

///上传视频封面
let k_url_file_cover            = "account/video_cover"

//MARK: ------------------全局颜色-------------------
/// 全局背景颜色
public let k_color_bg = UIColor.white

/// 全局背景颜色
public let k_color_bg_gray = UIColor.colorRGB(0xf5f5f5)
/// 全局选中背景颜色
public let k_color_sel = UIColor.white

/// 全局选中黑色色
public let k_color_black = UIColor.colorRGB(0x333333)

/// 全局字体颜色 黑色0x333333
public let k_color_title_black = UIColor.colorRGB(0x333333)

/// 字体黄色
public let k_color_title_yellow = UIColor.colorRGB(0xf5b325)

/// 全局字体颜色 浅灰
public let k_color_title_light = k_color_title_gray
/// 全局字体颜色 浅灰2
public let k_color_title_light_gray2 = UIColor.colorRGB(0x666666)
/// 全局字体颜色 浅灰3
public let k_color_title_light_gray_3 = UIColor.colorRGB(0x9fadc2)

/// 全局字体蓝颜色 0x588df2
public let k_color_title_blue  = UIColor.colorRGB(0x588df2)

/// 全局字体baise颜色
public let k_color_white = UIColor.white
/// 全局字体选中颜色
public let k_color_title_sel = UIColor.black

/// 带点蓝色的灰色字体
public let k_color_title_gray_blue = UIColor.colorRGB(0x9fadc2)

/// 字体灰色 0x999999
public let k_color_title_gray = UIColor.colorRGB(0x999999)

/// 字体红色
public let k_color_title_red = UIColor.colorRGB(0xfb605d)
public let k_color_title_red_deep = UIColor.colorRGB(0xff0000)

/// 全局色块颜色
public let k_color_normal_blue = UIColor.colorRGB(0x598cf2)

/// 全局色块颜色
public let k_color_normal_green = UIColor.colorRGB(0x0ab039)

/// 红色色块颜色 #F56C6C
public let k_color_normal_red = UIColor.colorRGB(0xf56c6c)

/// 全局line颜色
public let k_color_line   = UIColor.colorRGB(0xdddddd)

public let k_color_line_light = UIColor.colorRGB(0xf5f5f5)

/// 全局网络请求图片的背景颜色
public let k_color_placeholder = UIColor.colorRGB(0xeeeeee)


//MARK: ---------------全局字体----------------------

///全局字体大小 14
public let k_font_title = UIFont.systemFont(ofSize: 14)
///全局字体大小 15
public let k_font_title_15 = UIFont.systemFont(ofSize: 15)
///全局字体大小 12
public let k_font_title_12 = UIFont.systemFont(ofSize: 12)
public let k_font_title_12_weight = UIFont.systemFont(ofSize: 12, weight: .bold)

///全局字体大小 11
public let k_font_title_11 = UIFont.systemFont(ofSize: 11)
///全局字体大小 11 加粗
public let k_font_title_11_weight = UIFont.systemFont(ofSize: 11, weight: .bold)

///全局字体加粗 14
public let k_font_title_weight = UIFont.systemFont(ofSize: 14, weight: .bold)

///全局字体加粗 16
public let k_font_title_16_weight = UIFont.systemFont(ofSize: 16, weight: .bold)

public let k_font_title_16 = UIFont.systemFont(ofSize: 16)

public let k_font_title_22 = UIFont.systemFont(ofSize: 22)




















//MARK: -------------------布局全局设置---------------

/// 全局的圆角半径 6
public let k_corner_radiu: CGFloat = 6.0
/// 全局的圆角半径 10
public let k_corner_radiu_10: CGFloat = 10.0
/// 全局的圆角半径size 6
public let k_corner_radiu_size: CGSize = CGSize.init(width: k_corner_radiu, height: k_corner_radiu)
/// 全局的圆角半径size 10
public let k_corner_radiu_size_10: CGSize = CGSize.init(width: k_corner_radiu_10, height: k_corner_radiu_10)
///全局的边宽
public let k_corner_boder_width: CGFloat = 1

/// 全局的屏幕宽度
public let k_screen_width   = UIScreen.main.bounds.size.width
public let k_screen_height  = UIScreen.main.bounds.size.height

///相对屏幕比例
public let k_scale_iphone6_w = k_screen_width / 375
public let k_scale_iphone6_h = k_screen_width / 667
///状态栏高度
public let k_status_bar_height: CGFloat = UIApplication.shared.statusBarFrame.size.height

///lineView高度 10
public let k_line_height_big: CGFloat = 10
public let k_line_height: CGFloat     = 0.5

public let k_page_title_view_height: CGFloat = 45

///nav 高度
public let k_nav_height: CGFloat = k_status_bar_height > 20 ? 88 : 64

/// tabbar高度
public let k_tabbar_height: CGFloat = k_status_bar_height > 20 ? 83 : 49

///底部引导栏高度
public let k_bottom_h: CGFloat = k_status_bar_height > 20 ? 34 : 0


///margin
public let k_margin_x: CGFloat = 20







//MARK: ------------------全局UserDfaultKey-------------------



/// 用户名key
public let k_ud_user = "k_ud_user"

/// 一级id
public let k_ud_Level1_sel_key = "k_ud_Level1_sel_key"

/// 二级id
public let k_ud_Level2_sel_key = "k_ud_Level2_sel_key"



//MARK:       --------------全局noti 设置---------------------
/// 评论数量
public let k_noti_comment_num = "k_noti_comment_num"
public let k_noti_jump_loginVC = "k_noti_jump_loginVC"
///
public let k_noti_top_article = "k_noti_top_article"
/// 收藏通知 参数collectState Bool 1表示收藏 0表示未收藏 article_id 文章id
public let k_noti_collect      = "k_noti_collect"

///刷新下载列表通知
public let k_noti_download = Notification.Name.init(rawValue: "k_noti_download")
//MARK:  --------------------全局遮盖图片-----------------------

///个人默认头像遮盖
public let k_image_ph_account = UIImage.init(named: "account_icon")

 ///通知头像
public let k_image_ph_report = UIImage.init(named: "sq_notification_jubao")
///审核头像
public let k_image_ph_review = UIImage.init(named: "sq_cloud_shenhe")
///分类删除头像
public let k_image_ph_category_delete = UIImage.init(named: "sq_notification_category_delete")

///加载中图片
public let k_image_ph_loading = UIImage.init(named: "sq_image_loading")

///加载失败图片

public let k_image_ph_fail = UIImage.init(named: "sq_image_image_error")

///加载视频失败
public let k_image_video_ph_fail = UIImage.init(named: "sq_image_video_error")
//=======
//public let k_image_ph_fail = UIImage.init(named: "sq_image_fail")
//
//>>>>>>> 4.0
