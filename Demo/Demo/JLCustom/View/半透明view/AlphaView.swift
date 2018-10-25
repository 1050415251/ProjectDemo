//
//  AlphaView.swift
//  VgSale
//
//  Created by ztsapp on 2017/9/15.
//  Copyright © 2017年 ztstech. All rights reserved.
//

import Foundation
import UIKit

class AlphaView: UIView {
    
    var showVframe:CGRect!
    
    private weak var ctr:UIViewController!
    
    var CLICKELSEHIDDEN = true //点击透明区域 就移除这个view 部分界面需要点击某个确定按钮才消失
    var hiddencallback:(()->Void)?//消失的回调
    
    
    init(ctr:UIViewController) {
        super.init(frame: ctr.view.bounds)
        self.ctr = ctr
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if showVframe == nil {
            fatalError("请设置showVframe(在show的时候)")
        }
        
        if AppDelegate.KEYBOARDSHOW {
            self.endEditing(true)
            return
        }
        if !CLICKELSEHIDDEN {
            return
        }
        
        if let touch = touches.first {
            let point = touch.location(in: self)
            if (point.y < showVframe.minY || point.y > showVframe.maxY) || (point.x > showVframe.maxX || point.x < showVframe.minX) {
                hidden()
                return
            }
        }
    }
    
    func show() {
         APP.navController?.fd_fullscreenPopGestureRecognizer.isEnabled = false
        ctr.view.addSubview(self)
    }
    
    func show_Animation() { ///待动画
        APP.navController?.fd_fullscreenPopGestureRecognizer.isEnabled = false
        ctr.view.addSubview(self)
        
            for i in self.subviews {
                i.transform = CGAffineTransform.init(scaleX: 0.75, y: 0.75)
                i.alpha = 0.1
            }
            UIView.animate(withDuration: 0.15, animations: {
                
                for i in self.subviews {
                    i.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
                    i.alpha = 1.0
                }
            }) { (finsh) in
                
            }
        
    }
    
    func show_AnimationFromCGRect(startpoint:CGPoint) {
        
    }
    
    
    func hidden() {
         APP.navController?.fd_fullscreenPopGestureRecognizer.isEnabled = true
        for i in self.subviews {
            i.removeFromSuperview()
        }
        self.removeFromSuperview()
    }
    
    func hidden_Animation() {
        APP.navController?.fd_fullscreenPopGestureRecognizer.isEnabled = true
       
        UIView.animate(withDuration: 0.15, animations: {
            for i in self.subviews {
                i.transform = CGAffineTransform.init(scaleX: 0.75, y: 0.75)
                i.alpha = 0.0
            }
        }) { (finsh) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                for i in self.subviews {
                    i.removeFromSuperview()
                }
                self.removeFromSuperview()
            })
        }
    }
    
    func hidden_AnimationFromCGRect(endpoint:CGPoint) {
        
    }
}
