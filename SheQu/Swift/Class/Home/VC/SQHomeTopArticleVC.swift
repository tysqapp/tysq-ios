//
//  SQHomeTopArticleListVCViewController.swift
//  SheQu
//
//  Created by iMac on 2019/11/12.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQHomeTopArticleVC: SQViewController {
    lazy var parent_id = 0
    lazy var category_id = 0
    lazy var topArticleArr = [SQTopArticleModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "置顶"
        addTableView(frame: CGRect.zero)
        tableView.register(SQHomeTopArticleListCell.self, forCellReuseIdentifier: SQHomeTopArticleListCell.cellID)
        getTopArticleList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden    = false
        navigationItem.title = "置顶"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
}

extension SQHomeTopArticleVC {
    func getTopArticleList() {
        SQHomeNewWorkTool.getTopArticleList(parent_id: parent_id, category_id: category_id) { [weak self] (listModel, status, errorMessage) in
            
            if errorMessage != nil {
                return
            }
            
            self?.topArticleArr.append(contentsOf: listModel!.articles)
            self?.tableView.reloadData()
        }
    }


}


extension SQHomeTopArticleVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topArticleArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SQHomeTopArticleListCell.cellID) as! SQHomeTopArticleListCell
        cell.titleLabel.attributedText = topArticleArr[indexPath.row].title.toTopArticleTitle()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        let vc = SQHomeArticleInfoVC()
        vc.article_id = topArticleArr[indexPath.row].article_id
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return "置顶   \(topArticleArr[indexPath.row].title)".calcuateLabSizeHeight(font: k_font_title, maxWidth: k_screen_width - 40) + 40
    }
    
    
}
