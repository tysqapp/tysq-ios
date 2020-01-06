//
//  UIImage+Extension.swift
//  SheQu
//
//  Created by gm on 2019/5/15.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

extension UIImage {
    
   class func imageFromColor(color: UIColor, viewSize: CGSize) -> UIImage{
        
        let rect: CGRect = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(color.cgColor)
        
        context.fill(rect)
        
        
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsGetCurrentContext()
        
        return image!
        
    }
    
    public func roundImage(byRoundingCorners: UIRectCorner = UIRectCorner.allCorners, cornerRadi: CGFloat) -> UIImage? {
        return roundImage(byRoundingCorners: byRoundingCorners, cornerRadii: CGSize(width: cornerRadi, height: cornerRadi))
    }
    
    public func roundImage(byRoundingCorners: UIRectCorner = UIRectCorner.allCorners, cornerRadii: CGSize) -> UIImage? {
        
        let imageRect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        let context = UIGraphicsGetCurrentContext()
        guard context != nil else {
            return nil
        }
        
        context?.setShouldAntialias(true)
        let bezierPath = UIBezierPath(roundedRect: imageRect,
                                      byRoundingCorners: byRoundingCorners,
                                      cornerRadii: cornerRadii)
        bezierPath.close()
        bezierPath.addClip()
        self.draw(in: imageRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize: CGSize) -> UIImage {
        //UIGraphicsBeginImageContext(reSize);
    UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        draw(in: CGRect.init(x: 0, y: 0, width: reSize.width, height: reSize.height))
        let reSizeImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return reSizeImage ?? UIImage()
    }
    
    /**
     *  等比率缩放
     */
    func scaleImage(scaleSize: CGFloat)-> UIImage {
        let reSize = CGSize.init(width: size.width * scaleSize, height: size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
    
    
    /// 保存图片到ImageView
    ///
    /// - Parameter handel: 保存图片成功或失败回调
    func saveImageToAlbum(handel:@escaping ((_ path: String?, _ error: Error?) -> ())) {
        yy_saveToAlbum { (pathUrl, error) in
            handel(pathUrl?.absoluteString,error)
        }
    }
    
}

