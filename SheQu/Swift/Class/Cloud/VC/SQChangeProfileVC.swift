//
//  SQChangeAddressVC.swift
//  SheQu
//
//  Created by iMac on 2019/9/11.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

enum AccountInfoChangeType: String {
    case account = "account"
    case home_address = "home_address"
    case career = "career"
    case trade = "trade"
    case personal_profile = "personal_profile"
}

class SQChangeProfileVC: SQViewController {
    var vcTitle = ""
    
    var type:AccountInfoChangeType?{
        didSet{
            
            switch type! {
            case .account:
                vcTitle = "设置昵称"
                break
                
            case .home_address:
                vcTitle = "设置现居地"
                break
                
            case .career:
                vcTitle = "设置职位"
                break
                
            case .trade:
                vcTitle = "设置行业"
                break
                
            case .personal_profile:
                vcTitle = "设置简介"
                break
            }
        }
    }
    
    
    /// 完成按钮
    lazy var publishBtn: SQDisableBtn = {
        let publishBtn = SQDisableBtn.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 30), enabled: true)
        publishBtn.setTitle("完成", for: .normal)
        publishBtn.titleLabel?.font = k_font_title
        publishBtn.setBtnBGImage()
        publishBtn.addTarget(self, action: #selector(changeBtnClick), for: .touchUpInside)
        return publishBtn
    }()
    
    lazy var tableHeaderView: UIView = {
        let tableHeaderView = UIView()
        tableHeaderView.backgroundColor = k_color_line_light
        return tableHeaderView
    }()
    
    lazy var changeBgView: UIView = {
        let tableHeaderView = UIView()
        tableHeaderView.backgroundColor = UIColor.white
        return tableHeaderView
    }()
    
    lazy var changeTextField: UITextField = {
        let changeTextField = UITextField()
        changeTextField.clearButtonMode = .always
        changeTextField.returnKeyType   = .done
        changeTextField.delegate        = self
        changeTextField.addTarget(self, action: #selector(tfEditeChange), for: .editingChanged)
        let accountModel = SQAccountModel.getAccountModel()
        
        switch type! {
        case .home_address:
            changeTextField.placeholder = "未知星球"
            changeTextField.text = accountModel.home_address
            break
            
        case .account:
            changeTextField.placeholder = "未填写"
            changeTextField.text = accountModel.account
            break
            
        case .career:
            changeTextField.placeholder = "未填写"
            changeTextField.text = accountModel.career
            break
            
        case .trade:
            changeTextField.placeholder = "未填写"
            changeTextField.text = accountModel.trade
            break
            
            
        case .personal_profile:
            break
        }
        
        return changeTextField
    }()
    
    lazy var changeTextView: SQPlaceholderTextView = {
       let tv = SQPlaceholderTextView(frame: CGRect(x: 0, y: tableHeaderView.maxY(), width: k_screen_width, height: 90), placeholder: "未填写", limit: 50, textContainerInset: TextContainerInset(top: 10, left: 20, bottom: 10, right: 20))
        let accountModel = SQAccountModel.getAccountModel()
        tv.textView.text = accountModel.personal_profile
        tv.checkShowHiddenPlaceholder()
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = k_color_line_light
        view.addSubview(tableHeaderView)
        view.addSubview(changeBgView)
        
        if((type!) != .personal_profile){
            view.addSubview(changeTextField)
        }else{
            view.addSubview(changeTextView)
        }
        
        

        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: publishBtn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = vcTitle
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableHeaderView.frame = CGRect.init(x: 0, y: k_nav_height, width: k_screen_width, height: 10)
        
        if((type!) != .personal_profile){
            changeBgView.frame  = CGRect.init(x: 0, y: tableHeaderView.maxY(), width: k_screen_width, height: 50)
            changeTextField.frame = CGRect.init(x: 20, y: tableHeaderView.maxY(), width: k_screen_width - 40, height: 50)
        }else{
            changeTextView.frame = CGRect.init(x: 0, y: tableHeaderView.maxY(), width: k_screen_width, height: 90)
        }
        
    }
    
    @objc func tfEditeChange() {
        if changeTextField.text!.count == 0 {
            if type! == .account{
                publishBtn.isEnabled = false
            }
            
        }else{
            publishBtn.isEnabled = true
        }
        
        publishBtn.setBtnBGImage()
    }
    
    @objc func changeBtnClick(){
        if !publishBtn.isEnabled {
            return
        }
        
        weak var weakSelf = self
        var value:String = ""
        if(type! == .personal_profile){
            value = changeTextView.textView.text
        }else{
            value = changeTextField.text!
        }
        
        SQCloudNetWorkTool.changeAccountName(value, type!) { (accountModel, statu, errorMessage) in
            
            if (errorMessage != nil) {
                if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: statu, handel: nil) {
                    return
                }
                
                SQEmptyView.showUnNetworkView(statu: statu, handel: { (isClick) in
                    if isClick {
                        weakSelf?.changeBtnClick()
                    }else{
                        weakSelf?.navigationController?.popViewController(animated: true)
                    }
                })
                return
            }
            
            SQAccountModel.updateAccountModel(accountModel)
            weakSelf?.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension SQChangeProfileVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    
    
}


