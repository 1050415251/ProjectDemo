//
//  Debug.swift
//  GTEDai
//
//  Created by 国投 on 2018/1/23.
//  Copyright © 2018年 国投. All rights reserved.
//

import Foundation

class DEBUG:NSObject {
    
    class func DEBUGPRINT(obj:Any...,bringTime:Bool = true) {
        #if DEBUG

        if bringTime {
            debugPrint(Date().yyyyMMddHHmmss)
        }
        debugPrint(obj)
        #endif
    }
    
}
