//
//  SQChooseCategoryTableView.swift
//  SheQu
//
//  Created by gm on 2019/5/6.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQChooseCategoryTableView: UITableView {
    static let cellID      = "SQChooseCategoryTableViewCellID"
    static let lableTag   = 100
    static let selViewTag = 101
    var selLeve1Index = -1
    var selLeve2Index = -1
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.tableFooterView = UIView()
        self.separatorStyle  = .none
    }
    
    var callBack: ((Int) -> ())?
    
    var titleArray: [String]? {
        didSet {
            if (titleArray != nil) {
               reloadData()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SQChooseCategoryTableView: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: SQChooseCategoryTableView.cellID)
        
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: SQChooseCategoryTableView.cellID)
            
            let lable = UILabel.init(frame: cell!.bounds)
            
            lable.textColor       = k_color_black
            lable.font            = k_font_title
            lable.tag             = SQChooseCategoryTableView.lableTag
            let selView = UIImageView.init(image: UIImage.init(named: "sq_ac_shoose"))
            selView.setCenterY(centerY: lable.centerY())
            selView.sizeToFit()
            selView.tag             = SQChooseCategoryTableView.selViewTag
            cell?.selectionStyle    = .none
            cell?.addSubview(lable)
            cell?.addSubview(selView)
        }
        
        let label: UILabel? = cell!.viewWithTag(SQChooseCategoryTableView.lableTag) as? UILabel
        label!.text = titleArray![indexPath.row]
        
        let selView: UIView? = cell!.viewWithTag(SQChooseCategoryTableView.selViewTag)
        let tempIndex  = tag == 0 ? selLeve1Index : selLeve2Index
        if indexPath.row == tempIndex {
            let width = label!.text?.calcuateLabSizeWidth(font: k_font_title, maxHeight: cell!.height())
            selView?.setLeft(x: label!.left() + width! + 10)
            selView?.isHidden = false
            label?.textColor  = k_color_normal_blue
        }else{
            selView?.isHidden = true
            label?.textColor  = k_color_black
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tag == 0 {
            selLeve1Index = indexPath.row
        }else{
            selLeve2Index = indexPath.row
        }
        
        if callBack != nil {
            callBack!(indexPath.row)
        }
        reloadData()
    }
}
