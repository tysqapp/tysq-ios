//
//  SQFristCommentTableHeaderView.swift
//  SheQu
//
//  Created by gm on 2019/5/23.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQFristCommentTableHeaderView: UITableView {
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = k_color_line
        return lineView
    }()
    
    lazy var totleNumLabel: UILabel =  {
        let totleNumLabel       = UILabel()
        totleNumLabel.font      = k_font_title_weight
        totleNumLabel.textColor = k_color_black
        return totleNumLabel
    }()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        delegate   = self
        dataSource = self
        isScrollEnabled = false
        register(SQCommentTableViewCell.self, forCellReuseIdentifier: SQCommentTableViewCell.cellID)
        let footView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: k_screen_width, height: 55))
        lineView.frame = CGRect.init(x: 0, y: 0, width: k_screen_width, height: 10)
        footView.addSubview(lineView)
        
        totleNumLabel.frame = CGRect.init(x: 0, y: 10, width: k_screen_width, height: 45)
        footView.addSubview(totleNumLabel)
        tableFooterView = footView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SQFristCommentTableHeaderView: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SQCommentTableViewCell  =  tableView.dequeueReusableCell(withIdentifier: SQCommentTableViewCell.cellID, for: indexPath) as! SQCommentTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
}
