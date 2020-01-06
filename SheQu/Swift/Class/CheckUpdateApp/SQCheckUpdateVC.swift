//
//  SQCheckUpdateVC.swift
//  SheQu
//
//  Created by gm on 2019/8/23.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQCheckUpdateVC: UIViewController {
    
    lazy var imagView : UIImageView  = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = UIImage.init(named: "sq_update_vc_bg")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(imagView)
        requestNetWork()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imagView.frame = view.bounds
    }
    
    func requestNetWork() {
        weak var weakSelf = self
        SQCheckUpdateNetworkTool.getVersion(true){ (model, statu, errorString) in
            
            if (errorString != nil) {
                weakSelf?.jumpHomeVC()
                return
            }
            
            let updataState = model!.checkNeedUpdate()
            if updataState.forceUpdate || updataState.update {
                let _ =  SQShowUpdateAppView.init(frame: UIScreen.main.bounds, version: model!.latest_version, tipsArray: model!.new_features,isForce: updataState.forceUpdate, handel: { (showViewTemp) in
                    weakSelf?.jumpHomeVC()
                })
            }else{
               weakSelf?.jumpHomeVC()
            }
        }
    }
    
    func jumpHomeVC() {
        AppDelegate.goToHomeVC()
    }
}
