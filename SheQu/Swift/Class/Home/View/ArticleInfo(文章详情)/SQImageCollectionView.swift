//
//  SQImageCollectionView.swift
//  SheQu
//
//  Created by gm on 2019/5/23.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQImageCollectionView: UICollectionView{
    static let itemW: CGFloat = 90
    static let itemH: CGFloat = 70
    var isAddDeleteView       = false
    var imageUrlArray: [SQCommentModelImageUrlItem]? {
        didSet {
            if imageUrlArray == nil {
                return
            }
            
            reloadData()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .clear
        delegate   = self
        dataSource = self
        showsHorizontalScrollIndicator = false
        register(SQImageCollectionViewCell.self, forCellWithReuseIdentifier: SQImageCollectionViewCell.cellID)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SQImageCollectionView:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrlArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SQImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SQImageCollectionViewCell.cellID, for: indexPath) as! SQImageCollectionViewCell
        
        cell.subImageView.sq_setImage(with: imageUrlArray![indexPath.row].url, imageType: .image, placeholder: k_image_ph_loading)
        cell.subImageView.contentMode = .scaleAspectFit
        if isAddDeleteView {
            cell.addDeleteView()
            weak var weakSelf = self
            cell.callBack = { isNeedDelte in
                weakSelf?.imageUrlArray?.remove(at: indexPath.row)
                weakSelf?.reloadData()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var showImageArray = [SQBrowserImageViewItem]()
        for index in 0..<imageUrlArray!.count {
          let cell = cellForItem(at: IndexPath.init(row: index, section: 0)) as! SQImageCollectionViewCell
          let oldFrame = cell.convert(cell.subImageView.frame, to: UIApplication.shared.keyWindow)
            let item = SQBrowserImageViewItem.init(blurredImageLink: imageUrlArray![index].url, originalImageLink: imageUrlArray![index].original_url, oldFrame: oldFrame , contentModel: .scaleAspectFit)
          showImageArray.append(item)
        }
        
        SQBrowserImageViewManager.showBrowserImageView(
                browserImageViewItemArray: showImageArray,
                selIndex: indexPath.row
        )
    }
}






class SQImageCollectionViewCell: UICollectionViewCell {
    static let cellID = "SQImageCollectionViewCellID"
    lazy var subImageView: SQAniImageView = {
        let subImageView = SQAniImageView()
        return subImageView
    }()

    lazy var clearBtn: UIButton = {
        let clearBtn = UIButton()
        clearBtn.setImage(UIImage.init(named: "sq_ac_imagepick_close"), for: .normal)
        clearBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        return clearBtn
    }()
    var callBack:((Bool)->())?
    var isAddClearView = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(subImageView)
    }
    
    func addDeleteView() {
        isAddClearView = true
        addSubview(clearBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var margin: CGFloat = 0
        if isAddClearView {
            margin = 10
            let btnX = frame.size.width - 20
            clearBtn.frame = CGRect.init(x: btnX, y: 0, width: 20, height: 20)
            clearBtn.layer.cornerRadius = 10
        }else{
           clearBtn.removeFromSuperview()
        }
        
        subImageView.frame = CGRect.init(x: 0, y: 10, width: frame.size.width - margin , height: frame.size.height - margin)
        subImageView.addRounded(corners: .allCorners, radii: k_corner_radiu_size, borderWidth: 0.7, borderColor: k_color_line)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func closeBtnClick() {
        if callBack != nil {
            callBack!(true)
        }
    }
}

