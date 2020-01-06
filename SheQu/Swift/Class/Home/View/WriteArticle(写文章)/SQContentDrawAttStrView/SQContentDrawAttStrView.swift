//
//  SQContentDrawAttStrView.swift
//  SheQu
//
//  Created by gm on 2019/5/15.
//  Copyright © 2019 sheQun. All rights reserved.
//

//import UIKit
//import YYWebImage
//class SQContentDrawAttStrView: UIView {
//    lazy var aniImageView: YYAnimatedImageView = {
//        let aniImageView = YYAnimatedImageView()
//        aniImageView.contentMode = .center
//        addSubview(aniImageView)
//        bringSubviewToFront(aniImageView)
//        return aniImageView
//    }()
//
//    lazy var playImageView: UIImageView = {
//        let playImageView   = UIImageView()
//        playImageView.image = UIImage.init(named: "home_play")
//        playImageView.contentMode = .center
//        addSubview(playImageView)
//        bringSubviewToFront(playImageView)
//        return playImageView
//    }()
//
//    lazy var idLabel: UILabel = {
//        let idLabel = UILabel()
//        idLabel.frame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 20, height: 20))
//        addSubview(idLabel)
//        idLabel.isHidden = true
//        return idLabel
//    }()
//
//    lazy var nameLabel: UILabel = {
//        let nameLabel = UILabel.init()
//        nameLabel.font = k_font_title_weight
//        nameLabel.textColor = k_color_black
//        addSubview(nameLabel)
//        return nameLabel
//    }()
//
//    lazy var startTimeLabel: UILabel = {
//        let startTimeLabel = UILabel.init()
//        startTimeLabel.font = k_font_title_11
//        startTimeLabel.textColor = k_color_title_gray_blue
//        addSubview(startTimeLabel)
//        return startTimeLabel
//    }()
//
//    lazy var endTimeLabel: UILabel = {
//        let endTimeLabel = UILabel.init()
//        endTimeLabel.font = k_font_title_11
//        endTimeLabel.textColor = k_color_title_gray_blue
//        endTimeLabel.textAlignment = .right
//        addSubview(endTimeLabel)
//        return endTimeLabel
//    }()
//
//    lazy var linkUrl = ""
//
//    lazy var progressView: SQSlider = {
//        let progressView = SQSlider()
//        progressView.isUserInteractionEnabled = false
//        progressView.maximumTrackTintColor = UIColor.colorRGB(0xd4e1eb)
//        progressView.minimumTrackTintColor = k_color_title_gray_blue
//        progressView.thumbTintColor        = k_color_title_gray_blue
//        let imageSize = CGSize.init(width: 10, height: 10)
//        let image = UIImage.imageFromColor(
//            color: k_color_title_gray_blue,
//            viewSize: imageSize
//            ).roundImage(cornerRadi: 5)
//
//        progressView.setThumbImage(image, for: .normal)
//        addSubview(progressView)
//        return progressView
//    }()
//
//    var playerTool: SQIJKPlayerTool?
//    lazy var isStartProgress = false
//    var callBack:((SQContentDrawAttStrView) -> ())?
//
//    class func getDrawImageAttStrView(id: Int, imageUrl: String,handel:@escaping ((SQContentDrawAttStrView,Bool)->())) {
//        let defaultWidth = k_screen_width - 40
//        let drawAttStrViewTemp = SQContentDrawAttStrView()
//        drawAttStrViewTemp.idLabel.text = "img:\(id)"
//        drawAttStrViewTemp.setSize(size: CGSize.init(width: defaultWidth, height: defaultWidth / 1.67))
//        drawAttStrViewTemp.aniImageView.image = UIImage.init(named: "home_cloud_img_ph")
//        drawAttStrViewTemp.aniImageView.frame = drawAttStrViewTemp.bounds
//        drawAttStrViewTemp.aniImageView.contentMode = .center
//        drawAttStrViewTemp.layer.borderWidth = k_corner_boder_with
//        drawAttStrViewTemp.layer.borderColor = k_color_line.cgColor
//        drawAttStrViewTemp.layer.cornerRadius = k_corner_radiu
//        handel(drawAttStrViewTemp,false)
//
//        let drawAttStrView = SQContentDrawAttStrView()
//        let url = URL.init(string: imageUrl)
//        drawAttStrView.idLabel.text = "img:\(id)"
//        drawAttStrView.aniImageView.yy_setImage(with: url, placeholder: UIImage.init(named: "home_cloud_img_ph")) { (image, url, type, state, errorMessage) in
//            var tempImage = image
//            if image == nil {
//                tempImage = UIImage.init(named: "home_cloud_img_ph")
//            }
//
//            var height = tempImage!.size.height
//            var width  = tempImage!.size.width
//            if width > defaultWidth {//判断图片是否过大
//                let scale = defaultWidth / width
//                width  = defaultWidth
//                height = height * scale
//            }
//
//            drawAttStrView.aniImageView.image = tempImage
//            drawAttStrView.aniImageView.contentMode = .scaleAspectFill
//            let imageViewX = (defaultWidth - width) * 0.5
//            drawAttStrView.aniImageView.frame = CGRect.init(x: imageViewX, y: 10, width: width, height: height)
//            drawAttStrView.aniImageView.layer.cornerRadius = k_corner_radiu
//            drawAttStrView.aniImageView.layer.masksToBounds = true
//            drawAttStrView.setSize(size: CGSize.init(width: defaultWidth, height: height + 20))
//            //drawAttStrView.backgroundColor = UIColor.blue
//            handel(drawAttStrView,true)
//        }
//    }
//
//    class func getDrawVideoAttStrView(id: Int, imageUrl: String,needHandel: Bool = true) -> SQContentDrawAttStrView{
//        let defaultWidth = k_screen_width - 40
//        let drawAttStrView = SQContentDrawAttStrView()
//        let url = URL.init(string: imageUrl)
//        drawAttStrView.aniImageView.yy_setImage(with: url, placeholder: UIImage.init(named: "home_cloud_img_ph"))
//        drawAttStrView.aniImageView.contentMode = .scaleAspectFill
//        drawAttStrView.aniImageView.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 10), size: CGSize.init(width: defaultWidth, height: defaultWidth / 1.67))
//        drawAttStrView.idLabel.text = "video:\(id)"
//        drawAttStrView.setSize(size: CGSize.init(width: defaultWidth, height: drawAttStrView.aniImageView.height() + 20))
//        drawAttStrView.playImageView.frame = drawAttStrView.aniImageView.frame
//        drawAttStrView.aniImageView.layer.cornerRadius  = k_corner_radiu
//        drawAttStrView.aniImageView.layer.masksToBounds = true
//        return drawAttStrView
//    }
//
//
//    class func getDrawAudioAttStrView(_ id: Int32, _ duration: Int64,_ nameStr: String,needHandel: Bool = true) -> SQContentDrawAttStrView {
//        let defaultWidth = k_screen_width - 40
//        let drawAttStrViewFrame = CGRect.init(
//            x: 20,
//            y: 0,
//            width: defaultWidth,
//            height: 80
//        )
//
//        let drawAttStrView = SQContentDrawAttStrView.init(frame: drawAttStrViewFrame)
//
//        let contentViewFrame = CGRect.init(
//            x: 0,
//            y: 7,
//            width: defaultWidth,
//            height: 66
//        )
//
//        let contentView    = UIView.init(frame: contentViewFrame)
//        ///添加contentView是为了加背景色和
//        drawAttStrView.addSubview(contentView)
//
//        let centerY = drawAttStrView.centerY()
//        let aniImageViewH: CGFloat = 54
//        let drawAttStrViewY = (drawAttStrView.height() - aniImageViewH) * 0.5
//        drawAttStrView.aniImageView.frame = CGRect.init(
//            x: 10,
//            y: drawAttStrViewY,
//            width: aniImageViewH,
//            height: aniImageViewH
//        )
//        drawAttStrView.aniImageView.image = UIImage.init(named: "home_audio_play")
//
//        drawAttStrView.idLabel.text       = "audio:\(id)"
//        let contentX            = drawAttStrView.aniImageView.maxX() + 7
//        let progressViewW       = defaultWidth - contentX - 20
//        let progressViewH: CGFloat = 10
//
//        drawAttStrView.progressView.frame  = CGRect.init(
//            x: contentX,
//            y: 0,
//            width: progressViewW,
//            height: progressViewH
//        )
//
//        drawAttStrView.progressView.setCenterY(centerY: centerY + 5)
//
//        let labelH: CGFloat = 25
//        drawAttStrView.nameLabel.frame = CGRect.init(
//            x: contentX,
//            y:drawAttStrView.progressView.top() - labelH,
//            width: drawAttStrView.progressView.width(),
//            height: labelH
//        )
//        drawAttStrView.nameLabel.text = nameStr
//
//        drawAttStrView.startTimeLabel.text = "00:00"
//        drawAttStrView.startTimeLabel.frame = CGRect.init(
//            x: contentX,
//            y: drawAttStrView.progressView.maxY() - 4,
//            width: 50,
//            height: labelH
//        )
//
//        drawAttStrView.endTimeLabel.frame = CGRect.init(
//            x: drawAttStrView.progressView.maxX() - 50,
//            y: drawAttStrView.startTimeLabel.top(),
//            width: 50,
//            height: labelH
//        )
//
//        drawAttStrView.endTimeLabel.text = drawAttStrView.getTimeStr(Int(duration))
//
//        contentView.backgroundColor     = UIColor.colorRGB(0xf5f5f5)
//        contentView.layer.cornerRadius  = k_corner_radiu
//        contentView.layer.masksToBounds = true
//        return drawAttStrView
//    }
//
//    func createPlayToolByUrlStr(urlStr: String) {
//        weak var weakSelf = self
//        self.playerTool = SQIJKPlayerTool.init(url: URL.init(string: urlStr)!, callBack: { (player) in
//            weakSelf?.updateUI()
//        })
//
//        aniImageView.isUserInteractionEnabled = true
//        progressView.isUserInteractionEnabled = true
//        progressView.callBack = { isStartProgress in
//            if isStartProgress {
//                weakSelf?.progressViewTouchUpInSide()
//            }else{
//                weakSelf?.progressViewTouchUpOutSide()
//            }
//        }
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(playBtnClick))
//        aniImageView.addGestureRecognizer(tap)
//    }
//
//   @objc func playBtnClick() {
//    if (callBack != nil) {
//        callBack!(self)
//    }
//     self.playerTool?.play()
//   }
//
//    @objc func updateUI() {
//        if self.playerTool == nil {
//            return
//        }
//        if self.playerTool!.player.isPlaying() {
//            aniImageView.image = UIImage.init(named: "home_audio_play")
//        }else{
//           aniImageView.image = UIImage.init(named: "home_audio_pause")
//        }
//
//        var currentValue = 0
//        if isStartProgress {
//            currentValue = Int(progressView.value)
//        }else{
//            currentValue = Int(self.playerTool!.player.currentPlaybackTime + 0.5)
//        }
//
//        var duration: Int = 0
//        if self.playerTool!.player.duration.isNaN {
//            duration = 0
//        }else{
//            duration = Int(self.playerTool!.player.duration)
//        }
//        startTimeLabel.text = getTimeStr(Int(currentValue))
//        endTimeLabel.text   = "\(getTimeStr(duration))"
//        progressView.maximumValue = Float(self.playerTool!.player.duration)
//        progressView.value        = Float(currentValue)
//
//        if !self.playerTool!.player.isPlaying() {
//            return
//        }
//        perform(#selector(updateUI), with: nil, afterDelay: 0.5)
//    }
//    @objc func progressViewTouchUpInSide() {
//        isStartProgress = true
//
//        //self.playerTool?.pause()
//    }
//    @objc func progressViewTouchUpOutSide() {
//        isStartProgress = false
//        self.playerTool?.player.currentPlaybackTime = TimeInterval(progressView.value)
//
//        //self.playerTool?.play()
//    }
////    @objc func progressViewChange() {
////        self.progressView.value
////    }
//
//    func getTimeStr(_ time: Int) -> String{
//        let min = time / 60
//        let sec = time % 60
//        return String.init(format: "%02d:%02d", min,sec)
//    }
//
//    func removePlayerTool() {
//        playerTool?.removePlayer()
//    }
//}
