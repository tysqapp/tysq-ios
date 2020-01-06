//
//  SQReportDetailVC.swift
//  SheQu
//
//  Created by iMac on 2019/9/20.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQReportDetailVC: SQViewController {
    fileprivate var reportDetailTableViewSectionModel = [[ReportDetailTableViewModel]]()
    var reportID = ""
    var reportDetailModel = SQReportDetailModel()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "举报详情"
    }
    
    lazy var sectionHeadView: UIView = {
        let sectionHeadView = UIView()
        sectionHeadView.backgroundColor = k_color_line_light
        return sectionHeadView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getReportDetail()
        addTableView(frame: view.bounds)
        tableView.backgroundColor = k_color_line_light
        tableView.separatorColor = k_color_line
        tableView.register(SQReportDetailCell.self, forCellReuseIdentifier: SQReportDetailCell.cellID)
        
    }
    
    
}

extension SQReportDetailVC {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return sectionHeadView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return reportDetailTableViewSectionModel.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportDetailTableViewSectionModel[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return reportDetailTableViewSectionModel[indexPath.section][indexPath.row].cellHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SQReportDetailCell.cellID) as! SQReportDetailCell
        cell.titleLabel.text = reportDetailTableViewSectionModel[indexPath.section][indexPath.row].title
        cell.detailLabel.text = reportDetailTableViewSectionModel[indexPath.section][indexPath.row].detail
        
        if indexPath.section == 0 && indexPath.row == 0 {
            cell.arrowImg.isHidden = false
        }
        
        if (indexPath.section == 0 && indexPath.row == 2) || (indexPath.section == 1 && indexPath.row == 1){
            cell.detailLabel.font = k_font_title
            cell.detailLabel.textColor = k_color_title_black
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0{
            let atricleVC = SQHomeArticleInfoVC()
            atricleVC.article_id = reportDetailModel.article_id
            navigationController?.pushViewController(atricleVC, animated: true)
            
        }
        
        return
    }
    
}

extension SQReportDetailVC {
    func getReportDetail() {
        SQCloudNetWorkTool.getReportDetail(targetID: reportID) { [weak self] (listModel, status, errorMessage) in
            if errorMessage != nil {
                return
            }
            
            self?.reportDetailModel = listModel!
            self?.reportDetailTableViewSectionModel = ReportDetailTableViewModel.getReportTableViewModels(reportDetail: listModel!)
            self?.tableView.reloadData()
        }
    }
    
}

fileprivate class ReportDetailTableViewModel {
    var cellHeight: CGFloat = 50
    var title = ""
    var detail = "" {
        didSet {
            cellHeight = detail.calcuateLabSizeHeight(font: k_font_title, maxWidth: 248) + 36
        }
    }
    
    static func getReportTableViewModels(reportDetail: SQReportDetailModel) -> [[ReportDetailTableViewModel]] {
        var modelSectionArr = [[ReportDetailTableViewModel]]()
        var modelRowArr1 = [ReportDetailTableViewModel]()
        var modelRowArr2 = [ReportDetailTableViewModel]()
        var modelRowArr3 = [ReportDetailTableViewModel]()
        
        let model1 = ReportDetailTableViewModel()
        model1.title = "被举报文章:"
        model1.detail = reportDetail.title
        modelRowArr1.append(model1)
        
        let model2 = ReportDetailTableViewModel()
        model2.title = "举报内容:"
        model2.detail = reportDetail.type
        modelRowArr1.append(model2)
        
        let model3 = ReportDetailTableViewModel()
        model3.title = "问题描述:"
        model3.detail = reportDetail.note
        modelRowArr1.append(model3)
        
        modelSectionArr.append(modelRowArr1)
        
        let model4 = ReportDetailTableViewModel()
        model4.title = "处理结果:"
        model4.detail = reportDetail.result
        modelRowArr2.append(model4)
        
        let model5 = ReportDetailTableViewModel()
        model5.title = "结果描述:"
        model5.detail = reportDetail.process_reason
        modelRowArr2.append(model5)
        
        modelSectionArr.append(modelRowArr2)
        
        let model6 = ReportDetailTableViewModel()
        model6.title = "举报编号:"
        model6.detail = reportDetail.report_id
        modelRowArr3.append(model6)
        
        modelSectionArr.append(modelRowArr3)
        
        return modelSectionArr
    }
    
}
