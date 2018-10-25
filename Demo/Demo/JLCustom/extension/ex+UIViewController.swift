//
//  ex+UIViewController.swift
//  CustomFile
//
//  Created by 国投 on 2018/10/19.
//  Copyright © 2018 FlyKite. All rights reserved.
//

import Foundation

extension UIViewController {

    func refreshstatubarstyle(_ barstyle:UIStatusBarStyle) {
        UIApplication.shared.setStatusBarStyle(barstyle, animated: true)
    }

    func refreshstatusbarisHidden(_ isHidden:Bool) {
        UIApplication.shared.setStatusBarHidden(isHidden, with: .fade)
    }

    /// 去web页面的方法
    ///
    /// - Parameters:
    ///   - url: 网址可以是html标签
    ///   - title: web容器的默认title可以不传但是在web加载完成后悔以网页title为准
    ///   - isHTMLlab: 是否是html标签
    ///   - finish: 完成的回调
    func goH5(_ url: String, title: String? = nil,isHTMLlab:Bool = false,finish:(()->Void)? = nil) {
        if url == "" {
            return
        }
        let webV = WebController.normalWebInstance(url: !url.hasPrefix("http") && !isHTMLlab ? NetConstants.api + url:url, title,finish: finish)
        if self.navigationController != nil {
            self.navigationController?.show(webV, sender: nil)
        }else {
            APP.navController.show(webV, sender: nil)
        }
    }




    func addlineView(offset:CGFloat) {
        for i in self.view.subviews {
            if i.frame.origin.y == offset && i.frame.height == 0.5 {
                return
            }
        }

        let view = UIView(frame:CGRect.init(x: 0, y: offset, width: self.view.frame.width, height: 0.5))
        view.backgroundColor = UIUtils.makeColor(r: 229, g: 229, b: 229, a: 1.0)
        self.view.addSubview(view)

    }

    func removelineView(offset:CGFloat) {
        for i in self.view.subviews {
            if i.frame.origin.y == offset && i.frame.height == 0.5 {
                i.removeFromSuperview()
                return
            }
        }
    }

