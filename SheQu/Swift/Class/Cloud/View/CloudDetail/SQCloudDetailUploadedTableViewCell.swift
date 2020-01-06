//
//  SQCloudDetailUploadedTableViewCell.swift
//  SheQu
//
//  Created by gm on 2019/6/10.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQCloudDetailUploadedTableViewCell: UITableViewCell {
    static let cellID = "SQCloudDetailUploadedTableViewCellID"
    
    lazy var iconImageView: SQAniImageView = {
        let iconImageView = SQAniImageView()
        iconImageView.setSize(size: CGSize.init(width: 40, height: 40))
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
    
    lazy var upLoadCoverBtn: UIButton = {
        let upLoadCoverBtn = UIButton()
        upLoadCoverBtn.setBackgroundImage(UIImage.init(named: "sq_cloud_cover"), for: .normal)
        upLoadCoverBtn.addTarget(self, action: #selector(uploadCoverBtnClick), for: .touchUpInside)
        upLoadCoverBtn.setSize(size: CGSize.init(width: 40, height: 40))
        upLoadCoverBtn.addRounded(corners: .allCorners, radii: k_corner_radiu_size, borderWidth: 1, borderColor: UIColor.clear)
        return upLoadCoverBtn
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel       = UILabel()
        titleLabel.font      = SQAccountFileListFrame.titleLabelFont
        titleLabel.textColor = k_color_black
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel       = UILabel()
        timeLabel.font      = k_font_title_12
        timeLabel.textColor = k_color_title_gray_blue
        return timeLabel
    }()
    
    lazy var sizeLabel: UILabel = {
        let sizeLabel = UILabel()
        sizeLabel.font      = k_font_title_12
        sizeLabel.textColor = k_color_title_gray_blue
        return sizeLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line
        return lineView
    }()
    
    lazy var errorMessageLabel: UILabel = {
        let errorMessageLabel = UILabel()
        errorMessageLabel.textColor = UIColor.colorRGB(0xee0000)
        errorMessageLabel.font      = UIFont.systemFont(ofSize: 9)
        return errorMessageLabel
    }()
    
    lazy var uploadingLabel: UILabel = {
        let uploadingLabel = UILabel()
        uploadingLabel.text = "服务器上传中"
        uploadingLabel.textColor = UIColor.red
        uploadingLabel.font = k_font_title_12
        uploadingLabel.textAlignment = .right
        return uploadingLabel
    }()
    
    ///cell 回掉
    var callBack: ((_ currentMomdel:SQAccountFileItemModel,_ respondModel:SQAccountFileItemModel)->())?
    
    var videoCoverCallBack: ((SQAccountFileItemModel) -> ())?
    
    
    /// 进度条
    lazy var progressView: SQCircleProgressView = {
        let progressView = SQCircleProgressView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        progressView.progerWidth = 3.0
        progressView.percentageFontSize = 12
        progressView.progerssBackgroundColor = k_color_line_light
        progressView.progerssColor = UIColor.colorRGB(0x33C037)
        progressView.percentFontColor = UIColor.colorRGB(0x33C037)
        progressView.progress = 0
        return progressView
    }()
    
    var model: SQAccountFileItemModel? {
        didSet {
            if model == nil {
                return
            }
            
            let itemFrame       = model!.accountFileListFrame
            iconImageView.frame = itemFrame.iconImageViewFrame
            titleLabel.frame    = itemFrame.titleLabelFrame
            timeLabel.frame     = itemFrame.timeLabelFrame
            sizeLabel.frame     = itemFrame.sizeLabelFrame
            lineView.frame      = itemFrame.lineViewFrame
            iconCoverView.frame = itemFrame.iconImageViewFrame
            progressView.frame  = itemFrame.progressViewFrame
            progressView.isHidden = !model!.isUploadIng
            progressView.progress = model!.progress
            uploadingLabel.frame = itemFrame.uploadingLabelFrame
            uploadingLabel.isHidden = model!.storage == 3
            model?.delegate       = self
            let palceHolderName = SQAccountFileItemModel.getPlaceHolderName(type: model!.type, filename: model!.filename)
            let linkStr = model!.getShowImageLink()
            if model!.isUploadIng {
                if ((model?.iconImage) != nil) {
                    iconImageView.image = model!.iconImage
                }else{
                    iconImageView.image = UIImage.init(named: palceHolderName)
                }
            }else{
                if model!.type == "audio" || model!.type == "other" {
                    iconImageView.image = UIImage.init(named: palceHolderName)
                }else{
                   iconImageView.sq_yysetImage(with: linkStr, placeholder: UIImage.init(named: palceHolderName))
                }
            }
            
            if model?.type == "video" || model?.type == "image" {
                iconCoverView.isHidden = false
            }else{
                iconCoverView.isHidden = true
            }
            
            if model!.type == "video" && model!.isUploadIng == false {
                upLoadCoverBtn.frame    = iconImageView.frame
                upLoadCoverBtn.isHidden = false
            }else{
                upLoadCoverBtn.isHidden = true
            }
            
            if model!.isUploadIng {
                errorMessageLabel.isHidden = false
                errorMessageLabel.text     = model?.errorMessage
                if iconImageView.maxY() > timeLabel.maxY() {
                    errorMessageLabel.frame = CGRect.init(x: timeLabel.left(), y: iconImageView.maxY() + 3, width: titleLabel.width(), height: 10)
                }else{
                    errorMessageLabel.frame = CGRect.init(x: timeLabel.left(), y: timeLabel.maxY() + 3, width: titleLabel.width(), height: 10)
                }
            }else{
                errorMessageLabel.isHidden = true
            }
            
            titleLabel.text    = model?.filename
            timeLabel.text     = model!.create_at.formatStr("YYYY-MM-dd hh:mm")
            sizeLabel.text     = getSizeStr()
        }
    }
    
    
    func updateIconImageView(){
        iconImageView.sq_yysetImage(with: model!.getShowImageLink(), placeholder: UIImage.init(named: "sq_cloud_video"))
    }
    
    private func getSizeStr() -> String {
        
        let bValue = model!.size / 1024
        
        if bValue < 1 {
            return "\(model!.size)B"
        }
        
        let kbValue = model!.size / 1048576
        if kbValue < 1 { //
           return String.init(format: "%.2fKB", Double(model!.size) / 1024.0)
        }
        
        let mbValue = model!.size / 1073741824
        if mbValue < 1 {
            return String.init(format: "%.2fMB", Double(model!.size) / 1048576.0)
        }
        
        return String.init(format: "%.2fG", Double(model!.size) / 1073741824.0)
    }
    
    @objc private func uploadCoverBtnClick() {
        if (videoCoverCallBack != nil) {
            videoCoverCallBack!(model!)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(timeLabel)
        addSubview(sizeLabel)
        addSubview(lineView)
        addSubview(progressView)
        addSubview(upLoadCoverBtn)
        addSubview(errorMessageLabel)
        addSubview(iconCoverView)
        addSubview(uploadingLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SQCloudDetailUploadedTableViewCell: SQAccountFileListInfoDelegate {
    
    func accountFileListInfo(accountFileInfo: SQAccountFileItemModel, isFinish: Bool, resultModel: SQAccountFileItemModel?) {
        DispatchQueue.main.async {
            if self.sizeLabel.text == "0B" {
                self.sizeLabel.text = self.getSizeStr()
            }
            self.progressView.progress = accountFileInfo.progress
            if isFinish {
                if (self.callBack != nil) {
                    self.callBack!(accountFileInfo,resultModel!)
                }
            }
        }
    }
    
    func accountFileListInfoError(accountFileInfo: SQAccountFileItemModel, errorStatus: Int, errorMessage: String) {
        DispatchQueue.main.async {
            self.errorMessageLabel.text = errorMessage
            self.progressView.progress = 0
        }
    }
}


