//
//  SQReportCellTableViewCell.swift
//  SheQu
//
//  Created by iMac on 2019/9/16.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQReportCell: UITableViewCell {

    static let cellID = "SQReportCellID"
    
    
    lazy var selectBtn: UIButton = {
        let selectBtn = UIButton()
        selectBtn.setImage(UIImage.init(named: "sq_audit_sel"), for: .selected)
        selectBtn.setImage(UIImage.init(named: "sq_audit_unSel"), for: .normal)
        selectBtn.isSelected = false
        selectBtn.isUserInteractionEnabled = false
        
        return selectBtn
    }()
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(selectBtn)
        addLayout()
    }
    private func addLayout() {
        selectBtn.snp.makeConstraints {
            $0.centerY.equalTo(snp.centerY)
            $0.right.equalTo(snp.right).offset(-20)
            $0.size.equalTo(CGSize(width: 16, height: 16))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            selectBtn.isSelected = true
        }else{
            selectBtn.isSelected = false
        }
        
        
    }
    


}
