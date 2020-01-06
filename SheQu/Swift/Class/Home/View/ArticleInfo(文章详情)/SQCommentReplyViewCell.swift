//
//  SQCommentReplyView.swift
//  SheQu
//
//  Created by gm on 2019/5/22.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQCommentReplyViewCell: UITableViewCell {
    static let cellID = "SQCommentReplyViewCellID"
    
    lazy var iconImageView: SQAniImageView = {
        let iconImageView = SQAniImageView()
        iconImageView.setSize(size: CGSize.init(width: SQReplyViewFrame.iconWH, height: SQReplyViewFrame.iconWH))
        iconImageView.addRounded(corners: .allCorners, radii: CGSize.init(width: SQReplyViewFrame.iconWH * 0.5, height: SQReplyViewFrame.iconWH * 0.5), borderWidth: 0.7, borderColor: k_color_line)
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showForbidComment))
        iconImageView.addGestureRecognizer(tap)
        return iconImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showForbidComment))
        nameLabel.addGestureRecognizer(tap)
        return nameLabel
    }()
    
    lazy var commentedNameLabel: UILabel = {
        let commentedNameLabel = UILabel()
        commentedNameLabel.font = k_font_title_weight
        commentedNameLabel.textColor = k_color_black
        commentedNameLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showCommentedForbidComment))
        commentedNameLabel.addGestureRecognizer(tap)
        return commentedNameLabel
    }()
    
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.textColor = k_color_title_black
        contentLabel.numberOfLines = 0
        contentLabel.font  = SQCommentFrame.contentLabelFont
        return contentLabel
    }()
    
    lazy var imagesView: SQImageCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: SQCommentFrame.imageWidth, height: SQCommentFrame.imageHeight)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        let imagesView = SQImageCollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        return imagesView
    }()
    
    lazy var bottomView: SQCommentBottomView = {
        let bottomView = SQCommentBottomView()
        return bottomView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line
        return lineView
    }()
    
    ///禁用评论回调
    var fobinCommentCallBack:((_ accountID: Int, _ name: String) -> ())?
    
    private var selAccountID = 0
    
    var replyModel: SQCommentReplyModel? {
        didSet {
            if replyModel == nil {
                return
            }
            
            let itemFrame = replyModel!.replayViewFrame
            iconImageView.frame    = itemFrame.iconImageViewFrame
            nameLabel.frame        = itemFrame.nameLabelFrame
            commentedNameLabel.frame = itemFrame.commentedNameLabelFrame
            contentLabel.frame     = itemFrame.contentLabelFrame
            imagesView.frame       = itemFrame.imagesViewFrame
            bottomView.frame       = itemFrame.bottomViewFrame
            lineView.frame         = itemFrame.lineViewFrame
            
            iconImageView.isUserInteractionEnabled      = true
            nameLabel.isUserInteractionEnabled          = true
            commentedNameLabel.isUserInteractionEnabled = true
            
            nameLabel.attributedText = getNameLabelAttstr()
            commentedNameLabel.text  = replyModel!.commented_name
            iconImageView.sq_setImage(with: replyModel!.icon_url, imageType: .account, placeImageType: .scaleAspectFill,placeholder: k_image_ph_account)
            
            imagesView.imageUrlArray = replyModel!.image_url
            contentLabel.text     = replyModel!.content
            
            bottomView.timeValueLabel.text = replyModel!.time.updateTimeToCurrennTime()
            bottomView.deleteBtn.isHidden  = SQHomeArticleInfoVC.isDeleteComment
        }
    }
    
    func getNameLabelAttstr() -> NSAttributedString {
        let attM = NSMutableAttributedString()
        let attfirst = NSAttributedString.init(string: replyModel!.commentator_name, attributes: [NSAttributedString.Key.font: k_font_title_weight,NSAttributedString.Key.foregroundColor: k_color_black])
        attM.append(attfirst)
        
        if replyModel!.commented_name.count < 1 {
            return attM
        }
        
        let attMid = NSAttributedString.init(string: "  ▶  ", attributes: [NSAttributedString.Key.font : k_font_title_11,NSAttributedString.Key.foregroundColor: k_color_title_gray_blue])
        attM.append(attMid)
        return attM
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(iconImageView)
        addSubview(nameLabel)
        addSubview(commentedNameLabel)
        addSubview(contentLabel)
        addSubview(imagesView)
        addSubview(bottomView)
        backgroundColor = UIColor.clear
        selectionStyle  = .none
    }
    
    
    /// 禁止评论
    @objc func showCommentedForbidComment() {
        selAccountID = replyModel!.commented_id
        if (fobinCommentCallBack != nil) {
           fobinCommentCallBack!(
            replyModel!.commented_id,
            replyModel!.commented_name
            )
        }
    }
    
    /// 禁止评论
    @objc func showForbidComment() {
        selAccountID = replyModel!.commentator_id
        if (fobinCommentCallBack != nil) {
            fobinCommentCallBack!(replyModel!.commentator_id, replyModel!.commentator_name)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
