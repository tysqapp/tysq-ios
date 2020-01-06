//
//  SQViewController.swift
//  SheQu
//
//  Created by gm on 2019/4/11.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
import MJRefresh

class SQViewController: UIViewController {
    
    private lazy var isNeedGroup: Bool = false
    private lazy var tableViewFrame: CGRect = CGRect.zero
    lazy var isFirstDisp = true
    lazy var backBtn: UIButton = {
        let btn = UIButton()
        btn.frame.size = CGSize.init(width: 30, height: 30)
        btn.setImage(UIImage.init(named: "nav_back"), for: .normal)
        btn.addTarget(self, action: #selector(navPop), for: .touchUpInside)
        btn.imageView?.contentMode = .left
        return btn
    }()
    
    lazy var navBackBtn: UIButton = {
        let btn = UIButton()
        btn.frame.size = CGSize.init(width: 30, height: 30)
        btn.setImage(UIImage.init(named: "nav_back"), for: .normal)
        btn.addTarget(self, action: #selector(navPop), for: .touchUpInside)
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    lazy var tableView: UITableView = {
        let style: UITableView.Style = self.isNeedGroup ? .grouped : .plain
        var frame = self.tableViewFrame
        if  frame == CGRect.zero {//如果为zero的，则默认为view的高度
            frame = self.view.bounds
        }
        
        let tableView        = UITableView.init(frame: frame, style: style)
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.backgroundColor = k_color_bg
        //去除空余Cell的下划线
        tableView.tableFooterView = UIView()
        tableView.register(SQEmptyTableViewCell.self, forCellReuseIdentifier: SQEmptyTableViewCell.cellID)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.cellIDStr)
        return tableView
    }()
    
    lazy var showTips: SQShowTips = {
        let showTips = SQShowTips()
        return showTips
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = k_color_bg
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor.colorRGB(0x4e4e4e)
        
        guard let vc = navigationController?.children.first else {
            return
        }
        
        ///首页不需要添加返回按钮 SQHomeSubViewController作为伪首页 也不需要添加返回按钮
        if !self.isKind(of: vc.classForCoder)
            && !self.isKind(of: SQHomeSubViewController.self)
            && !self.isKind(of: SQHomeWriteArticleVC.self)
            && !self.isKind(of: SQVFEmailViewController.self){
            if isFirstDisp {
                isFirstDisp = false
                addNavBtn()
            }else{
              navigationController?
                .interactivePopGestureRecognizer?.delegate = self
            }
            
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //在debug状态下 添加帧率缓存cpu数据显示
//        #if DEBUG
//        LHPerformanceMonitorService.run()
//        #endif
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //在debug状态下 移除帧率缓存cpu数据显示
//        #if DEBUG
//        LHPerformanceMonitorService.stop()
//        #endif
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    ///MARK: ------------- 添加textView -----------------
    func addChangeTarget(_ tf: UITextField) {
        tf.addTarget(self, action: #selector(tfChanged(tf:)), for: .editingChanged)
    }
    
    @objc func tfChanged(tf: UITextField){}
    
    ///MARK: -------------导航栏返回按钮-----------------
    
    func addNavBtn() {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: navBackBtn)
        navigationController?
            .interactivePopGestureRecognizer?.delegate = self
    }
    
    func addNavBtnByView(){
        backBtn.frame.origin = CGPoint.init(x: 20, y: k_status_bar_height + 10)
        view.addSubview(backBtn)
        navigationController?
        .interactivePopGestureRecognizer?.delegate = self
    }
    
    @objc func navPop(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
}

extension SQViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


// MARK: - 添加tableView
extension SQViewController {
    
    final func addTableView(frame: CGRect, needGroup: Bool = false) {
        isNeedGroup    = needGroup
        tableViewFrame = frame
        view.addSubview(tableView)
    }
    
}

extension SQViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }    
}

extension SQViewController {
    func showLoading() {
//        showTips.initWithIndicatorWithView(view: self.view, withText: "Loading....")
//        showTips.startTheView()
    }
    
    func hiddenLoading() {
       // showTips.stopAndRemoveFromSuperView()
    }
    
    func showToastMessage(_ message: String) {
        SQToastTool.showToastMessage(message)
    }
    
    func goKeyWindow() {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.initWindow()
    }
}

extension SQViewController {
    final func addFooter() {
        tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(addMore))
    }
    
    func endFooterReFresh() {
        tableView.mj_footer?.endRefreshing()
    }
    
    func endFooterReFreshNoMoreData() {
        tableView.mj_footer?.endRefreshingWithNoMoreData()
    }
    
    @objc func addMore() {}
}


extension UITableViewCell {
    static let cellIDStr =  "SQHomeSearchArticleCell"
}

