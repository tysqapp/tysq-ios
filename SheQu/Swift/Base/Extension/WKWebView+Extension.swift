//
//  WKWebView+Extension.swift
//  SheQu
//
//  Created by gm on 2019/8/23.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit
import WebKit
extension WKWebView {
    func getImage() -> UIImage {
      let scrollView = self.scrollView
        UIGraphicsBeginImageContextWithOptions(
            self.scrollView.contentSize,false,
            UIScreen.main.scale
        )
        scrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image!
    }
}
