//
//  SQArticleInfoRewardCell.swift
//  SheQu
//
//  Created by iMac on 2019/11/11.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQArticleInfoRewardCell: UITableViewCell {
    static let cellID = "SQArticleInfoRewardCellID"
    var rewardModelArr = [SQRewardItemModel]() {
        didSet {
            if rewardModelArr.count == 0 {
                rewardNumLabel.isHidden = true
                line1.isHidden = true
                line2.isHidden = true
            } else {
                rewardNumLabel.isHidden = false
                line1.isHidden = false
                line2.isHidden = false
            }
            rewardNumLabel.text = "\(rewardModelArr.count.getShowString()) 人打赏"
            collectionView.reloadData()
        }
    }
    var rewardClickCallback: (()->())?
    weak var vc: UIViewController?
    lazy var article_id = ""
    
    lazy var rewardBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("打赏", for: .normal)
        btn.backgroundColor = k_color_normal_red
        btn.setSize(size: CGSize.init(width: 120, height: 40))
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(rewardClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: k_screen_width / 5, height: k_screen_width / 5)
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(SQArticleRewardCollectionViewCell.self, forCellWithReuseIdentifier: SQArticleRewardCollectionViewCell.cellID)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    lazy var rewardNumLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "\(rewardModelArr.count.getShowString()) 人打赏"
        label.font = k_font_title_12
        label.textColor = k_color_black
        return label
    }()
    
    lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = k_color_line
        return line
    }()
    
    lazy var line1: UIView = {
        let line = UIView()
        line.backgroundColor = k_color_line
        return line
    }()
    
    lazy var line2: UIView = {
        let line = UIView()
        line.backgroundColor = k_color_line
        return line
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(rewardBtn)
        addSubview(rewardNumLabel)
        addSubview(line)
        addSubview(line1)
        addSubview(line2)
        addSubview(collectionView)
        addLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func addLayout() {
        rewardBtn.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.width.equalTo(120)
            $0.height.equalTo(40)
            $0.top.equalTo(snp.top).offset(30)
        }
        
        rewardNumLabel.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.top.equalTo(rewardBtn.snp.bottom).offset(32)
            
        }
        
        line.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.top.equalTo(snp.top)
            $0.left.equalTo(snp.left).offset(20)
            $0.right.equalTo(snp.right).offset(-20)
        }
        
        line1.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.width.equalTo(50)
            $0.centerY.equalTo(rewardNumLabel.snp.centerY)
            $0.right.equalTo(rewardNumLabel.snp.left).offset(-10)
        }
        
        line2.snp.makeConstraints {
            $0.height.equalTo(0.5)
            $0.width.equalTo(50)
            $0.centerY.equalTo(rewardNumLabel.snp.centerY)
            $0.left.equalTo(rewardNumLabel.snp.right).offset(10)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(rewardNumLabel.snp.bottom).offset(6)
            $0.left.equalTo(snp.left)
            $0.right.equalTo(snp.right)
            $0.bottom.equalTo(snp.bottom)
        }
        
    }
    
    @objc func rewardClick() {
        guard let callback = rewardClickCallback else { return }
        callback()
    }
    
}

extension SQArticleInfoRewardCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rewardModelArr.count > 5 ? 5 : rewardModelArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 4 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SQArticleRewardCollectionViewCell.cellID, for: indexPath) as! SQArticleRewardCollectionViewCell
            cell.iconImageView.image = "sq_more_rewards".toImage()
            cell.iconImageView.addRounded(corners: .allCorners, radii: CGSize(width: 25, height: 25), borderWidth: 0, borderColor:.white)
            cell.messageLabel.text = ""
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SQArticleRewardCollectionViewCell.cellID, for: indexPath) as! SQArticleRewardCollectionViewCell
        cell.model = rewardModelArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            let rewardListVC = SQRewardListVC()
            rewardListVC.article_id = article_id
            vc?.navigationController?.pushViewController(rewardListVC, animated: true)
            return
        }
        
        let rewarderID = rewardModelArr[indexPath.row].rewarder_id
        let personalVC = SQPersonalVC()
        personalVC.accountID = rewarderID
        vc?.navigationController?.pushViewController(personalVC, animated: true)
    }
    
    
    
}

//------------------------collectionViewCell--------------------------
class SQArticleRewardCollectionViewCell: UICollectionViewCell {
    static let cellID = "SQArticleRewardCollectionViewCellID"
    var model: SQRewardItemModel? {
        didSet {
            messageLabel.text = "赏\(model!.amount)金币"
            iconImageView.sq_yysetImage(with: model!.head_url, placeholder: k_image_ph_account)
            
            iconImageView.addRounded(corners: .allCorners, radii: CGSize(width: 25, height: 25), borderWidth: 0, borderColor:.white)
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
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = k_color_black
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconImageView)
        addSubview(messageLabel)
        addLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLayout() {
        iconImageView.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.top.equalTo(snp.top).offset(10)
            $0.width.equalTo(35)
            $0.height.equalTo(35)
        }
        
        messageLabel.snp.makeConstraints {
            $0.centerX.equalTo(snp.centerX)
            $0.top.equalTo(iconImageView.snp.bottom).offset(10)
        }
        
    }
    
}
