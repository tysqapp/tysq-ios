//
//  Data+Extension.swift
//  SheQu
//
//  Created by gm on 2019/6/13.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

extension Data {
    
    mutating func changeInputStream(reading input: InputStream) {
        input.open()
        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        while input.hasBytesAvailable {
            let read = input.read(buffer, maxLength: bufferSize)
            self.append(buffer, count: read)
        }
        buffer.deallocate()
        input.close()
    }
    
    func toZipData() -> Data? {
        let data: NSData = self as NSData
        return data.gzipped()
    }
}
