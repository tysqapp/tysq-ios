//
//  SQShowAuditView.swift
//  SheQu
//
//  Created by gm on 2019/8/28.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQShowAuditView: UIView {
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = UIColor.black
        coverView.alpha = 0.7
        return coverView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    lazy var closeBtn: UIButton = {
        let closeBtn = UIButton()
        closeBtn.setImage(
            UIImage.init(named: "sq_integral_close"),
            for: .normal
        )
        
        closeBtn.addTarget(
            self,
            action: #selector(hiddenAuditView),
            for: .touchUpInside
        )
        
        closeBtn.isHidden = true
        return closeBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(coverView)
        addSubview(contentView)
        addSubview(closeBtn)
        addLayout()
    }
    
    private func addLayout() {
        
        coverView.snp.makeConstraints { (maker) in
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func hiddenAuditView() {
        
    }
    
}
