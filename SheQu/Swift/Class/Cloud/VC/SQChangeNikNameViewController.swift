//
//  SQChangeNikNameViewController.swift
//  SheQu
//
//  Created by gm on 2019/6/5.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQChangeNikNameViewController: SQViewController {
    
    /// 完成按钮
    lazy var publishBtn: SQDisableBtn = {
        let publishBtn = SQDisableBtn.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 30), enabled: true)
        publishBtn.setTitle("完成", for: .normal)
        publishBtn.titleLabel?.font = k_font_title
        publishBtn.setBtnBGImage()
        publishBtn.addTarget(self, action: #selector(changeNikeNameBtnClick), for: .touchUpInside)
        return publishBtn
    }()
    
    lazy var tableHeaderView: UIView = {
        let tableHeaderView = UIView()
        tableHeaderView.backgroundColor = k_color_line_light
        return tableHeaderView
    }()
    
    lazy var nikeNameBgView: UIView = {
        let tableHeaderView = UIView()
        tableHeaderView.backgroundColor = UIColor.white
        return tableHeaderView
    }()
    
    lazy var nikeNameTF: UITextField = {
        let nikeNameTF = UITextField()
        nikeNameTF.clearButtonMode = .always
        nikeNameTF.returnKeyType   = .done
        nikeNameTF.delegate        = self
        let accountModel           = SQAccountModel.getAccountModel()
        nikeNameTF.text            = accountModel.account
        nikeNameTF.addTarget(self, action: #selector(tfEditeChange), for: .editingChanged)
        return nikeNameTF
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = k_color_line_light
        view.addSubview(tableHeaderView)
        view.addSubview(nikeNameBgView)
        view.addSubview(nikeNameTF)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: publishBtn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "设置昵称"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableHeaderView.frame = CGRect.init(x: 0, y: k_nav_height, width: k_screen_width, height: 20)
        nikeNameBgView.frame  = CGRect.init(x: 0, y: tableHeaderView.maxY(), width: k_screen_width, height: 60)
        nikeNameTF.frame = CGRect.init(x: 20, y: tableHeaderView.maxY(), width: k_screen_width - 40, height: 60)
    }
    
    @objc func tfEditeChange() {
        if nikeNameTF.text!.count == 0 {
            publishBtn.isEnabled = false
        }else{
            publishBtn.isEnabled = true
        }
        
        publishBtn.setBtnBGImage()
    }
    
    @objc func changeNikeNameBtnClick(){
        if !publishBtn.isEnabled {
            return
        }
        
        weak var weakSelf = self
        SQCloudNetWorkTool.changeAccountName(nikeNameTF.text!, .account) { (accountModel, statu, errorMessage) in
            
            if (errorMessage != nil) {
                if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: statu, handel: nil) {
                    return
                }
                
                SQEmptyView.showUnNetworkView(statu: statu, handel: { (isClick) in
                    if isClick {
                        weakSelf?.changeNikeNameBtnClick()
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

extension SQChangeNikNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
