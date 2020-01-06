//
//  SQTextField.swift
//  SheQu
//
//  Created by gm on 2019/4/23.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQTextField: UITextField {
    lazy var isNeedNotiSecret = true
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
