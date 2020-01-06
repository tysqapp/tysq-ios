//
//  SQTextField.swift
//  SheQu
//
//  Created by gm on 2019/4/23.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit


class SQLoginTextField: SQTextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        initSubViews()
    }
    
    func initSubViews() {
        backgroundColor = UIColor.colorRGB(0xedf3f8)
        let attributesDict =  [
            NSAttributedString.Key.foregroundColor:k_color_title_gray_blue
        ]
        
        self.attributedPlaceholder = NSAttributedString.init(
            string:self.placeholder ?? "",
            attributes: attributesDict
        )
        
        self.returnKeyType   = .done
        self.delegate        = self
    }
    
}

extension SQLoginTextField: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done {
            textField.endEditing(true)
        }
        
        return true
    }
    
}
