//
//  SQSettingAcountViewController.swift
//  SheQu
//
//  Created by gm on 2019/6/5.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQSettingAcountViewController: SQViewController {
    lazy var tableHeaderView: UIView = {
        let tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: 10))
        tableHeaderView.backgroundColor = k_color_line_light
        return tableHeaderView
    }()
    
    lazy var modelArray = SQSettingAcountViewModel.getSettingAcountViewModelArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView(frame: view.bounds)
        tableView.rowHeight       = 60
        tableView.separatorStyle  = .none
        tableView.tableHeaderView = tableHeaderView
        tableView.backgroundColor  = k_color_line_light
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "个人资料"
        tableView.reloadData()
    }
    
    
}

extension SQSettingAcountViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 5){
            let accountModel = SQAccountModel.getAccountModel()
            let labelH = accountModel.personal_profile.calcuateLabSizeHeight(font: UIFont.systemFont(ofSize: 14), maxWidth: 223)
            var rowH = labelH + 40
            if(rowH < 60){
                rowH = 60
            }
            return rowH
        }else{
            return tableView.rowHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isAniImage = indexPath.row == 0 ? true : false
        let isBrief = indexPath.row == 5 ? true : false
        let cell: SQSettingAcountTableViewCell = SQSettingAcountTableViewCell.init(style: .default, reuseIdentifier: nil, isAniImage: isAniImage, isBrief:isBrief)
        
        let model = modelArray[indexPath.row]
        cell.titleLabel.text = model.title
        let accountModel = SQAccountModel.getAccountModel()
        
        if indexPath.row != 5{
            let lineView = UIView.init(frame: CGRect.init(x: 20, y: 59.5, width: k_screen_width - 20, height: k_line_height))
            lineView.backgroundColor = k_color_line
            cell.addSubview(lineView)
        }
        
        if indexPath.row == 0 {
            cell.aniImageView.sq_yysetImage(with: accountModel.head_url, placeholder: k_image_ph_account)

        }else if indexPath.row == 1{
            cell.valueLabel.text = accountModel.account == "" ? "未填写" : accountModel.account
        }else if indexPath.row == 2{
            cell.valueLabel.text = accountModel.home_address == "" ? "未知星球" : accountModel.home_address
        }
        else if indexPath.row == 3{
            cell.valueLabel.text = accountModel.career == "" ? "未填写" : accountModel.career
        }
        else if indexPath.row == 4{
            cell.valueLabel.text = accountModel.trade == "" ? "未填写" : accountModel.trade
        }else if indexPath.row == 5{
            cell.valueLabel.text = accountModel.personal_profile == "" ? "未填写" : accountModel.personal_profile
            cell.valueLabel.textAlignment = .right
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = modelArray[indexPath.row]
        if model.vc is SQHomeAccountListVCViewController.Type {
            let vc = SQHomeAccountListVCViewController()
            vc.type =  .image
            vc.selectNum = 1
            weak var weakSelf = self
            
            ///根据云盘图片设置头像
            vc.callBack = { imageModelArray in
                let model = imageModelArray.last
                SQCloudNetWorkTool.changeHeadUrl(Int(model!.id), { (accountModel, statu, errorMessage) in
                    if (errorMessage != nil) {
                        if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: statu, handel: nil) {
                            return
                        }
                        
                        return
                    }
                    
                    SQAccountModel.updateAccountModel(accountModel)
                    weakSelf?.tableView.reloadData()
                })
            }
            navigationController?.pushViewController(vc, animated: true)
        }else {
            let  vc = model.vc.init() as! SQChangeProfileVC
            if(indexPath.row == 1){
                vc.type = .account
            }else if(indexPath.row == 2){
                vc.type = .home_address
            }else if(indexPath.row == 3){
                vc.type = .career
            }else if(indexPath.row == 4){
                vc.type = .trade
            }else if(indexPath.row == 5){
                vc.type = .personal_profile
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

struct SQSettingAcountViewModel {
    var title = ""
    var vc    = UIViewController.self
    
    static func getSettingAcountViewModelArray() -> [SQSettingAcountViewModel] {
    
     let model1 = SQSettingAcountViewModel.init(title: "头像", vc: SQHomeAccountListVCViewController.self)
        
     let model2 = SQSettingAcountViewModel.init(title: "昵称", vc: SQChangeProfileVC.self)
    
     let model3 = SQSettingAcountViewModel.init(title: "现居地", vc: SQChangeProfileVC.self)

     let model4 = SQSettingAcountViewModel.init(title: "职位", vc: SQChangeProfileVC.self)

     let model5 = SQSettingAcountViewModel.init(title: "行业", vc: SQChangeProfileVC.self)

     let model6 = SQSettingAcountViewModel.init(title: "个人简介", vc: SQChangeProfileVC.self)
        return [model1,model2,model3,model4,model5,model6]
    }
}
