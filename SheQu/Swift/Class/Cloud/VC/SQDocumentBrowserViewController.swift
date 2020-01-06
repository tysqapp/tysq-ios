//
//  SQDocumentBrowserViewController.swift
//  FileBrowser
//
//  Created by gm on 2019/6/17.
//  Copyright © 2019 SmartInspection. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class SQDocumentBrowserViewController: UIDocumentBrowserViewController {
    
    var callBack: (([URL],Bool) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        allowsPickingMultipleItems = true
        let leftBtn =  UIButton()
        leftBtn.setTitle("取消", for: .normal)
        leftBtn.sizeToFit()
        leftBtn.setTitleColor(UIColor.black, for: .normal)
        leftBtn.addTarget(self, action: #selector(canBtnClick), for: .touchUpInside)
        let cancelItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(canBtnClick))
        additionalLeadingNavigationBarButtonItems = [cancelItem]
    }
    
    
    
    @objc private func canBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    
}

@available(iOS 11.0, *)
extension SQDocumentBrowserViewController: UIDocumentBrowserViewControllerDelegate {
    
    
    internal func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        if (callBack != nil) {
            callBack!(documentURLs,true)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    internal func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        if (callBack != nil) {
            callBack!([documentURL],false)
        }
    }
}
