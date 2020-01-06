//
//  SQFristCommentTableHeaderView.swift
//  SheQu
//
//  Created by gm on 2019/5/23.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQFristCommentTableHeaderView: UITableView {
    static let footViewH: CGFloat = 55
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line_light
        return lineView
    }()
    
    lazy var totleNumLabel: UILabel =  {
        let totleNumLabel       = UILabel()
        totleNumLabel.font      = k_font_title_weight
        totleNumLabel.textColor = k_color_black
        return totleNumLabel
    }()
    
    var fobinCommentCallBack:((_ accountID: Int,_ name: String) -> ())?
    
    var commentModelArray: [SQCommentModel]? {
        didSet{
            reloadData()
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        delegate   = self
        dataSource = self
        isScrollEnabled = false
        register(SQCommentTableViewCell.self, forCellReuseIdentifier: SQCommentTableViewCell.cellID)
        let footView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: 55))
        lineView.frame = CGRect.init(x: 0, y: 0, width: k_screen_width, height: k_line_height)
        footView.addSubview(lineView)
        
        totleNumLabel.frame = CGRect.init(x: 20, y: 10, width: k_screen_width, height: 44)
        footView.addSubview(totleNumLabel)
        
        let line2View = UIView()
        line2View.frame = CGRect.init(x: 0, y: 54, width: k_screen_width, height: k_line_height)
        line2View.backgroundColor = k_color_line
        footView.addSubview(line2View)
        
        tableFooterView = footView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SQFristCommentTableHeaderView: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentModelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SQCommentTableViewCell  =  tableView.dequeueReusableCell(withIdentifier: SQCommentTableViewCell.cellID, for: indexPath) as! SQCommentTableViewCell
        cell.commentModel = commentModelArray![indexPath.row]
        cell.fobinCommentCallBack = {[weak self] (accountID, accountName) in
            if ((self?.fobinCommentCallBack) != nil) {
                self!.fobinCommentCallBack!(accountID, accountName)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = commentModelArray![indexPath.row]
        return model.commentFrame.line2ViewFrame.maxY
    }
}
