//
//  SQEmptyCollectionViewCell.swift
//  SheQu
//
//  Created by gm on 2019/6/20.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQEmptyCollectionViewCell: UICollectionViewCell {
    static let cellID = "SQEmptyCollectionViewCellID"
    private var emptyView: SQEmptyView?
    var cellType: SQEmptyTableViewCellType? {
        didSet{
            
            if (cellType == nil) {
                return
            }
            
            emptyView = SQEmptyView.init(frame: CGRect.zero, cellType: cellType!)
            addSubview(emptyView!)
            addLayout()
        }
    }
    
    func addLayout(){
        emptyView?.snp.makeConstraints({ (maker) in
            maker.centerX.equalTo(snp.centerX)
            maker.centerY.equalTo(snp.centerY)
            maker.height.equalTo(snp.height)
            maker.width.equalTo(snp.width)
        })
    }
}
