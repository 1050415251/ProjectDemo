//
//  KeyBoardView.swift
//  GTEDai
//
//  Created by 国投 on 2018/1/18.
//  Copyright © 2018年 国投. All rights reserved.
//

import Foundation
import UIKit

class ZJLKeyBoardTabV: UITableView {
    
    private var keyboardViewup:KeyBoardViewUpUtils!
    
    ///输入框的高度
    var inputVheight:CGFloat{
        get {
            if keyboardViewup == nil {
                fatalError("请设置输入框高度")
            }
            
            return keyboardViewup.inputVHeight
        }set{
            keyboardViewup.inputVHeight = newValue
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.separatorStyle = .none
        self.tableFooterView = UIView()
        initObserVer()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initObserVer() {
        keyboardViewup = KeyBoardViewUpUtils.init(view: self)
    }
    
    func setStartY(y:CGFloat) {
        keyboardViewup.viewStartY = y
    }
    
    func setEndY(y:CGFloat) {
        keyboardViewup.viewEdnY = y
    }
    
    func setClioignY(y:CGFloat) {
        keyboardViewup.cligonY = y
    }
    
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        // keyboardViewup.cligonY = point.y + inputVheight
        return super.hitTest(point, with: event)
    }
    
}


class ZJLKeyBoardScroV: UIScrollView {
    
    private var keyboardViewup:KeyBoardViewUpUtils!
    
    ///输入框的高度
    var inputVheight:CGFloat{
        get {
            if keyboardViewup == nil {
                fatalError("请设置输入框高度")
            }
            
            return keyboardViewup.inputVHeight
        }set{
            keyboardViewup.inputVHeight = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initObserVer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initObserVer() {
        keyboardViewup = KeyBoardViewUpUtils.init(view: self)
    }
    
    func setStartY(y:CGFloat) {
        keyboardViewup.viewStartY = y
    }
    
    func setEndY(y:CGFloat) {
        keyboardViewup.viewEdnY = y
    }
    
    func setClioignY(y:CGFloat) {
        keyboardViewup.cligonY = y
    }
    
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
       // keyboardViewup.cligonY = point.y + inputVheight
        return super.hitTest(point, with: event)
    }
    
}


////必须frame，必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame必须frame
class ZJLKeyBoardV: UIView {
    
    private var keyboardViewup:KeyBoardViewUpUtils!
    
    ///输入框的高度
    var inputVheight:CGFloat{
        get {
            return keyboardViewup.inputVHeight
        }set{
            keyboardViewup.inputVHeight = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initObserVer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initObserVer() {
        keyboardViewup = KeyBoardViewUpUtils.init(view: self)
    }
    
    func setStartY(y:CGFloat) {
        keyboardViewup.viewStartY = y
    }
    
    func setEndY(y:CGFloat) {
        keyboardViewup.viewEdnY = y
    }
    
    func setClioignY(y:CGFloat) {
        keyboardViewup.cligonY = y + inputVheight
    }
    
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // keyboardViewup.cligonY = point.y + inputVheight * 0.5
        return super.hitTest(point, with: event)
    }
    
}
