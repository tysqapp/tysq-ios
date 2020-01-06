//
//  SQAduitImageView.swift
//  SheQu
//
//  Created by gm on 2019/8/29.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQAduitImageView: UIImageView {

    ///这里通过判断statu  是否是要隐藏和显示待审核或者审核文章
    func updateImage(_ statu: Int) {
        if statu == SQArticleAuditStatus.audit.rawValue ||
            statu == SQArticleAuditStatus.aduitFail.rawValue
        {
            if statu == SQArticleAuditStatus.audit.rawValue
            {
                image = UIImage.init(named: "sq_audit_waiting")
            }else{
                image = UIImage.init(named: "sq_audit_fail")
            }
            isHidden = false
        }else{
            isHidden = true
        }
    }

}
