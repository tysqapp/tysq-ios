//
//  SQDrawAttStrView.swift
//  SheQu
//
//  Created by gm on 2019/6/27.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit


class SQDrawAttStrView: UIView {
    var aniImageView: SQAniImageView!
    func toMutableAttributedString() -> NSMutableAttributedString {
        return NSMutableAttributedString.yy_attachmentString(
            withContent: self,
            contentMode: .scaleAspectFill,
            attachmentSize: size(),
            alignTo: UIFont.systemFont(ofSize: 0),
            alignment: .bottom
        )
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        aniImageView = SQAniImageView()
        aniImageView.layer.masksToBounds = true
        aniImageView.contentMode = .center
        addSubview(aniImageView)
        bringSubviewToFront(aniImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
