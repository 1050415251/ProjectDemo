//
//  KeyBoardUpUtils.swift
//  GTEDai
//
//  Created by 国投 on 2018/1/18.
//  Copyright © 2018年 国投. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

///键盘事件弹出事件 view上移动 保证不被键盘着挡 与KeyBoardUtils区别是 这个是点击区域是view键盘弹出view上移动而KeyBoardUtils是输入框
final class KeyBoardViewUpUtils: NSObject {
    
    var cligonY:CGFloat = 0
    ///textview的高度
    var inputVHeight:CGFloat!
    
    ///初始viwe的Y 默认初始值一样如果特殊需求
    var viewStartY:CGFloat = 0
    var viewEdnY:CGFloat = 0
    
    weak var contentView:UIView!
    
    let keyboardBg = DisposeBag()
    
    var keyboardchangecallback:((CGFloat)->Void)?
    
    
    
    init(view:UIView) {
        super.init()
        self.contentView = view
        viewStartY = view.frame.origin.y
        viewEdnY = view.frame.origin.y
        initKeyBoardObserVer()
    }
    
    
    
    
    private func initKeyBoardObserVer() {
        
        (NotificationCenter.default.rx.notification(UIResponder.keyboardWillChangeFrameNotification, object: nil)).subscribe {[weak self] (sender) in
            if sender.element != nil {
                self?.handlerKeyboardNotice(sender:sender.element!)
            }
            
            }.disposed(by: keyboardBg)
        
    }
    
    private func handlerKeyboardNotice(sender:Notification) {
        
        let userinfo:[AnyHashable:Any] = sender.userInfo!
        
        let animation:TimeInterval = userinfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        let endFrame:CGRect = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        keyboardchangecallback?(endFrame.origin.y)
        UIView.animate(withDuration: animation, animations: { [weak self] in
            self?.handlerViewUp(keyboardY:endFrame.origin.y)
        })
    }
    
    ///处理view上移动事件
    func handlerViewUp(keyboardY:CGFloat) {
        
        if inputVHeight == nil {
            fatalError("请设置输入框的高度")
        }
        
        if keyboardY == SCREEN_HEIGHT {
            contentView.frame.origin.y = viewEdnY
            return
        }
        
        var CY = cligonY///点击Y轴需要 + toolbar
        let distance = (CY + viewStartY - keyboardY) + 45
        if keyboardY != SCREEN_HEIGHT {
            CY = CY + distance
        }
        
        ///说明点击区域在键盘下面
        if CY + viewStartY  - keyboardY > 0 {
            ///view初始y 轴 - (点击的y 是cligonY + viewStartY - 键盘的y) 在减去输入框的宽度
            ///MARK:cligonY 是点击到view的hittest的Y轴 + inputVHeight 因为只能知道他点的是textview不能判断出那个textView的y
            var y = viewStartY - distance - inputVHeight//留出一半输入框的距离可以使用户不用收起键盘继续输入
            
            //y是向上偏移的距离 需要判断偏移距离是否大于键盘高度 如果大于键盘高度则强制为键盘高度  这样就不会出现屏幕黑一块儿的情况
            
            if let _ = contentView as? UITableView {
                y = abs(y) > (SCREEN_HEIGHT  - keyboardY - viewStartY) ? -(SCREEN_HEIGHT - keyboardY - viewStartY):y
                contentView.frame.origin.y =  y > viewStartY ? viewStartY:y + (SCREEN_HEIGHT - (viewStartY + contentView.frame.height))
            }else {
                contentView.frame.origin.y =  y > viewStartY ? viewStartY:y
            }
            
        }else {
            contentView.frame.origin.y = viewStartY
        }
        
    }
    
}



//键盘事件弹出事件 输入框随键盘变化 与 KeyBoardUpUtils区别 这个是自带的输入框而KeyBoardUpUtils是view上面的textview
class KeyBoardUtils: NSObject {
    
    weak var contentView:UIView!
    
    let keyboardBg = DisposeBag()
    
    var keyboardchangecallback:((CGFloat)->Void)?
    
    @objc dynamic var KEYBOARDDIDAPPEAR:Bool = false//键盘已经出现或者消失
    @objc dynamic var KEYBOARDWILLAPPEAR:Bool = false//键盘将要出现或者消失
    
    
    func initKeyBoardObserVer(view:UIView) {
        self.contentView = view
        (NotificationCenter.default.rx.notification(UIResponder.keyboardWillChangeFrameNotification, object: nil)).subscribe {[weak self] (sender) in
            if sender.element != nil {
                self?.handlerKeyboardNotice(sender:sender.element!)
            }
            
            }.disposed(by:keyboardBg)
        
        ///监听键盘显示 did
        (NotificationCenter.default.rx.notification(UIResponder.keyboardDidShowNotification, object: nil)).subscribe {[weak self] (sender) in
            if sender.element != nil {
                self?.KEYBOARDDIDAPPEAR = true
            }
            }.disposed(by:keyboardBg)
        let _ = (NotificationCenter.default.rx.notification(UIResponder.keyboardDidHideNotification, object: nil)).subscribe {[weak self] (sender) in
            if sender.element != nil {
                self?.KEYBOARDDIDAPPEAR = false
            }
            }.disposed(by:keyboardBg)
        
        ///监听键盘显示 will
        (NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification, object: nil)).subscribe {[weak self] (sender) in
            if sender.element != nil {
                self?.KEYBOARDWILLAPPEAR = true
            }
            }.disposed(by:keyboardBg)
        let _ = (NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification, object: nil)).subscribe {[weak self] (sender) in
            if sender.element != nil {
                self?.KEYBOARDWILLAPPEAR = false
            }
            }.disposed(by:keyboardBg)
        
    }
    
    private func handlerKeyboardNotice(sender:Notification) {
        
        let userinfo:[AnyHashable:Any] = sender.userInfo!
        
        let animation:TimeInterval = userinfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let endFrame:CGRect = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        
        keyboardchangecallback?(endFrame.origin.y)
        UIView.animate(withDuration: animation, animations: { [weak self] in
            if let s = self {
                if s.contentView.frame.maxY > endFrame.origin.y {
                    // s.contentView.frame.origin.y = endFrame.origin.y - s.contentView.frame.size.height
                    s.contentView.snp.remakeConstraints({ (make) in
                        make.left.right.equalTo(0)
                        make.bottom.equalTo(-endFrame.height)
                    })
                }else {
                    //  s.contentView.frame.origin.y = SCREEN_HEIGHT - s.contentView.frame.size.height
                    s.contentView.snp.remakeConstraints({ (make) in
                        make.left.right.equalTo(0)
                        make.bottom.equalTo(-UIUtils.TOLLBAR_HEIGHT)
                    })
                }
                s.contentView.layoutIfNeeded()
            }
        })
    }
}




