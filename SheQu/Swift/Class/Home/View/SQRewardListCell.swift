//
//  SQRewardListCell.swift
//  SheQu
//
//  Created by iMac on 2019/11/11.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQRewardListCell: UITableViewCell {
    static let cellID = "SQRewardListCellID"
    weak var vc: UIViewController?
    var model: SQRewardItemModel? {
        didSet {
            messageLabel.text = "打赏\(model!.amount)金币"
            iconImageView.sq_yysetImage(with: model!.head_url, placeholder: k_image_ph_account)
            
            iconImageView.addRounded(corners: .allCorners, radii: CGSize(width: 25, height: 25), borderWidth: 0, borderColor:.white)
            timeLabel.text = "\(model!.rewarded_at.formatStr("yyyy-MM-dd HH:mm"))"
        }
    }
    
    ///用户头像
    lazy var iconImageView: SQAniImageView = {
        let iconImageView = SQAniImageView()
        iconImageView.setSize(size: CGSize.init(
            width: 35,
            height: 35
        ))
        iconImageView.contentMode = .scaleAspectFill
        return iconImageView
    }()
    ///打赏信息
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = k_font_title_weight
        label.textColor = k_color_black
        return label
    }()
    
    ///时间标签
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font      = UIFont.systemFont(ofSize: 11)
        timeLabel.textColor = k_color_title_gray_blue
        timeLabel.textAlignment = .left
        return timeLabel
    }()
    
    lazy var iconBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(clickOnIcon), for: .touchUpInside)
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(iconImageView)
        addSubview(messageLabel)
        addSubview(timeLabel)
        addSubview(iconBtn)
        addLayout()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLayout() {
        iconImageView.snp.makeConstraints {
            $0.centerY.equalTo(snp.centerY)
            $0.left.equalTo(snp.left).offset(20)
            $0.width.equalTo(35)
            $0.height.equalTo(35)
        }
        
        messageLabel.snp.makeConstraints {
            $0.centerY.equalTo(snp.centerY)
            $0.left.equalTo(iconImageView.snp.right).offset(15)
            $0.right.equalTo(timeLabel.snp.left).offset(-5)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(snp.centerY)
            $0.right.equalTo(snp.right).offset(-20)
            
        }
        
        iconBtn.snp.makeConstraints {
            $0.center.equalTo(iconImageView.snp.center)
            $0.width.equalTo(iconImageView.snp.width)
            $0.height.equalTo(iconImageView.snp.height)
        }
        
        
    }
    
    @objc func clickOnIcon() {
        guard let rewarderID = model?.rewarder_id else { return }
        let personalVC = SQPersonalVC()
        personalVC.accountID = rewarderID
        vc?.navigationController?.pushViewController(personalVC, animated: true)
    }

}
