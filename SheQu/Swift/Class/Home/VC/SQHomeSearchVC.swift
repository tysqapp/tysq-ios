//
//  SQHomeSearchVC.swift
//  SheQu
//
//  Created by iMac on 2019/9/16.
//  Copyright © 2019 sheQun. All rights reserved.
//
import WebKit
import UIKit

class SQHomeSearchVC: SQViewController {
    static private let historyUDKey = "saved_home_search_history"
    lazy var searchType: SQMenuView.MenuType = .article
    lazy var isShowFooter:Bool = true
    lazy var keyword = ""
    lazy var infoDetailItemArray = [SQHomeInfoDetailItemModle]() //文章搜索
    lazy var tagItemArray = [SQHomeInfoDetailItemModle]() //标签搜索
    lazy var userItemArray = [SQBriefUserInfo]() //用户搜索
    lazy var isRequsted = false
    lazy var searchBar: SQHomeSearchBar = {
        let sb = SQHomeSearchBar()
        sb.textField.delegate = self
        sb.typeButton.addTarget(self, action: #selector(showLoadMoreView), for: .touchUpInside)
        sb.searchCallBack = { [weak self] in
            self?.keyword = self?.searchBar.textField.text ?? ""
            if self?.searchBar.typeButton.titleLabel?.text == "文章" {
                self?.searchType = .article
            } else if self?.searchBar.typeButton.titleLabel?.text == "标签" {
                self?.searchType = .tag
            } else if self?.searchBar.typeButton.titleLabel?.text == "用户" {
                self?.searchType = .account
            }
            self?.search()
            
            
        }
        return sb
    }()
    
    lazy var advertisementView: SQAdvertisementView = {
        let frame = CGRect.init(x: 0, y: k_screen_height - SQAdvertisementView.advertiesViewHeight - k_bottom_h, width: k_screen_width, height: SQAdvertisementView.advertiesViewHeight + k_bottom_h)
        let advertisementView = SQAdvertisementView.init(frame: frame, vc: self)
        advertisementView.urlString = WebViewPath.homeSearchADUrl
        return advertisementView
    }()
    
    lazy var menuView: SQMenuView = {
        let menuViewW: CGFloat = 100
        let menuViewX: CGFloat = 50
        let menuViewY: CGFloat = k_nav_height
        let frame = CGRect.init(x: menuViewX, y: menuViewY, width: menuViewY, height: 150.0)
        weak var  weakSelf = self
        let menu = SQMenuView(frame: frame, typeArray: [.article, .tag, .account], trianglePosition: .center) { (menuType, string) in
            if weakSelf?.searchBar.typeButton.titleLabel?.text == string { return }
            if(string == "文章") {
                weakSelf?.searchBar.typeButton.setTitle("文章",for: .normal)

            }else if(string == "标签"){
                weakSelf?.searchBar.typeButton.setTitle("标签",for: .normal)
                

            }else{
                weakSelf?.searchBar.typeButton.setTitle("用户",for: .normal)
                

            }
        }

        return menu
    }()
    
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
    
    lazy var tagsView: SQTagsView = {
        let tagsView = SQTagsView()
        let tags = UserDefaults.standard.array(forKey: SQHomeSearchVC.historyUDKey) as? [String] ?? [String]()
        tagsView.setTags (tags: tags)
        tagsView.tagCallBack = { [weak self] index in
                self?.searchBar.textField.text = tagsView.tagStringArr[index]
                self?.keyword = tagsView.tagStringArr[index]
                if self?.searchBar.typeButton.titleLabel?.text == "文章" {
                    self?.searchType = .article
                } else if self?.searchBar.typeButton.titleLabel?.text == "标签" {
                    self?.searchType = .tag
                } else if self?.searchBar.typeButton.titleLabel?.text == "用户" {
                    self?.searchType = .account
                }
                self?.search()
        }
        
        return tagsView
    }()
    
    lazy var footerView: UIView = {
        let footer = UIView()
        let label = UILabel()
        label.font = k_font_title
        label.textColor = k_color_title_black
        label.text = "搜索历史"
        footer.addSubview(label)
        footer.addSubview(tagsView)
        label.snp.makeConstraints {
            $0.left.equalTo(footer.snp.left).offset(20)
            $0.top.equalTo(footer.snp.top).offset(19)
            $0.right.equalTo(footer.snp.right)
            $0.height.equalTo(14)
        }
        tagsView.snp.makeConstraints {
            $0.left.equalTo(footer.snp.left)
            $0.right.equalTo(footer.snp.right)
            $0.top.equalTo(label.snp.bottom)
            $0.bottom.equalTo(footer.snp.bottom)
        }
        footer.frame = CGRect.init(x: 0, y: 0, width: k_screen_width, height: tagsView.viewHeight + 50)
        
        return footer
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        searchBar.frame = CGRect.init(x: 30, y: k_nav_height - 50, width: k_screen_width - 30, height: 55)
        UIApplication.shared.keyWindow?.addSubview(searchBar)
        if(userItemArray.count == 0 && infoDetailItemArray.count == 0 && tagItemArray.count == 0) {
            UIApplication.shared.keyWindow?.addSubview(advertisementView)
        }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView(frame: view.bounds)
        tableView.register(SQHomeSearchUserCell.self, forCellReuseIdentifier: SQHomeSearchUserCell.cellID)
        tableView.register(SQHomeInfoDetailCell.self, forCellReuseIdentifier: SQHomeInfoDetailCell.cellIDStr)
        tableView.separatorStyle = .none
        addFooter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.removeFromSuperview()
        advertisementView.removeFromSuperview()
    }

    @objc func showLoadMoreView() {
        if menuView.isShowing {
            menuView.hiddenMenuView()
        }else{
            menuView.showMenuView()
        }
        
    }
    
    func search(){
        guard let searchText = searchBar.textField.text else {return}
        tagItemArray.removeAll()
        infoDetailItemArray.removeAll()
        userItemArray.removeAll()
        if searchText != "" {
            var tags = tagsView.tagStringArr
            for i in 0..<tags.count {
                if searchText == tags[i] {
                    tags.remove(at: i)
                    break
                }
            }
                     
            tags.insert(searchText, at: 0)
            if tags.count > 10 {
                tags.removeLast()
            }
            
            tagsView.setTags(tags: tags)
            UserDefaults.standard.set(tags, forKey: SQHomeSearchVC.historyUDKey)
            UserDefaults.standard.synchronize()
        }
        
        footerView.frame = CGRect.init(x: 0, y: 0, width: k_screen_width, height: tagsView.viewHeight + 50)
        getSearchResult()
        tableView.reloadData()
    }

}





extension SQHomeSearchVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchType {
        case .article:
            return infoDetailItemArray.count == 0 ? 1 : infoDetailItemArray.count
        
