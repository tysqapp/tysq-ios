//
//  SQAniImageView.swift
//  SheQu
//
//  Created by gm on 2019/9/3.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
import YYWebImage

public class SQAniImageView: YYAnimatedImageView {
    enum ImageType {
        case image
        case video
        case account
        case report
        case review

    }
    
    func sq_setImage(with imageStr: String, imageType: SQAniImageView.ImageType, placeImageType: UIView.ContentMode = .center, placeholder: UIImage?, backGroundColor : UIColor = UIColor.clear, completion: YYWebImageCompletionBlock? = nil) {
        weak var weakSelf = self
        backgroundColor = backGroundColor
        
        if (placeholder != nil) {
            image = placeholder
            contentMode = placeImageType
        }
        
        var failImage = k_image_ph_fail
        if imageType == SQAniImageView.ImageType.video {
            failImage = k_image_video_ph_fail
        }
        
        if imageType == SQAniImageView.ImageType.account {
            failImage = k_image_ph_account
        }
        
        if imageType == SQAniImageView.ImageType.review {
            failImage = k_image_ph_review
        }
        
        if imageType == SQAniImageView.ImageType.report {
            failImage = k_image_ph_report
        }
        
        ///处理中文时候url为nil
        let imageStrTemp = imageStr.encodeURLCodeStr()
        var imageURL = URL.init(string: imageStrTemp )
        if !imageStrTemp.hasPrefix("http") {
            imageURL = URL.init(fileURLWithPath: imageStrTemp)
        }
        if (imageURL == nil) {
           image = failImage
           if (completion != nil) {
                completion!(
                    image,
                    URL.init(string: "http://www.baidu.com")!,
                    YYWebImageFromType.diskCache,
                    YYWebImageStage.cancelled,NSError()
            )
          }
          
          if imageType != .account {
              contentMode = .center
          }
          return
        }
        
        yy_setImage(with: imageURL, placeholder: placeholder) { (image, linkUrl, type, stage, error) in
            if stage != YYWebImageStage.progress {
                if (error != nil) {
                    weakSelf?.image = failImage
                    if imageType != .account {
                        weakSelf?.contentMode = .center
                    }
                }else{
                    weakSelf?.contentMode     = .scaleAspectFit
                    weakSelf?.backgroundColor = UIColor.clear
                }
            }
            
            if (completion != nil) {
                completion!(image,linkUrl,type,stage,error)
            }
        }
    }
    
    public func sq_yysetImage(with imageStr: String, placeholder: UIImage?) {
        ///处理中文时候url为nil
        let imageStrTemp = imageStr.encodeURLCodeStr()
        var imageURL = URL.init(string: imageStrTemp )
        if !imageStrTemp.hasPrefix("http") {
            imageURL = URL.init(fileURLWithPath: imageStrTemp)
        }
        yy_setImage(with: imageURL, placeholder: placeholder)
    }
    

    static func containsImage(imagePath: String) -> Bool{
        return YYImageCache.shared().containsImage(forKey: imagePath)
    }
    
    static func addCookie() {
        guard let cookieArray = HTTPCookieStorage.shared.cookies  else {
            return
        }
        
        for cookie in cookieArray {
            if cookie.name == "_session_" {
                YYWebImageManager.shared().headers = ["cookie":"_session_=\(cookie.value)"]
            }
        }
    }
}
