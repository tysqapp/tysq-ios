//
//  SQBrowserImageViewCollectionViewCell.swift
//  SheQu
//
//  Created by gm on 2019/9/3.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQBrowserImageViewCollectionViewCell: UICollectionViewCell {
    static let cellID = "SQBrowserImageViewCollectionViewCellID"
    
    var hiddenCallback: ((SQBrowserImageViewCollectionViewCell) -> ())?
    
    lazy var browserImageView: SQBrowserImageView = {
        let browserImageView = SQBrowserImageView.init(frame: UIScreen.main.bounds)
        weak var weakSelf = self
        browserImageView.hiddenCallback = { imageView in
            if ((weakSelf?.hiddenCallback) != nil) {
                weakSelf?.hiddenCallback!(weakSelf!)
            }
        }
        
        return browserImageView
    }()
    
    
    var item: SQBrowserImageViewItem!
    
    lazy var bottomView: SQBrowserBottomView = {
        let bottomView = SQBrowserBottomView()
        weak var weakSelf = self
        bottomView.eventCallBack = { event in
            switch event {
            case .lookOriginImage:
                weakSelf?.lookOriginImage()
            case .saveImage:
                weakSelf?.saveImage()
            }
        }
        
        return bottomView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addSubview(browserImageView)
        addSubview(bottomView)
        browserImageView.originImagedelegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        browserImageView.frame = bounds
        let bottomViewY = frame.size.height - SQBrowserBottomView.height
        bottomView.frame = CGRect.init(
            x: 0,
            y: bottomViewY,
            width: frame.size.width,
            height: frame.size.height
        )
    }
    
    func updata(item: SQBrowserImageViewItem, currentIndex: Int, total: Int) {
        self.item  = item
        
        bottomView.setNumberLabelText(currentIndex, total: total)
        ///判断图片是否缓存
        let isHaveOriginal = SQAniImageView.containsImage(imagePath: item.originalImageLink)
    
        if isHaveOriginal {
            item.imageState = .loadOriginalComplete
            browserImageView.update(
                browserImageViewLink: item.originalImageLink,
                isOriginImage: true , imageState: item.imageState
            )
            
            browserImageView(imageDownload: true, isOriginImage: true, error: nil)
            return
        }
        
        ///如果模糊图片和原始图一致 则直接显示原始图片
        if item.blurredImageLink == item.originalImageLink {
            item.imageState = .loadOriginalComplete
            browserImageView.update(
                browserImageViewLink: item.originalImageLink,
                isOriginImage: true , imageState: item.imageState
            )
        }else{
            bottomView.updateSate(item.imageState)
            browserImageView.update(
                browserImageViewLink: item.blurredImageLink,
                isOriginImage: false, imageState: item.imageState
            )
        }
    }
    
    private func lookOriginImage() {
        
        var imageLink = item.originalImageLink
        var isOriginImage  = false
        let isBlurredImage =  SQAniImageView.containsImage(imagePath: item.blurredImageLink)
        if isBlurredImage {
            item.imageState = .loadOriginalImage
            isOriginImage   = true
        }else{
            item.imageState = .loadBlurredImage
            imageLink = item.blurredImageLink
        }
        
        bottomView.updateSate(item.imageState)
        browserImageView.update(
            browserImageViewLink: imageLink,
            isOriginImage: isOriginImage,
            imageState: item.imageState
        )
    }
    
    func saveImage() {
        browserImageView.imageView.image?.saveImageToAlbum(handel: { (path, error) in
            if (error != nil) {
                SQToastTool.showToastMessage("保存图片失败")
                return
            }else{
                SQToastTool.showToastMessage("保存图片成功")
            }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class SQBrowserImageViewItem: NSObject {
    
    enum State {
        ///加载模糊图中
        case loadBlurredImage
        ///加载模糊图完成
        case loadBlurredComplete
        ///加载模糊图失败
        case loadBlurredFailed
        ///加载原图中
        case loadOriginalImage
        ///加载原图成功
        case loadOriginalComplete
        ///加载原图失败
        case loadOriginalFailed
    }
    
    /// 模糊图链接
    var blurredImageLink = ""
    
    /// 原型图链接
    var originalImageLink  = ""
    
    /// 图片在原来相对屏幕的位置
    var oldFrame         = CGRect.zero
    
    /// 图片model
    var contentModel     = UIView.ContentMode.scaleAspectFit

    /// 图片状态
    var imageState   = SQBrowserImageViewItem.State.loadBlurredImage
    
    
    /// 图片浏览器
    /// - Parameter blurredImageLink: 模糊图链接
    /// - Parameter originalImageLink: 原图链接·
    /// - Parameter oldFrame: 被放大图在屏幕中位置
    /// - Parameter contentModel: 原图图片类型
    /// - Parameter imageState: 加载图片状态
    init(
        blurredImageLink: String,
        originalImageLink: String,
        oldFrame: CGRect,
        contentModel: UIView.ContentMode,
        imageState: SQBrowserImageViewItem.State
        = SQBrowserImageViewItem.State.loadBlurredImage) {
        super.init()
        self.blurredImageLink = blurredImageLink.encodeURLCodeStr()
        self.originalImageLink = originalImageLink.encodeURLCodeStr()
        
        self.oldFrame = oldFrame
        self.contentModel = contentModel
        self.imageState   = imageState
        
        ///当位置在频幕外时
        let screenH = UIScreen.main.bounds.size.height
        if oldFrame.maxY < 0 {
            self.oldFrame = CGRect.init(
                x: oldFrame.origin.x,
                y: oldFrame.size.height * -1,
                width: oldFrame.size.width,
                height: oldFrame.size.height
            )
        }
        
        if oldFrame.origin.y > screenH {
            self.oldFrame = CGRect.init(
                x: oldFrame.origin.x,
                y: screenH,
                width: oldFrame.size.width,
                height: oldFrame.size.height
            )
        }
    }
}


extension SQBrowserImageViewCollectionViewCell: SQBrowserImageViewDelegate {
    
    func browserImageView(imageDownload isCompletes: Bool, isOriginImage: Bool, error: Error?) {
        
        if !isOriginImage { //模糊图逻辑
            if item.imageState == .loadOriginalImage || item.imageState == .loadOriginalFailed || item.imageState == .loadOriginalComplete {
                return
            }
            
            if isCompletes {
              item.imageState = .loadBlurredComplete
            }else{
                if error != nil {
                    item.imageState = .loadBlurredFailed
                }
            }
            
        }else {
            
            if item.imageState == .loadBlurredImage || item.imageState == .loadBlurredFailed || item.imageState == .loadBlurredComplete {
                return
            }
            
            if isCompletes {
                item.imageState = .loadOriginalComplete
            }else{
                if error != nil {
                 item.imageState = .loadOriginalFailed
                }else{
                 item.imageState = .loadOriginalImage
                }
            }
        }
        
        bottomView.updateSate(item.imageState)
    }
}
