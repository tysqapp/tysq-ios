//
//  SQCommentViewController.swift
//  SheQu
//
//  Created by gm on 2019/5/24.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQCommentViewController: SQViewController {
    var textViewH:   CGFloat   = 200
    var iamgesViewH: CGFloat   = 0
    var marginX: CGFloat       = 20
    var contentW: CGFloat      = k_screen_width - 20 * 2
    
    var commentModel =  SQCommentModel()
    var replyCommentModel: SQCommentReplyModel?
    var callBack: ((SQCommentReplyModel) -> ())?
    
    
    lazy var placeHolderLabel: UILabel = {
        let placeHolderLabel = UILabel()
        placeHolderLabel.textColor = k_color_title_gray_blue
        placeHolderLabel.font      = k_font_title
        placeHolderLabel.frame     = CGRect.init(x: marginX + 4, y: 2, width: contentW, height: 30)
        return placeHolderLabel
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        let type = SQWriteArticleInputAccessoryView
            .SQWriteArticleInputAccessoryViewStyle.image
        let inputAccessoryView  = SQWriteArticleInputAccessoryView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: 50), styleArray: [type])
        
        textView.frame = CGRect.init(x: marginX, y: 0, width: contentW, height: textViewH)
        textView.font = k_font_title
        textView.inputAccessoryView = inputAccessoryView
        weak var weakSelf = self
        
        inputAccessoryView.callBack = { type in
            if type == .image {
                weakSelf?.jumpFlieVC()
            }else{
                weakSelf?.view.endEditing(true)
            }
        }
        
        textView.delegate = self
        return textView
    }()
    
    lazy var textViewCell: UITableViewCell = {
        let textViewCell = UITableViewCell()
        textViewCell.addSubview(textView)
        textViewCell.addSubview(placeHolderLabel)
        textViewCell.selectionStyle = .none
        return textViewCell
    }()
    
    lazy var imagesViewCell: UITableViewCell = {
        let imagesViewCell = UITableViewCell()
        imagesViewCell.addSubview(imagesView)
        imagesViewCell.selectionStyle = .none
        return imagesViewCell
    }()
    
    lazy var publishBtn: SQDisableBtn = {
        let publishBtn = SQDisableBtn.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 30), enabled: false)
        publishBtn.setTitle("发布", for: .normal)
        publishBtn.titleLabel?.font = k_font_title
        publishBtn.setBtnBGImage()
        publishBtn.addTarget(self, action: #selector(publishBtnClick), for: .touchUpInside)
        return publishBtn
    }()
    
    lazy var imageLinkArray = [SQAccountFileItemModel]()
    
    
    lazy var imagesView: SQImageCollectionView = {
        let width  = k_scale_iphone6_w * SQImageCollectionView.itemW
        let height = k_scale_iphone6_w * SQImageCollectionView.itemH
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: width, height: height)
        let imagesView = SQImageCollectionView.init(frame: CGRect.init(x: marginX, y: 0, width: contentW, height: 100), collectionViewLayout: layout)
        imagesView.isAddDeleteView = true
        return imagesView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView(frame: view.bounds)
        tableView.separatorStyle = .none
        textView.keyboardDismissMode = .onDrag
        view.addSubview(textView)
        view.addSubview(imagesView)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: publishBtn)
        NotificationCenter.default.addObserver(self, selector: #selector(jumpLoginVC), name: Notification.Name.init(k_noti_jump_loginVC), object: nil)
    }
    
    @objc func jumpLoginVC() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "发评论"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    @objc func publishBtnClick() {
        if textView.text.count < 1 && imagesView.imageUrlArray?.count == 0 {
            return
        }
        
        var at_account_id = commentModel.commentator_id
        var parent_id     = commentModel.id
        var father_id     = commentModel.id
        if (replyCommentModel != nil)  {
            at_account_id = replyCommentModel!.commentator_id
            parent_id     = replyCommentModel!.parent_id
            father_id     = replyCommentModel!.id
        }
        
        var imageIdArray = [NSNumber]()
        for imageLink in imagesView.imageUrlArray ?? [SQCommentModelImageUrlItem]() {
            let linkModel = imageLinkArray.first { (findModel) -> Bool in
                return findModel.getShowImageLink() == imageLink.url
            }
            
            if linkModel != nil {
                imageIdArray.append(NSNumber.init(value: linkModel!.id))
            }
        }
        
        weak var weakSelf = self
        SQHomeNewWorkTool.publishComment(
        commentModel.article_id,
        textView.text,
        at_account_id,
        parent_id,
        father_id,
        image_id: imageIdArray) { (replyModel, statu, errorMessage) in
            if errorMessage != nil {
                return
            }
            
            if weakSelf!.callBack != nil {
                if at_account_id != 0 {
                   weakSelf!.callBack!(replyModel!.sub_comment)
                }else{
                   weakSelf!.callBack!(replyModel!.top_comment)
                }
                
            }
            
            var time = 0.25
            var title = "评论成功"
            if replyModel!.limit_score > 0 {
                title = title + ",扣\(replyModel!.limit_score)积分"
              time  = 2
            }
            
            weakSelf?.showToastMessage(title)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                weakSelf!.navigationController?
                .popViewController(animated: true)
            }
            
        }
        
    }
    
    
    func getCommentBy(_ commentModelTemp: SQCommentModel, _ replayCommentModelTemp: SQCommentReplyModel?,handel:@escaping ((SQCommentReplyModel) ->())) {
        commentModel      = commentModelTemp
        callBack          = handel
        replyCommentModel = replayCommentModelTemp
        if (replyCommentModel != nil) {
            placeHolderLabel.text = "回复\(replyCommentModel!.commentator_name)"
        }else{
            placeHolderLabel.text = "回复\(commentModelTemp.commentator_name)"
        }
    }
    
    func jumpFlieVC() {
        var num = 9 - (imagesView.imageUrlArray?.count ?? 0)
        if num < 0 {///最多选择9张
            num = 0
        }
        
        let vc = SQHomeAccountListVCViewController()
        vc.selectNum = num
        vc.type = SQAccountFileListType.image
        navigationController?.pushViewController(vc, animated: true)
        weak var weakSelf = self
        vc.callBack = { modelArray in
            var tempModelArray: [SQCommentModelImageUrlItem] = weakSelf!.imagesView.imageUrlArray ?? [SQCommentModelImageUrlItem]()
            for model in modelArray {
                if tempModelArray.count > 9 { //最多九张图片
                    break
                }
                
                let item = SQCommentModelImageUrlItem()
                item.original_url = model.getShowImageLink()
                item.url          = model.getShowImageLink()
                tempModelArray.append(item)
                weakSelf!.imageLinkArray.append(model)
            }
            
            weakSelf!.imagesView.imageUrlArray = tempModelArray
            weakSelf!.tableView.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with: .none)
            weakSelf?.textViewDidChange(weakSelf!.textView)
        }
    }
}

extension SQCommentViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            var heightTemp = textViewH
            if textView.contentSize.height > textViewH {
                heightTemp = textView.contentSize.height
            }
            
            textView.setHeight(height: heightTemp)
            return textViewCell
        }
        
        imagesView.setHeight(height: iamgesViewH)
        return imagesViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            var heightTemp = textViewH
            if textView.contentSize.height > textViewH {
                heightTemp = textView.contentSize.height
            }

            return heightTemp
        }
        
        let num  = imageLinkArray.count / 3 + 1
        let rowH = CGFloat(num) * (k_scale_iphone6_w * SQImageCollectionView.itemH + 10)
        iamgesViewH = rowH
        return rowH
    }
}


extension SQCommentViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 || imagesView.imageUrlArray?.count ?? 0 > 0{
            publishBtn.isEnabled = true
            placeHolderLabel.isHidden = true
        }else{
            publishBtn.isEnabled = false
            placeHolderLabel.isHidden = false
        }
        
        publishBtn.setBtnBGImage()
    }
}
