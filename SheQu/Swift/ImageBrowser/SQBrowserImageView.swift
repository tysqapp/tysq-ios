//
//  SQBrowserImageView.swift
//  testDraft
//
//  Created by gm on 2019/9/3.
//  Copyright © 2019 SmartInspection. All rights reserved.
//

import UIKit

protocol SQBrowserImageViewDelegate: NSObject {
    func browserImageView(imageDownload isCompletes: Bool, isOriginImage: Bool,error: Error?)
}

class SQBrowserImageView: UIScrollView {
   
   weak var originImagedelegate: SQBrowserImageViewDelegate?
    
   lazy var imageView: SQAniImageView = {
        let imageView = SQAniImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        imageView.backgroundColor = UIColor.clear
        return imageView
    }()
    
    var hiddenCallback: ((SQBrowserImageView) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor   = UIColor.clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isPagingEnabled  = true
        imageView.frame  = bounds
        maximumZoomScale = 1.5
        delegate         = self
        addSubview(imageView)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapBtnClick))
        self.addGestureRecognizer(tap)
    }
    
    @objc func tapBtnClick() {
        if (hiddenCallback != nil) {
            hiddenCallback!(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func update(browserImageViewLink imageViewLink: String, isOriginImage: Bool, imageState: SQBrowserImageViewItem.State) {
        
        var placeImage = k_image_ph_loading
        var contentModelTemp: UIView.ContentMode = .center
       
        switch imageState {
        case .loadBlurredImage:
            break
        case .loadBlurredComplete:
            placeImage = imageView.image
            contentModelTemp = .scaleAspectFit
            break
        case .loadBlurredFailed:
            placeImage = k_image_ph_fail
            break
        case .loadOriginalImage:
            placeImage = imageView.image
            contentModelTemp = .scaleAspectFit
            break
        case .loadOriginalComplete:
            placeImage = imageView.image
            contentModelTemp = .scaleAspectFit
        case .loadOriginalFailed:
            placeImage = k_image_ph_fail
            break
        }
        
        
        weak var weakSelf = self
        originImagedelegate?.browserImageView(
            imageDownload: false,
            isOriginImage: isOriginImage,
            error: nil
        )
        
        imageView.sq_setImage(
            with: imageViewLink,
            imageType: .image,
            placeImageType: contentModelTemp,
            placeholder: placeImage
            ){ (image, linkUrl, formType, state, error) in
            weakSelf?.backgroundColor   = UIColor.clear
            if (error != nil) {
                weakSelf?.originImagedelegate?.browserImageView(
                    imageDownload: false,
                    isOriginImage: isOriginImage,
                    error: error
                )
                return
            }
            
            weakSelf?.imageView.backgroundColor = UIColor.clear
            weakSelf?.originImagedelegate?.browserImageView(
                imageDownload: true,
                isOriginImage: isOriginImage,
                error: error
            )
        }
    }
}


extension SQBrowserImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageScaleWidth: CGFloat = zoomScale * k_screen_width
        let imageScaleHeight: CGFloat = zoomScale * k_screen_height
        let imageX: CGFloat = CGFloat(floorf(Float((self.frame.size.width - imageScaleWidth) / 2.0)));
        let imageY: CGFloat = CGFloat(floorf(Float((self.frame.size.height - imageScaleHeight) / 2.0)));
        self.imageView.frame = CGRect.init(x: imageX, y: imageY, width: imageScaleWidth, height: imageScaleHeight)
    }
}
