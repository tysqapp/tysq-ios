//
//  SQCloudDetailsVC.swift
//  SheQu
//
//  Created by gm on 2019/10/28.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQCloudDetailsVC: SQViewController {
    lazy var fileListInfoArray = [SQAccountFileItemModel]()
    
    private var totalNum      = 0
    
    var totalNumCallBack:((Int) -> ())?
    
    var oneTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "我的云盘"
        let height = k_screen_height - k_page_title_view_height - k_bottom_h - SQCloudBottomView.cloudBottomViewH - k_nav_height
        addTableView(frame: CGRect.init(
            x: 0,
            y: 0,
            width: k_screen_width,
            height: height
        ))
        
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
        //addCallBack()
    }
    
    override func addMore() {
        requestNetWork()
    }
    
    func addCallBack() {
        //weak var weakSelf = self
       
        
//        FileUploadManager.sharedInstance.successCallBak = { resultModel in
//            weakSelf?.updateUploadTableView(resultModel)
//        }
    }
}


extension SQCloudDetailsVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileListInfoArray.count == 0 ? 1 : fileListInfoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if fileListInfoArray.count == 0 { ///空文件时
            let type: SQEmptyTableViewCellType =  SQEmptyTableViewCellType.uploadLoadFile
            let cell: SQEmptyTableViewCell = SQEmptyTableViewCell.init(style: .default, reuseIdentifier: SQEmptyTableViewCell.cellID, cellType: type)
            return cell
        }
        
        let cell: SQCloudDetailUploadedTableViewCell = tableView.dequeueReusableCell(withIdentifier: SQCloudDetailUploadedTableViewCell.cellID, for: indexPath) as! SQCloudDetailUploadedTableViewCell
        cell.model = fileListInfoArray[indexPath.row]
        weak var weakSelf = self
        cell.videoCoverCallBack = { uploadModel in
            let vc = SQHomeAccountListVCViewController()
            vc.type = SQAccountFileListType.image
            vc.selectNum = 1
            vc.callBack = { imageModelArray in
                let imageUploadModel = imageModelArray.last
                weakSelf?.uploadCoverImage(Int(uploadModel.id), Int(imageUploadModel!.id), cell: cell, imageUploadModel!.getShowImageLink())
            }
            
            weakSelf?.navigationController?
                .pushViewController(vc, animated: true)
        }
        
        return cell
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
        
        var actionArray = [UITableViewRowAction]()
        
        weak var weakSelf = self
        let delAction = UITableViewRowAction.init(style: .default, title: "删除") { (action, indexPath) in
            let model = weakSelf?.fileListInfoArray[indexPath.row]
            SQAlertView.sharedInstance.showAlertView(title: "确定删除吗?", message: "", cancel: "取消", sure: "确定") { (clickIndex, tf1, tf2) in
                if clickIndex == 1 {
                   weakSelf?.deleteFile(fileId: model?.id ?? 0)
                }
            }
            
        }
        
        delAction.backgroundColor = UIColor.colorRGB(0xF05B5B)
        actionArray.append(delAction)
        
        let model = fileListInfoArray[indexPath.row]
        ///需要上传到亚马逊服务器以后才能开启下载功能
        if model.storage == 3 {
            let downloadAction = UITableViewRowAction.init(style: .default, title: "下载") { (action, indexPath) in
                let model = weakSelf?.fileListInfoArray[indexPath.row]
                weakSelf?.startDownload(model)
            }
            
            downloadAction.backgroundColor = UIColor.colorRGB(0xF18C3B)
            actionArray.append(downloadAction)
        }
        
        
        let renameAction = UITableViewRowAction.init(style: .default, title: "重命名") { (action, indexPath) in
            let model = weakSelf?.fileListInfoArray[indexPath.row]
            weakSelf?.updateFileName(model: model)
        }
        renameAction.backgroundColor = UIColor.colorRGB(0xF5AC3B)
        actionArray.append(renameAction)
        return actionArray
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var actionArray = [UIContextualAction]()
        
        weak var weakSelf = self
        let delAction = UIContextualAction.init(style: .normal, title: "") { (action, view, handled) in
            let model = weakSelf?.fileListInfoArray[indexPath.row]
            SQAlertView.sharedInstance.showAlertView(title: "确定删除吗?", message: "", cancel: "取消", sure: "确定") { (clickIndex, tf1, tf2) in
                if clickIndex == 1 {
                   weakSelf?.deleteFile(fileId: model?.id ?? 0)
                }
            }
            handled(true)
        }
        //delAction.title = "删除"
        delAction.image = "sq_cloud_trash_delete".toImage()
        delAction.backgroundColor = UIColor.colorRGB(0xF05B5B)
        actionArray.append(delAction)
        
        let model = fileListInfoArray[indexPath.row]
        ///需要上传到亚马逊服务器以后才能开启下载功能
        if model.storage == 3 {
            let downloadAction = UIContextualAction.init(style: .normal, title: "") { (action, view, handled) in
                let model = weakSelf?.fileListInfoArray[indexPath.row]
                weakSelf?.startDownload(model)
                handled(true)
            }
            //downloadAction.title = "下载"
            downloadAction.image = "sq_cloud_download".toImage()
            downloadAction.backgroundColor = UIColor.colorRGB(0xF18C3B)
            actionArray.append(downloadAction)
        }
        
        
        let renameAction = UIContextualAction.init(style: .normal, title: "") { (action, view, handled) in
            let model = weakSelf?.fileListInfoArray[indexPath.row]
            weakSelf?.updateFileName(model: model)
            handled(true)
        }
        //renameAction.title = "重命名"
        renameAction.image = "sq_cloud_rename".toImage()
        renameAction.backgroundColor = UIColor.colorRGB(0xF5AC3B)
        actionArray.append(renameAction)
        
        return UISwipeActionsConfiguration.init(actions: actionArray)
    }
}

