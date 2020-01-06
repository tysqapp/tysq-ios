//
//  SQControlEventTableView.swift
//  SheQu
//
//  Created by gm on 2019/10/21.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQControlEventTableView: UITableView, UIGestureRecognizerDelegate {
    static let noti = NSNotification.Name.init("tableViewChangeState")
    static var isFirstViewScrool = true
    var isFirstView = false
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
}
