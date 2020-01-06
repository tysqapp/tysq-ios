//
//  SQHorizontalTableView.swift
//  SheQu
//
//  Created by gm on 2019/4/30.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQHorizontalTableView: UITableView {
    static let horizontalTableViewCellId = "horizontalTableViewCellId"
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.register(SQHorizontalTableViewCell.self, forCellReuseIdentifier: SQHorizontalTableView.horizontalTableViewCellId)
        self.separatorStyle = .none
        self.transform = CGAffineTransform(rotationAngle: -.pi/2)
        self.rowHeight   = 100
    }
    
    var labelArray: [SQHomeInfoDetailLabel]? {
        didSet {
            if labelArray != nil {
                reloadData()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SQHorizontalTableView: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return labelArray == nil ? 0 : labelArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SQHorizontalTableViewCell = tableView.dequeueReusableCell(withIdentifier: SQHorizontalTableView.horizontalTableViewCellId) as! SQHorizontalTableViewCell
        cell.transform = CGAffineTransform(rotationAngle: .pi/2)
        cell.titleLable.text = "我是测试"
        return cell
    }
}
