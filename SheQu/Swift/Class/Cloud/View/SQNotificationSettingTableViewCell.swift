//
//  SQNotificationSettingTableViewCell.swift
//  SheQu
//
//  Created by iMac on 2019/9/9.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQNotificationSettingTableViewCell: UITableViewCell {
    var notiModel: SQSubNotiSettingModel? {
        didSet{
            if notiModel == nil {
                return
            }
            
            titleLabel.text = notiModel?.subTitle
            switchBtn.isOn = notiModel!.isSel
        }
    }
    
    var selectCallBack: ((Bool)->())?
    
    static let cellID = "SQNotificationSettingTableViewCellID"
    
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.font = k_font_title
        return label
    }()
    
    lazy var switchBtn:UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = k_color_normal_blue
        sw.addTarget(self, action: #selector(tapSwitchBtn), for: .valueChanged)
        return sw
    }()
    
    lazy var gapView:UIView = {
        let gv = UIView()
        gv.backgroundColor = k_color_line
        return gv
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
       // super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        addSubview(switchBtn)
        addSubview(gapView)
        addLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func tapSwitchBtn(){
        //SQNotiSettingNotiTool.updateNotiIsSel(isSel: switchBtn.isOn, type: notiModel!.udKeyType)
        if let callBack = selectCallBack {
            callBack(switchBtn.isOn)
        }
        
    }
    
    private func addLayout(){
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(20)
            make.centerY.equalTo(snp.centerY)
        }
        
        switchBtn.snp.makeConstraints { (make) in
            make.right.equalTo(snp.right).offset(-21)
            make.centerY.equalTo(snp.centerY)
        }
        
        gapView.snp.makeConstraints { (make) in
            make.height.equalTo(k_line_height)
            make.right.equalTo(snp.right)
            make.left.equalTo(snp.left).offset(20)
            make.bottom.equalTo(snp.bottom)
        }
    }
    
    
}
