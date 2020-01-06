//
//  SQCloudDataSourceVC.swift
//  SheQu
//
//  Created by gm on 2019/8/12.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQCloudDataSourceVC: SQViewController {
    static let ud_dataSourceHistories = "ud_datasource_histories"
    var histories = [String]()
    
    /// 完成按钮
    lazy var publishBtn: SQDisableBtn = {
        let publishBtn = SQDisableBtn.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 30), enabled: false)
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
    
    lazy var tableHeaderView: UIView = {
        let tableHeaderView = UIView()
        tableHeaderView.backgroundColor = .white
        let label = UILabel()
        label.text = "请输入您要访问的网站"
        label.textColor = k_color_title_gray
        label.font = k_font_title_12
        label.frame = CGRect.init(x: 20, y: 12, width: 300, height: 12)
        tableHeaderView.addSubview(label)
        return tableHeaderView
    }()
    
    lazy var datasourceBgView: UIView = {
        let tableHeaderView = UIView()
        tableHeaderView.backgroundColor = UIColor.white
        return tableHeaderView
    }()
    
    lazy var datasourceTF: UITextField = {
        let datasourceTF = UITextField()
        datasourceTF.clearButtonMode = .always
        datasourceTF.returnKeyType   = .done
        datasourceTF.delegate        = self
        datasourceTF.text            = SQHostStruct.getLoaclHost()
        datasourceTF.addTarget(
            self,
            action: #selector(tfEditeChange),
            for: .editingChanged
        )
        
        
        datasourceTF.backgroundColor = k_color_line_light
        datasourceTF.placeholder = "请输入网址"
        datasourceTF.layer.cornerRadius = 10
        datasourceTF.layer.borderColor = k_color_normal_blue.cgColor
        
        
        let leftView = UIView(frame: CGRect.init(x: 0, y: 0, width: 46, height: 16))
        let leftViewImg = UIImageView(image: UIImage.init(named: "sq_datasource_leftview"))
        leftViewImg.frame = CGRect.init(x: 15, y: 0, width: 16, height: 16)
        leftView.addSubview(leftViewImg)
        datasourceTF.leftView = leftView
        datasourceTF.leftViewMode = .always
        
        
        return datasourceTF
    }()
    
    lazy var isFirst = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableHeaderView)
        view.addSubview(datasourceBgView)
        view.addSubview(datasourceTF)
        addTableView(frame: CGRect.init(x: 0, y: k_nav_height + 106, width: k_screen_width, height: k_screen_height - k_nav_height - 106))
        tableView.backgroundColor = k_color_line_light
        tableView.register(SwitchSourceCell.self, forCellReuseIdentifier: SwitchSourceCell.cellID)
        tableView.isHidden = true
        tableView.backgroundColor = .white
        
        histories = UserDefaults.standard.stringArray(forKey: SQCloudDataSourceVC.ud_dataSourceHistories) ?? [String]()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "切换网站"
        if isFirst {
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: publishBtn)
            isFirst = false
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableHeaderView.frame = CGRect.init(
            x: 0,
            y: k_nav_height,
            width: k_screen_width,
            height: 36
        )
        
        datasourceBgView.frame  = CGRect.init(
            x: 0,
            y: tableHeaderView.maxY(),
            width: k_screen_width,
            height: 60
        )
        
        datasourceTF.frame = CGRect.init(
            x: 20,
            y: tableHeaderView.maxY(),
            width: k_screen_width - 40,
            height: 60
        )
    }
    
    @objc func tfEditeChange() {
        if datasourceTF.text!.count == 0 {
            publishBtn.isEnabled = false
        }else{
            publishBtn.isEnabled = true
        }
        
        publishBtn.setBtnBGImage()
    }
    
    @objc func changedatasourceBtnClick(){
        if !publishBtn.isEnabled {
            return
        }
        requestNetwork()
    }
    
    @objc func tfTouchOutside() {
        tableView.isHidden = true
    }
}

extension SQCloudDataSourceVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tableView.isHidden = false
        datasourceTF.layer.borderWidth = 0.5
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        datasourceTF.layer.borderWidth = 0
    }

}

