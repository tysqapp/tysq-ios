//
//  SQCloudUploadVC.swift
//  SheQu
//
//  Created by gm on 2019/10/28.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

protocol SQCloudUploadVCUploadFinishDelegate: class {
    func uploadFinish()
}

class SQCloudUploadVC: SQViewController {
    
    var totalNumCallBack:((Int) -> ())?
    weak var uploadFinishDelegate: SQCloudUploadVCUploadFinishDelegate?
    
    lazy var fileListInfoArray = [SQAccountFileItemModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "我的云盘"
        fileListInfoArray = FileUploadManager.sharedInstance.uploadIngFileListInfoArray
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
    }
    
    private func responseTotalNum() {
        if (self.totalNumCallBack != nil) {
            self.totalNumCallBack!(fileListInfoArray.count)
        }
    }
}


extension SQCloudUploadVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return fileListInfoArray.count == 0 ? 1 : fileListInfoArray.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            if fileListInfoArray.count == 0 { ///空文件时
                let type: SQEmptyTableViewCellType =  SQEmptyTableViewCellType.uploadIngFile
                let cell: SQEmptyTableViewCell = SQEmptyTableViewCell.init(style: .default, reuseIdentifier: SQEmptyTableViewCell.cellID, cellType: type)
                return cell
            }
            
            let cell: SQCloudDetailUploadedTableViewCell = tableView.dequeueReusableCell(withIdentifier: SQCloudDetailUploadedTableViewCell.cellID, for: indexPath) as! SQCloudDetailUploadedTableViewCell
            cell.model = fileListInfoArray[indexPath.row]
            cell.uploadingLabel.isHidden = true
            weak var weakSelf = self
            
            cell.callBack = { (currentModel, resultModel) in
                
                TiercelLog("currentModel:\(currentModel.toJSONString() ?? ""),resultModel:\(resultModel.toJSONString() ?? "")")
                weakSelf?.fileListInfoArray.removeAll(where: {
                    $0.sha256 == resultModel.sha256
                })
                weakSelf?.tableView.reloadData()
                weakSelf?.responseTotalNum()
                weakSelf?.uploadFinishDelegate?.uploadFinish()
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
            
            weak var weakSelf = self
            let rowAction = UITableViewRowAction.init(style: .default, title: "删除") { (action, indexPath) in
                ///删除数据越界时返回
                if indexPath.row >= weakSelf?.fileListInfoArray.count ?? 0 {
                    return
                }
                
                let model = weakSelf?.fileListInfoArray[indexPath.row]
                FileUploadManager.sharedInstance
                   .deleteUploadFile(model!, false)
                weakSelf?.fileListInfoArray = FileUploadManager.sharedInstance.uploadIngFileListInfoArray
                weakSelf?.tableView.reloadData()
                weakSelf?.responseTotalNum()
            }
            
            rowAction.backgroundColor = UIColor.red
            return [rowAction]
        }
}


extension SQCloudUploadVC: SQCloudManagerUploadDelegate {
    func uploadModels(uploadModel: SQAccountFileItemModel) {
        FileUploadManager.sharedInstance
            .addUploadFile(uploadModel)
        fileListInfoArray = FileUploadManager.sharedInstance.uploadIngFileListInfoArray
        tableView.reloadData()
        responseTotalNum()
    }
}
