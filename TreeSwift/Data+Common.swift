//
//  NSdata+Common.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/11/3.
//  Copyright © 2023 feng. All rights reserved.
//

import UIKit
import Foundation
extension Date {
    func isSameDayWithDate(date:Date) -> Bool {
        var isSame = false
        do{
            try isSame = sameDayWithDate(date: date)
        }catch {
            print("[Line %d] exception:\n%@", #line,exception());

        }
        return isSame
    }
    
    func sameDayWithDate(date:Date) -> Bool {
        let calendar = NSCalendar.init(identifier: NSCalendar.Identifier.gregorian)
        let unitFlags:NSCalendar.Unit = [NSCalendar.Unit.year, NSCalendar.Unit.month , NSCalendar.Unit.day]
        let componentsA = calendar?.components(unitFlags, from: date)
        let componentsB = calendar?.components(unitFlags, from: self)

        let isSame = (componentsA?.year == componentsB?.year &&
                  componentsA?.month == componentsB?.month &&
                  componentsA?.day == componentsB?.day);
        
        return isSame
        
        
    }

    func dateStringWithTimelineDate() -> String {
        let now = Date.init()
        let delta = now.timeIntervalSince1970 - self.timeIntervalSince1970
        if (delta < 60*60) {
            let min = Int(delta / 60.0)
            if (min <= 1) {
                return "1 min ago"
            } else {
                return "\(min) mins ago"
            }
        } else if (delta < 60 * 60 * 24) { // 1天内
            let hour = Int(delta / 60.0 / 60.0)
            if (hour <= 1) {
                return "1 hour ago"
            } else {
                return "\(hour) hours ago"
            }
        } else if (delta < 60 * 60 * 24 * 30) {
            let day = Int(delta / 60.0 / 60.0 / 24.0)
            if (day <= 1) {
                return "1 day ago"
            } else {
                return "\(day) days ago"
            }
        } else if (delta < 60 * 60 * 24 * 30 * 3) {
            let month = Int(delta / 60.0 / 60.0 / 24.0 / 30.0)
            if (month <= 1) {
                return "1 month ago"
            } else {
                return "\(month) months ago"
            }
        } else {
            return "3 months ago"
        }
    }
    
    static func dateWithTimeStamp(timestamp:Double) -> Date {
        var times = timestamp
        if(times > 140000000000) {
            times = times / 1000;
        }
        
        return Date.init(timeIntervalSince1970: times)
    }
}
