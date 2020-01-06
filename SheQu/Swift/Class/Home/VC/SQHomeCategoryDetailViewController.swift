//
//  SQHomeCategoryDetailViewController.swift
//  SheQu
//
//  Created by gm on 2019/4/30.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
typealias SQHomeCategoryDetailVCCallBack = ((SQHomeCategorySubInfo) -> ())
private let itemW: CGFloat = 70
private let itemH: CGFloat = 70
class SQHomeCategoryDetailViewController: UIViewController {
    
    lazy var lineView: UIView = {
        let lineView = UIView.init(frame: CGRect.init(x: 0, y: k_nav_height, width: k_screen_width, height: k_line_height))
        lineView.backgroundColor = k_color_line
        return lineView
    }()
    
    lazy var cancelBtn: UIButton = {
        let btnW = k_screen_width - 20 - 40
        let btnY = k_nav_height - 40
        let cancelBtn = UIButton.init(frame: CGRect.init(x: btnW, y: btnY, width: 40, height: 40))
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(k_color_black, for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        return cancelBtn
    }()
    
    lazy var blueView: UIView = {
        let blueView = UIView()
        blueView.backgroundColor = k_color_normal_blue
        return blueView
    }()
    
    @objc func cancelBtnClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame:
            CGRect.init(
                x: 0,
                y: lineView.maxY(),
                width: 90,
                height: k_screen_height - k_nav_height
        ))
        
        tableView.delegate   = self
        tableView.dataSource =  self
        tableView.separatorStyle = .none
        tableView.rowHeight  =  60
        tableView.backgroundColor = UIColor.colorRGB(0xf5f5f5)
        return tableView
    }()
    
    lazy var categoryLabel: UILabel = {
        let categoryLabel = UILabel.init(frame: CGRect.init(x: 90, y: lineView.maxY(), width: k_screen_width - 90, height: 55))
        categoryLabel.textAlignment = .center
        
        var attTextM  = NSMutableAttributedString.init(string: "————  ", attributes: [NSAttributedString.Key.foregroundColor: k_color_line])
        
        let attTextTitle            = NSAttributedString.init(string: "分类推荐", attributes: [
            NSAttributedString.Key.foregroundColor: k_color_black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .heavy)
            ])
        
        let lineText  = NSAttributedString.init(string: "  ————", attributes: [NSAttributedString.Key.foregroundColor: k_color_line])
        attTextM.append(attTextTitle)
        attTextM.append(lineText)
        categoryLabel.attributedText = attTextM
        
        return categoryLabel
    }()
    
    lazy var collectionView: UICollectionView = {
        let layoutTemp = UICollectionViewFlowLayout()
        let itemWidth: CGFloat  = (k_screen_width - 90 - 60) / 3
        let scale: CGFloat  = itemWidth / 140
        let height: CGFloat = 70 * scale
        layoutTemp.itemSize = CGSize.init(width: itemWidth, height: height)
        layoutTemp.minimumLineSpacing = 20
        layoutTemp.minimumInteritemSpacing = 0
        layoutTemp.scrollDirection = .vertical
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 90, y: categoryLabel.maxY(), width: k_screen_width - 90, height: k_screen_height - categoryLabel.maxY() - k_bottom_h), collectionViewLayout: layoutTemp)
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.register(SQHomeTitleCollectionViewCell.self, forCellWithReuseIdentifier: "collectionViewID")
        collectionView.backgroundColor = k_color_bg
        return collectionView
    }()
    
    var categoryModel = [SQHomeCategoryInfo]()
    var selCategoryInfoModel = SQHomeCategoryInfo()
    var callBack: SQHomeCategoryDetailVCCallBack!
    var selModel = SQHomeCategorySubInfo()
    func setCategoryModel(_ model: [SQHomeCategoryInfo],_ callBackTemp: @escaping SQHomeCategoryDetailVCCallBack) {
        categoryModel = model
        callBack      = callBackTemp
       
        /// 选择选中的一级菜单
        let id        = UserDefaults.standard.integer(forKey: k_ud_Level1_sel_key)
        let selIndx   = model.firstIndex { (infModel) -> Bool in
            return infModel.id == id
        }
        selCategoryInfoModel = model[selIndx ?? 0]
        
        ///选择选中的二级菜单
        let udLevel2 = k_ud_Level2_sel_key + "\(selCategoryInfoModel.id)"
        let cacheLevel2 = UserDefaults.standard.integer(forKey: udLevel2)

        let selModelTemp = selCategoryInfoModel.subcategories.first(where: { $0.id == cacheLevel2
        })
        
        if (selModelTemp != nil) {
            selModel = selModelTemp!
        }else{
            UserDefaults.standard.set(0, forKey: udLevel2)
            UserDefaults.standard.synchronize()
            if selCategoryInfoModel.subcategories.count > 0 {
               selModel = selCategoryInfoModel.subcategories[0]
            }
        }
        
        tableView.reloadData()
        collectionView.reloadData()
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = k_color_bg
        view.addSubview(lineView)
        view.addSubview(tableView)
        view.addSubview(categoryLabel)
        view.addSubview(collectionView)
        view.addSubview(cancelBtn)
        SQHomeSubViewController.isFirst = true
        collectionView.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 0, right: 10)
    }
    
}

