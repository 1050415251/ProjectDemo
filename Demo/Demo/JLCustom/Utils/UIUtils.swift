//
//  UIUtils.swift
//  GTEDai
//
//  Created by 国投 on 2018/1/16.
//  Copyright © 2018年 国投. All rights reserved.
//

import Foundation
import UIKit

var SCREEN_WIDTH:CGFloat {
    get {
        return UIScreen.main.bounds.width
    }
}

var SCREEN_HEIGHT:CGFloat {
    get {
        return UIScreen.main.bounds.height
    }
}
class UIUtils {

    static let BG_COLOR = 0xffffff.rgbColor
    
    ///状态栏高度
    static var STATUSBAR_HEIGHT:CGFloat {
        get {
            if AppDelegate.PHONETYPE == .PHONE_X {
                return 44
            }
            return 20
            //FIXME:- 因为在 UIApplication.shared 中调用这个方法所以无法获取到状态栏高度所以此处写死数据
            //return UIApplication.shared.statusBarFrame.height
        }
    }
    
    static var NAV_HEIGHT:CGFloat {
        get {
            return UIUtils.STATUSBAR_HEIGHT + 44
        }
    }

    ///底部高度 适配iphoneX 专用
    static var TOLLBAR_HEIGHT:CGFloat {
        get {
            if AppDelegate.PHONETYPE == .PHONE_X {
                return 44
            }
            return 0
        }
    }
    
    class func makeColor(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor {
        
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }

}























