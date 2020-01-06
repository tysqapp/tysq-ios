//
//  SQContentDrawAttStrViewFactoryProtocol.swift
//  SheQu
//
//  Created by gm on 2019/6/26.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

public typealias SQContentDrawAttStrViewCallBack = (SQContentDrawAttStrViewProtocol) -> ()

protocol SQContentDrawAttStrViewFactoryProtocol {
    func getDrawAttStrViewProtocol( idStr: String, dispLink: String, fileLink: String,audioName: String,size: CGSize,handel: SQContentDrawAttStrViewCallBack?) -> SQContentDrawAttStrViewProtocol
}
