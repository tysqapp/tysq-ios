//
//  SQChangePasswordTableViewCell.swift
//  SheQu
//
//  Created by gm on 2019/6/5.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQChangePasswordTableViewCell: UITableViewCell {
    static let cellID = "SQChangePasswordTableViewCellID"
    lazy var passwordTF: SQTextField = {
        let passwordTF = SQTextField()
        passwordTF.delegate = self
        passwordTF.addRightSecretBtn(false)
        passwordTF.returnKeyType = .done
        return passwordTF
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        passwordTF.frame = CGRect.init(x: 20, y: 0, width: k_screen_width - 40, height: 60)
        addSubview(passwordTF)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SQChangePasswordTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
}
