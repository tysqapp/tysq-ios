//
//  SQGoldToCashVC.swift
//  SheQu
//
//  Created by gm on 2019/8/13.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit


/// 提现界面： 金币转现金 
class SQCoinToCashVC: SQViewController {
    
    
    
    lazy var tableHeaderView: SQCoinToCashView = {
        let tableHeaderView = SQCoinToCashView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: SQCoinToCashView.height))
        tableHeaderView.updateCoinMaxTitleLabelText(coinNum)
        return tableHeaderView
    }()
    
    lazy var bottomView: SQCloudBottomView = {
        let bottomViewH = SQCloudBottomView.cloudBottomViewH
        let bottomViewY = k_screen_height - k_bottom_h - bottomViewH
        let frame = CGRect.init(
            x: 0,
            y: bottomViewY,
            width: k_screen_width,
            height: bottomViewH
        )
        
        let bottomView = SQCloudBottomView.init(frame: frame)
        bottomView.sureBtn.setTitle("确定", for: .normal)
        bottomView.sureBtn.addTarget(
            self,
            action: #selector(sureBtnClick),
            for: .touchUpInside
        )
        
        return bottomView
    }()
    
    
    var coinNum: Int = 0 {
        didSet {
            addTableView(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: bottomView.top()))
            tableView.tableHeaderView = tableHeaderView
            view.addSubview(bottomView)
            addCallBack()
        }
    }
    
    var callBack:((SQCoinToCashVC) -> ())?
    
    
    @objc func sureBtnClick() {
        getBtcRate(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect.init(x: 0, y: 0, width: k_screen_width, height: bottomView.top())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "提现"
    }
    
    func addCallBack() {
        weak var weakSelf =  self
        
        ///tableHeaderView sureBtn的状态回调
        tableHeaderView.sureBtnCallBack = { state in
            if state != weakSelf!.bottomView.sureBtn.isEnabled {
              weakSelf?.bottomView.sureBtn.isEnabled = state
            }
        }
        
        /// tableHeaderView 获取验证码或者请求btc回调
        tableHeaderView.eventCallBack = { event in
            switch event {
            case .getBtc:
                weakSelf?.getBtcRate()
            case .getPin:
               weakSelf?.getEmailCode()
            }
        }
    }
}

extension SQCoinToCashVC {
    
    ///获取交易验证码
    func getEmailCode() {
        weak var weakSelf = self
        let account = SQAccountModel.getAccountModel()
        SQLoginNetWorkTool.getEmailPinCode(account.email, type: .drawCurrency) { (model, statu, errorMessage) in
            if (errorMessage != nil) {
                return
            }
            
            weakSelf?.tableHeaderView
                .updateCap_id(model!.captcha_id)
        }
        
    }
    
    
    /// 获取btcRate
    func getBtcRate(_ isSure: Bool = false) {
        weak var weakSelf = self
        if isSure {
            let emailInfo = tableHeaderView.getEmailInfo()
            let captcha_id = emailInfo.captcha_id
            if captcha_id.count < 1 {
                showToastMessage("请通过邮箱获取验证码")
                return
            }
        }
        let coin_amout = tableHeaderView.getCoinNum()
        if coin_amout.count < 1 { ///输入为0 则不输入提交
            return
        }
        
        SQCloudNetWorkTool.getBtcRate(coin_amout) { (model, statu, errorMessage) in
            if (errorMessage != nil) {
                return
            }
            
            weakSelf?.tableHeaderView.updateValueLabel(model!.withdraw_amount)
            weakSelf?.tableHeaderView.updatePoundageLabel(model!.min_fee)
            weakSelf?.tableHeaderView.updateFundsToTheAccount(model!.income_amount)
            
            if isSure {
                let coinAmout: Int = Int(coin_amout) ?? 0
                let valueArray = [
                    coinAmout.toEuropeanType(3),
                    SQCoinToCashSubmitView.getShowText(value: model!.withdraw_amount, true),
                    SQCoinToCashSubmitView.getShowText(value: model!.min_fee),
                    SQCoinToCashSubmitView.getShowText(value: model!.income_amount)]
                let submitView = SQCoinToCashSubmitView.init(frame: UIScreen.main.bounds, valueArray: valueArray)
                submitView.showSubmitView()
                submitView.callBack = { submitViewTemp in
                    weakSelf?.withdraw(submitViewTemp)
                }
            }
        }
    }

    /// 提现
    func withdraw(_ submitView:SQCoinToCashSubmitView){
        let emailInfo = tableHeaderView.getEmailInfo()
        let captcha_id = emailInfo.captcha_id
        if captcha_id.count < 1 {
            showToastMessage("请通过邮箱获取验证码")
            return
        }
        let captcha = emailInfo.captcha
        
        let account = SQAccountModel.getAccountModel()
        let withdraw_url = tableHeaderView.getAddress()
        let note    = tableHeaderView.getNote()
        let coin_amount: Int
            = Int(tableHeaderView.getCoinNum()) ?? 0
        
        weak var weakSelf = self
        SQCloudNetWorkTool.withdraw(withdraw_url: withdraw_url, coin_amount: coin_amount, email: account.email, captcha_id: captcha_id, captcha: captcha, note: note) { (model, statu, errorMessage) in
            if (errorMessage != nil) {
                submitView.hiddenSubmitView()
                return
            }
            submitView.hiddenSubmitView()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25, execute: {
                if ((weakSelf?.callBack) != nil) {
                    weakSelf!.callBack!(weakSelf!)
                }
                
                weakSelf?.showToastMessage("提现申请已提交")
                weakSelf?.navigationController?
                    .popViewController(animated: true)
            })
            
        }
    }
}
