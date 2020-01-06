//
//  SQNotiSettingVC.swift
//  SheQu
//
//  Created by gm on 2019/8/27.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQNotiSettingVC: SQViewController{
    
    var notiSettingModels = [SQNotiSettingModel]()
    var isModerator = SQAccountModel.getAccountModel().is_moderator
    /// 完成按钮
    lazy var publishBtn: SQDisableBtn = {
        let publishBtn = SQDisableBtn.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 30), enabled: true)
        publishBtn.setTitle("完成", for: .normal)
        publishBtn.titleLabel?.font = k_font_title
        publishBtn.setBtnBGImage()
        publishBtn.addTarget(
            self,
            action: #selector(changedatasourceBtnClick),
            for: .touchUpInside
        )
        
        return publishBtn
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "设置"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: publishBtn)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView(frame: view.bounds, needGroup: true)
        tableView.backgroundColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        tableView.separatorStyle = .none
        tableView.sectionFooterHeight = 0
        tableView.register(SQNotificationSettingTableViewCell.self, forCellReuseIdentifier: SQNotificationSettingTableViewCell.cellID)
        getSettingFromNet()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    @objc func changedatasourceBtnClick(){
        saveSettingToNet()
    }
    
    
    private func addLayout(){
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.bottom.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
        
    }

}

extension SQNotiSettingVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notiSettingModels[section].subSettingModels.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return notiSettingModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SQNotificationSettingTableViewCell.cellID, for: indexPath) as! SQNotificationSettingTableViewCell
        cell.notiModel = notiSettingModels[indexPath.section].subSettingModels[indexPath.row]
        if(indexPath.row == (notiSettingModels[indexPath.section].subSettingModels.count - 1)){
            cell.gapView.removeFromSuperview()
        }
        
        cell.selectCallBack = { [weak self]isSel in
            self?.notiSettingModels[indexPath.section].subSettingModels[indexPath.row].isSel = isSel
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = notiSettingCellHeadView()
        header.title.text = notiSettingModels[section].title
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !isModerator && (section == 2 || section == 1){
            return 0
        }
        
        return 30
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if !isModerator && (indexPath.section == 2 || indexPath.section == 1){
            return 0
        }
        
        return 50
    }
    
    
    
}

extension SQNotiSettingVC {
    
    func getSettingFromNet() {
        SQCloudNetWorkTool.getNotiConfig { [weak self] (model, status, errorMessage) in
            if errorMessage != nil {
                return
            }
            
            self?.notiSettingModels = SQNotiSettingModel.getNotiSettingModel(settingFromNet: model!)
            self?.tableView.reloadData()
        }
        
    }
    
    func saveSettingToNet() {
        let settingFromNetModel = SQNotiSettingFromNetModel()
        settingFromNetModel.article_reviewed_system = notiSettingModels[0].subSettingModels[0].isSel
        settingFromNetModel.article_reviewed_email = notiSettingModels[0].subSettingModels[1].isSel
        settingFromNetModel.article_review_system =  notiSettingModels[1].subSettingModels[0].isSel
        settingFromNetModel.article_review_email =  notiSettingModels[1].subSettingModels[1].isSel
        settingFromNetModel.report_handler_system = notiSettingModels[2].subSettingModels[0].isSel
        settingFromNetModel.report_handler_email = notiSettingModels[2].subSettingModels[1].isSel
        settingFromNetModel.report_handled_system = notiSettingModels[3].subSettingModels[0].isSel
        settingFromNetModel.new_comment_system = notiSettingModels[4].subSettingModels[0].isSel
        settingFromNetModel.new_reply_system = notiSettingModels[5].subSettingModels[0].isSel

        SQCloudNetWorkTool.updateNotiConfig(notiSetting: settingFromNetModel) { [weak self](model, status, errorMessage) in
            if errorMessage != nil {
                return
            }
            
            self?.navPop()
        }
        
                
    }
    
}

//SectionHeader
class notiSettingCellHeadView: UIView {
    var title:UILabel = {
        let title = UILabel()
        title.font = k_font_title
        title.textColor = UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        return title
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.init(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        addSubview(title)
        addLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLayout(){
        title.snp.makeConstraints { (make) in
            make.left.equalTo(snp.left).offset(20)
            make.centerY.equalTo(snp.centerY)
        }
    }
}