        case .tag:
            return tagItemArray.count == 0 ? 1 : tagItemArray.count
            
        case .account:
            return userItemArray.count == 0 ? 1 : userItemArray.count
       
        default:
            return 1
        
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isShowFooter {
            
            tableView.tableFooterView = footerView
            return UITableViewCell()
            
        }
        
        switch searchType {
        case .article:
            if infoDetailItemArray.count == 0 {
                tableView.tableFooterView = footerView
                UIApplication.shared.keyWindow?.addSubview(advertisementView)
                if !isRequsted {
                    return UITableViewCell()
                }
                let emptyCell: SQEmptyTableViewCell = SQEmptyTableViewCell.init(style: .default, reuseIdentifier: SQEmptyTableViewCell.cellID, cellType: .homeSearchEmpty)
                tableView.tableHeaderView = UIView()
                return emptyCell
            }else{
                if indexPath.row == 0 {
                    tableView.tableHeaderView = headerView
                    tableView.tableFooterView = UIView()
                    advertisementView.removeFromSuperview()
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: SQHomeInfoDetailCell.cellIDStr) as! SQHomeInfoDetailCell
                cell.keyword = keyword
                cell.searchType = searchType
                cell.homeArticlesInfo = infoDetailItemArray[indexPath.row]
                cell.jumpAuthorCallBack = { [weak self] authorId in
                    let vc = SQPersonalVC()
                    vc.accountID = authorId
                    vc.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                return cell
            }
        
        case .tag:
            if tagItemArray.count == 0 {
                tableView.tableFooterView = footerView
                UIApplication.shared.keyWindow?.addSubview(advertisementView)
                if !isRequsted {
                    return UITableViewCell()
                }
                let emptyCell: SQEmptyTableViewCell = SQEmptyTableViewCell.init(style: .default, reuseIdentifier: SQEmptyTableViewCell.cellID, cellType: .homeSearchEmpty)
                tableView.tableHeaderView = UIView()
                return emptyCell
            }else{
                if indexPath.row == 0 {
                    tableView.tableHeaderView = headerView
                    tableView.tableFooterView = UIView()
                    advertisementView.removeFromSuperview()
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: SQHomeInfoDetailCell.cellIDStr) as! SQHomeInfoDetailCell
                cell.keyword = keyword
                cell.searchType = searchType
                cell.homeArticlesInfo = tagItemArray[indexPath.row]
                cell.jumpAuthorCallBack = { [weak self] authorId in
                    let vc = SQPersonalVC()
                    vc.accountID = authorId
                    vc.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                return cell
            }
            
        case .account:
            if userItemArray.count == 0 {
                tableView.tableFooterView = footerView
                UIApplication.shared.keyWindow?.addSubview(advertisementView)
                if !isRequsted {
                    return UITableViewCell()
                }
                let emptyCell: SQEmptyTableViewCell = SQEmptyTableViewCell.init(style: .default, reuseIdentifier: SQEmptyTableViewCell.cellID, cellType: .homeSearchEmpty)
                tableView.tableHeaderView = UIView()
                return emptyCell
            }else{
                if indexPath.row == 0 {
                    tableView.tableHeaderView = headerView
                    tableView.tableFooterView = UIView()
                    advertisementView.removeFromSuperview()
                }
                let cell = tableView.dequeueReusableCell(withIdentifier: SQHomeSearchUserCell.cellID) as! SQHomeSearchUserCell
                cell.keyword = keyword
                cell.model = userItemArray[indexPath.row]

                return cell
            }
        default:
            return UITableViewCell()

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isShowFooter {
            isShowFooter = !isShowFooter
            return 10
        }
        
        switch searchType {
        case .article:
            if infoDetailItemArray.count == 0 {
                if isRequsted {
                    return 200
                } else {
                    return 0
                }
                
            }else{
                return infoDetailItemArray[indexPath.row].itemFrame.rowH
            }
        
        case .tag:
            if tagItemArray.count == 0 {
               if isRequsted {
                    return 200
                } else {
                    return 0
                }
            }else{
                return tagItemArray[indexPath.row].itemFrame.rowH
            }
            
        case .account:
            if userItemArray.count == 0 {
                if isRequsted {
                    return 200
                } else {
                    return 0
                }
            }else{
                return 100
            }
            
        default:
            return 0
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        if userItemArray.count == 0 && infoDetailItemArray.count == 0 && tagItemArray.count == 0 {
            return
        }
        
        if searchType == .account {
            let vc = SQPersonalVC()
            vc.accountID = userItemArray[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        } else if searchType == .article{
            let vc = SQHomeArticleInfoVC()
            vc.article_id = infoDetailItemArray[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = SQHomeArticleInfoVC()
            vc.article_id = tagItemArray[indexPath.row].id
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    //下拉刷新
    override func addMore() {
        if keyword == "" {
            endFooterReFresh()
            return
        }
        getSearchResult()
    }
    
}
extension SQHomeSearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if searchBar.typeButton.titleLabel?.text == "文章" {
            searchType = .article
        } else if searchBar.typeButton.titleLabel?.text == "标签" {
            searchType = .tag
        } else if searchBar.typeButton.titleLabel?.text == "用户" {
            searchType = .account
        }
        keyword = searchBar.textField.text ?? ""
        search()
        return true
    }
}

extension SQHomeSearchVC {
    //获取搜索结果
    func getSearchResult() {
        isRequsted = true
        let searchText = keyword
        searchBar.textField.resignFirstResponder()
        if searchType == .account {
            infoDetailItemArray.removeAll()
            tagItemArray.removeAll()
            SQHomeNewWorkTool.homeSearch(type: "user", keyword: searchText , start: userItemArray.count, size: 20) { [weak self] (listModel, status, errorMessage) in
                
                self?.endFooterReFresh()
                
                if errorMessage != nil {
                    return
                }
                
                if listModel!.users.count < 20{
                    self?.endFooterReFreshNoMoreData()
                }
                
                self?.keyword = listModel!.keyword
                self?.userItemArray.append(contentsOf: listModel!.users)
                self?.tableView.reloadData()
                self?.headerLabel.text = "\(listModel!.count)条搜索结果 "
            }
            
        } else if searchType == .article {
            userItemArray.removeAll()
            tagItemArray.removeAll()
            SQHomeNewWorkTool.homeSearch(type: "title", keyword: searchText , start: infoDetailItemArray.count, size: 20) { [weak self] (listModel, status, errorMessage) in
                
                self?.endFooterReFresh()
                
                if errorMessage != nil {
                    return
                }
                
                if listModel!.articles.count < 20{
                    self?.endFooterReFreshNoMoreData()
                }
                
                self?.keyword = listModel!.keyword
                for item in listModel!.articles {
                    item.content = ""
                    item.cover_url = ""
                    item.cover_type = ""
                    item.keyword = listModel!.keyword
                    item.createItemFrame()
                    self?.infoDetailItemArray.append(item)
                }
                
                self?.tableView.reloadData()
                self?.headerLabel.text = "\(listModel!.count)条搜索结果 "
            }
            
        } else if searchType == .tag {
            userItemArray.removeAll()
            infoDetailItemArray.removeAll()
            SQHomeNewWorkTool.homeSearch(type: "label", keyword: searchText , start: tagItemArray.count, size: 20) { [weak self] (listModel, status, errorMessage) in
                
                self?.endFooterReFresh()
                
                if errorMessage != nil {
                    return
                }
                
                if listModel!.articles.count < 20{
                    self?.endFooterReFreshNoMoreData()
                }
                
                self?.keyword = listModel!.keyword
                for item in listModel!.articles {
                    item.content = ""
                    item.cover_url = ""
                    item.cover_type = ""
                    item.keyword = listModel!.keyword
                    item.createItemFrame()
                    self?.tagItemArray.append(item)
                }
                self?.tableView.reloadData()
                self?.headerLabel.text = "\(listModel!.count)条搜索结果 "
            }
        }
        
    }
    
    
}



