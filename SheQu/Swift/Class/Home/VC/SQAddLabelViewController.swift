//
//  SQAddLabelViewController.swift
//  SheQu
//
//  Created by gm on 2019/5/14.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQAddLabelViewController: SQViewController {
    
    var marginX: CGFloat    = 20
    var marginH: CGFloat    = 10
    var btnH: CGFloat       = 30
    var btnAppendW: CGFloat = 40
    var callBack:(([SQLabelInfoModel])->())?
    lazy var addMarksView: SQWriteArticleAddMarksView = {
        let addMarksView = SQWriteArticleAddMarksView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        return addMarksView
    }()
    
    lazy var sureBtn = SQDisableBtn.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 30), enabled: false)
    lazy var searchTF: UITextField = {
        let searchTF = UITextField()
        searchTF.placeholder = "可输入标签名称查询"
        let imageView = UIImageView.init(frame:
            CGRect.init(x: 0, y: 0, width: 30, height: 40))
        imageView.contentMode = .center
        imageView.image             = UIImage.init(named: "sq_label_search")
        let leftV = UIView(frame: CGRect.init(x: 0, y: 0, width: 30, height: 40))
        leftV.addSubview(imageView)
        searchTF.leftView           = leftV
        searchTF.leftViewMode       = .always
        searchTF.clearButtonMode    = .always
        searchTF.backgroundColor    = k_color_bg_gray
        searchTF.layer.cornerRadius = k_corner_radiu
        searchTF.textColor          = k_color_title_black
        return searchTF
    }()
    
    lazy var labelsView = UIView.init(frame: CGRect.init(x: 20, y: 0, width: k_screen_width - 40, height: SQWriteArticleAddMarksView.defaultHeight))
    
    lazy var labelModel = SQLabelModel()
    lazy var infoModelArray  = [SQLabelInfoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "添加标签"
        view.addSubview(addMarksView)
        view.addSubview(searchTF)
        addSureBtn()
        searchTF.addTarget(self, action: #selector(searchTFChange), for: .editingChanged)
        addTableView(frame: view.bounds)
        tableView.register(
            SQEmptyTableViewCell.self,
            forCellReuseIdentifier: SQEmptyTableViewCell.cellID
        )
        
        tableView.delegate        = self
        tableView.dataSource      = self
        tableView.separatorStyle  = .none
        addCallBack()
        requestNetWork()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "添加标签"
    }
    
    func uploadDate(infoModelArray:[SQLabelInfoModel], handel:@escaping (([SQLabelInfoModel])->())){
        addMarksView.titlesArrayM = infoModelArray
        addMarksView.initMarksView()
        self.callBack = handel
    }
    
    func addSureBtn() {
        sureBtn.titleLabel?.font = k_font_title
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitle("确定", for: .disabled)
        sureBtn.setSize(size: CGSize.init(width: 50, height: 30))
        sureBtn.addTarget(self, action: #selector(sureBtnClick), for: .touchUpInside)
        sureBtn.setBtnBGImage()
        view.addSubview(sureBtn)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: sureBtn)
    }
    
    
    
    func addCallBack() {
        weak var weakSelf = self
        addMarksView.callBack = { infoModel in
            weakSelf!.sureBtn.isEnabled = weakSelf!.addMarksView.titlesArrayM.count > 0 ? true : false
            weakSelf!.sureBtn.setBtnBGImage()
            let tempModel = weakSelf!.infoModelArray.first(where: { (model) -> Bool in
                return model.label_id == infoModel.label_id
            })
            
            if tempModel == nil {//去重复
                weakSelf!.infoModelArray.append(infoModel)
                weakSelf!.updateLabelsView()
            }
        }
    }
    
    @objc func searchTFChange(){
       requestNetWork()
    }
    
    @objc func sureBtnClick(){
        if !sureBtn.isEnabled {
            return
        }
        
        if callBack != nil {
            callBack!(addMarksView.titlesArrayM)
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if addMarksView.height() < SQWriteArticleAddMarksView.defaultHeight {
          addMarksView.frame =  CGRect.init(x: 0, y: k_nav_height, width: k_screen_width, height: SQWriteArticleAddMarksView.defaultHeight)
        }else{
            addMarksView.frame =  CGRect.init(x: 0, y: k_nav_height, width: k_screen_width, height: addMarksView.height())
        }
        
        addMarksView.updateConstraints()
        
        searchTF.frame = CGRect.init(x: 20, y: addMarksView.maxY() + 20, width: k_screen_width - 40, height: 40)
        
        let tableViewH  = k_screen_height - k_bottom_h - searchTF.maxY()
        tableView.frame = CGRect.init(x: 0, y: searchTF.maxY() + 20, width: k_screen_width, height: tableViewH)
        
    }

}

//MARK: ----------tableview  代理----------------
extension SQAddLabelViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if infoModelArray.count == 0 {
            let cell = SQEmptyTableViewCell.init(style: .default, reuseIdentifier: SQEmptyTableViewCell.cellID, cellType: .labels)
            return cell
        }
        
        let cell = UITableViewCell()
        cell.addSubview(labelsView)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if infoModelArray.count == 0 {
            return tableView.height()
        }
        
        return labelsView.height()
    }
}

