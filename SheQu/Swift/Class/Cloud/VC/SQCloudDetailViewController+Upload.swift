//
//  SQCloudDetailViewController+Upload.swift
//  SheQu
//
//  Created by gm on 2019/6/12.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
import Photos
import CLImagePickerTool

extension SQCloudDetailViewController {
    
    @objc func uploadFile(){
        let alertView = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        weak var weakSelf = self
        let imageAction = UIAlertAction.init(title: "图片", style: .default) { (action) in
            let imagePickTool = CLImagePickerTool()
            imagePickTool.isHiddenVideo = true
            imagePickTool.cl_setupImagePickerWith(MaxImagesCount: 9, superVC: weakSelf!) { (assetArray,cutImage) in
                let manager = PHImageManager.default()
                var index   = 0
                for assetItem in assetArray {
                  _ = autoreleasepool{
                    manager.requestImageData(for: assetItem, options: PHImageRequestOptions(), resultHandler: { (data, strUrl, statu, infoDict) in
                        let model = SQAccountFileItemModel
                            .createAccountFileListInfoModel(
                            data as NSData? ?? NSData(),
                            strUrl ?? "",
                            .image
                        )
                        
                        model.isUploadIng = true
                        model.createAccountFileListFrame()
                        FileUploadManager.sharedInstance
                            .addUploadFile(model)
                        index += 1
                        if index == assetArray.count {
                            weakSelf?.uploadTableViewData()
                        }
                    })
                }
             }
            }
        }
        
        let videoAction = UIAlertAction.init(title: "视频", style: .default) { (action) in
            let imagePickTool = CLImagePickerTool()
            imagePickTool.isHiddenImage = true
            imagePickTool.cl_setupImagePickerWith(MaxImagesCount: 9, superVC: weakSelf!) { (assetArr,cutImage) in
                
                for asset in assetArr {
                    
                    CLImagePickerTool.convertAssetToAvPlayerItem(asset: asset, successClouse: { (avItem) in
                        let itemPath: AVURLAsset = avItem.asset as! AVURLAsset
                        var data = NSData()
                        do{
                            data = try NSData.init(contentsOf: itemPath.url, options: [.alwaysMapped,.uncached])
                            TiercelLog("视频长度\(data.count)")
                        }catch{
                            TiercelLog(error.localizedDescription)
                        }
                        
                        let model = SQAccountFileItemModel.createAccountFileListInfoModel(data, itemPath.url.absoluteString, .video)
                        model.localUrl    = itemPath.url
                        model.isUploadIng = true
                        model.createAccountFileListFrame()
                        FileUploadManager.sharedInstance
                            .addUploadFile(model)
                        weakSelf?.uploadTableViewData()
                    }, failedClouse: {
                        
                    }, progressClouse: { (progress) in
                        
                    })
                }
            }
        }
        
//        let audioAction = UIAlertAction.init(title: "音频", style: .default) { (action) in
//
//        }
        alertView.addAction(imageAction)
        alertView.addAction(videoAction)
        
        if #available(iOS 11.0, *) {
            let fileAction = UIAlertAction.init(title: "其它", style: .default) { (action) in
               
                let vc = SQDocumentBrowserViewController()
                vc.callBack = { (fileUrlArray, isSuccess) in
                    if !isSuccess {
                        return
                    }
                    for fileUrl in fileUrlArray {
                        var data = NSData()
                        let dc = UIDocument.init(fileURL: fileUrl)
                        do{
                            
                            data = try NSData.init(contentsOf: dc.fileURL, options: [.alwaysMapped,.uncached])
                            TiercelLog("文件\(data.count)")
                        }catch{
                            TiercelLog(error.localizedDescription)
                        }
                        
                        let model = SQAccountFileItemModel.createAccountFileListInfoModel(data, fileUrl.absoluteString, .others)
                        model.isUploadIng = true
                        model.localUrl    = dc.fileURL
                        model.createAccountFileListFrame()
                        FileUploadManager.sharedInstance
                            .addUploadFile(model)
                        weakSelf?.uploadTableViewData()
                    }
                   
                }
                
                vc.modalPresentationStyle = .fullScreen
                weakSelf?.present(vc, animated: true, completion: nil)
            }
            
            alertView.addAction(fileAction)
        }
        
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
            
        }
        
        alertView.addAction(cancelAction)
        present(alertView, animated: true, completion: nil)
    }
}