extension SQHomeCategoryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let model: SQHomeCategoryInfo = categoryModel[indexPath.row]
        if cell.textLabel?.numberOfLines != 0 {
            cell.textLabel!.textAlignment = .center
            cell.textLabel!.numberOfLines = 0
            cell.textLabel?.font          = k_font_title_weight
        }
        
        cell.textLabel!.text          = model.name
        if selCategoryInfoModel.id == model.id {
            cell.textLabel?.textColor =  k_color_black
            cell.backgroundColor      =  k_color_bg
            blueView.frame = CGRect.init(x: 0, y: 22, width: 3, height: 16)
            cell.addSubview(blueView)
        }else{
            cell.textLabel?.textColor =  k_color_title_gray
            cell.backgroundColor      =  UIColor.colorRGB(0xf5f5f5)
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selCategoryInfoModel = categoryModel[indexPath.row]
        blueView.removeFromSuperview()
        tableView.reloadData()
        if selCategoryInfoModel.subcategories.count == 0 {
            
            let selModel = selCategoryInfoModel.createAllCategorySubInfo()
            let ud = UserDefaults.standard
            let level2Key = k_ud_Level2_sel_key + "\(selModel.parent_id)"
            ud.set(selModel.id, forKey: level2Key)
            ud.set(selCategoryInfoModel.id, forKey: k_ud_Level1_sel_key)
            ud.synchronize()
            callBack(selModel)
            navigationController?
                .popViewController(animated: true)
            return
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadSections(IndexSet.init(integer: 0))
    }
}

extension SQHomeCategoryDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selModel = selCategoryInfoModel.subcategories[indexPath.row]
        
        let ud = UserDefaults.standard
        let level2Key = k_ud_Level2_sel_key + "\(selModel.parent_id)"
        ud.set(selModel.id, forKey: level2Key)
        ud.set(selCategoryInfoModel.id, forKey: k_ud_Level1_sel_key)
        ud.synchronize()
        
        callBack(selModel)
        navigationController?.popViewController(animated: true)
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selCategoryInfoModel.subcategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SQHomeTitleCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewID", for: indexPath) as! SQHomeTitleCollectionViewCell
        let model = selCategoryInfoModel.subcategories[indexPath.row]
        cell.layer.borderWidth        = 0.8
        cell.layer.cornerRadius       = k_corner_radiu
        if selModel.id == model.id && selModel.parent_id == model.parent_id {
            cell.titleLabel.textColor     =  k_color_title_blue
            cell.layer.borderColor        =  k_color_normal_blue.cgColor
        }else{
            cell.titleLabel.textColor     = k_color_black
            cell.layer.borderColor        = k_color_line.cgColor
        }
        cell.titleLabel.text = model.name
        if cell.titleLabel.numberOfLines != 0 {
            cell.titleLabel.numberOfLines = 0
            cell.titleLabel.textAlignment = .center
            cell.titleLabel.font          = UIFont.systemFont(ofSize: 12, weight: .heavy)
        }
        
        cell.tag = indexPath.row
        return cell
    }
        
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let title = selCategoryInfoModel.subcategories[indexPath.row].name
//        var itemHTemp = title.calcuateLabSizeWidth(font: UIFont.systemFont(ofSize: 12), maxHeight: itemW)
//        if itemHTemp  < itemH {
//            itemHTemp = itemH
//        }
//        
//        return CGSize.init(width: itemW, height: itemHTemp)
//    }
}