    ///添加通用的NAVview
    @discardableResult
    func addTopNavView(bgcolor:UIColor,leftimg:String?,lefttext:String? = nil,leftTextColor:UIColor? = nil,title:String,titleTextColor:UIColor?,rightimg:String? = nil,righttitle:String? = nil,rightTextColor:UIColor? = nil) -> UIView? {
        self.navigationController?.navigationBar.isHidden = true


        for i in self.view.subviews {
            if i.frame == CGRect(x:0,y:0,width:self.view.frame.width,height:UIUtils.STATUSBAR_HEIGHT + 44) {
                i.removeFromSuperview()
                break
            }
        }
        if let view = getTitleView(title: title,titleTextColor: titleTextColor) {
            view.isUserInteractionEnabled = true
            view.backgroundColor = bgcolor
            if let leftview = getleftView(leftimg: leftimg, lefttext: lefttext, leftTextColor: leftTextColor) {
                leftview.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer()
                tap.addTarget(self, action: #selector(UIViewController.onNavgiationLeftClick(sender:)))
                leftview.addGestureRecognizer(tap)
                view.addSubview(leftview)
            }
            if let rightview = getrightView(rightimg: rightimg, righttile: righttitle, rightTextColor: rightTextColor) {
                rightview.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer()
                tap.addTarget(self, action:#selector(UIViewController.onNavgiationRightClick(sender:)))
                rightview.addGestureRecognizer(tap)

                view.addSubview(rightview)
            }
            self.view.addSubview(view)
            return view
        }
        return nil
    }

    //MARK:- 设置导航栏头部
    func setNavheadTitle(_ headTitle:String) {
        for i in self.view.subviews {
            if i.frame == CGRect(x:0,y:0,width:self.view.frame.width,height:UIUtils.STATUSBAR_HEIGHT + 44) {
                for j in i.subviews {
                    if j.classForCoder == UILabel.classForCoder() && j.frame.width == SCREEN_WIDTH - 110 {
                        (j as! UILabel).text = headTitle
                    }
                }
                break
            }
        }
    }

    //MARK:- 设置导航栏北京颜色
    func setNavBgColor(_ bgColor:UIColor) {
        for i in self.view.subviews {
            if i.frame == CGRect(x:0,y:0,width:self.view.frame.width,height:UIUtils.STATUSBAR_HEIGHT + 44) {
                i.backgroundColor = bgColor
                break
            }
        }
    }

    func getNavHeadTitle() -> String {
        for i in self.view.subviews {
            if i.frame == CGRect(x:0,y:0,width:self.view.frame.width,height:UIUtils.STATUSBAR_HEIGHT + 44) {
                for j in i.subviews {
                    if j.classForCoder == UILabel.classForCoder() && j.frame.width == SCREEN_WIDTH - 110 {
                        return (j as! UILabel).text ?? "" == "" ? "":(j as! UILabel).text ?? ""
                    }
                }
                break
            }
        }
        return ""
    }


    func getTitleView(title:String,titleTextColor:UIColor?) -> UIView? {

        let baseview  = UIView(frame:CGRect(x:0,y:0,width:SCREEN_WIDTH,height:UIUtils.STATUSBAR_HEIGHT + 44))
        let width:CGFloat = (baseview.frame.width - 110)
        let height:CGFloat = CGFloat(20)
        let lab = UILabel(frame:CGRect(origin: CGPoint(x:(baseview.frame.width - width) * 0.5,y:UIUtils.STATUSBAR_HEIGHT + (44 - height) * 0.5),size: CGSize(width: width,height: height)))
        lab.font = UIFont.systemFont(ofSize: 16)
        lab.text = title
        lab.textAlignment = .center
        if let color = titleTextColor {
            lab.textColor = color
        }
        baseview.addSubview(lab)
        return baseview
    }



    func getleftView(leftimg:String?,lefttext:String?,leftTextColor:UIColor?) -> UIView? {

        if let text = lefttext {
            let bgtext = UILabel(frame:CGRect(x:0,y:UIUtils.STATUSBAR_HEIGHT,width:55,height:44))
            bgtext.text = text
            bgtext.font = UIFont.systemFont(ofSize: 14)
            bgtext.textColor = leftTextColor
            bgtext.textAlignment = .center
            bgtext.isUserInteractionEnabled = true
            return bgtext
        }
        if let img = leftimg {
            let bgimg = UIImageView(frame:CGRect(x:0,y:UIUtils.STATUSBAR_HEIGHT,width:55,height:44))

            bgimg.image = UIImage(named:"\(img)")
            bgimg.isUserInteractionEnabled = true
            bgimg.contentMode = .center
            return bgimg
        }

        return nil
    }


    func getrightView(rightimg:String?,righttile:String?,rightTextColor:UIColor?) -> UIView? {

        if let text = righttile {
            let bgtext = UILabel()
            bgtext.text = text
            bgtext.font = UIFont.systemFont(ofSize: 14)
            bgtext.sizeToFit()
            let width = bgtext.frame.width < 80 ? bgtext.frame.width:80
            bgtext.frame = CGRect(x:self.view.frame.width - width - 15,y:UIUtils.STATUSBAR_HEIGHT,width:width,height:44)
            bgtext.textColor = rightTextColor
            bgtext.textAlignment = .center
            bgtext.isUserInteractionEnabled = true

            return bgtext
        }
        if let img = rightimg {
            let bgimg = UIImageView(frame:CGRect(x:self.view.frame.width - 55,y:UIUtils.STATUSBAR_HEIGHT,width:55,height:44))
            bgimg.image = UIImage(named:"\(img)")
            bgimg.isUserInteractionEnabled = true
            bgimg.contentMode = .center
            return bgimg
        }
        return nil
    }

    @objc func onNavgiationLeftClick(sender:UITapGestureRecognizer) {
        self.view.endEditing(true)
        if let nav = self.navigationController {
            if nav.children.count == 1 {
                nav.dismiss(animated: true, completion: nil)
            }
            else {
                nav.popViewController(animated: true)
            }
        }else {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc func onNavgiationRightClick(sender:UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @objc func onNavgiationCenterClick(sender:UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

extension UIViewController {



    @objc func willAppear(animatie:Bool) {
        if self.classForCoder ==  NSClassFromString("UICompatibilityInputViewController") || self.classForCoder ==  NSClassFromString("UIInputWindowController") || self.classForCoder ==  NSClassFromString("UICompatibilityInputViewController") || self.classForCoder ==  NSClassFromString("UISystemKeyboardDockController")  {
            return
        }
        DEBUG.DEBUGPRINT(obj: "runtime 拦截了viewwillAppear事件")
    }

    @objc func didAppear(animatie:Bool) {
        if self.classForCoder ==  NSClassFromString("UICompatibilityInputViewController") || self.classForCoder ==  NSClassFromString("UIInputWindowController") || self.classForCoder ==  NSClassFromString("UICompatibilityInputViewController") || self.classForCoder ==  NSClassFromString("UISystemKeyboardDockController")  {
            return
        }

        let name = NSStringFromClass(self.classForCoder)
        print("begin",name)
        DEBUG.DEBUGPRINT(obj: "runtime 拦截了viewdidAppear事件")

    }

    @objc func willDisAppear(animatie:Bool) {
        if self.classForCoder ==  NSClassFromString("UICompatibilityInputViewController") || self.classForCoder ==  NSClassFromString("UIInputWindowController") || self.classForCoder ==  NSClassFromString("UICompatibilityInputViewController") || self.classForCoder ==  NSClassFromString("UISystemKeyboardDockController")  {
            return
        }
        HUDUtil.hideHud(isForce: true)
    }

    @objc func didDisAppear(animated:Bool) {
        if self.classForCoder ==  NSClassFromString("UICompatibilityInputViewController") || self.classForCoder ==  NSClassFromString("UIInputWindowController") || self.classForCoder ==  NSClassFromString("UICompatibilityInputViewController") || self.classForCoder ==  NSClassFromString("UISystemKeyboardDockController")  {
            return
        }

        let name = NSStringFromClass(self.classForCoder)
        print("end",name)
       
    }

}

////MARK: runtime  拦截viewcontroller的viewwillappear
//func setWillAppearEvent() {
//    let origsel = #selector(UIViewController.viewWillAppear(_:))
//    let origMethod = class_getInstanceMethod(UIViewController.classForCoder(), origsel)
//
//    let nowsel = #selector(UIViewController.willAppear(animatie:))
//    let nowMethod = class_getInstanceMethod(UIViewController.classForCoder(), nowsel)
//
//    let addmethod = class_addMethod(UIViewController.classForCoder(), origsel, method_getImplementation(nowMethod!), method_getTypeEncoding(nowMethod!))
//    if addmethod {
//        class_replaceMethod(UIViewController.classForCoder(), nowsel, method_getImplementation(origMethod!), method_getTypeEncoding(origMethod!))
//    }else {
//        method_exchangeImplementations(origMethod!, nowMethod!)
//    }
//}
//
////MARK: runtime  拦截viewcontroller的viewwillappear
//func setDidAppearEvent() {
//    let origsel = #selector(UIViewController.viewDidAppear(_:))
//    let origMethod = class_getInstanceMethod(UIViewController.classForCoder(), origsel)
//
//    let nowsel = #selector(UIViewController.didAppear(animatie:))
//    let nowMethod = class_getInstanceMethod(UIViewController.classForCoder(), nowsel)
//
//    let addmethod = class_addMethod(UIViewController.classForCoder(), origsel, method_getImplementation(nowMethod!), method_getTypeEncoding(nowMethod!))
//    if addmethod {
//        class_replaceMethod(UIViewController.classForCoder(), nowsel, method_getImplementation(origMethod!), method_getTypeEncoding(origMethod!))
//    }else {
//        method_exchangeImplementations(origMethod!, nowMethod!)
//    }
//}
//
//func setWillDisAppearEvent() {
//
//    let origsel = #selector(UIViewController.viewWillDisappear(_:))
//    let origMethod = class_getInstanceMethod(UIViewController.classForCoder(), origsel)
//
//    let nowsel = #selector(UIViewController.willDisAppear(animatie:))
//    let nowMethod = class_getInstanceMethod(UIViewController.classForCoder(), nowsel)
//
//    let addmethod = class_addMethod(UIViewController.classForCoder(), origsel, method_getImplementation(nowMethod!), method_getTypeEncoding(nowMethod!))
//    if addmethod {
//        class_replaceMethod(UIViewController.classForCoder(), nowsel, method_getImplementation(origMethod!), method_getTypeEncoding(origMethod!))
//    }else {
//        method_exchangeImplementations(origMethod!, nowMethod!)
//    }
//}
//
//func setDidDisAppearEvent() {
//
//    let origsel = #selector(UIViewController.viewDidDisappear(_:))
//    let origMethod = class_getInstanceMethod(UIViewController.classForCoder(), origsel)
//
//    let nowsel = #selector(UIViewController.didDisAppear(animated:))
//    let nowMethod = class_getInstanceMethod(UIViewController.classForCoder(), nowsel)
//
//    let addmethod = class_addMethod(UIViewController.classForCoder(), origsel, method_getImplementation(nowMethod!), method_getTypeEncoding(nowMethod!))
//    if addmethod {
//        class_replaceMethod(UIViewController.classForCoder(), nowsel, method_getImplementation(origMethod!), method_getTypeEncoding(origMethod!))
//    }else {
//        method_exchangeImplementations(origMethod!, nowMethod!)
//    }
//}
