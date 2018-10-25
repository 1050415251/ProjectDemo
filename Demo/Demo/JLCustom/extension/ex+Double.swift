//
//  ex+Double.swift
//  CustomFile
//
//  Created by 国投 on 2018/9/12.
//  Copyright © 2018年 FlyKite. All rights reserved.
//

import Foundation

extension Double {

    var date: Date {
        get {
            return Date.init(timeIntervalSince1970: self)
        }
    }

    func format(_ numbersAfterDot: Int) -> String {
        let formatString = "%.\(numbersAfterDot)lf"
        return String(format: formatString, self)
    }

    func format(_ numbersAfterDot: Int) -> Double? {
        return Double(self.format(numbersAfterDot))
    }


}
