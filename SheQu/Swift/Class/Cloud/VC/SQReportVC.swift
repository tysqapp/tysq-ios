//
//  SQReportVC.swift
//  SheQu
//
//  Created by iMac on 2019/9/16.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQReportVC: SQViewController {
    var articleID = ""
    var articleName = ""
    
    private var selectedType = "广告或垃圾信息"
    
    lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.font            = k_font_title_11
        headerLabel.textColor       = k_color_title_gray
        headerLabel.frame           = CGRect.init(x: 20, y: 0, width: k_screen_width - 20, height: 30)
        return headerLabel
    }()
    
    lazy var headerView: UIView = {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: 30))
        headerView.backgroundColor = UIColor.colorRGB(0xf5f5f5)
        headerView.addSubview(headerLabel)
        return headerView
    }()
    
    lazy var footerView: UIView = {
        let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: 110))
        footerView.backgroundColor = UIColor.colorRGB(0xf5f5f5)
        footerView.addSubview(placeholderTextView)
        return footerView
    }()
    
    lazy var placeholderTextView: SQPlaceholderTextView = {
        let placeholderTextView = SQPlaceholderTextView(frame: CGRect(x: 0, y: 10, width: k_screen_width, height: 90), placeholder: "详细说明（必填）", limit: 50, textContainerInset: TextContainerInset(top: 15, left: 20, bottom: 15, right: 20))
        
        return placeholderTextView
    }()
    
    lazy var reportBtn: UIButton = {
        let reportBtn = UIButton(frame: CGRect.init(x: 20, y: k_screen_height - 70, width: k_screen_width - 40, height: 50))
        reportBtn.setTitle("举报", for: .normal)
        reportBtn.layer.cornerRadius = 4
        reportBtn.layer.masksToBounds = true
        reportBtn.titleLabel?.font = k_font_title_16_weight
        reportBtn.setTitleColor(UIColor.white, for: .normal)
        reportBtn.setTitleColor(UIColor.white, for: .disabled)
        reportBtn.setBackgroundImage(UIImage.init(named: "sq_btn_unuse"), for: .disabled)
        reportBtn.setBackgroundImage(UIImage.init(named: "sq_btn_use"), for: .normal)
        reportBtn.addTarget(self, action: #selector(reportOnClick), for: .touchUpInside)
        return reportBtn
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = k_color_bg_gray
        title = "举报"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavBtn()
        addTableView(frame: CGRect(x: 0, y: 0, width: k_screen_width, height: 414))
        tableView.isScrollEnabled = false
        tableView.register(SQReportCell.self, forCellReuseIdentifier: SQReportCell.cellID)
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        tableView.separatorColor = k_color_line
        tableView.backgroundColor = k_color_bg_gray
        headerLabel.text = "我要举报\(articleName)"
        view.addSubview(reportBtn)
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
    }
    


}

extension SQReportVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SQReportCell.cellID) as! SQReportCell
        cell.textLabel?.font = k_font_title
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "广告或垃圾信息"
            break
            
        case 1:
            cell.textLabel?.text = "涉嫌侵权"
            break
            
        case 2:
            cell.textLabel?.text = "低质问题"
            break
            
        case 3:
            cell.textLabel?.text = "其他"
            break
        
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            selectedType = "广告或垃圾信息"
        case 1:
            selectedType = "涉嫌侵权"
        case 2:
            selectedType = "低质问题"
        case 3:
            selectedType = "其他"
        default:
            return
        }
    }
    
}

extension SQReportVC {
    @objc func reportOnClick() {
        let report_type = selectedType
        let id = articleID
        let note = placeholderTextView.textView.text ?? ""
        if note == "" {
            self.showToastMessage("必须填写详细说明")
            return
        }
        
        SQCloudNetWorkTool.reportArticle(articleID: id, reportType: report_type, note: note) {[weak self] (listModel, status, errorMessage) in

            
            if errorMessage != nil {
                return
            }
            
            if(status == 0) {
                SQToastTool.showToastMessage("举报成功")
                self?.navPop()
            }
        }
    }
    
}


