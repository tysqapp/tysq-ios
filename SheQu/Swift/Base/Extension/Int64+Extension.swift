//
//  Int64+Extension.swift
//  SheQu
//
//  Created by gm on 2019/5/22.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

extension Int64 {
    func updateTimeToCurrennTime() -> String {
        
        var timeStamp   = TimeInterval(self)
        
        //获取当前的时间戳 单位秒
        let currentTime = Date().timeIntervalSince1970
        
        ///纳秒
        if (timeStamp / currentTime) > 1000000 {
            timeStamp = timeStamp / 1000000000
        }
        
        ///微秒
        if (timeStamp / currentTime) > 1000 {
            timeStamp = timeStamp / 1000000
        }
        
        ///毫秒
        if (timeStamp / currentTime) > 10 {
            timeStamp = timeStamp / 1000
        }
        
        
        //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
        let timeSta:TimeInterval = TimeInterval(timeStamp)
        //时间差
        let reduceTime : TimeInterval = currentTime - timeSta
        //时间差小于60秒
        if reduceTime < 600 {
            return "刚刚"
        }
        //时间差大于一分钟小于60分钟内
        let mins = Int(reduceTime / 60)
        if mins < 60 {
            return "\(mins)分钟前"
        }
        let hours = Int(reduceTime / 3600)
        if hours < 24 {
            return "\(hours)小时前"
        }
        
        let days = Int(reduceTime / 86400)
        if days < 30 {
            return "\(days)天前"
        }
        
        let months = Int(reduceTime / 2592000 )
        if months < 12 {
            return "\(months)个月前"
        }else{
            let years = Int(reduceTime / 31104000)
            return "\(years)年前"
        }
    }
    
    func formatStr(_ formatStr: String)-> String {
        let date = Date.init(timeIntervalSince1970: TimeInterval(self))
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = formatStr
        return dateFormat.string(from: date)
    }
}
