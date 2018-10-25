//
//  OpenAppUtils.swift
//  VgSale
//
//  Created by ztsapp on 2017/8/23.
//  Copyright © 2017年 ztstech. All rights reserved.
//

import Foundation

///打开其他的app方式
class OpenAppUtils: NSObject {
    
    
    class func openApp(url:String) {
       
        guard let newurl = URL.init(string: url) else {
            return
        }
        if UIApplication.shared.canOpenURL(newurl) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL.init(string: url)!, options: [:], completionHandler: nil)
            }else {
                UIApplication.shared.openURL(URL.init(string: url)!)
            }
        }else {
            UIAlertView.init(title: "操作失败，请手动操作", message: nil, delegate: nil, cancelButtonTitle: "我知道了").show()
        }
    }

    class func canOpenApp(url:String) -> Bool {
        guard let newurl = URL.init(string: url) else {
            return false
        }
        return UIApplication.shared.canOpenURL(newurl)
    }
    
}
