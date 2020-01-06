//
//  Array+Extension.swift
//  SheQu
//
//  Created by gm on 2019/11/28.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

extension Array {
    // 去重
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}
