//
//  SQHomeInfoDetail.swift
//  SheQu
//
//  Created by gm on 2019/4/29.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit


class SQHomeInfoDetailCell: UITableViewCell, SQButtomTipsViewDelegate {
    var searchType: SQMenuView.MenuType = .all
    var keyword = ""
    private static let titleLabelColor = k_color_black
    private static let titleLabelFont  = k_font_title_16_weight
    
    static let rightImageViewW: CGFloat = 80
    static let rightImageViewH: CGFloat = 114
    //MARK: -----------属性--------------------
    ///lineView
    lazy var lineView: UIView = {
        let lineView = UIView.init(frame: CGRect.init(
            x: 0,
            y: 0,
            width: k_screen_width,
            height: k_line_height))
        lineView.backgroundColor = k_color_line
        return lineView
    }()
    
    ///标题内容
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = SQHomeInfoDetailCell.titleLabelFont
        titleLabel.textColor = SQHomeInfoDetailCell.titleLabelColor
        return titleLabel
    }()
    
    ///标签view
    lazy var marksView: UIView = {
        let marksView = UIView()
        return marksView
    }()
    
    /// 正文内容Label
    lazy var contentLabel: UILabel = {
        let contentLabel           = UILabel()
        contentLabel.numberOfLines = 2
        contentLabel.font          = k_font_title
        contentLabel.textColor     = k_color_title_black
        // contentLabel.backgroundColor = UIColor.brown
        return contentLabel
    }()
    
    lazy var rightBgView: UIView = {
        let rightBgView = UIView()
        rightBgView.setSize(size: CGSize.init(
            width: SQHomeInfoDetailCell.rightImageViewW + 1,
            height: SQHomeInfoDetailCell.rightImageViewH + 1
        ))
        rightBgView.layer.borderWidth = 0.5
        rightBgView.layer.borderColor = k_color_line.cgColor
        rightBgView.layer.cornerRadius = k_corner_radiu
        return rightBgView
    }()
    
    ///右边的imageView
    lazy var rightImageView: SQAniImageView = {
        let rightImageView = SQAniImageView()
        rightImageView.contentMode  = .scaleAspectFit
        rightImageView.setSize(size: CGSize.init(
            width: SQHomeInfoDetailCell.rightImageViewW,
            height: SQHomeInfoDetailCell.rightImageViewH
        ))
        
        rightImageView.addRounded(corners: .allCorners, radii: CGSize.init(width: k_corner_radiu, height: k_corner_radiu), borderWidth: 0.7, borderColor: k_color_line)
        rightImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapBtnClick))
        rightImageView.addGestureRecognizer(tap)
        return rightImageView
    }()
    
    lazy var playImageView: UIImageView = {
        let playImageView         = UIImageView()
        playImageView.image       = UIImage.init(named: "home_play")
        playImageView.contentMode = .center
        playImageView.isHidden    = true
        return playImageView
    }()
    
    lazy var buttomTipsView: SQButtomTipsView = {
        let buttomTipsView = SQButtomTipsView.init(frame: CGRect.zero, delegate: self)
        //buttomTipsView.backgroundColor = UIColor.purple
        return buttomTipsView
    }()
    
    var articleDeleteCallBack: ((_ isDeleted: Bool,_ articleID: String) -> ())?
    var jumpAuthorCallBack: ((_ authorId: Int) -> ())?
    fileprivate var requestUrl = ""

    /// 为了界面的流畅性，将使用frame来计算
    var homeArticlesInfo: SQHomeInfoDetailItemModle? {
        didSet {
            if (homeArticlesInfo == nil) {
                return
            }
            
            let itemFrame    = homeArticlesInfo!.itemFrame
            titleLabel.frame = itemFrame.titleLabelFrame
            titleLabel.attributedText = NSAttributedString(string: homeArticlesInfo!.title)
            if searchType == .article {
                titleLabel.attributedText  = homeArticlesInfo!.title.heightLightKeyWordText(keyword, color: .red)
            }
            
            playImageView.image = nil
            playImageView.removeFromSuperview()
            playImageView.isHidden = true
            ///标签页
            marksView.frame     = itemFrame.marksViewFrame
            for subView in marksView.subviews {
                subView.removeFromSuperview()
            }
            
            let labelY: CGFloat = 10
            let labelH          = marksView.height() - labelY
            var labelX:CGFloat  = 0
            let font11          = UIFont.systemFont(ofSize: 11)
            
            var  labelsArrayTemp = [String]()
            if  searchType == .tag {
                var noKeyword = [String]()
                for label in homeArticlesInfo!.labels {
                    if label.contains(keyword) {
                        labelsArrayTemp.append(label)
                    }else{
                        noKeyword.append(label)
                    }
                }
                
                labelsArrayTemp.append(contentsOf: noKeyword)
            }else {
                labelsArrayTemp = homeArticlesInfo!.labels
            }
            
            for label in labelsArrayTemp {
                let width  = label.calcuateLabSizeWidth(font:font11, maxHeight: labelH) + 20
                let button = UIButton.init(frame: CGRect.init(x: labelX, y: labelY, width: width, height: labelH))
                if button.maxX() > marksView.width() {
                    break
                }
                marksView.addSubview(button)
                button.setTitle(label, for: .normal)
                button.titleLabel?.font = font11
                button.setTitleColor(k_color_title_blue, for: .normal)
                button.layer.borderColor = k_color_normal_blue.cgColor
                button.layer.cornerRadius = labelH * 0.5
                button.layer.borderWidth = 1
                labelX = button.maxX() + 10
                button.isUserInteractionEnabled = false
                if searchType == .tag && button.titleLabel!.text!.contains(keyword) {
                    button.setTitleColor(.red, for: .normal)
                    button.layer.borderColor = UIColor.red.cgColor
                }
            }
            
            
            contentLabel.frame = itemFrame.contentLabelFrame
            contentLabel.text  = homeArticlesInfo!.content
            
            rightImageView.frame   = itemFrame.rightImageViewFrame
            if rightImageView.frame == CGRect.zero {
                rightBgView.frame = CGRect.zero
            }else{
                rightBgView.setSize(size: CGSize.init(
                    width: SQHomeInfoDetailCell.rightImageViewW + 1,
                    height: SQHomeInfoDetailCell.rightImageViewH + 1
                ))
                
                rightBgView.center      = rightImageView.center
            }
            
            
            rightImageView.image   = nil
            let imageLink   = homeArticlesInfo!.cover_url
            requestUrl      = imageLink
            if  homeArticlesInfo!.cover_type == SQHomeInfoDetailItemModle.CoverType.video.rawValue{
                weak var weakSelf = self
                rightImageView.sq_setImage(with: imageLink, imageType: .video, placeholder: k_image_ph_loading) { (image, url, formType, stage, error) in
                    if (error != nil) {
                        return
                    }
                    
                    if (weakSelf?.homeArticlesInfo != nil) {
                        if weakSelf!.homeArticlesInfo!.cover_url == url.absoluteString {
                            weakSelf?.playImageView.frame = weakSelf!.rightImageView.frame
                            weakSelf?.playImageView.isHidden = false
                            weakSelf?.playImageView.image = UIImage.init(named: "home_play")
                            weakSelf?.addSubview(weakSelf!.playImageView)
                        }
                    }
                }
            } else {
                if  homeArticlesInfo!.cover_type == SQHomeInfoDetailItemModle.CoverType.image.rawValue {
                    rightImageView.sq_setImage(
                        with: imageLink,
                        imageType: .image,
                        placeholder: k_image_ph_loading
                    )
                }
            }
            
            
            buttomTipsView.frame  = itemFrame.buttomViewFrame
            buttomTipsView.nikeNameBtn.setTitle(
                homeArticlesInfo!.author_name,
                for: .normal
            )
            
            buttomTipsView.readBtn.setTitle(
                homeArticlesInfo!.read_number.getShowString(),
                for: .normal
            )
            
            buttomTipsView.timeLabel.text = homeArticlesInfo!.created_time.updateTimeToCurrennTime()
            
            
            
            buttomTipsView.commentBtn.setTitle(
                homeArticlesInfo!.comment_number.getShowString(),
                for: .normal)
            
            buttomTipsView.layoutSubviews()
            
            ///这里是处理回掉 是为了事实刷新浏览数和评论数
            weak var weakSelf = self
            homeArticlesInfo!.articelCallBack = { article in
                weakSelf?.buttomTipsView.readBtn.setTitle(
                    article.read_number.getShowString(),
                    for: .normal)
                weakSelf?.buttomTipsView.commentBtn.setTitle(
                    article.comment_number.getShowString(),
                    for: .normal)
                
                if article.isDeleted {
                    if ((weakSelf?.articleDeleteCallBack) != nil) {
                        weakSelf!.articleDeleteCallBack!(true, article.id)
                    }
                }
            }
        }
    }
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(lineView)
        addSubview(titleLabel)
        addSubview(marksView)
        addSubview(contentLabel)
        addSubview(rightBgView)
        addSubview(rightImageView)
        addSubview(buttomTipsView)
    }
    
    @objc func tapBtnClick() {
        
        let oldFrame = super.convert(rightImageView.frame, to: UIApplication.shared.keyWindow)
        let item = SQBrowserImageViewItem.init(blurredImageLink: homeArticlesInfo!.cover_url, originalImageLink: homeArticlesInfo!.original_url, oldFrame: oldFrame, contentModel: .scaleAspectFit)
        SQBrowserImageViewManager
            .showBrowserImageView(browserImageViewItemArray: [item], selIndex: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttomTipsView(event: Int) {
        if (jumpAuthorCallBack != nil) {
            jumpAuthorCallBack!(homeArticlesInfo?.author_id ?? 0)
        }
    }
    

    
}

protocol SQButtomTipsViewDelegate: class {
    func buttomTipsView(event: Int);
}

class SQButtomTipsView:  UIView{
    private static let font = UIFont.systemFont(ofSize: 11)
    private static let titleColor = k_color_title_gray_blue
    private weak var delegate: SQButtomTipsViewDelegate!
    
    lazy var nikeNameBtn: UIButton = {
        let nikeNameBtn = UIButton()
        nikeNameBtn.titleLabel?.font = SQButtomTipsView.font
        nikeNameBtn.setTitleColor(SQButtomTipsView.titleColor, for: .normal)
        nikeNameBtn.addTarget(
            self,
            action: #selector(nikeNameBtnClick),
            for: .touchUpInside
        )
        return nikeNameBtn
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font      = SQButtomTipsView.font
        timeLabel.textColor = SQButtomTipsView.titleColor
        timeLabel.textAlignment = .left
        return timeLabel
    }()
    
    lazy var readBtn: UIButton = {
        let readBtn = UIButton()
        readBtn.titleLabel?.font = SQButtomTipsView.font
        readBtn.setTitleColor(SQButtomTipsView.titleColor, for: .normal)
        readBtn.titleLabel?.textAlignment = .right
        readBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        readBtn.setImage(UIImage.init(named: "home_see"), for: .normal)
        readBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 5)
        return readBtn
    }()
    
    lazy var commentBtn: UIButton = {
        let commentBtn = UIButton()
        commentBtn.setImage(UIImage.init(named: "home_message"), for: .normal)
        commentBtn.titleLabel?.font = SQButtomTipsView.font
        commentBtn.setTitleColor(SQButtomTipsView.titleColor, for: .normal)
        commentBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        commentBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 5)
        return commentBtn
    }()
    
    init(frame: CGRect, delegate: SQButtomTipsViewDelegate) {
        super.init(frame: frame)
        self.delegate = delegate
        addSubview(nikeNameBtn)
        addSubview(timeLabel)
        addSubview(readBtn)
        addSubview(commentBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let itemY: CGFloat = 15
        let itemH: CGFloat = (self.height() - itemY) * 0.5
        let text: String   = nikeNameBtn.titleLabel?.text ?? ""
        let nikeNameBtnW  = text.calcuateLabSizeWidth(font: k_font_title_11, maxHeight: itemH)
        
        nikeNameBtn.frame = CGRect.init(x: 0, y: itemY, width: nikeNameBtnW, height: itemH)
        
        var timeLabelX    = nikeNameBtn.maxX() + 15
        if nikeNameBtn.maxX() == 0 {
            timeLabelX = 0
        }
        
        timeLabel.frame   = CGRect.init(x: timeLabelX, y: itemY, width: 100, height: itemH)
        
        let commentBtnTitle = commentBtn.titleLabel?.text ?? "0"
        let commentBtnW   = commentBtnTitle.calcuateLabSizeWidth(font: SQButtomTipsView.font, maxHeight: itemH) + 20
        let commentBtnX   = self.frame.size.width - commentBtnW
        commentBtn.frame  = CGRect.init(x: commentBtnX, y: itemY, width: commentBtnW, height: itemH)
        
        let readBtnTitle = readBtn.titleLabel?.text ?? "0"
        let readBtnW   = readBtnTitle.calcuateLabSizeWidth(font: SQButtomTipsView.font, maxHeight: itemH) + 20
        let readBtnX      = commentBtnX - readBtnW - 20
        readBtn.frame     = CGRect.init(x: readBtnX, y: itemY, width: readBtnW, height: itemH)
        
    }
    
    @objc func nikeNameBtnClick() {
        self.delegate.buttomTipsView(event: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
