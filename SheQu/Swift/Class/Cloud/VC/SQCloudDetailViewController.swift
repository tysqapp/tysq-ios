//
//  SQCloudDetailViewController.swift
//  SheQu
//
//  Created by gm on 2019/5/27.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
import Photos
import CLImagePickerTool

class SQCloudDetailViewController: SQViewController {
    lazy var fileListInfoArray = [SQAccountFileItemModel]()
    lazy var uploadFileListInfoArray = [SQAccountFileItemModel]()
    lazy var cloudDetailView: SQCloudDetailChooseView = {
        let cloudDetailView = SQCloudDetailChooseView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: k_screen_width))
        return cloudDetailView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line_light
        return lineView
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
        bottomView.sureBtn.setTitle("上传", for: .normal)
        bottomView.sureBtn.isEnabled = true
        bottomView.sureBtn.addTarget(
            self,
            action: #selector(uploadFile),
            for: .touchUpInside
        )
        
        return bottomView
    }()
    
    lazy var uploadedNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cloudDetailView)
        view.addSubview(lineView)
        view.addSubview(bottomView)
        
        addTableView(frame: CGRect.zero)
        tableView.register(
            SQCloudDetailUploadedTableViewCell.self,
            forCellReuseIdentifier: SQCloudDetailUploadedTableViewCell.cellID
        )
        
        tableView.register(
            SQEmptyTableViewCell.self,
            forCellReuseIdentifier: SQEmptyTableViewCell.cellID
        )
        
        tableView.backgroundColor = k_color_line_light
        addFooter()
        requestNetWork()
        addCallBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "我的云盘"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cloudDetailView.frame = CGRect.init(
            x: 0,
            y: k_nav_height,
            width: k_screen_width,
            height: 50
        )
        
        lineView.frame        = CGRect.init(
            x: 0,
            y: cloudDetailView.maxY(),
            width: k_screen_width,
            height: k_line_height_big
        )
        
        tableView.frame       = CGRect.init(
            x: 0,
            y: lineView.maxY(),
            width: k_screen_width,
            height: bottomView.top() - lineView.maxY()
        )
    }
    
    override func addMore() {
        requestNetWork()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension SQCloudDetailViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileListInfoArray.count == 0 ? 1 : fileListInfoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if fileListInfoArray.count == 0 { ///空文件时
            let type: SQEmptyTableViewCellType = cloudDetailView.uploadIngBtn.isSelected ? SQEmptyTableViewCellType.uploadIngFile : SQEmptyTableViewCellType.uploadLoadFile
            let cell: SQEmptyTableViewCell = SQEmptyTableViewCell.init(style: .default, reuseIdentifier: SQEmptyTableViewCell.cellID, cellType: type)
            return cell
        }
        
        let cell: SQCloudDetailUploadedTableViewCell = tableView.dequeueReusableCell(withIdentifier: SQCloudDetailUploadedTableViewCell.cellID, for: indexPath) as! SQCloudDetailUploadedTableViewCell
        cell.model = fileListInfoArray[indexPath.row]
        weak var weakSelf = self
        cell.callBack = { (currentModel, resultModel) in
            weakSelf?.uploadedNum += 1
            weakSelf?.updateUploadTableView(resultModel)
        }
        
        cell.videoCoverCallBack = { uploadModel in
            let vc = SQHomeAccountListVCViewController()
            vc.type = SQAccountFileListType.image
            vc.selectNum = 1
            vc.callBack = { imageModelArray in
                let imageUploadModel = imageModelArray.last
                weakSelf?.uploadCoverImage(Int(uploadModel.id), Int(imageUploadModel!.id), cell: cell, imageUploadModel!.getShowImageLink())
            }
            weakSelf?.navigationController?.pushViewController(vc, animated: true)
        }
        
        return cell
    }
    
    func updateUploadTableView(_ resultModel: SQAccountFileItemModel) {
        resultModel.createAccountFileListFrame()
        let isHave = uploadFileListInfoArray.contains(where: { (findModel) -> Bool in
            return findModel.id == resultModel.id
        })
        
        if isHave { //如果有的话就不需要再传入了
            
        }else{
            resultModel.createAccountFileListFrame()
            if uploadFileListInfoArray.count == 0 {
                uploadFileListInfoArray.append(resultModel)
            }else{
                uploadFileListInfoArray.insert(resultModel, at: 0)
            }
        }
        
        uploadTableViewData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if fileListInfoArray.count == 0 {
            return tableView.height()
        }
        let model = fileListInfoArray[indexPath.row]
        return model.accountFileListFrame.lineViewFrame.maxY
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return fileListInfoArray.count == 0 ? false : true
    }
    
    ///删除
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        weak var weakSelf = self
        let rowAction = UITableViewRowAction.init(style: .default, title: "删除") { (action, indexPath) in
            let model = weakSelf?.fileListInfoArray[indexPath.row]
            if model!.isUploadIng {
                FileUploadManager.sharedInstance.deleteUploadFile(model!, false)
                weakSelf?.uploadTableViewData()
            }else {
                weakSelf?.uploadedNum -= 1
                weakSelf?.deleteFile(fileId: model?.id ?? 0)
                weakSelf?.uploadTableViewData()
            }
            
        }
        rowAction.backgroundColor = UIColor.red
        return [rowAction]
    }
    
    
}