extension SQCloudDataSourceVC {
    func requestNetwork() {
        var dataSourceText = datasourceTF.text!.toValidatedDataSource()
        if dataSourceText == "" {
            showToastMessage("请输入正确的网址!")
            return
        }
        if !datasourceTF.text!.hasPrefix(SQHostStruct.httpHead) {
            let httpArray = dataSourceText.components(separatedBy: "://")
            let domain = (httpArray.last)!.toValidatedDataSource()
            if domain == "" {
                showToastMessage("请输入正确的网址!")
                return
            }
            dataSourceText = SQHostStruct.httpHead + domain
        }
        
        handleHistories(history: dataSourceText)
        
        if dataSourceText == SQHostStruct.getLoaclHost() {
            let message = "当前正访问\(SQHostStruct.getLoaclHost())，不需要修改"
            datasourceTF.text = SQHostStruct.getLoaclHost()
            showToastMessage(message)
            return
        }
        

        
        tableView.reloadData()
        
        SQHostStruct.appendVersion(dataSourceText)
        weak var weakSelf = self
        SQHomeNewWorkTool.getCategory {
            (model, statu, errorMessage) in
            if (errorMessage != nil) {
                weakSelf?.showToastMessage("数据源不存在")
                SQHostStruct.updateLocalHost(
                    SQHostStruct.getLoaclHost()
                )
                
                return
            }
            
            UserDefaults.standard.set(-1, forKey: k_ud_Level1_sel_key)
            UserDefaults.standard.synchronize()
            SQAccountModel.clearLoginCache()
            SQCacheContainerTool.shareInstance.clearAllcaches()
            SQHostStruct.updateLocalHost(dataSourceText)
            SQHomeSubViewController.isFirst = true
            //AppDelegate.getAppDelegate().downLoadSessionManager.cache.update()
            weakSelf?.checkVersion()
        }
    }
    
    func checkVersion() {
        weak var weakSelf = self
        SQCheckUpdateNetworkTool.getVersion { (model, statu, errorString) in
            
            if (errorString != nil) {
                weakSelf?.jumpHomeVC()
                return
            }
            
            let updataState = model!.checkNeedUpdate()
            if updataState.forceUpdate || updataState.update {
                let _ =  SQShowUpdateAppView.init(frame: UIScreen.main.bounds, version: model!.latest_version, tipsArray: model!.new_features,isForce: updataState.forceUpdate, handel: { (showViewTemp) in
                    weakSelf?.jumpHomeVC()
                })
            }else{
                weakSelf?.jumpHomeVC()
            }
        }
    }
    
    func jumpHomeVC() {
        AppDelegate.goToHomeVC()
    }
}

///处理设置数据源历史缓存
extension SQCloudDataSourceVC {
    func handleHistories(history: String) {
        //添加搜索历史(去重)
        histories.removeAll { (his) -> Bool in
            his == history
        }
        
        histories.insert(history, at: 0)
        if(histories.count > 20) {
            histories.removeLast()
        }
        
        UserDefaults.standard.set(histories, forKey: SQCloudDataSourceVC.ud_dataSourceHistories)
        UserDefaults.standard.synchronize()
        
        
    }
    
}

extension SQCloudDataSourceVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SwitchSourceCell.cellID) as! SwitchSourceCell
        cell.historyLabel.text = histories[indexPath.row]
        cell.delBtnCallBack = { [weak self] in
            self?.histories.remove(at: indexPath.row)     
            self?.tableView.reloadData()
            UserDefaults.standard.set(self?.histories, forKey: SQCloudDataSourceVC.ud_dataSourceHistories)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        datasourceTF.text = histories[indexPath.row]
        datasourceTF.resignFirstResponder()
        tableView.cellForRow(at: indexPath)?.isSelected = false
        publishBtn.isEnabled = true
        publishBtn.setBtnBGImage()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 41
    }
    
    
}




class SwitchSourceCell: UITableViewCell {
    static let cellID = "SwitchSourceCellID"
    var delBtnCallBack: (() -> ())?
    
    lazy var historyIcon: UIImageView = {
        let img = UIImageView(image: UIImage.init(named: "sq_datasource_search_histroy"))
        
        return img
    }()
    
    lazy var historyLabel: UILabel = {
        let label = UILabel()
        label.textColor = k_color_title_light_gray2
        return label
    }()
    
    lazy var delBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "home_ac_close"), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 15, left: 10, bottom: 16, right: 32)
        btn.addTarget(self, action: #selector(delCallBack), for: .touchUpInside)
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(delBtn)
        addSubview(historyLabel)
        addSubview(historyIcon)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        historyIcon.snp.makeConstraints {
            $0.left.equalTo(snp.left).offset(20)
            $0.centerY.equalTo(snp.centerY)
            $0.width.equalTo(15)
            $0.height.equalTo(15)
        }
        
        delBtn.snp.makeConstraints {
            $0.right.equalTo(snp.right)
            $0.top.equalTo(snp.top)
            $0.bottom.equalTo(snp.bottom)
            $0.centerY.equalTo(snp.centerY)
            $0.width.equalTo(50)
        }
        
        historyLabel.snp.makeConstraints {
            $0.left.equalTo(historyIcon.snp.right).offset(15)
            $0.right.equalTo(delBtn.snp.left).offset(-5)
            $0.centerY.equalTo(snp.centerY)
        }
        
        
    }
    
    @objc func delCallBack() {
        if let callback = delBtnCallBack {
            callback()
        }
        return
    }
    
    
}

