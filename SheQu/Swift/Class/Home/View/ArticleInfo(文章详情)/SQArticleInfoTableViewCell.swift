//
//  SQArticleInfoTableViewCell.swift
//  SheQu
//
//  Created by gm on 2019/5/21.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    static let auditImageViewW: CGFloat = 77.5
    static let auditImageViewH: CGFloat = 59
}



class SQArticleInfoTableViewCell: UITableViewCell, SQButtomTipsViewDelegate {
    
    
    static let cellID = "SQArticleInfoTableViewCellID"
    static let tipsLabelMaxY: CGFloat = 41
    static let contentViewH: CGFloat  = 106
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font       = SQArticleInfoItemFrame.titleFont
        titleLabel.textColor  = k_color_black
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    lazy var tipsLabel: UILabel = {
        let tipsLabel           = UILabel()
        tipsLabel.font          = UIFont.systemFont(ofSize: 16)
        tipsLabel.textColor     = k_color_black
        tipsLabel.text          = "相关推荐"
        return tipsLabel
    }()
    
    lazy var collectBottomView: SQCollectBottomView = {
        let collectBottomView = SQCollectBottomView()
        return collectBottomView
    }()
    
    lazy var bottomView: SQButtomTipsView = {
        let bottomView = SQButtomTipsView.init(frame: CGRect.zero, delegate: self)
        return bottomView
    }()
    
    lazy var line1View: UIView = {
        let line1View = UIView.init()
        line1View.backgroundColor = k_color_line_light
        return line1View
    }()
    
    lazy var line2View: UIView = {
        let line2View = UIView.init()
        line2View.backgroundColor = k_color_line
        return line2View
    }()
    
    lazy var auditImageView: SQAduitImageView = {
        let auditImageView = SQAduitImageView()
        let auditImageViewX = k_screen_width - SQItemStruct.auditImageViewW - 20
        auditImageView.frame = CGRect.init(
            x: auditImageViewX,
            y: 15,
            width: SQItemStruct.auditImageViewW,
            height: SQItemStruct.auditImageViewH
        )
        auditImageView.image = UIImage.init(named: "sq_audit_waiting")
        return auditImageView
    }()
    
    
    lazy var line3View: UIView = {
        let line3View = UIView()
        line3View.backgroundColor = k_color_line
        return line3View
    }()
    
    ///驳回原因
    lazy var reasonLabel: UILabel = {
        let reasonLabel = UILabel()
        reasonLabel.numberOfLines = 0
        reasonLabel.font          = k_font_title_12
        reasonLabel.textColor     = k_color_title_red_deep
        return reasonLabel
    }()
    
    lazy var needShowTipsLabel = false
    
    lazy var isCollect = false
    
    var deleteCallBack: ((_ isDeleted: Bool,_ articleID: String) -> ())?
    
    var infoModel: SQHomeArticleItemModel? {
        didSet {
            
            let itemFrame    = infoModel!.articleFrame
            line1View.frame  = itemFrame.line1ViewFrame
            titleLabel.frame = itemFrame.titleLabelFrame
            tipsLabel.frame  = itemFrame.tipsLabelFrame
            bottomView.frame = itemFrame.bottomViewFrame
            collectBottomView.frame = itemFrame.bottomViewFrame
            line2View.frame  = itemFrame.line2ViewFrame
            line3View.frame  = itemFrame.line3ViewFrame
            reasonLabel.frame = itemFrame.reasonLabelFrame
            
            if infoModel!.status == SQArticleAuditStatus.draft.rawValue {
                titleLabel.attributedText = infoModel!.title.toDraftAttStr()
            } else if infoModel!.status == SQArticleAuditStatus.hidden.rawValue {
                titleLabel.attributedText = infoModel!.title.toHiddenAttStr()
            } else {
                titleLabel.text = infoModel!.title
            }
            
            ///这里通过判断 是否是要隐藏和显示待审核或者审核文章
            auditImageView.updateImage(infoModel!.status)
            
            bottomView.isHidden = isCollect
            collectBottomView.isHidden = !isCollect
            if isCollect {
                collectBottomView.timeLabel.text = infoModel!.created_time.formatStr("yyyy-MM-dd HH:mm")
                return
            }
            
            bottomView.nikeNameBtn.setTitle(infoModel!.account, for: .normal)
            bottomView.timeLabel.text = infoModel!.created_time.updateTimeToCurrennTime()
            
            bottomView.readBtn.setTitle(
                infoModel!.read_number.getShowString(),
                for: .normal)
            
            bottomView.commentBtn.setTitle(
                infoModel!.comment_number.getShowString(),
                for: .normal)
            
            bottomView.layoutSubviews()
            reasonLabel.text = infoModel!.reason
            if infoModel!.reason.count > 0 {
                reasonLabel.isHidden = false
                line3View.isHidden   = false
            }else{
                reasonLabel.isHidden = true
                line3View.isHidden   = true
            }
            
            weak var weakSelf = self
            infoModel?.articelCallBack = { articelModel in
                weakSelf?.bottomView.readBtn.setTitle(
                    articelModel.read_number.getShowString(),
                    for: .normal)
                weakSelf?.bottomView.commentBtn.setTitle(
                    articelModel.comment_number.getShowString(),
                    for: .normal)
                if articelModel.isDeleted {
                    if ((weakSelf?.deleteCallBack) != nil) {
                        weakSelf!.deleteCallBack!(true, articelModel.article_id)
                    }
                }
            }
        }
    }
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?,_ isCollect: Bool = false) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.isCollect = isCollect
        addSubview(tipsLabel)
        addSubview(line1View)
        addSubview(line2View)
        addSubview(titleLabel)
        addSubview(bottomView)
        addSubview(collectBottomView)
        addSubview(reasonLabel)
        addSubview(line3View)
        addSubview(auditImageView)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttomTipsView(event: Int) {
        
    }
}

class SQCollectBottomView: UIView {
    lazy var collectImageView: UIImageView = {
        let collectImageView = UIImageView()
        collectImageView.image = UIImage.init(named: "sq_cloud_collect")
        collectImageView.setSize(size: CGSize.init(width: 10, height: 12))
        return collectImageView
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font      = UIFont.systemFont(ofSize: 11)
        timeLabel.textColor = k_color_title_gray_blue
        timeLabel.textAlignment = .left
        return timeLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectImageView)
        addSubview(timeLabel)
        addLayout()
    }
    
    func addLayout() {
        collectImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(snp.left)
            maker.width.equalTo(10)
            maker.height.equalTo(12)
            maker.centerY.equalTo(snp.centerY)
        }
        
        timeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(collectImageView.snp.right).offset(5)
            maker.top.equalTo(snp.top)
            maker.bottom.equalTo(snp.bottom)
            maker.right.equalTo(snp.right)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
