//
//  SQContentDrawAttStrAudioView.swift
//  SheQu
//
//  Created by gm on 2019/6/26.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQContentDrawAttStrAudioViewFactory: SQContentDrawAttStrViewFactoryProtocol{
    func getDrawAttStrViewProtocol(idStr: String, dispLink: String, fileLink: String, audioName: String, size: CGSize,handel: SQContentDrawAttStrViewCallBack?) -> SQContentDrawAttStrViewProtocol {
        return SQContentDrawAttStrAudioView.init(frame: CGRect.zero, idStr, dispLink, fileLink, audioName, handel)
    }
}

class SQContentDrawAttStrAudioView: SQDrawAttStrView ,SQContentDrawAttStrViewProtocol {
    
    static let nameLabelAttributed = [
        NSAttributedString.Key.foregroundColor: k_color_black,
        NSAttributedString.Key.font:k_font_title_weight
    ]
    
    static let loadingAttributed = NSMutableAttributedString.init(string: "  加载中......", attributes: [
        NSAttributedString.Key.foregroundColor: k_color_title_gray_blue,
        NSAttributedString.Key.font:k_font_title_11
        ])
    static let pauseAttributed = NSMutableAttributedString.init(string: "  待播放......", attributes: [
        NSAttributedString.Key.foregroundColor: k_color_title_gray_blue,
        NSAttributedString.Key.font:k_font_title_11
        ])
    
    static let errorAttributed = NSMutableAttributedString.init(string: "  加载失败", attributes: [
        NSAttributedString.Key.foregroundColor: UIColor.red,
        NSAttributedString.Key.font:k_font_title_11
        ])
    
    var callBack: SQContentDrawAttStrViewCallBack?
    
    var dispLink: String!
    var fileLink: String!
    var idStr: String!
    var audioName: String!
    lazy private var nameLabel: UILabel = {
        let nameLabel = UILabel.init()
        nameLabel.font = k_font_title_weight
        nameLabel.textColor = k_color_black
        addSubview(nameLabel)
        return nameLabel
    }()
    
    lazy private var startTimeLabel: UILabel = {
        let startTimeLabel = UILabel.init()
        startTimeLabel.font = k_font_title_11
        startTimeLabel.textColor = k_color_title_gray_blue
        addSubview(startTimeLabel)
        return startTimeLabel
    }()
    
    lazy private var endTimeLabel: UILabel = {
        let endTimeLabel = UILabel.init()
        endTimeLabel.font = k_font_title_11
        endTimeLabel.textColor = k_color_title_gray_blue
        endTimeLabel.textAlignment = .right
        addSubview(endTimeLabel)
        return endTimeLabel
    }()
    
    lazy private var progressView: SQSlider = {
        let progressView = SQSlider()
        progressView.isUserInteractionEnabled = false
        progressView.maximumTrackTintColor = UIColor.colorRGB(0xd4e1eb)
        progressView.minimumTrackTintColor = k_color_title_gray_blue
        progressView.thumbTintColor        = k_color_title_gray_blue
        let imageSize = CGSize.init(width: 10, height: 10)
        let image = UIImage.imageFromColor(
            color: k_color_title_gray_blue,
            viewSize: imageSize
            ).roundImage(cornerRadi: 5)
        
        progressView.setThumbImage(image, for: .normal)
        addSubview(progressView)
        return progressView
    }()
    
    lazy private var isStartProgress = false
    
    
    
    private var playerTool: SQIJKPlayerTool?
    
