//
//  SQCommentTableViewCell.swift
//  SheQu
//
//  Created by gm on 2019/5/22.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQCommentTableViewCell: UITableViewCell {
    static var totleComment = 0
    static let cellID = "SQCommentTableViewCellID"
    lazy var line1View: UIView = {
        let line1View = UIView()
        line1View.backgroundColor = k_color_line_light
        return line1View
    }()
    
    lazy var line2View: UIView = {
        let line2View = UIView()
        line2View.backgroundColor = k_color_line
        return line2View
    }()
    
    lazy var totleCommentLabel: UILabel = {
        let totleCommentLabel = UILabel()
        totleCommentLabel.textColor = k_color_black
        totleCommentLabel.font      = k_font_title_16
        return totleCommentLabel
    }()
    
    lazy var iconImageView: SQAniImageView = {
        let iconImageView = SQAniImageView()
        iconImageView.setSize(size: CGSize.init(
            width: SQReplyViewFrame.iconWH,
            height: SQReplyViewFrame.iconWH
        ))
        
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
        nameLabel.textColor = k_color_black
        nameLabel.font      = k_font_title_weight
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(showForbidComment))
        nameLabel.addGestureRecognizer(tap)
        return nameLabel
    }()
    
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.textColor = k_color_title_black
        contentLabel.font      = SQCommentFrame.contentLabelFont
        return contentLabel
    }()
    
    lazy var imagesView: SQImageCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: SQCommentFrame.imageWidth, height: SQCommentFrame.imageHeight)
        layout.minimumInteritemSpacing = 10
        layout.minimumInteritemSpacing = 10
        let imagesView = SQImageCollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        return imagesView
    }()
    
    lazy var bottomView: SQCommentBottomView = {
        let bottomView = SQCommentBottomView()
        return bottomView
    }()
    
    var callBack: ((SQCommentModel,SQCommentReplyModel?)->())?
    
    ///禁用评论回调
    var fobinCommentCallBack:((_ accountID: Int,_ name: String) -> ())?
    
    lazy var replyTableView: UITableView = {
        let replyTableView = UITableView()
        replyTableView.delegate        = self
        replyTableView.dataSource      = self
        replyTableView.isScrollEnabled = false
        replyTableView.register(SQCommentReplyViewCell.self, forCellReuseIdentifier: SQCommentReplyViewCell.cellID)
        replyTableView.backgroundColor = UIColor.colorRGB(0xf6f9fb)
        return replyTableView
    }()
    
    lazy var tableFooterView: UIButton = {
        let tableFooterView = UIButton()
        tableFooterView.setTitle("查看更多回复", for: .normal)
        tableFooterView.setTitleColor(k_color_normal_blue, for: .normal)
        tableFooterView.titleLabel?.font = k_font_title_11
        tableFooterView.titleLabel?.textAlignment = .left
        tableFooterView.contentHorizontalAlignment  = .left
        tableFooterView.titleEdgeInsets = UIEdgeInsets.init(top: -12, left: 48, bottom: 0, right: 0)
        tableFooterView.imageEdgeInsets = UIEdgeInsets.init(top: -12, left: 130, bottom: 0, right: 0)
        tableFooterView.setImage(UIImage.init(named: "sq_ai_cm"), for: .normal)
        tableFooterView.contentVerticalAlignment  = .center
        
        return tableFooterView
    }()
    
    var commentModel: SQCommentModel? {
        didSet {
            if (commentModel == nil) {
                return
            }
            
            let commentFrame        = commentModel!.commentFrame
            iconImageView.frame     = commentFrame.iconImageViewFrame
            line1View.frame         = commentFrame.line1ViewFrame
            totleCommentLabel.frame = commentFrame.totleCommentLabelFrame
            nameLabel.frame         = commentFrame.nameLabelFrame
            contentLabel.frame      = commentFrame.contentLabelFrame
            imagesView.frame        = commentFrame.imagesViewFrame
            bottomView.frame        = commentFrame.bottomViewFrame
            replyTableView.frame    = commentFrame.replyViewFrame
            line2View.frame         = commentFrame.line2ViewFrame
            
            if commentModel!.isFirstView {
                totleCommentLabel.isHidden = false
                NotificationCenter.default.removeObserver(self)
                let totleNum = getCommentNum(commentModel!.totleNum)
                if totleNum != commentModel!.totleNum {
                    commentModel?.totleNum = totleNum
                }
                
                totleCommentLabel.text = "全部评论 • \(commentModel!.totleNum)"
                totleCommentLabel.tag  = commentModel!.totleNum//0x0000000112c0a400 //0000000111316fc0
                NotificationCenter.default.addObserver(self, selector: #selector(totleNumChange(_:)), name: NSNotification.Name(rawValue: k_noti_comment_num), object: nil)
            }else{
                totleCommentLabel.isHidden = true
            }
            
            
            
            iconImageView.isUserInteractionEnabled = true
            nameLabel.isUserInteractionEnabled     = true

            iconImageView.sq_setImage(with: commentModel!.icon_url, imageType: .account, placeImageType: .scaleAspectFill,placeholder: k_image_ph_account)
            
            nameLabel.text    = commentModel!.commentator_name
            contentLabel.text = commentModel!.content
            
            imagesView.imageUrlArray = commentModel!.image_url
            
            bottomView.timeValueLabel.text = commentModel!.time.updateTimeToCurrennTime()
            bottomView.deleteBtn.isHidden  = SQHomeArticleInfoVC.isDeleteComment
            if commentModel!.isHeaderView {//如果是作为tableHeaderView 则不显示子评论
                return
            }
            replyTableView.reloadData()
            
            if commentModel!.reply.count >= 3 {
                tableFooterView.frame = CGRect.init(x: 0, y: 0, width: replyTableView.width(), height: 42)
                replyTableView.tableFooterView = tableFooterView
            }else{
                replyTableView.tableFooterView = UIView()
            }
            
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(line1View)
        addSubview(totleCommentLabel)
        addSubview(iconImageView)
        addSubview(nameLabel)
        addSubview(contentLabel)
        addSubview(imagesView)
        addSubview(bottomView)
        addSubview(replyTableView)
        addSubview(line2View)
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCommentNum(_ commentNum: Int) -> Int {
        if commentNum < SQCommentTableViewCell.totleComment {
            return SQCommentTableViewCell.totleComment
        }else{
            SQCommentTableViewCell.totleComment = commentNum
            return SQCommentTableViewCell.totleComment
        }
    }
    
    /// 禁止评论
    @objc func showForbidComment() {
        if (fobinCommentCallBack != nil) {
            fobinCommentCallBack!(
                commentModel!.commentator_id,
                commentModel!.commentator_name
            )
        }
    }
    
    deinit {
        SQCommentTableViewCell.totleComment =  0
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension SQCommentTableViewCell {
    
    @objc func replyDeleteBtnClick(_ btn: UIButton) {
        weak var weakSelf = self
        let alertView = SQAlertView.sharedInstance
        alertView.showAlertView(title: "你确定要删除这条评论吗?", message: "", cancel: "取消", sure: "确定") { (index,tfStr1,tfStr2) in
            if index == 1 {
                weakSelf!.replyCommentDelete(btn)
            }
        }
    }
    
    func replyCommentDelete(_ btn: UIButton) {
        weak var weakSelf = self
        SQHomeNewWorkTool.deleteComment(btn.titleLabel!.text!) { (resultModel, statu, errorMessage) in
            if (errorMessage != nil) {
                return
            }
            
            var num = 0
            weakSelf?.commentModel?.reply.removeAll(where: { (temp) -> Bool in
                let isDelte: Bool = (temp.id == btn.titleLabel!.text! || temp.father_id == btn.titleLabel!.text!)
                
                if isDelte {
                    num = num + 1
                }
                
                return isDelte
            })
            
            weakSelf?.commentModel?.getCommentFrame()
            let tableView: UITableView = self.superview as! UITableView
            guard let indexPath = tableView.indexPath(for: self) else {
                return
            }
            
            let dict = [
                "comment_num": num,
                "article_id": weakSelf?.commentModel?.article_id ?? ""
                ] as [String : Any]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: k_noti_comment_num), object: dict)
            UIView.performWithoutAnimation {
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
    
    @objc func replyCommentBtnClick(_ btn: UIButton) {
        let model = commentModel?.reply.first(where: { (findModel) -> Bool in
            return findModel.id == btn.titleLabel?.text
        })
        
        if callBack != nil {
            callBack!(commentModel!,model)
        }
    }
    
    @objc func totleNumChange(_ noti: Notification) {
        guard  let dict: [String: Any] = noti.object as? [String : Any]  else {
            return
        }
        
        let totleNum: Int?         = dict["comment_num"] as? Int
        let article_id: String     = dict["article_id"] as! String
        if article_id != commentModel!.article_id {
            return
        }
        let count = totleCommentLabel.tag - (totleNum ?? 0)
        commentModel?.totleNum = count
        totleCommentLabel.text = "全部评论 • \(count)"
        totleCommentLabel.tag  = count
        SQCommentTableViewCell.totleComment = count
    }
}


extension SQCommentTableViewCell: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = commentModel?.reply[indexPath.row]
        let height = model?.replayViewFrame.lineViewFrame.maxY  ?? 0
        return height == 0 ? 0 : height + 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num: Int = commentModel?.reply.count ?? 0
        return num > 3 ? 3 : num
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SQCommentReplyViewCell = tableView.dequeueReusableCell(withIdentifier: SQCommentReplyViewCell.cellID, for: indexPath) as! SQCommentReplyViewCell
        let replyModel  = commentModel!.reply[indexPath.row]
        cell.replyModel = replyModel
        cell.bottomView.deleteBtn.titleLabel?.text = cell.replyModel?.id
            cell.bottomView.replayBtn.titleLabel?.text = cell.replyModel?.id
        cell.bottomView.deleteBtn.addTarget(self, action: #selector(replyDeleteBtnClick(_:)), for: .touchUpInside)
        cell.bottomView.replayBtn.addTarget(self, action: #selector(replyCommentBtnClick(_:)), for: .touchUpInside)
        
        weak var weakSelf = self
        cell.fobinCommentCallBack = { (commentID,name) in
            if ((weakSelf?.fobinCommentCallBack) != nil) {
                weakSelf!.fobinCommentCallBack!(commentID,name)
            }
        }
        return cell
    }
}
