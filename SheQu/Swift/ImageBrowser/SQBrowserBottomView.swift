//
//  SQBrowserBottomView.swift
//  SheQu
//
//  Created by gm on 2019/9/3.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
fileprivate struct SQItemStruct {
    
    ///bottom
    static let bottom: CGFloat = SQBrowserBottomView.height - numberLabelH
    
    ///numberLabel
    static let numberLabelH: CGFloat = 40
    static let numberLabelW: CGFloat = 40
    static let numberLabelX: CGFloat = 20
    
    ///lookOriginImageBtn
    static let lookOriginImageBtnW: CGFloat = 100
    static let lookOriginImageBtnH: CGFloat = 40
    
    ///downloadBtn
    static let downloadBtnW: CGFloat = 40
    static let downloadBtnH: CGFloat = 40
    static let downloadBtnRight: CGFloat = -20
    
}

class SQBrowserBottomView: UIView {
    
    enum Event {
        case lookOriginImage
        case saveImage
    }
    
    static let height = 60 + k_bottom_h
    
    var eventCallBack:((SQBrowserBottomView.Event) -> ())?
    
    private lazy var numberLabel: UILabel = {
        let numberLabel                = UILabel()
        numberLabel.backgroundColor    = k_color_black
        numberLabel.textColor          = UIColor.white
        numberLabel.font               = k_font_title
        numberLabel.textAlignment      = .center
        numberLabel.setSize(size: CGSize.init(
            width: SQItemStruct.numberLabelW,
            height: SQItemStruct.numberLabelH
        ))
        
        numberLabel.layer.masksToBounds = true
        numberLabel.layer.cornerRadius = 4
        return numberLabel
    }()
    
    private lazy var lookOriginImageBtn: UIButton = {
        let lookOriginImageBtn = UIButton()
        lookOriginImageBtn.backgroundColor = k_color_black
        lookOriginImageBtn.layer.cornerRadius = 4
        lookOriginImageBtn.setTitle("查看原图", for: .normal)
        lookOriginImageBtn.titleLabel?.font = k_font_title
        lookOriginImageBtn.addTarget(
            self,
            action: #selector(lookOriginImageBtnClick),
            for: .touchUpInside
        )
        
        return lookOriginImageBtn
    }()
    
    private lazy var downloadBtn: UIButton = {
        let downloadBtn = UIButton()
        downloadBtn.backgroundColor = k_color_black
        downloadBtn.setImage(
            UIImage.init(named: "sq_image_browser_download"),
            for: .normal
        )
        
        downloadBtn.imageView?.contentMode = .center
        downloadBtn.layer.cornerRadius = 4
        downloadBtn.addTarget(self, action: #selector(downloadBtnClick), for: .touchUpInside)
        return downloadBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(numberLabel)
        addSubview(lookOriginImageBtn)
        addSubview(downloadBtn)
        addLayout()
    }
    
    private func addLayout() {
        
        numberLabel.snp.makeConstraints { (maker) in
            maker.height.equalTo(SQItemStruct.numberLabelH)
            maker.width.equalTo(SQItemStruct.numberLabelW)
            maker.left.equalTo(snp.left)
                .offset(SQItemStruct.numberLabelX)
            maker.top.equalTo(snp.top)
        }
        
        lookOriginImageBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(snp.centerX)
            maker.bottom.equalTo(numberLabel.snp.bottom)
            maker.height
                .equalTo(SQItemStruct.lookOriginImageBtnH)
            maker.width
                .equalTo(SQItemStruct.lookOriginImageBtnW)
        }
        
        downloadBtn.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(numberLabel.snp.bottom)
            maker.height.equalTo(SQItemStruct.downloadBtnH)
            maker.width.equalTo(SQItemStruct.downloadBtnW)
            maker.right.equalTo(snp.right)
                .offset(SQItemStruct.downloadBtnRight)
        }

    }
    
    @objc private func lookOriginImageBtnClick() {
        let title: String = lookOriginImageBtn.titleLabel?.text ?? ""
        if title.hasPrefix("加载中") || title.hasPrefix("加载完成") {
            return
        }
        
        if (eventCallBack != nil) {
            eventCallBack!(.lookOriginImage)
        }
    }
    
    @objc private func downloadBtnClick() {
        if (eventCallBack != nil) {
            eventCallBack!(.saveImage)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setNumberLabelText(_ currentIndex: Int, total: Int) {
        numberLabel.isHidden = total == 1
        numberLabel.text = "\(currentIndex)/\(total)"
    }
    
    open func updateSate(_ imageState: SQBrowserImageViewItem.State) {
        var title = "查看原图"
        var btnIsHidden = false
        var downLoadBtnIsHidden = true
        switch imageState {
        case .loadBlurredImage:
            title = "加载中..."
            break
        case .loadBlurredComplete:
            downLoadBtnIsHidden = false
            break
        case .loadBlurredFailed:
            title = "重新加载"
            break
        case .loadOriginalImage:
            title = "加载中..."
        case .loadOriginalComplete:
            title = "加载完成"
            btnIsHidden = true
            downLoadBtnIsHidden = false
        case .loadOriginalFailed:
            title = "重新加载"
            break
        }
        
        lookOriginImageBtn.setTitle(title, for: .normal)
        
        downloadBtn.isHidden = downLoadBtnIsHidden
        if imageState == .loadOriginalComplete {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.lookOriginImageBtn.isHidden = btnIsHidden
            }
        }else{
           lookOriginImageBtn.isHidden = btnIsHidden
        }
    }
}

