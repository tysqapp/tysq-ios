//
//  SQHomeAccountListVCViewController.swift
//  SheQu
//
//  Created by gm on 2019/5/13.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
import MJRefresh

class SQHomeAccountListVCViewController: SQViewController {
    static let cellID = "SQHomeAccountListVCViewControllerCellId"
    lazy var netModelArray = [SQAccountFileItemModel]()
    lazy var selModelArray = [SQAccountFileItemModel]()
    lazy var start = 0
    lazy var fileSize  = 21
    lazy var titleStr = ""
    lazy var placeHolderStr = ""
    lazy var selectNum = 100000000
    
    lazy var itemSize =  CGSize.init(width: k_screen_width / 3, height: 145)
    
    var callBack: (([SQAccountFileItemModel]) -> ())?
    
    var type: SQAccountFileListType? {
        didSet {
            if type == nil {
                return
            }
            var title = ""
            switch type! {
            case .image:
                title = "云盘图片选择"
                placeHolderStr = "图片"
            case .video:
                title = "云盘视频选择"
                placeHolderStr = "视频"
            case .music:
                title = "云盘音乐选择"
                placeHolderStr = "音乐"
            case .others:
                title = "云盘附件选择"
                placeHolderStr = "附件"
            }
            
           titleStr  = title
           navigationItem.title = title
           requestNetWork()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layoutTemp = UICollectionViewFlowLayout()
        let itemWidth: CGFloat  = k_screen_width / 3
        layoutTemp.itemSize = itemSize
        layoutTemp.minimumLineSpacing = 0
        layoutTemp.minimumInteritemSpacing = 0
        layoutTemp.scrollDirection = .vertical
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: bottomView.top()), collectionViewLayout: layoutTemp)
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.register(SQAccountListViewCollectionViewCell.self, forCellWithReuseIdentifier: SQHomeAccountListVCViewController.cellID)
        collectionView.register(SQEmptyCollectionViewCell.self, forCellWithReuseIdentifier: SQEmptyCollectionViewCell.cellID)
        collectionView.backgroundColor = k_color_bg
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    lazy var bottomView: SQCloudBottomView = {
        let bottomViewH = SQCloudBottomView.cloudBottomViewH
        let bottomViewY = k_screen_height - k_bottom_h - bottomViewH
        let frame = CGRect.init(
            x: 0,
            y: bottomViewY,
            width: k_screen_width,
            height: bottomViewH
        )
        
        let bottomView = SQCloudBottomView.init(frame: frame)
        bottomView.sureBtn.addTarget(
            self,
            action: #selector(sureBtnClick),
            for: .touchUpInside
        )
        
        return bottomView
    }()
    
    lazy var searchTF: UITextField = {
        let searchTF = UITextField()
        let leftImageView = UIButton()
        leftImageView.isUserInteractionEnabled = false
        leftImageView.setImage(UIImage.init(named: "sq_search"), for: .normal)
        leftImageView.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        leftImageView.setSize(size: CGSize.init(width: 30, height: 30))
        let leftV = UIView(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        leftV.addSubview(leftImageView)
        
        searchTF.leftView        = leftV
        searchTF.leftViewMode    = .always
        searchTF.clearButtonMode = .always
        searchTF.backgroundColor = k_color_line_light
        searchTF.layer.borderWidth = 0.7
        searchTF.layer.borderColor = k_color_line.cgColor
        searchTF.layer.cornerRadius = k_corner_radiu
        searchTF.frame = CGRect.init(x: 0, y: 0, width: k_screen_width - 100, height: 30)
        searchTF.addTarget(self, action: #selector(searchTFChange), for: .editingChanged)
        searchTF.returnKeyType = .done
        searchTF.delegate      = self
        return searchTF
    }()
    
    lazy var rightNavBtn: UIButton = {
        let rightNavBtn = UIButton()
        rightNavBtn.setTitle("取消", for: .selected)
        rightNavBtn.titleLabel?.font = k_font_title
        rightNavBtn.setTitleColor(k_color_title_blue, for: .selected)
        rightNavBtn.setImage(UIImage.init(named: "sq_search"), for: .normal)
        rightNavBtn.setSize(size: CGSize.init(width: 30, height: 30))
        rightNavBtn.contentHorizontalAlignment = .right
        rightNavBtn.addTarget(self, action: #selector(rightNavBtnClick), for: .touchUpInside)
        return rightNavBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bottomView)
        view.addSubview(collectionView)
        
        collectionView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(refresh))
        collectionView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(addMore))
        collectionView.mj_header?.beginRefreshing()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightNavBtn)
    }
    
    @objc func refresh(){
        start       = 0
        requestNetWork(true)
    }
    
    @objc override func addMore(){
        start = netModelArray.count
        requestNetWork()
    }
    
    @objc func rightNavBtnClick() {
        rightNavBtn.isSelected = !rightNavBtn.isSelected
        if rightNavBtn.isSelected {
            rightNavBtn.setImage(UIImage.init(named: ""), for: .normal)
            rightNavBtn.setImage(UIImage.init(named: ""), for: .selected)
            navigationItem.titleView = searchTF
            searchTF.placeholder = "\(placeHolderStr)名称"
        }else{
            rightNavBtn.setImage(UIImage.init(named: "sq_search"), for: .normal)
            navigationItem.titleView = nil
            searchTF.text = ""
            navigationItem.title = titleStr
            requestNetWork(true)
        }
        
        
    }
    
    @objc func sureBtnClick() {
        if callBack != nil {
            callBack!(selModelArray)
            self.navigationController?
                .popViewController(animated: true)
        }
    }
    
    @objc func searchTFChange() {
        objc_sync_enter(self)
        
        requestNetWork(true, searchStr: searchTF.text ?? "")
        objc_sync_exit(self)
    }
    
    func clearAllSelCache() {
        for model in selModelArray {
            model.isSelected = false
        }
        selModelArray.removeAll()
        showBottomBtn()
    }
    
    func showBottomBtn() {
        let count = selModelArray.count
        bottomView.sureBtn.isEnabled = count > 0 ? true : false
        let title = count > 0 ? "确定(\(count))" : "确定"
        bottomView.sureBtn.setTitle(title, for: .normal)
        collectionView.reloadData()
    }
}

