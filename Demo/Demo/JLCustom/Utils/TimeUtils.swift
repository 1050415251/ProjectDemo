//
//  TimeUtils.swift
//  VgSale
//
//  Created by ztsapp on 2017/7/25.
//  Copyright © 2017年 ZhanTengMr'S Zhang. All rights reserved.
//

import Foundation

///fileprivate 只在该文件里面私有
class TimeUtils: NSObject {
    ///当前年
    static var currentYear:String {
        get {
            return TimeUtils.getYear(date: dateToString(date: Date()))
        }
    }
    ///当前月
    static var currentMonth:String {
        get {
            return TimeUtils.getMonth(date: dateToString(date: Date()))
        }
    }
    ///当前日
    static var currentDay:String {
        get {
            return TimeUtils.getDay(date: dateToString(date: Date()))
        }
    }
    ///当前事件
    static var currenttime:String {
        get {
            return TimeUtils.getTime(date: dateToString(date: Date()))
        }
    }
    
    fileprivate static let dateFoment = DateFormatter()
    
    class func dateToString(date:Date) -> String {
        TimeUtils.dateFoment.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return TimeUtils.dateFoment.string(from: date)
    }
    
    class func stringToDate(date:String) -> Date? {
        if !date.contains("-") {
            fatalError("请传入时间格式为 - 的参数")
        }


        if date.length == "yyyy-MM-dd HH:mm:ss".length {
            TimeUtils.dateFoment.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return TimeUtils.dateFoment.date(from: date)
        }
        if date.length == "yyyy-MM-dd".length {
            TimeUtils.dateFoment.dateFormat = "yyyy-MM-dd"
            return TimeUtils.dateFoment.date(from: date)
        }
        
        return nil
    }
}

extension TimeUtils {
    
    class func getYear(date:String) -> String {
        if date.length >= 10 {
            return (date as NSString).substring(to: 4)
        }
        return "0"
    }
    
    class func getMonth(date:String) -> String {
        if date.length >= 10 {
            return (date as NSString).substring(with: NSRange(location: 5,length: 2))
        }
        return "0"
    }
    
    class func getDay(date:String) -> String {
        if date.length >= 10 {
            return (date as NSString).substring(with: NSRange(location: 8,length: 2))
        }
        return "0"
    }
    
    class func getTime(date:String) -> String {
        if date.length == 19 {
            return (date as NSString).substring(with: NSRange(location: 11,length: 5))
        }
        return "00:00"
    }
    
    ///xxxx年xx月xx日
    class func getbasicDate(date:String) -> String {
        return "\(TimeUtils.getYear(date:date))年\(TimeUtils.getMonth(date: date))月\(TimeUtils.getDay(date: date))日"
    }
    
    
    
    
    ///返回一个5月23号 如果是同年的 不反年份 不具体到时间
    class func getDate(date:String) -> String {
        if TimeUtils.getYear(date: date) == TimeUtils.currentYear {
            return "\(TimeUtils.getMonth(date: date))月\(TimeUtils.getDay(date: date))日"
        }
        return "\(TimeUtils.getYear(date:date))年\(TimeUtils.getMonth(date: date))月\(TimeUtils.getDay(date: date))日"
    }
    
    ///获取到具体的时间  刚刚 1分钟前 n分钟前 n小时前 具体规则如果 offset 小于60s return刚刚 offset 小于 3600 return 多少分钟前 offset 小于 86400 返回多少小时前
    class func getTimestamp(date:String) -> String {
        if date == ""{
            return ""
        }
        TimeUtils.dateFoment.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if TimeUtils.dateFoment.date(from: date) == nil {
            return ""
        }
        
        
        let nowTime:Int = Int(NSDate().timeIntervalSince1970)
        let flgTime:Int = Int(TimeUtils.dateFoment.date(from: date)!.timeIntervalSince1970)
        
        let dayTime:Int = 86400
        let hourTime:Int = 3600
        let minTime:Int = 60
        let offset = nowTime - flgTime
        
        if offset < 60 {
            return "刚刚"
        }else if offset < 3600 {
            return "\(offset/minTime)分钟前"
        }else if offset < dayTime {
            return "\(offset/hourTime)小时前"
        }else if offset < dayTime * 3 {
            return "\(offset/dayTime)天前"
        }
        return TimeUtils.getDate(date:date)
    }
    
    ///多少天前
    class func getOnlyDaysTimestamp(date:String) -> String {
        if date == ""{
            return ""
        }
        TimeUtils.dateFoment.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let nowTime:Int = Int(NSDate().timeIntervalSince1970)
        let flgTime:Int = Int(TimeUtils.dateFoment.date(from: date)!.timeIntervalSince1970)
        
        let dayTime:Int = 86400
        let hourTime:Int = 3600
        let minTime:Int = 60
        let offset = nowTime - flgTime
        
        if offset < 60 {
            return "刚刚"
        }else if offset < 3600 {
            return "\(offset/minTime)分钟前"
        }else if offset < dayTime {
            return "\(offset/hourTime)小时前"
        }
        return "\(offset/dayTime)天前"
        
    }

    
}
