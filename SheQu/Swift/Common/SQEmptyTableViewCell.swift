//
//  SQEmptyTableViewCell.swift
//  SheQu
//
//  Created by gm on 2019/6/5.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQEmptyTableViewCell: UITableViewCell {
    static let cellID = "SQEmptyTableViewCellID"
    
    private var emptyView: SQEmptyView?
    
    init(style: UITableViewCell.CellStyle,
         reuseIdentifier: String?,
         cellType: SQEmptyTableViewCellType) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle  = .none
        emptyView = SQEmptyView.init(frame: CGRect.zero, cellType: cellType)
        addSubview(emptyView!)
        addLayout()
    }
    
    func addLayout(){
        emptyView?.snp.makeConstraints({ (maker) in
            maker.centerX.equalTo(snp.centerX)
            maker.centerY.equalTo(snp.centerY)
            maker.height.equalTo(snp.height)
            maker.width.equalTo(snp.width)
        })
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
