//
//  SQHomeTitleCollectionView.swift
//  SheQu
//
//  Created by gm on 2019/4/25.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit



class SQHomeTitleCollectionView: UICollectionView {
    
    private static let textSelColor = k_color_black
    private static let labelSelFont = UIFont.systemFont(ofSize: 18, weight: .heavy)
    private static let textColor    = k_color_title_gray_blue
    private static let labelFont    = k_font_title_weight
    
    fileprivate static let cellID = "homeTitleCollectionViewID"
    
    var selCell: SQHomeTitleCollectionViewCell!
    var selIndex = 0
    var isFirst  = true
    var callBack: Level1SelCallBack?
    var infoModel: SQArticleInfoModel!
    var titleArray: [SQHomeCategoryInfo]? {
        
        didSet{
            reloadData()
            weak var weakSelf = self
            let selId = UserDefaults.standard.integer(forKey: k_ud_Level1_sel_key)
            selIndex  = titleArray!.firstIndex(where: { (model) -> Bool in
                return model.id == selId
            }) ?? 0
            if weakSelf!.callBack != nil {
                if weakSelf!.selIndex >= titleArray!.count {
                    weakSelf!.selIndex = 0
                    UserDefaults.standard.set(-1, forKey: k_ud_Level1_sel_key)
                    UserDefaults.standard.synchronize()
                }
                weakSelf!.callBack!(weakSelf!.selIndex, titleArray![weakSelf!.selIndex].subcategories)
            }
            
            if weakSelf?.selIndex == 0 {
                return
            }
            weakSelf!.scrollToIndex(selId)
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layoutTemp = UICollectionViewFlowLayout.init()
        layoutTemp.itemSize = CGSize.init(width: 80, height: 30)
        layoutTemp.minimumLineSpacing = 5
        layoutTemp.minimumInteritemSpacing = 5
        layoutTemp.scrollDirection = .horizontal
        super.init(frame: frame, collectionViewLayout: layoutTemp)
        self.backgroundColor = k_color_bg
        self.delegate   = self
        self.dataSource = self
        self.showsHorizontalScrollIndicator = false
        self.register(SQHomeTitleCollectionViewCell.self, forCellWithReuseIdentifier: SQHomeTitleCollectionView.cellID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 跳转到指定的item
    ///
    /// - Parameter row: 需要跳转到的item
    func scrollToIndex(_ id: Int) {
        
        selIndex = titleArray!.firstIndex(where: { $0.id == id}) ?? 0
        selectItem(at: IndexPath.init(item: selIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        reloadData()
        cacheSelIndex()
        if callBack != nil {
            callBack!(selIndex, titleArray![selIndex].subcategories)
        }
    }
    
    func cacheSelIndex() {
        let itemModel = titleArray![selIndex]
        UserDefaults.standard.set(itemModel.id, forKey: k_ud_Level1_sel_key)
        UserDefaults.standard.synchronize()
    }
}

extension SQHomeTitleCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell: SQHomeTitleCollectionViewCell = collectionView.cellForItem(at: indexPath) as! SQHomeTitleCollectionViewCell
        selIndex = indexPath.row
        selCell  = cell
        cacheSelIndex()
        reloadData()
        if callBack != nil {
            callBack!(indexPath.row, titleArray![indexPath.row].subcategories)
        }

    }
    
    
}

extension SQHomeTitleCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray == nil ? 0 : titleArray!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SQHomeTitleCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SQHomeTitleCollectionView.cellID, for: indexPath) as! SQHomeTitleCollectionViewCell
        cell.titleLabel.text = titleArray![indexPath.row].name
        cell.tag = indexPath.row
        if selIndex == indexPath.row {
            cell.setSelColor(
                SQHomeTitleCollectionView.textSelColor,
                SQHomeTitleCollectionView.labelSelFont)
            selCell = cell
        }else{
            cell.setNormalColor(
                SQHomeTitleCollectionView.textColor,
                SQHomeTitleCollectionView.labelFont)
        }
        
        return cell
    }
}

extension SQHomeTitleCollectionView: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = self.titleArray![indexPath.row].name
        var width: CGFloat = 80
        if self.selIndex == indexPath.row {
           width = title.calcuateLabSizeWidth(
            font: SQHomeTitleCollectionView.labelSelFont,
            maxHeight: 30)
        }else{
            width = title.calcuateLabSizeWidth(
                font: SQHomeTitleCollectionView.labelFont,
                maxHeight: 30)
        }
        
        return CGSize.init(width: width + 10, height: 30)
    }
    
}
