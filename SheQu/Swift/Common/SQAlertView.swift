//
//  SQAlertView.swift
//  SheQu
//
//  Created by gm on 2019/6/12.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
typealias SQAlertViewCallBack = ((Int,String,String) -> ())
class SQAlertView: NSObject {
    
    static let sharedInstance: SQAlertView = {
        let instance = SQAlertView()
        return instance
    }()
    
    fileprivate var callBack: SQAlertViewCallBack?
    
    func showAlertView(
        title: String,
        message: String,
        cancel: String,
        sure: String,
        placeholder1: String = "",
        placeholder2: String = "",
        tf1Str: String = "",
        tf2Str: String = "",
        alertViewStyle: UIAlertViewStyle = .default,
        handel: @escaping SQAlertViewCallBack) {
        callBack = handel
        let alertView = UIAlertView.init(title: title, message: message, delegate: self, cancelButtonTitle: cancel, otherButtonTitles: sure)
        alertView.alertViewStyle = alertViewStyle
        switch alertViewStyle {
        case .default:
            break
        case .secureTextInput:
            let tf = alertView.textField(at: 0)
            tf?.placeholder = placeholder1
            tf?.text = tf1Str
        case .plainTextInput:
            let tf = alertView.textField(at: 0)
            tf?.text = tf1Str
            tf?.placeholder = placeholder1
            tf?.clearButtonMode = .always
        case .loginAndPasswordInput:
            let tf1 = alertView.textField(at: 0)
            tf1?.placeholder = placeholder1
            tf1?.text = tf1Str
            let tf2 = alertView.textField(at: 1)
            tf2?.text = tf2Str
            tf2?.placeholder = placeholder2
        @unknown default:
            break
        }
        alertView.show()
    }
}

extension SQAlertView: UIAlertViewDelegate {
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        guard let tf1 = alertView.textField(at: 0) else {
            callBack!(buttonIndex,"","")
            return
        }
        
        guard let tf2 = alertView.textField(at: 1) else {
            callBack!(buttonIndex,tf1.text ?? "","")
            return
        }
        callBack!(buttonIndex,tf1.text ?? "",tf2.text ?? "")
    }
    
}
