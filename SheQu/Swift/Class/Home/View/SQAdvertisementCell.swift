//
//  SQAdvertisementCellTableViewCell.swift
//  SheQu
//
//  Created by iMac on 2019/10/31.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQAdvertisementCell: UITableViewCell {
    static let cellID = "SQAdvertisementCellTableViewCellID"
    static let cellID1 = "SQAdvertisementCellTableViewCellID1"
    static let cellID2 = "SQAdvertisementCellTableViewCellID2"
    static let cellID3 = "SQAdvertisementCellTableViewCellID3"
    weak var vc: UIViewController? {
        didSet {
            adView.viewController = vc
        }
    }
    var url = "" {
        didSet {
            adView.urlString = url
        }
    }
    
    
    lazy var adView: SQAdvertisementView = {
        let adView = SQAdvertisementView(frame: CGRect.zero, vc: vc)
        adView.backgroundColor = .green
        return adView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(adView)
        backgroundColor = .red
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        adView.frame = bounds
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
