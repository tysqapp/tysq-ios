//
//  SQHomeTopArticleListCell.swift
//  SheQu
//
//  Created by iMac on 2019/11/12.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQHomeTopArticleListCell: UITableViewCell {
    static let cellID = "SQHomeTopArticleListCellID"

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        return titleLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        addLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLayout() {
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(snp.left).offset(20)
            $0.right.equalTo(snp.right).offset(-20)
            $0.top.equalTo(snp.top).offset(20)
            
        }
        
    }
    
}
