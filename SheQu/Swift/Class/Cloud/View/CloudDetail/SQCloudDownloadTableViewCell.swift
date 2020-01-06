//
//  SQCloudDownloadTableViewCell.swift
//  SheQu
//
//  Created by gm on 2019/10/30.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    
    static let iconImageViewWH: CGFloat = 40
    
    static let downloadBtnWH: CGFloat = 30
    
    static let progressViewWH: CGFloat = 40
}

class SQCloudDownloadTableViewCell: UITableViewCell {
    static let cellID = "SQCloudDownloadTableViewCellID"
    static let rowHeight: CGFloat = 90
    private var urlID = ""
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.setSize(size: CGSize.init(
            width: SQItemStruct.iconImageViewWH,
            height: SQItemStruct.iconImageViewWH
        ))
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.addRounded(corners: .allCorners, radii: k_corner_radiu_size, borderWidth: 1, borderColor: UIColor.clear)
        return iconImageView
    }()
    
    lazy var iconCoverView: UIView = {
        let iconCoverView = UIView()
        iconCoverView.isUserInteractionEnabled = false
        iconCoverView.setSize(size: CGSize.init(width: 40, height: 40))
        iconCoverView.layer.borderWidth  = 0.5
        iconCoverView.layer.borderColor  = k_color_line.cgColor
        iconCoverView.layer.cornerRadius = k_corner_radiu
        return iconCoverView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 2
        nameLabel.font          = k_font_title_weight
        nameLabel.textColor     = k_color_title_black
        return nameLabel
    }()
    
    lazy var timeLable: UILabel = {
        let timeLable = UILabel()
        timeLable.font         = k_font_title_11
        timeLable.textColor    = k_color_title_gray
        return timeLable
    }()
    
    /// 进度条
    lazy var progressView: SQCircleProgressView = {
        let progressView = SQCircleProgressView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        progressView.progerWidth = 3.0
        progressView.percentageFontSize = 12
        progressView.progerssBackgroundColor = k_color_line_light
        progressView.progerssColor = UIColor.colorRGB(0x33C037)
        progressView.percentFontColor = UIColor.clear
        progressView.progress = 0
        return progressView
    }()
    
    lazy var tipsLabel: UILabel = {
        let tipsLabel = UILabel()
        tipsLabel.textAlignment = .right
        tipsLabel.font = k_font_title_11
        tipsLabel.text = "0%"
        return tipsLabel
    }()
    
    lazy var downloadBtn: UIButton = {
        let downloadBtn = UIButton()
        
        downloadBtn.setImage(
            "sq_cloud_download_play".toImage(),
            for: .normal
        )
        
        downloadBtn.setImage(
            "sq_cloud_download_pause".toImage(),
            for: .selected
        )
        
        downloadBtn.addTarget(self, action: #selector(downloadBtnClick), for: .touchUpInside)
        return downloadBtn
    }()
    
    lazy var errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.isHidden = true
        errorLabel.textColor = UIColor.red
        errorLabel.font     = k_font_title_11_weight
        errorLabel.textAlignment = .right
        errorLabel.text     = "下载失败"
        return errorLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line
        return lineView
    }()
    
    var downloadItem: SQMutableDownloadItem?
    
    var downBtnCallBack: ((UIButton) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(iconCoverView)
        addSubview(iconImageView)
        addSubview(nameLabel)
        addSubview(timeLable)
        addSubview(progressView)
        addSubview(tipsLabel)
        addSubview(errorLabel)
        addSubview(downloadBtn)
        addSubview(lineView)
        addLayout()
    }
    
    private func addLayout() {
        let margin: CGFloat = 20
        iconImageView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(snp.centerY)
            maker.left.equalTo(snp.left).offset(margin)
            maker.width.height
                .equalTo(SQItemStruct.iconImageViewWH)
        }
        
        iconCoverView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(snp.centerY)
            maker.left.equalTo(snp.left).offset(margin)
            maker.width.height
                .equalTo(SQItemStruct.iconImageViewWH)
        }
        
        progressView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(snp.centerY)
            maker.right.equalTo(snp.right).offset(-20)
            maker.width.height
                .equalTo(SQItemStruct.progressViewWH)
        }
        
        tipsLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(progressView.snp.right).offset(-10)
            maker.top.equalTo(progressView.snp.bottom).offset(8)
        }
        
        errorLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(progressView.snp.right)
            maker.top.equalTo(snp.top)
            maker.bottom.equalTo(snp.bottom)
        }
        
        
        downloadBtn.snp.makeConstraints { (maker) in
            maker.center.equalTo(progressView.snp.center)
            maker.width.height
                .equalTo(SQItemStruct.downloadBtnWH)
        }
        
        nameLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(iconImageView.snp.top)
            maker.left.equalTo(iconImageView.snp.right)
                .offset(margin)
            maker.right.equalTo(progressView.snp.left)
            .offset(-20)
        }
        
        timeLable.snp.makeConstraints { (maker) in
            maker.top.equalTo(nameLabel.snp.bottom).offset(8)
            maker.left.equalTo(nameLabel.snp.left)
            maker.right.equalTo(nameLabel.snp.right)
        }
        
        lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(iconImageView.snp.left)
            maker.height.equalTo(k_line_height)
            maker.bottom.equalTo(snp.bottom)
            maker.right.equalTo(snp.right)
        }
    }
    
    func updataItem(_ item: SQMutableDownloadItem) {
        downloadItem = item
        item.delegate = self
        nameLabel.text = item.fileName
        progressView.progress = 0
        tipsLabel.text = "0%"
        let palceHolderName = SQAccountFileItemModel.getPlaceHolderName(type: item.mineType, filename: item.fileName )
        if item.mineType == "audio" || item.mineType == "other" {
            iconImageView.image = UIImage.init(named: palceHolderName)
            iconCoverView.isHidden = true
        }else{
            iconCoverView.isHidden = false
            let url = URL.init(string: item.dispPath.encodeURLCodeStr())
            iconImageView.yy_setImage(with: url, placeholder: palceHolderName.toImage())
        }
        
        timeLable.text = item.timeStr + "  " + getSizeStr()
        
        getCellStatus(item)
    }
    
    private func getSizeStr() -> String {
        
        if (downloadItem == nil) {
            return ""
        }
        
        let bValue = downloadItem!.totalValue / 1024
        
        if bValue < 1 {
            return "\(downloadItem!.totalValue)B"
        }
        
        let kbValue = downloadItem!.totalValue / 1048576
        if kbValue < 1 { //
           return String.init(format: "%.2fKB", Double(downloadItem!.totalValue) / 1024.0)
        }
        
        let mbValue = downloadItem!.totalValue / 1073741824
        if mbValue < 1 {
            return String.init(format: "%.2fMB", Double(downloadItem!.totalValue) / 1048576.0)
        }
        
        return String.init(format: "%.2fG", Double(downloadItem!.totalValue) / 1073741824.0)
    }
    
    private func getCellStatus(_ item: SQMutableDownloadItem) {
        
        ///完成
        if item.status >= 7 {
            downloadComplate()
            return
        }
        
        ///失败
        if item.status == 6 {
            downloadFailed()
            return
        }
        
        ///下载中
        if item.status == 2 {
            downloadIng()
            return
        }
        
        ///重新下载
        if item.status == 4 {
            downloadRetry(item.errorMessage)
            return
        }
        
        ///暂停
        downloadPause()
    }
    
    
    @objc private func downloadBtnClick() {
        if downloadBtn.isSelected {
            downloadItem?.totalPause()
        }else{
            downloadItem?.totalStart()
        }
    }
    
    private func downloadComplate() {
        downloadBtn.isHidden  = true
        progressView.isHidden = true
        errorLabel.isHidden   = true
        tipsLabel.isHidden    = true
        progressView.snp.updateConstraints {
            $0.width.equalTo(0)
        }
    }
    
    
    
    private func downloadIng() {
        downloadBtn.isSelected = true
        downloadBtn.isHidden  = false
        progressView.isHidden = false
        tipsLabel.isHidden    = false
        errorLabel.isHidden   = true
        tipsLabel.textColor   = UIColor.colorRGB(0x23AE19)
        updateProgress()
        progressView.snp.updateConstraints {
            $0.width.equalTo(SQItemStruct.progressViewWH)
        }
    }
    
    private func downloadFailed() {
        downloadBtn.isHidden = true
        progressView.isHidden = true
        errorLabel.isHidden   = false
        tipsLabel.isHidden    = true
    }
    
    private func downloadRetry(_ errorMessage: String) {
        downloadBtn.isHidden  = false
        downloadBtn.isSelected = false
        progressView.isHidden = false
        errorLabel.isHidden   = true
        tipsLabel.isHidden    = false
        tipsLabel.text        = errorMessage
        tipsLabel.textColor   = UIColor.red
        progressView.snp.updateConstraints {
            $0.width.equalTo(SQItemStruct.progressViewWH)
        }
    }
    
    private func downloadPause() {
        downloadBtn.isHidden  = false
        downloadBtn.isSelected = false
        progressView.isHidden = false
        errorLabel.isHidden   = true
        tipsLabel.isHidden    = false
        tipsLabel.textColor   = UIColor.colorRGB(0x23AE19)
        updateProgress()
        progressView.snp.updateConstraints {
            $0.width.equalTo(SQItemStruct.progressViewWH)
        }
    }
    
    private func updateProgress() {
        let progress = CGFloat(downloadItem?.complateValue ?? 0) / CGFloat(downloadItem?.totalValue ?? 1)
        
        if !progress.isNaN {
            progressView.progress = progress
            tipsLabel.text = "\(Int(progress * 100))%"
            if timeLable.text?.hasSuffix("0B") ?? false {
                timeLable.text = downloadItem!.timeStr + "  " + getSizeStr()
            }
            
        }
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


extension SQCloudDownloadTableViewCell: SQMutableDownloadItemDelegate {
    func downloadItemState(subItem: SQMutableDownloadItem, status: Int64) {
        DispatchQueue.main.async {
            self.getCellStatus(subItem)
        }
    }
    
    func downloadItemError(subItem: SQMutableDownloadItem, errorMessage: String?) {
        DispatchQueue.main.async {
            if subItem.status == 4 {
                self.downloadRetry(errorMessage ?? "下载失败")
                
            }
        
            if  subItem.status == 6 {
                self.downloadFailed()
            }
        }
    }
    
    func downloadItemSuccess(subItem: SQMutableDownloadItem) {
        
        DispatchQueue.main.async {
            self.downloadComplate()
            NotificationCenter.default.post(name: k_noti_download, object: nil)
        }
        
    }
    
    func downloadItemProgress(subItem: SQMutableDownloadItem, complateValue: Int64) {
        DispatchQueue.main.async {
            self.updateProgress()
        }
    }
    
    
}
