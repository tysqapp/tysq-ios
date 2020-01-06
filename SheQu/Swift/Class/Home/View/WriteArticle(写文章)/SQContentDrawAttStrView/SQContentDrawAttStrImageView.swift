//
//  SQContentDrawAttStrImageView.swift
//  SheQu
//
//  Created by gm on 2019/6/26.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQContentDrawAttStrImageViewFactory: NSObject, SQContentDrawAttStrViewFactoryProtocol  {
    
    func getDrawAttStrViewProtocol(idStr: String, dispLink: String, fileLink: String, audioName: String,size: CGSize, handel: SQContentDrawAttStrViewCallBack?) -> SQContentDrawAttStrViewProtocol {
        let frame = CGRect.init(
            x: 0,
            y: 0,
            width: size.width / UIScreen.main.scale,
            height: size.height / UIScreen.main.scale
        )
        
        return SQContentDrawAttStrImageView.init(
            frame: frame,
            idStr,
            dispLink,
            fileLink,
            handel
        )
    }
}


class SQContentDrawAttStrImageView: SQDrawAttStrView,   SQContentDrawAttStrViewProtocol{
    var idStr: String!
    var dispLink: String!
    var fileLink: String!
    var originalUrl: String!
    var callBack: SQContentDrawAttStrViewCallBack?
    lazy var isUsed    = false
    lazy var coverView = UIView()
    
    init(frame: CGRect,_ idStrTemp: String,_ dispLink: String, _ fileLink: String,_ handel: SQContentDrawAttStrViewCallBack?) {
        super.init(frame: frame)
        idStr            = "img:" + idStrTemp
        callBack         = handel
        self.dispLink    = dispLink
        self.fileLink    = fileLink
        if idStrTemp.count < 1 {
            return
        }
        
        let imageViewSize = frame.size
        
        let defaultWidth = draw_stt_str_default_height
        let maxWidth     = defaultWidth - 8
        
        var height = imageViewSize.height
        var width  = imageViewSize.width
        if width > maxWidth {//判断图片是否过大
            height = height * maxWidth / width
            width  = maxWidth
        }
        
        let imageViewX = (defaultWidth - width) * 0.5
        aniImageView.frame       = CGRect.init(
            x: imageViewX - 3,
            y: 10,
            width: width,
            height: height
        )
        
        setSize(size: CGSize.init(
            width: defaultWidth,
            height: height + 20
        ))

        coverView.frame          = aniImageView.frame
        addSubview(coverView)
        bringSubviewToFront(aniImageView)
        aniImageView.addRounded(corners: .allCorners, radii: k_corner_radiu_size, borderWidth: 0.7, borderColor: UIColor.clear)
//        coverView.layer.borderWidth        = k_corner_boder_with
//        coverView.layer.borderColor        = UIColor.clear.cgColor
//        coverView.layer.cornerRadius       = k_corner_radiu
        ///从服务器刷新最新的image出来

        aniImageView.sq_setImage(
            with: dispLink, imageType: .image,
            placeholder: k_image_ph_loading,
            backGroundColor: k_color_line_light
        )
    }
    
    func startClickImageView(handel: @escaping SQContentDrawAttStrViewCallBack) {
        callBack = handel
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(imageViewAttClick))
        aniImageView.addGestureRecognizer(tap)
        aniImageView.isUserInteractionEnabled = true
    }
    
    func copyImageView() -> SQContentDrawAttStrViewProtocol {
        let drawAttStrImageView = SQContentDrawAttStrImageView.init(frame: CGRect.zero, "", "", "", nil)
        drawAttStrImageView.frame = self.frame
        drawAttStrImageView.idStr = self.idStr
        drawAttStrImageView.fileLink = self.fileLink
        drawAttStrImageView.dispLink = self.dispLink
        drawAttStrImageView.aniImageView.frame = aniImageView.frame
        drawAttStrImageView.aniImageView.image = aniImageView.image
        drawAttStrImageView.coverView.isHidden = true
        drawAttStrImageView.aniImageView.addRounded(corners: .allCorners, radii: k_corner_radiu_size, borderWidth: 0.7, borderColor: UIColor.clear)
        return drawAttStrImageView
    }
    
    @objc private func imageViewAttClick() {
        if (callBack != nil) {
            callBack!(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