extension SQCloudDetailsVC {
    
    func requestNetWork() {
        
        weak var weakSelf = self
        SQCloudNetWorkTool.getAccountFileList(
        fileListInfoArray.count,
        fileListInfoArray.count + 20) { (fileListModel, Statu, errorMesaage) in
            weakSelf?.endFooterReFresh()
            if (errorMesaage != nil) {
                return
            }
            
            if fileListModel!.file_info.count < 20 {
                weakSelf?.endFooterReFreshNoMoreData()
            }
            
            for model in fileListModel!.file_info {
                model.createAccountFileListFrame()
                ///因为文件先上传了 所以可能已经存在 这个时候就不需要再添加了
                weakSelf?.fileListInfoArray.append(model)
            }
            
            weakSelf?.tableView.reloadData()
            weakSelf?.totalNum = fileListModel!.total_number
            if ((weakSelf?.totalNumCallBack) != nil) {
                weakSelf!.totalNumCallBack!(fileListModel!.total_number)
            }
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
    
    func updateFileName(model: SQAccountFileItemModel?) {
        if model == nil {
            return
        }
        
        SQAlertView.sharedInstance.showAlertView(title: "", message: "", cancel: "取消", sure: "确定", placeholder1: "请输入新的名称", alertViewStyle: .plainTextInput) {[weak self] (clickIndex, tf1Str, tf2Str) in
            if clickIndex != 0 {
                self?.updateFileName(model: model!, fileName: tf1Str)
            }
        }
    }
    
    func updateFileName(model: SQAccountFileItemModel, fileName: String) {
        
        if fileName.count < 1 {
            showToastMessage("文件名不能为空")
            return
        }
        
        if fileName == model.filename {
            showToastMessage("修改成功")
            return
        }
        
        SQCloudNetWorkTool.updateFileName(file_id: model.id, fileName) {[weak self] (baseModel, statu, errorMessage) in
            if (errorMessage != nil) {
                self?.showToastMessage("修改失败")
                return
            }
            
            self?.showToastMessage("修改成功")
            model.filename = fileName
            model.createAccountFileListFrame()
            self?.tableView.reloadData()
        }
    }
    
    ///开始下载
    func startDownload(_ model: SQAccountFileItemModel?) {
        if model == nil {
            return
        }
        
        let downloadStr = model!.download_url
        SQDownloadManager.appendDownload(filePath: downloadStr, dispPath: model!.getShowImageLink(), mineType: model!.type)
    }
    
    ///从服务器删除已上传文件
    func deleteFile(fileId: Int32) {
        weak var weakSelf = self
        SQCloudNetWorkTool.deleteAccountFile(file_id: fileId) { (model, statu, errorMessage) in
            if errorMessage != nil {
                return
            }
            
            weakSelf?.fileListInfoArray.removeAll(where: { (model) -> Bool in
                return model.id == fileId
            })
            weakSelf?.tableView.reloadData()
            weakSelf!.totalNum -= 1
            if ((weakSelf?.totalNumCallBack) != nil) {
                weakSelf!.totalNumCallBack!(weakSelf!.totalNum)
            }
        }
    }
}


extension SQCloudDetailsVC: SQCloudUploadVCUploadFinishDelegate {
    func uploadFinish() {
        ///处理一秒之内不多做网络请求
        if (oneTimer == nil) {
            oneTimer = Timer.init(timeInterval: 1, repeats: false, block: {[weak self] (time) in
                self?.fileListInfoArray.removeAll()
                self?.requestNetWork()
                self?.oneTimer?.invalidate()
                self?.oneTimer = nil
            })
            
            RunLoop.main.add(oneTimer!, forMode: .common)
        }else{
            oneTimer?.invalidate()
            oneTimer = nil
            uploadFinish()
        }
        
    }
}