extension SQCloudDetailViewController {
    
    func addCallBack() {
        weak var weakSelf = self
        cloudDetailView.callBack = { detailView in
            if !detailView.uploadedBtn.isSelected {
                weakSelf?.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }else{
                weakSelf?.tableView.mj_footer?.resetNoMoreData()
            }
            weakSelf?.uploadTableViewData()
        }
        
        FileUploadManager.sharedInstance.successCallBak = { resultModel in
            weakSelf?.updateUploadTableView(resultModel)
        }
    }
    
}


extension SQCloudDetailViewController{
    
    func requestNetWork() {
        
        weak var weakSelf = self
        SQCloudNetWorkTool.getAccountFileList(fileListInfoArray.count, fileListInfoArray.count + 20) { (fileListModel, Statu, errorMesaage) in
            weakSelf!.endFooterReFresh()
            if (errorMesaage != nil) {
                return
            }
            
            weakSelf?.uploadedNum = fileListModel!.total_number
            
            if fileListModel!.file_info.count < 20 {
                weakSelf?.endFooterReFreshNoMoreData()
            }
            
            for model in fileListModel!.file_info {
                model.createAccountFileListFrame()
                ///因为文件先上传了 所以可能已经存在 这个时候就不需要再添加了
                let isHave = weakSelf?.uploadFileListInfoArray.contains(where: { (findModel) -> Bool in
                    return findModel.id == model.id
                })
                if isHave ?? false { //如果有的话就不需要再传入了
                    
                }else{
                    weakSelf?.uploadFileListInfoArray.append(model)
                }
                
            }
            
            weakSelf?.uploadTableViewData()
        }
    }
    
    func uploadCoverImage(_ videoID: Int, _ imageID: Int, cell: SQCloudDetailUploadedTableViewCell, _ coverUrl: String) {
        //weak var weakSelf = self
        SQCloudNetWorkTool.uploadCoverImage(videoID, imageID) { (model, statu, errorMessage) in
            if (errorMessage != nil) {
                return
            }
            let cover = SQAccountCoversModel()
            cover.cover_url = coverUrl
            cover.id        = UInt64(imageID)
            cell.model?.covers = [cover]
            cell.updateIconImageView()
        }
    }
    
    ///从服务器删除已上传文件
    func deleteFile(fileId: Int32) {
        weak var weakSelf = self
        SQCloudNetWorkTool.deleteAccountFile(file_id: fileId) { (model, statu, errorMessage) in
            if errorMessage != nil {
                return
            }
            
            weakSelf?.uploadFileListInfoArray.removeAll(where: { (model) -> Bool in
                return model.id == fileId
            })
            
            weakSelf?.uploadTableViewData()
        }
    }
    
    func uploadTableViewData() {
        fileListInfoArray.removeAll()
        
        if cloudDetailView.uploadedBtn.isSelected {
            fileListInfoArray.append(contentsOf: uploadFileListInfoArray)
        }else{
            fileListInfoArray.append(contentsOf: FileUploadManager.sharedInstance.uploadIngFileListInfoArray)
        }
        
        if uploadedNum > 0 {
            cloudDetailView.uploadedBtn.setTitle(
                "已上传(\(uploadedNum))",
                for: .normal
            )
        }else{
            cloudDetailView.uploadedBtn.setTitle(
                "已上传",
                for: .normal
            )
        }
        
        if  FileUploadManager.sharedInstance.uploadIngFileListInfoArray.count > 0 {
            cloudDetailView.uploadIngBtn.setTitle(
                "上传中(\(FileUploadManager.sharedInstance.uploadIngFileListInfoArray.count))",
                for: .normal
            )
        }else{
            cloudDetailView.uploadIngBtn.setTitle(
                "上传中",
                for: .normal
            )
        }
        
        
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
    }
    
    
    
    func updateUploadTitleView() {
        
    }
}