extension SQAddLabelViewController {
    
    func requestNetWork() {
        weak var weakSelf = self
        SQHomeNewWorkTool.getLabel(0, 10, searchTF.text!) { (labelModel, statu, errorMessage) in
            if errorMessage != nil {
                if SQLoginViewController.jumpLoginVC(vc: weakSelf, state: statu, handel: nil) {
                    return
                }
                return
            }
            
            weakSelf!.labelModel = labelModel!
            weakSelf!.infoModelArray = labelModel!.label_infos
            weakSelf!.updateLabelsView()
        }
    }
    
    func updateLabelsView() {
        
        for subView in labelsView.subviews {
            subView.removeFromSuperview()
        }
        
        let font = k_font_title_11
        var tempBtn = UIButton.init(frame: CGRect.init(x: -20, y: 0, width: 0, height: 0))
        for index in 0...infoModelArray.count {
           if index == infoModelArray.count {
                break
           }
            
           let infoModel = infoModelArray[index]
           let btn = UIButton()
            let labelName = infoModel.label_name
           if labelName.count == 0 {
               continue
           }
            
           btn.titleLabel?.font = font
           btn.setTitleColor(k_color_title_blue, for: .normal)
           btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
           btn.setTitle(labelName, for: .normal)
            let titleW  = labelName.calcuateLabSizeWidth(font: font, maxHeight: btnH)
            var btnX    = tempBtn.maxX() + marginX
            var btnW    = titleW + btnAppendW
            var btnY    = tempBtn.top()
            let totleW  = btnW + btnX
            if totleW > labelsView.width() {
                if btnX == 0 {
                    btnW = labelsView.width()
                }else{
                    btnY    = tempBtn.maxY() + 10
                    btnX    = 0
                }
            }
            
           
            btn.titleEdgeInsets = UIEdgeInsets.init(
                top: 0,
                left: 5,
                bottom: 0,
                right: 0
            )
            
            btn.frame   = CGRect.init(
                x: btnX,
                y: btnY,
                width: btnW,
                height: btnH
            )
            
            btn.backgroundColor    = UIColor.colorRGB(0xdee8fc)
            
            btn.layer.cornerRadius = 15
            btn.layer.borderColor  = k_color_normal_blue.cgColor
            btn.layer.borderWidth  = 0.7
            btn.tag                = infoModel.label_id
            btn.setImage(UIImage.init(named: "home_wa_label"), for: .normal)
            labelsView.addSubview(btn)
            tempBtn = btn
        }
        
        labelsView.setHeight(height: tempBtn.maxY())
        labelsView.removeFromSuperview()
        tableView.reloadData()
    }
    
    @objc func btnClick(btn: UIButton) {
        objc_sync_enter(self)
        if addMarksView.titlesArrayM.count >= 6 {//最多6个
            showToastMessage("最多添加6个标签")
            return
        }
        
        let findModel = infoModelArray.first { (model) -> Bool in
            return model.label_id == btn.tag
        }
        
        
        infoModelArray.removeAll { (model) -> Bool in
            return model.label_id == btn.tag
        }
        
        let tempModel = addMarksView.titlesArrayM.first { (model) -> Bool in
            return model.label_id == btn.tag
        }
        
        if tempModel == nil { //去重复
            addMarksView.getMarksSubView(findModel!)
        }
        sureBtn.isEnabled = addMarksView.titlesArrayM.count > 0 ? true : false
        sureBtn.setBtnBGImage()
        updateLabelsView()
        tableView.reloadData()
        objc_sync_exit(self)
    }
}
