//
//  ex+Date.swift
//  CustomFile
//
//  Created by 国投 on 2018/9/12.
//  Copyright © 2018年 FlyKite. All rights reserved.
//

import Foundation

extension Date {

    var yyyyMMdd: String {
        get {
            let fmt = DateFormatter()
            fmt.timeZone = TimeZone.current
            fmt.dateFormat = "yyyy-MM-dd"
            return fmt.string(from: self)
        }
    }

    var yyyyMMddHHmm: String {
        get {
            let fmt = DateFormatter()
            fmt.timeZone = TimeZone.current
            fmt.dateFormat = "yyyy-MM-dd HH:mm"
            return fmt.string(from: self)
        }
    }

    var yyyyMMddHHmmss: String {
        get {
            let fmt = DateFormatter()
            fmt.timeZone = TimeZone.current
            fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return fmt.string(from: self)
        }
    }

    var millseconds: Double {
        get {
            return self.timeIntervalSince1970 * 1000
        }
    }

    var nextDay: Date {
        get {
            return Date(timeInterval: 24 * 60 * 60, since: self)
        }
    }

    /// 距离 date 这个日期 多少天
    func numberDayOf(date: Date) -> Int {
        let calendar = Calendar.current
        let unit = Calendar.Component.day
        let result = calendar.dateComponents([unit], from: date, to: self)
        return result.day ?? 0
    }

    //本周开始日期（星期天）
    func startOfThisWeek() -> Date {

        let calendar = NSCalendar .current
        let components = calendar.dateComponents(
            Set < Calendar . Component >([.yearForWeekOfYear, .weekOfYear]), from: self)
        let startOfWeek = calendar.date(from: components)!
        return startOfWeek
    }

    //本周结束日期（星期六）
    func endOfThisWeek(returnEndTime:Bool = false) -> Date {
        let calendar = NSCalendar .current
        var components = DateComponents()
        if returnEndTime {
            components.day = 7
            components.second = -1
        } else {
            components.day = 6
        }

        let endOfMonth = calendar.date(byAdding: components, to: self.startOfThisWeek())!
        return endOfMonth
    }

}
