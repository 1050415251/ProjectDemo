//
//  ex+Int.swift
//  CustomFile
//
//  Created by 国投 on 2018/9/12.
//  Copyright © 2018年 FlyKite. All rights reserved.
//

import Foundation


extension Int {

    func rgbColor(_ alpha: CGFloat = 1.0) -> UIColor {
        let red = CGFloat(Double(self >> 16) / 255.0)
        let green = CGFloat(Double(self >> 8 % 256) / 255.0)
        let blue = CGFloat(Double(self % 256) / 255.0)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    var rgbColor: UIColor {
        let red = CGFloat(Double(self >> 16) / 255.0)
        let green = CGFloat(Double(self >> 8 % 256) / 255.0)
        let blue = CGFloat(Double(self % 256) / 255.0)
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }


    //MARK:Int赚字符串
    func IntToZH() -> String {
        if self > 10 {
            return ""
        }

        switch self {
        case 0:
            return "零"
        case 1:
            return "一"
        case 2:
            return "二"
        case 3:
            return "三"
        case 4:
            return "四"
        case 5:
            return "五"
        case 6:
            return "六"
        case 7:
            return "七"
        case 8:
            return "八"
        case 9:
            return "九"
        case 10:
            return "十"
        default:
            break
        }
        return ""
    }


    var doubleValue:Double! {
        return Double(self)
    }

    var floatValue:Float! {
        return Float(self)
    }


}
