//
//  SQSlider.swift
//  SheQu
//
//  Created by gm on 2019/6/18.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

class SQSlider: UISlider {
    var callBack: ((_ isSlider: Bool) -> ())?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if (callBack != nil) {
            callBack!(true)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if (callBack != nil) {
            callBack!(false)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if (callBack != nil) {
            callBack!(false)
        }
    }
}
