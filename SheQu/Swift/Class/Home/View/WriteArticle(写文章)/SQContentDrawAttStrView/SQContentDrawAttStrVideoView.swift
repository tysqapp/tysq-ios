//
//  SQContentDrawAttStrVideoView.swift
//  SheQu
//
//  Created by gm on 2019/6/26.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQContentDrawAttStrVideoViewFactory: NSObject, SQContentDrawAttStrViewFactoryProtocol{
    func getDrawAttStrViewProtocol(idStr: String, dispLink: String, fileLink: String, audioName: String, size: CGSize,handel: SQContentDrawAttStrViewCallBack?) -> SQContentDrawAttStrViewProtocol {
        return SQContentDrawAttStrVideoView.init(frame: CGRect.zero, idStr, dispLink, fileLink, handel)
    }
}



class SQContentDrawAttStrVideoView: SQDrawAttStrView,SQContentDrawAttStrViewProtocol {
    
    enum event: Int {
        case larger = 1
        case download = 2
    }
    
    var callBack: SQContentDrawAttStrViewCallBack?
    var eventCallBack: ((SQContentDrawAttStrVideoView, SQContentDrawAttStrVideoView.event)-> ())?
    var dispLink: String!
    var fileLink: String!
    var originalLink: String!
    var idStr: String!
    var status = 0
    
    lazy private var playImageView: UIImageView = {
        let playImageView   = UIImageView()
        playImageView.image = "home_play".toImage()
        playImageView.contentMode = .center
        return playImageView
    }()
    
    init(frame: CGRect,_ idStrTemp: String,_ dispLink: String, _ fileLink: String,_ handel: SQContentDrawAttStrViewCallBack?) {
        super.init(frame: frame)
        
        let defaultWidth   = draw_stt_str_default_height
        idStr              = "video:" + idStrTemp
        callBack           = handel
        self.dispLink           = dispLink
        self.fileLink           = fileLink
    
        weak var weakSelf = self
        aniImageView.sq_setImage(with: dispLink.toOriginalPath(), imageType: .video, placeholder: k_image_ph_loading, backGroundColor: k_color_line_light) { (image, url, type, stage, error) in
            if (error != nil) {
                return
            }
            
            if stage == .finished {
                weakSelf?.aniImageView.contentMode = .scaleAspectFill
            }
        }
        
        let itemSizeWidth = defaultWidth-4
        let itemSize = CGSize.init(
            width: itemSizeWidth,
            height: itemSizeWidth / 1.67
        )
        
        aniImageView.frame = CGRect.init(
            origin: CGPoint.init(x: 0, y: 10),
            size: itemSize)
        
        setSize(size: CGSize.init(
            width: defaultWidth,
            height: aniImageView.height() + 20
        ))
        
        playImageView.frame              = aniImageView.frame
        aniImageView.addRounded(corners: .allCorners, radii: k_corner_radiu_size, borderWidth: 0.7, borderColor: UIColor.clear)
        isUserInteractionEnabled = false
        addSubview(playImageView)
    }
    
    func startPlayVideo(handel: @escaping SQContentDrawAttStrViewCallBack) {
        callBack = handel
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func listeningEvent(events:[SQContentDrawAttStrVideoView.event], handel: @escaping ((SQContentDrawAttStrVideoView, SQContentDrawAttStrVideoView.event)-> ())) {
        eventCallBack = handel
        let viewLarginImageWH: CGFloat = 40
        var viewLarginImageX = aniImageView.maxX()  - viewLarginImageWH
        let viewLarginImageY = aniImageView.maxY() - viewLarginImageWH
        for index in 0..<events.count {
            let subEvent = events[index]
            let itemBtn = getVideoBtn(event: subEvent)
            
            itemBtn.frame = CGRect.init(
                x: viewLarginImageX,
                y: viewLarginImageY,
                width: viewLarginImageWH,
                height: viewLarginImageWH
            )
            
            viewLarginImageX -= (viewLarginImageWH + 1)
            
            ///最右边的添加右下圆角
            if index == 0 {
              itemBtn.addRounded(corners: [.bottomRight], radii: CGSize.init(width: 4, height: 4), borderWidth: 0, borderColor: UIColor.clear)
            }
            
            ///最左边的添加左上圆角
            if index == events.count - 1 {
                itemBtn.addRounded(corners: [.topLeft], radii: CGSize.init(width: 4, height: 4), borderWidth: 0, borderColor: UIColor.clear)
            }
            
            addSubview(itemBtn)
        }
    }
    
    private func getVideoBtn(event: SQContentDrawAttStrVideoView.event) -> UIButton {
        
        var imageName = ""
        switch event {
        case .larger:
            imageName = "sq_video_largin_image"
        case .download:
            imageName = "sq_video_download"
        }
        
        let viewLarginBtn = UIButton()
        viewLarginBtn.setImage(
            imageName.toImage(),
            for: .normal
        )
        viewLarginBtn.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        viewLarginBtn.tag = event.rawValue
        viewLarginBtn.addTarget(self, action: #selector(viewLarginImage(btn:)), for: .touchUpInside)
        return viewLarginBtn
    }
    
    @objc private func viewLarginImage(btn: UIButton) {
        if (eventCallBack != nil) {
            eventCallBack!(
                self,
                SQContentDrawAttStrVideoView.event.init(rawValue: btn.tag) ?? .larger
            )
        }
    }
    
    @objc private func tapClick() {
        if (callBack != nil) {
            callBack!(self)
        }
    }
}
