//
//  SQChangePasswordViewController.swift
//  SheQu
//
//  Created by gm on 2019/6/5.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQChangePasswordViewController: SQViewController {
    static let rowH: CGFloat = 60
    lazy var placeHolderArray = [
        "请输入旧密码",
        "请输入新密码,不少于6位",
        "请再次输入密码,不少于6位"
    ]
    
    lazy var tfArray = [SQTextField]()
    
    lazy var tableHeaderView: UIView = {
        let tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: 10))
        tableHeaderView.backgroundColor = k_color_line_light
        return tableHeaderView
    }()
    
    lazy var submitBtn =  UIButton()
    
    lazy var tableFooterView: UIView = {
        let rowTotleH = SQChangePasswordViewController.rowH * CGFloat(placeHolderArray.count)
        let viewH = k_screen_height - rowTotleH - tableHeaderView.height() - k_bottom_h - k_nav_height
        let tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: viewH))
        
        let submitBtnH: CGFloat = SQChangePasswordViewController.rowH
        let submitBtnY: CGFloat = 100
        submitBtn.frame = CGRect.init(x: 20, y: submitBtnY, width: k_screen_width - 40, height: submitBtnH)
        
        tableFooterView.addSubview(submitBtn)
        submitBtn.layer.cornerRadius = k_corner_radiu
        submitBtn.titleLabel?.font   = k_font_title
        submitBtn.setTitle("确定", for: .normal)
        submitBtn.addTarget(self, action: #selector(submitBtnClick), for: .touchUpInside)
        submitBtn.isEnabled = false
        submitBtn.backgroundColor = k_color_line
        submitBtn.updateBGColor()
        tableFooterView.backgroundColor = k_color_line_light
        return tableFooterView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView(frame: view.bounds)
        tableView.tableHeaderView = tableHeaderView
        tableView.tableFooterView = tableFooterView
        tableView.rowHeight       = SQChangePasswordViewController.rowH
        tableView.register(
            SQChangePasswordTableViewCell.self,
            forCellReuseIdentifier: SQChangePasswordTableViewCell.cellID
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "修改密码"
    }
    
    deinit {
        
    }
}

extension SQChangePasswordViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeHolderArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SQChangePasswordTableViewCell = tableView.dequeueReusableCell(withIdentifier: SQChangePasswordTableViewCell.cellID) as! SQChangePasswordTableViewCell
        cell.passwordTF.addTarget(self, action: #selector(tfValueChange), for: .editingChanged)
        tfArray.append(cell.passwordTF)
        
        cell.passwordTF.attributedPlaceholder = NSAttributedString.init(string: placeHolderArray[indexPath.row], attributes: [NSAttributedString.Key.font: k_font_title])
        return cell
    }
    
    @objc func tfValueChange() {
        var tag = 0
        for tf in tfArray {
            if tf.text!.count > 0 {
                tag += 1
            }
        }
        
        if tag == placeHolderArray.count {
            submitBtn.isEnabled = true
        }else{
           submitBtn.isEnabled = false
        }
        
        submitBtn.updateBGColor()
    }
    
    @objc func submitBtnClick(){
        
        for tf in tfArray {
            let validation = SQLoginTool.validationPassword(tf.text!)
            if !validation.0 {
                return
            }
        }
        
        let tf1 = tfArray[0]
        let tf2 = tfArray[1]
        let tf3 = tfArray[2]
        if tf2.text != tf3.text {
            showToastMessage("新密码和重复密码不一致!")
            return
        }
        
        weak var weakSelf = self
        SQCloudNetWorkTool.changePassword(tf1.text!, tf2.text!) { (model, statu, errorMessage) in
            if errorMessage != nil {
                if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: statu, handel: nil) {
                    return
                }
                return
            }
            
            weakSelf!.navigationController?
                .popViewController(animated: true)
        }
        
    }
}
