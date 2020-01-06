//
//  SQDisableBtn.swift
//  SheQu
//
//  Created by gm on 2019/5/15.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQDisableBtn: UIButton {
    
    init(frame: CGRect, enabled: Bool, radiu: CGFloat = -1) {
        super.init(frame: frame)
        isEnabled = enabled
        setBackgroundImage(UIImage.init(named: "sq_btn_unuse")?.reSizeImage(reSize: frame.size), for: .disabled)
        setBackgroundImage(UIImage.init(named: "sq_btn_use")?.reSizeImage(reSize: frame.size), for: .normal)
        var radiuTemp = radiu
        if radiuTemp < 0 {
            radiuTemp = frame.size.height * 0.5
        }
        
        addRounded(corners: .allCorners, radii: CGSize.init(width: radiuTemp, height: radiuTemp), borderWidth: k_corner_boder_width, borderColor: k_color_line)
    }
    
    func setBtnBGImage(){
        if isEnabled {
            setBackgroundImage(UIImage.init(named: "sq_btn_use")?.reSizeImage(reSize: self.size()), for: .normal)
            
        }else{
            setBackgroundImage(UIImage.init(named: "sq_btn_unuse")?.reSizeImage(reSize: self.size()), for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
