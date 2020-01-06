//
//  SQGCDTimer.swift
//  SheQu
//
//  Created by gm on 2019/4/23.
//  Copyright © 2019 sheQun. All rights reserved.
//

import UIKit

typealias GCDTimerCallBack = (Int)->()

class SQGCDTimer:NSObject{
    
    private var customTimer:DispatchSourceTimer?
    
    
    /// 启动一个GCD一个定时器
    ///
    /// - Parameters:
    ///   - timeInterval: 多少时间循环一次
    ///   - repeatCount: 重复次数 当输入为-1时为无限循环
    ///   - callBack: 返回Int类型
    func startTimer(_ timeInterval: Double,_ repeatCount:Int,_ callBack:@escaping (Int)->()){
        
        DispatchTimer(timeInterval: timeInterval, repeatCount: repeatCount) { (timer, count)  in
            callBack(count)
        }
        
    }
    
    public func stopTimer(){
        if (self.customTimer != nil) {
            self.customTimer?.cancel()
            self.customTimer = nil;
        }
    }
    
    fileprivate  func DispatchTimer(timeInterval: Double, repeatCount:Int, handler:@escaping (DispatchSourceTimer?, Int)->())
    {
        weak var weakSelf = self
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        self.customTimer = timer
        var count = repeatCount
        timer.schedule(deadline: .now(), repeating: timeInterval)
        //scheduleOneshot(wallDeadline: .now(), repeating: timeInterval)
        timer.setEventHandler(handler: {
            count -= 1
            DispatchQueue.main.async {
                handler(timer, count)
            }
            if count == 0 {
                timer.cancel()
                weakSelf?.customTimer = nil
            }
        })
        timer.resume()
    }
}
