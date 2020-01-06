//
//  SQCloudDownloadVC.swift
//  SheQu
//
//  Created by gm on 2019/10/28.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQCloudDownloadVC: SQViewController {
    
    var totalNumCallBack:((Int) -> ())?

    lazy var datasourceArray = [[SQMutableDownloadItem]]()
    
    lazy var tableheaderView: UIView = {
        let tableheaderView = UIView()
        tableheaderView.addSubview(downloadCompleteLabel)
        tableheaderView.frame = CGRect.init(x: 0, y: 0, width: k_screen_width, height: 40)
        tableheaderView.backgroundColor = k_color_line_light
        return tableheaderView
    }()
    
    lazy var downloadCompleteLabel: UILabel = {
        let downloadCompleteLabel = UILabel()
        downloadCompleteLabel.textColor = k_color_title_gray
        downloadCompleteLabel.font      = k_font_title
        downloadCompleteLabel.frame = CGRect.init(x: 20, y: 0, width: k_screen_width - 20, height: 40)
        return downloadCompleteLabel
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = "我的云盘"
        addTableView(frame: CGRect.zero, needGroup: true)
        tableView.register(SQCloudDownloadTableViewCell.self, forCellReuseIdentifier: SQCloudDownloadTableViewCell.cellID)
        tableView.separatorStyle = .none
        tableView.rowHeight      = SQCloudDownloadTableViewCell.rowHeight
        initDatasourceArray()
        NotificationCenter.default.addObserver(self, selector: #selector(initDatasourceArray), name: k_noti_download, object: nil)
    }
    
    @objc func initDatasourceArray() {
        DispatchQueue.main.async {
            self.datasourceArray.removeAll()
            
            let itemArray = SQMutableDownloadManager.shareInstance.itemArray.filter {$0.status < 7}
            
            if itemArray.count > 0 {
                self.datasourceArray.append(itemArray)
            }
            
            let successItemArray = SQMutableDownloadManager.shareInstance.itemArray.filter {$0.status >= 7}
            
            if successItemArray.count > 0 {
                self.datasourceArray.append(successItemArray)
            }
            
            self.tableView.reloadData()
            self.downloadCompleteLabel.text = "下载完成\(successItemArray.count)"
            if (self.totalNumCallBack != nil) {
                self.totalNumCallBack!(SQMutableDownloadManager.shareInstance.itemArray.count)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = k_screen_height - k_page_title_view_height - k_bottom_h - SQCloudBottomView.cloudBottomViewH - k_nav_height
        let frame = CGRect.init(
            x: 0,
            y: 0,
            width: k_screen_width,
            height: height
        )
        
        tableView.frame = frame
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension SQCloudDownloadVC {
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if datasourceArray.count == 0 {
            return 0
        }
        let itemArray = datasourceArray[section]
        if itemArray.first!.status >= 7 {
            return 40
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if datasourceArray.count == 0 {
            return UIView()
        }
        let itemArray = datasourceArray[section]
        if itemArray.first!.status >= 7 {
            
            return tableheaderView
        }else{
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasourceArray.count == 0 ? 1 : datasourceArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if datasourceArray.count == 0 {
            return 1
        }
        return datasourceArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if datasourceArray.count == 0 {
            let emptyCell = SQEmptyTableViewCell.init(style: .default, reuseIdentifier: SQEmptyTableViewCell.cellID, cellType: .download)
            return emptyCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SQCloudDownloadTableViewCell.cellID) as! SQCloudDownloadTableViewCell

        let item = datasourceArray[indexPath.section][indexPath.row]
        cell.progressView.progress = 0
        cell.updataItem(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return datasourceArray.count != 0
    }
    
    ///删除
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        weak var weakSelf = self
        let rowAction = UITableViewRowAction.init(style: .default, title: "删除") { (action, indexPath) in
            guard let item = weakSelf?.datasourceArray[indexPath.section][indexPath.row] else {
                weakSelf?.initDatasourceArray()
                return
            }
            item.totalDelete()
            weakSelf?.initDatasourceArray()
        }
        
        rowAction.backgroundColor = UIColor.red
        return [rowAction]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if datasourceArray.count == 0 {
            return tableView.height()
        }
        
        return SQCloudDownloadTableViewCell.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if datasourceArray.count == 0 {
            return
        }
        
        let item = datasourceArray[indexPath.section][indexPath.row]
        ///如果是视频或者音频
        let filePath = downloadDocuPath + "/" + item.localPath
        if item.status == 7 {
            showToastMessage("文件正在合并")
            return
        }
        if item.status ==  8 && (item.mineType == "video" || item.mineType == "audio") {
            let isAudio = item.mineType == "audio"
            IJKVideoViewController.present(
            from: self,
            withTitle: "",
            url: URL.init(fileURLWithPath: filePath), isAudio: isAudio) {}
        }
        
        ///如果是图片的话
        if item.status == 8 && item.mineType == "image" {
            
            guard let cell:SQCloudDownloadTableViewCell = tableView.cellForRow(at: indexPath) as? SQCloudDownloadTableViewCell else {
                return
            }
            
            let oldFrame: CGRect = cell.convert(cell.iconImageView.frame, to: UIApplication.shared.keyWindow)
            let item = SQBrowserImageViewItem.init(blurredImageLink: filePath, originalImageLink: filePath, oldFrame: oldFrame, contentModel: .scaleAspectFit)
            SQBrowserImageViewManager
            .showBrowserImageView(browserImageViewItemArray: [item], selIndex: 0)
        }
    }
}

