//
//  SQCloudCommentTableViewCell.swift
//  SheQu
//
//  Created by gm on 2019/5/27.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQCloudCommentTableViewCell: UITableViewCell {
    static let cellID = "SQCloudCommentTableViewCellCellId"
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        return titleLabel
    }()
    
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.font = SQAccountCommentItemFrame.contentFont
        return contentLabel
    }()
    
    lazy var imagesView: SQImageCollectionView = {
        let width  = SQAccountCommentItemFrame.imageWidth
        let height = SQAccountCommentItemFrame.imageHeight
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: width, height: height)
        let imagesView = SQImageCollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        imagesView.isUserInteractionEnabled = false
        return imagesView
    }()
    
    lazy var repliedView: SQCloudCommentRepliedView = {
        let repliedView = SQCloudCommentRepliedView()
        return repliedView
    }()
    
    
    lazy var timeLabel: UILabel = {
        let timeLabel       = UILabel()
        timeLabel.font      = k_font_title_11
        timeLabel.textColor = k_color_title_gray
        return timeLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line
        return lineView
    }()
    
    var callBack: ((Int) -> ())?
    
    var commentModel: SQAccountCommentInfoModel? {
        didSet {
            if commentModel == nil {
                return
            }
            
            titleLabel.frame = commentModel!.itemFrame.titleLabelFrame
            contentLabel.frame = commentModel!.itemFrame.contentLabelFrame
            imagesView.frame   = commentModel!.itemFrame.imagesViewFrame
            repliedView.frame  = commentModel!.itemFrame.repliedViewFrame
            timeLabel.frame    = commentModel!.itemFrame.timeLabelFrame
            lineView.frame     = commentModel!.itemFrame.lineFrame
            
            let titleStr  = NSMutableAttributedString()
            let titleFont = SQAccountCommentItemFrame.titleFont
            let normalDict = [
                NSAttributedString.Key.font: titleFont,
                NSAttributedString.Key.foregroundColor:k_color_title_gray
            ]
            
            let differeDict = [
                NSAttributedString.Key.font: titleFont,
                NSAttributedString.Key.foregroundColor:UIColor.colorRGB(0xf3842b)
            ]
            
            if commentModel!.commented_name.count > 0 {
                let titleStr1 = NSAttributedString.init(string: "回复了\(commentModel!.commented_name)在", attributes: normalDict)
                let titleStr2 = NSAttributedString.init(string: "《\(commentModel!.title)》", attributes: differeDict)
                let titleStr3 = NSAttributedString.init(string: "的评论", attributes: normalDict)
                titleStr.append(titleStr1)
                titleStr.append(titleStr2)
                titleStr.append(titleStr3)
            }else{
                let titleStr1 = NSAttributedString.init(string: "评论了文章", attributes: normalDict)
                let titleStr2 = NSAttributedString.init(string: "《\(commentModel!.title)》", attributes: differeDict)
                titleStr.append(titleStr1)
                titleStr.append(titleStr2)
            }
            
            titleLabel.attributedText = titleStr
            
            contentLabel.text = commentModel!.content
            
            
            imagesView.imageUrlArray = commentModel!.image_url
            timeLabel.text           = commentModel!.time.formatStr("YYYY-MM-dd HH:mm")
            
            if commentModel!.commented_name.count > 0 {
                repliedView.isHidden = false
                let repliedFont = SQAccountCommentItemFrame.repliedFont
                let repliedNormalDict = [
                    NSAttributedString.Key.font: repliedFont,
                    NSAttributedString.Key.foregroundColor:k_color_title_gray
                ]
                
                let repliedDiffereDict = [
                    NSAttributedString.Key.font: repliedFont,
                    NSAttributedString.Key.foregroundColor:k_color_black
                ]
                
                let attStrM = NSMutableAttributedString()
                
                let att1    = NSAttributedString.init(string: "\(commentModel!.commented_name): ", attributes: repliedNormalDict)
                let att2    = NSAttributedString.init(string: commentModel!.respond_content, attributes: repliedDiffereDict)
                attStrM.append(att1)
                attStrM.append(att2)
                repliedView.layer.cornerRadius = 2
                repliedView.repliedContentLabel.attributedText = attStrM
                repliedView.updateRepliedBtnWidth(commentModel!.commented_name) { [weak self](repliedViewTemp) in
                    if ((self?.callBack) != nil) {
                        self!.callBack!(
                            self!.commentModel!.commented_id
                        )
                    }
                }
            }else{
                 repliedView.isHidden = true
            }
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(titleLabel)
        addSubview(contentLabel)
        addSubview(imagesView)
        addSubview(repliedView)
        addSubview(timeLabel)
        addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SQCloudCommentRepliedView: UIView {
    
    private var repliedBtnW: CGFloat = 60
    
    lazy var repliedContentLabel: UILabel = {
        let repliedContentLabel = UILabel()
        repliedContentLabel.numberOfLines = 0
        
        return repliedContentLabel
    }()
    
    lazy var repliedBtn: UIButton = {
        let repliedBtn = UIButton()
        repliedBtn.backgroundColor = UIColor.clear
        repliedBtn.addTarget(self, action: #selector(repliedBtnClick), for: .touchUpInside)
        return repliedBtn
    }()
    
    lazy var imageView: UIImageView = {
        let imageView  = UIImageView()
        imageView.image = UIImage.init(named: "sq_triangle")
        return imageView
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.colorRGB(0xf6f8fb)
        return bgView
    }()
    
    var callBack:((SQCloudCommentRepliedView) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(bgView)
        addSubview(repliedContentLabel)
        addSubview(repliedBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect.init(x: 40, y: 0, width: 15, height: 7)
        
        let bgViewY  = imageView.frame.maxY
        let bgViewH  = frame.size.height -  bgViewY
        let bgViewW  = frame.size.width
        bgView.frame = CGRect.init(x: 0, y: bgViewY, width: bgViewW, height: bgViewH)
        
        let repliedX: CGFloat = 20
        let repliedY = imageView.frame.maxY + 10
        let repliedH = frame.size.height -  repliedY - 10
        let repliedW = frame.size.width - repliedX * 2
        repliedContentLabel.frame = CGRect.init(x: repliedX, y: repliedY, width: repliedW, height: repliedH)
        
        repliedBtn.frame = CGRect.init(x: repliedX, y: repliedY, width: repliedBtnW, height: 16)
    }
    
    func updateRepliedBtnWidth(_ title: String, handler: @escaping ((SQCloudCommentRepliedView) -> ())) {
        callBack = handler
        repliedBtnW = title.calcuateLabSizeWidth(font: repliedContentLabel.font, maxHeight: 16) + 5
        repliedBtn.setWidth(width: repliedBtnW)
    }
    
    @objc private func repliedBtnClick() {
        if (callBack != nil) {
            callBack!(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