    init(frame: CGRect,_ idStrTemp: String,_ showLink: String,_ fileLink: String,_ audioName: String, _ handel: SQContentDrawAttStrViewCallBack?) {
        super.init(frame: frame)
        idStr              = "audio:" + idStrTemp
        callBack           = handel
        self.dispLink      = showLink
        self.fileLink      = fileLink
        self.audioName     = audioName
        
        let defaultWidth   = draw_stt_str_default_height
        let drawAttStrViewFrame = CGRect.init(
            x: 20,
            y: 0,
            width: defaultWidth,
            height: 80
        )
        
        self.frame = drawAttStrViewFrame
        
        let contentViewFrame = CGRect.init(
            x: 0,
            y: 7,
            width: defaultWidth,
            height: 66
        )
        
        let contentView    = UIView.init(frame: contentViewFrame)
        ///添加contentView是为了加背景色和
        addSubview(contentView)
        
        let centerY = self.centerY()
        let aniImageViewH: CGFloat = 54
        let drawAttStrViewY = (height() - aniImageViewH) * 0.5
        aniImageView.frame = CGRect.init(
            x: 10,
            y: drawAttStrViewY,
            width: aniImageViewH,
            height: aniImageViewH
        )
        aniImageView.image = UIImage.init(named: "home_audio_play")
        
        let contentX            = aniImageView.maxX() + 7
        let progressViewW       = defaultWidth - contentX - 20
        let progressViewH: CGFloat = 10
        
        progressView.frame  = CGRect.init(
            x: contentX,
            y: 0,
            width: progressViewW,
            height: progressViewH
        )
        
        progressView.setCenterY(centerY: centerY + 5)
        
        let labelH: CGFloat = 25
        nameLabel.frame = CGRect.init(
            x: contentX,
            y:progressView.top() - labelH,
            width:progressView.width(),
            height: labelH
        )
        nameLabel.text = audioName
        
        startTimeLabel.text = "00:00"
        startTimeLabel.frame = CGRect.init(
            x: contentX,
            y: progressView.maxY() - 4,
            width: 50,
            height: labelH
        )
        
        endTimeLabel.frame = CGRect.init(
            x: progressView.maxX() - 50,
            y: startTimeLabel.top(),
            width: 50,
            height: labelH
        )
        
        endTimeLabel.text = getTimeStr(Int(0))
        
        contentView.backgroundColor     = UIColor.colorRGB(0xf5f5f5)
        contentView.layer.cornerRadius  = k_corner_radiu
        contentView.layer.masksToBounds = true
        bringSubviewToFront(aniImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(audioName name: String?) {
        if (name == nil) {
            return
        }
        audioName      = name
        let nameAtt    = NSAttributedString.init(
            string: name!, attributes: SQContentDrawAttStrAudioView.nameLabelAttributed)
        let pauseAtt    =  SQContentDrawAttStrAudioView.pauseAttributed
        let attributedAtt = NSMutableAttributedString.init()
        attributedAtt.append(nameAtt)
        attributedAtt.append(pauseAtt)
        nameLabel.attributedText = attributedAtt
    }
    
    func updatePauseUi() {
        let nameAtt    = NSAttributedString.init(
            string: audioName, attributes: SQContentDrawAttStrAudioView.nameLabelAttributed)
        let loadAtt    =  SQContentDrawAttStrAudioView.loadingAttributed
        let attributedAtt = NSMutableAttributedString.init()
        attributedAtt.append(nameAtt)
        attributedAtt.append(loadAtt)
        nameLabel.attributedText = attributedAtt
    }
    
}


extension SQContentDrawAttStrAudioView {
    
    func createPlayToolByUrlStr(urlStr: String) {
        let urlStrTemp = urlStr.encodeURLCodeStr()
        guard let palyUrl = URL.init(string: urlStrTemp) else {
            return
        }
        
        weak var weakSelf = self
        self.playerTool = SQIJKPlayerTool.init(url: palyUrl, callBack: { (player) in
            weakSelf?.updateUI()
        })
        
        aniImageView.isUserInteractionEnabled = true
        progressView.isUserInteractionEnabled = true
        progressView.callBack = { isStartProgress in
            if isStartProgress {
                weakSelf?.progressViewTouchUpInSide()
            }else{
                weakSelf?.progressViewTouchUpOutSide()
            }
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(playBtnClick))
        aniImageView.addGestureRecognizer(tap)
    }
    
    @objc func playBtnClick() {
//        if endTimeLabel.text! == "00:00" {
//            SQToastTool.showToastMessage("请稍侯,\(nameLabel.text!)正在加载中...")
//            return
//        }
        if !(playerTool?.player.isPreparedToPlay)! {
            playerTool?.player.prepareToPlay()
            playerTool?.player.shouldAutoplay = true
            updatePauseUi()
            return
        }
        if !(playerTool?.player.isPlaying() ?? true) {
            if (callBack != nil) {
                callBack!(self)
            }
        }
        
        
        playerTool?.play()
        
    }
    
    ///刷新音频播放界面
    @objc func updateUI() {
        if self.playerTool == nil {
            return
        }
        if self.playerTool!.player.isPlaying() {
            aniImageView.image = UIImage.init(named: "home_audio_play")
        }else{
            aniImageView.image = UIImage.init(named: "home_audio_pause")
        }
        
        var currentValue = 0
        if isStartProgress {
            currentValue = Int(progressView.value)
        }else{
            currentValue = Int(self.playerTool!.player.currentPlaybackTime + 0.5)
        }
        
        var duration: Int = 0
        if self.playerTool!.player.duration.isNaN {
            duration = 0
        }else{
            duration = Int(self.playerTool!.player.duration)
        }
        
        if !playerTool!.isPlayError {
            if duration > 0 {
                nameLabel.text = audioName
            }
        }else{
            let nameAtt = NSMutableAttributedString.init(string: audioName, attributes: SQContentDrawAttStrAudioView.nameLabelAttributed)
            let errorAtt = SQContentDrawAttStrAudioView.errorAttributed
            nameAtt.append(errorAtt)
            nameLabel.attributedText = nameAtt
        }
        
        
        
        startTimeLabel.text = getTimeStr(Int(currentValue))
        endTimeLabel.text   = "\(getTimeStr(duration))"
        progressView.maximumValue = Float(duration)
        progressView.value        = Float(currentValue)
        
        if !self.playerTool!.player.isPlaying() {
            return
        }
        
        perform(#selector(updateUI), with: nil, afterDelay: 0.5)
    }
    
    
    @objc func progressViewTouchUpInSide() {
        isStartProgress = true
    }
    
    @objc func progressViewTouchUpOutSide() {
        isStartProgress = false
        self.playerTool?.player.currentPlaybackTime = TimeInterval(progressView.value)
    }
   
    private func getTimeStr(_ time: Int) -> String{
        let min = time / 60
        let sec = time % 60
        return String.init(format: "%02d:%02d", min,sec)
    }
    
    
    func manuelPause() {
        if playerTool?.player.isPlaying() ?? false {
            playerTool?.player.pause()
        }
    }
    
    func removePlayerTool() {
        DispatchQueue.main.async {
           self.playerTool?.removePlayer()
        }
        
    }
}
