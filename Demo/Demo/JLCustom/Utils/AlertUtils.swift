//
//  AlertUtils.swift
//  VgSale
//
//  Created by ztsapp on 2017/8/16.
//  Copyright © 2017年 ztstech. All rights reserved.
//

import Foundation

//alret帮助类
@objcMembers
class AlertUtils: NSObject {
    
    weak var ctr:UIViewController!



    private var alert:UIAlertController!
    
    init(ctr:UIViewController = UIApplication.shared.keyWindow!.rootViewController!) {
        super.init()
        self.ctr = ctr
    }

    
    func showAlert(title:String?,message:String?,leftText:String?,rightText:String?,leftCallback:(()->Void)?,rightCallback:(()->Void)?) {
        
        alert = UIAlertController(title: title,message: message,preferredStyle: UIAlertController.Style.alert)
        if let txt = leftText {
            let leftAction = UIAlertAction(title: txt,style: UIAlertAction.Style.default,handler: { Action in
                leftCallback?()
            })
            alert.addAction(leftAction)
        }
        if let txt = rightText {
            let rightAction = UIAlertAction(title: txt,style: UIAlertAction.Style.default,handler: { Action in
                rightCallback?()
            })
            alert.addAction(rightAction)
        }
        ctr.present(alert, animated: true, completion: nil)
        
    }
    
    
    ///显示出sheet的提示框
    /// - parameters:
    ///    - title:标题
    ///    - message:信息
    ///    - info:数组要显示的信息最后一个为取消状态
    ///    - importindex:需要特殊显示的
    ///    - clickcomplete:点击后的回调
    func showAlretSheet(title:String?,message:String?,info:[String],importindex:[Int]? = nil,rect:CGRect? = nil,clickcomplete:((Int)->Void)?) {
        
        alert = UIAlertController(title: title,message: message,preferredStyle: UIAlertController.Style.actionSheet)
        for i in 0..<info.count {
            var style = (i == info.count - 1 ? UIAlertAction.Style.cancel:UIAlertAction.Style.default)
            if let _ = importindex {
                for index in importindex! {
                    if i == index {
                        style = UIAlertAction.Style.destructive
                    }
                }
            }
            let action = UIAlertAction(title: info[i],style: style,handler: { Action in
                clickcomplete?(i)
            })
            alert.addAction(action)
        }
        if  alert.popoverPresentationController != nil {
            alert.popoverPresentationController?.sourceView = ctr.view
            if let _  = rect {
                alert.popoverPresentationController?.sourceRect = rect!
            }
        }
        
//        if alert.responds(to: #selector(popoverPresentationController)) {
//            alert.popoverPresentationController.sourceView = ctr.view
//
//        }

        ctr.present(alert, animated: true, completion: nil)
    }
}
