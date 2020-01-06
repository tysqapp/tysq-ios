//
//  SQBrowserImageViewCollectionView.swift
//  SheQu
//
//  Created by gm on 2019/9/3.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQBrowserImageViewCollectionView: UICollectionView {
    
    private var browserImageViewItemArray = [SQBrowserImageViewItem]()
    
    var collectionViewCallBack: ((SQBrowserImageViewCollectionView,SQBrowserImageViewCollectionViewCell) -> ())?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layoutTemp = UICollectionViewFlowLayout.init()
        layoutTemp.itemSize = CGSize.init(width: frame.size.width, height: frame.size.height)
        layoutTemp.minimumLineSpacing = 0
        layoutTemp.minimumInteritemSpacing = 0
        layoutTemp.scrollDirection = .horizontal
        super.init(frame: frame, collectionViewLayout: layoutTemp)
        self.backgroundColor = UIColor.clear
        self.delegate   = self
        self.dataSource = self
        self.showsHorizontalScrollIndicator = false
        self.isPagingEnabled = true
        let cellID = SQBrowserImageViewCollectionViewCell.cellID
        register(
            SQBrowserImageViewCollectionViewCell.self,
            forCellWithReuseIdentifier: cellID
        )
    }
    
    func update(browserImageViewItemArray itemArray: [SQBrowserImageViewItem], selIndex: Int) {
        browserImageViewItemArray = itemArray
        reloadData()
        self.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05){
           self.alpha = 1
           self.scrollToItem(at: IndexPath.init(row: selIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension  SQBrowserImageViewCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return browserImageViewItemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellID = SQBrowserImageViewCollectionViewCell.cellID
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellID,
            for: indexPath
            ) as! SQBrowserImageViewCollectionViewCell
        
        cell.updata(item: browserImageViewItemArray[indexPath.row], currentIndex: indexPath.row + 1, total: browserImageViewItemArray.count)
        weak var weakSelf = self
        cell.hiddenCallback = { temp in 
            weakSelf?.hidden(cell: temp)
        }
        return cell
    }
    
    ///这里是隐藏图片view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SQBrowserImageViewCollectionViewCell
        hidden(cell: cell)
    }
    
    func hidden(cell: SQBrowserImageViewCollectionViewCell) {
        if (collectionViewCallBack != nil) {
            collectionViewCallBack!(self, cell )
        }
    }
}


extension SQBrowserImageViewCollectionView: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return frame.size
    }
    
}


