//
//  SQDatasourceVC.swift
//  SheQu
//
//  Created by gm on 2019/8/14.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

fileprivate struct SQItemStruct {
    ///tipsImageView
    static let tipsImageViewTop        = k_nav_height + 50
    static let tipsImageViewW: CGFloat = k_screen_width > 320 ? 335 : 300
    static let tipsImageViewH: CGFloat = 213.5
    static let tipsImageViewX = (k_screen_width - tipsImageViewW) * 0.5
    
    
    ///datasourceTF
    static let datasourceTFTop: CGFloat = 100
    static let datasourceTFH: CGFloat  = 50
    static let datasourceTFX  = tipsImageViewX
    static let datasourceTFW  = tipsImageViewW
    
    ///sureBtn
    static let sureBtnX   = tipsImageViewX
    static let sureBtnW   = tipsImageViewW
    static let sureBtnTop: CGFloat = 20
    static let sureBtnH: CGFloat   = 50
}

/// 数据源
class SQDatasourceVC: SQViewController {
    
    lazy var tipsImageView: UIImageView = {
        let tipsImageView = UIImageView()
        tipsImageView.contentMode = .center
        tipsImageView.image = UIImage.init(named: "sq_datasource_tips")
        return tipsImageView
    }()
    
    lazy var datasourceTF: SQLoginTextField = {
        let datasourceTF = SQLoginTextField()
        datasourceTF.setSize(size: CGSize.init(width: SQItemStruct.datasourceTFW, height: SQItemStruct.datasourceTFH))
        datasourceTF.placeholder = "请输入网址"
        datasourceTF.layer.cornerRadius = k_corner_radiu
        datasourceTF.layer.borderWidth  = 0.7
        datasourceTF.layer.borderColor  = k_color_normal_blue.cgColor
        datasourceTF.initSubViews()
        datasourceTF.clearButtonMode = .always
        
        let leftView = UIView()
        leftView.setSize(size: CGSize.init(
            width: 20,
            height: SQItemStruct.datasourceTFH
        ))
        datasourceTF.leftView = leftView
        datasourceTF.leftViewMode = .always
        
        return datasourceTF
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn       = UIButton()
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.isEnabled = false
        sureBtn.backgroundColor = k_color_line
        sureBtn.setSize(size: CGSize.init(
            width: SQItemStruct.sureBtnW,
            height: SQItemStruct.sureBtnH
        ))
        
        sureBtn.isEnabled = false
        sureBtn.layer.cornerRadius = k_corner_radiu
        sureBtn.addTarget(self, action: #selector(sureBtnClick), for: .touchUpInside)
        return sureBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(tipsImageView)
        view.addSubview(datasourceTF)
        view.addSubview(sureBtn)
        addChangeTarget(datasourceTF)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tipsImageView.frame = CGRect.init(
            x: SQItemStruct.datasourceTFX,
            y: SQItemStruct.tipsImageViewTop,
            width: SQItemStruct.tipsImageViewW,
            height: SQItemStruct.tipsImageViewH
        )
        
        let datasourceTFY = tipsImageView.maxY() + SQItemStruct.datasourceTFTop
        datasourceTF.frame = CGRect.init(
            x: SQItemStruct.datasourceTFX,
            y: datasourceTFY,
            width: SQItemStruct.datasourceTFW,
            height: SQItemStruct.datasourceTFH
        )
        
        let sureBtnY = datasourceTF.maxY() + SQItemStruct.sureBtnTop
        sureBtn.frame = CGRect.init(
            x: SQItemStruct.sureBtnX,
            y: sureBtnY,
            width: SQItemStruct.sureBtnW,
            height: SQItemStruct.sureBtnH
        )
    }
    
    override func tfChanged(tf: UITextField) {
        let vfDatasource = tf.text!.count > 0
        if vfDatasource == sureBtn.isEnabled {
            return
        }
        
        sureBtn.isEnabled = vfDatasource
        sureBtn.updateBGColor(k_corner_radiu)
    }
    
    @objc func sureBtnClick() {
        requestNetwork()
    }
    
}

extension SQDatasourceVC {
    func handleHistories(history: String) {
        var histories = UserDefaults.standard.stringArray(forKey: SQCloudDataSourceVC.ud_dataSourceHistories) ?? [String]()
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

extension SQDatasourceVC {
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
        SQHostStruct.appendVersion(dataSourceText)
        weak var weakSelf = self
        SQHomeNewWorkTool.getCategory { (model, statu, errorMessage) in
            if (errorMessage != nil) {
                weakSelf?.showToastMessage("数据源不存在")
                return
            }
            
            SQHostStruct.updateLocalHost(dataSourceText)
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