extension SQHomeAccountListVCViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if netModelArray.count == 0 {
            return
        }
        
        let model = netModelArray[indexPath.row]
        model.isSelected = !model.isSelected
        //根据选中状态 获取需要返回的图片
        if model.isSelected {
            if selectNum == 1 {
                for findModel in selModelArray {
                    findModel.isSelected = false
                }
                selModelArray.removeAll()
            }else{
                if selModelArray.count >= selectNum {
                    showToastMessage("最多选择\(selectNum)\(placeHolderStr)")
                    model.isSelected = false
                    return
                }
            }
            selModelArray.append(model)
        }else{
            selModelArray.removeAll { (tempModel) -> Bool in
                return tempModel.id == model.id
            }
        }
        
        showBottomBtn()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return netModelArray.count > 0 ? netModelArray.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if netModelArray.count == 0 {
            let cell: SQEmptyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SQEmptyCollectionViewCell.cellID, for: indexPath) as! SQEmptyCollectionViewCell
            var cellType = SQEmptyTableViewCellType.cloudImage
            switch type! {
            case .video:
                cellType = SQEmptyTableViewCellType.cloudVideo
            case .music:
                cellType = SQEmptyTableViewCellType.cloudAudio
            case .image:
                cellType = SQEmptyTableViewCellType.cloudImage
            case .others:
                cellType = SQEmptyTableViewCellType.cloudOther
            }
            
            if searchTF.text?.count ?? 0 > 0 { //搜索词条为空
                cellType = SQEmptyTableViewCellType.searchEmpty
            }
            
            cell.cellType = cellType
            return cell
        }
        
        let cell: SQAccountListViewCollectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SQHomeAccountListVCViewController.cellID,
            for: indexPath) as! SQAccountListViewCollectionViewCell
        let model = netModelArray[indexPath.row]
        
        let urlString = model.getShowImageLink()
        if type! == SQAccountFileListType.music {
            cell.contentImageView.image = getPlaceHolderImage(cell.size())
        }else{
           cell.contentImageView.sq_yysetImage(with: urlString, placeholder: getPlaceHolderImage(cell.size()))
        }
        
        if cell.contentImageView.image!.size.width < cell.contentImageView.width() {
            cell.contentImageView.contentMode = .center
        }else{
            cell.contentImageView.contentMode = .scaleAspectFill
        }
        
        cell.titleLabel.text = model.filename
        cell.selBtn.isSelected = model.isSelected
        return cell
    }
    
    func getPlaceHolderImage(_ size: CGSize) -> UIImage?{
        var imageName = ""
        switch type! {
        
        case .image:
            imageName = "home_cloud_img_ph"
        case .video:
            imageName = "home_cloud_video_ph"
        case .music:
            imageName = "home_cloud_music_ph"
        case .others:
            break
        }
        
        return UIImage.init(named: imageName)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if netModelArray.count == 0 {
            return collectionView.size()
        }
    
        return itemSize
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

//MARK: 请求网络数据
extension SQHomeAccountListVCViewController {
    
    func requestNetWork(_ isFresh: Bool = false, searchStr: String = "") {
        weak var weakSelf = self
        SQHomeNewWorkTool.getAccountFileList(type!,start,start + fileSize,searchStr) { (model, statu, errorMessage) in
            
            if weakSelf == nil {
                return
            }
            
            weakSelf?.collectionView.mj_header?.endRefreshing()
            weakSelf?.collectionView.mj_footer?.endRefreshing()
            if errorMessage != nil {
                if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: statu, handel: nil) {
                    return
                }
                return
            }
            
            if isFresh {
                weakSelf?.netModelArray.removeAll()
            }
            
            if searchStr.count > 0 {
                weakSelf?.clearAllSelCache()
            }
            
            if model!.file_info.count < weakSelf!.fileSize {
                weakSelf?.collectionView.mj_footer?.endRefreshingWithNoMoreData()
            }
            
            if model!.file_info.count >= 1 {
                weakSelf?.netModelArray.append(contentsOf: model!.file_info)
            }
            
            weakSelf?.collectionView.reloadData()
        }
    }
    
}

extension SQHomeAccountListVCViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
}
