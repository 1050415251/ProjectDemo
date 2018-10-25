//
//  HudUtils.swift
//  VgSale
//
//  Created by ztsapp on 2017/7/26.
//  Copyright © 2017年 ZhanTengMr'S Zhang. All rights reserved.
//

import Foundation
import MBProgressHUD

///显示hud
class HUDUtil:NSObject {
    
    
    private static var hud:MBProgressHUD!
    ///可以点击的hud
    private static var canclickhud:MBProgressHUD!
    
    private static var BindShowHUD:Int = 0///HUD展示数量
    

    
    ///显示hud
    class func showHud(_ text:String? = nil) {

//        hud.mode = MBProgressHUDMode.indeterminate
//        hud.label.text = text ?? ""
//        hud.detailsLabel.text = ""
//        hud.show(animated: false)
        DispatchQueue.main.async {
            BindShowHUD = BindShowHUD + 1

        }

    }


    
    ///隐藏hud
    class func hideHud(isForce: Bool = false) {
        if isForce {
            BindShowHUD = 0
        }
        DispatchQueue.main.async {
            BindShowHUD = BindShowHUD - 1

            if BindShowHUD <= 0 {


            }
        }

    }
    
   

//    @objc func clickhidden(sender:UIButton) {
//        
//    }
//    
    ///从内存加载数据
    class func showHudloaddata(text:String?,callback:(()->Void)?) {
        let hud: MBProgressHUD = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        hud.customView = UIImageView(image: UIImage(named: "37x-Checkmark"))
        hud.bezelView.backgroundColor = UIUtils.makeColor(r: 0, g: 0, b: 0, a: 1.0)
        hud.mode = MBProgressHUDMode.customView
        if let t = text {
            hud.label.textColor = UIColor.white
            hud.detailsLabel.text = ""
            hud.label.text = t

        }
        hud.offset.y = -50
        hud.hide(animated: true, afterDelay: 1.0)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            callback?()
        }
    }
    

    
 
    ///显示文字hud
    class func showHudWithText(text: String, delay: Double = 1.0) {
        if text == "" {
            return
        }
        ///因为查询数据的时候有的接口会吐丝未登录 去掉这个吐丝
        if text == "用户未登录!" {
            return
        }
        DispatchQueue.main.async {
            let hud: MBProgressHUD = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
            //hud.isUserInteractionEnabled = false
            hud.mode = MBProgressHUDMode.text
            
            hud.offset.y = -50
            hud.detailsLabel.text = text
            hud.label.text = ""
            hud.detailsLabel.font = UIFont.boldSystemFont(ofSize: 15)
            hud.hide(animated: false, afterDelay: delay)
        }
       
    }
}




extension MBProgressHUD {
    
    /**
     * The HUD delegate object. Receives HUD state notifications.
     */
    @discardableResult
    open func delegate(_ delegate: MBProgressHUDDelegate) -> MBProgressHUD {
        self.delegate = delegate
        return self
    }
    
    /**
     * Called after the HUD is hiden.
     */
    @discardableResult
    open func completionBlock(_ completionBlock: @escaping () -> ()) -> MBProgressHUD {
        self.completionBlock = completionBlock
        return self
    }
    
    /*
     * Grace period is the time (in seconds) that the invoked method may be run without
     * showing the HUD. If the task finishes before the grace time runs out, the HUD will
     * not be shown at all.
     * This may be used to prevent HUD display for very short tasks.
     * Defaults to 0 (no grace time).
     */
    @discardableResult
    open func graceTime(_ graceTime: TimeInterval) -> MBProgressHUD {
        self.graceTime = graceTime
        return self
    }
    
    /**
     * The minimum time (in seconds) that the HUD is shown.
     * This avoids the problem of the HUD being shown and than instantly hidden.
     * Defaults to 0 (no minimum show time).
     */
    @discardableResult
    open func minShowTime(_ minShowTime: TimeInterval) -> MBProgressHUD {
        self.minShowTime = minShowTime
        return self
    }
    
    /**
     * Removes the HUD from its parent view when hidden.
     * Defaults to NO.
     */
    @discardableResult
    open func removeFromSuperViewOnHide(_ removeFromSuperViewOnHide: Bool) -> MBProgressHUD {
        self.removeFromSuperViewOnHide = removeFromSuperViewOnHide
        return self
    }
    
    /// @name Appearance
    
    /**
     * MBProgressHUD operation mode. The default is MBProgressHUDModeIndeterminate.
     */
    @discardableResult
    open func mode(_ mode: MBProgressHUDMode) -> MBProgressHUD {
        self.mode = mode
        return self
    }
    
    /**
     * A color that gets forwarded to all labels and supported indicators. Also sets the tintColor
     * for custom views on iOS 7+. Set to nil to manage color individually.
     * Defaults to semi-translucent black on iOS 7 and later and white on earlier iOS versions.
     */
    @discardableResult
    open func contentColor(_ contentColor: UIColor) -> MBProgressHUD {
        self.contentColor = contentColor
        return self
    }
    
    /**
     * The animation type that should be used when the HUD is shown and hidden.
     */
    @discardableResult
    open func animationType(_ animationType: MBProgressHUDAnimation) -> MBProgressHUD {
        self.animationType = animationType
        return self
    }
    
    /**
     * The bezel offset relative to the center of the view. You can use MBProgressMaxOffset
     * and -MBProgressMaxOffset to move the HUD all the way to the screen edge in each direction.
     * E.g., CGPointMake(0.f, MBProgressMaxOffset) would position the HUD centered on the bottom edge.
     */
    @discardableResult
    open func offset(_ offset: CGPoint) -> MBProgressHUD {
        self.offset = offset
        return self
    }
    
    /**
     * The amount of space between the HUD edge and the HUD elements (labels, indicators or custom views).
     * This also represents the minimum bezel distance to the edge of the HUD view.
     * Defaults to 20.f
     */
    @discardableResult
    open func margin(_ margin: CGFloat) -> MBProgressHUD {
        self.margin = margin
        return self
    }
    
    /**
     * The minimum size of the HUD bezel. Defaults to CGSizeZero (no minimum size).
     */
    @discardableResult
    open func minSize(_ minSize: CGSize) -> MBProgressHUD {
        self.minSize = minSize
        return self
    }
    
    /**
     * Force the HUD dimensions to be equal if possible.
     */
    @discardableResult
    open func square(_ square: Bool) -> MBProgressHUD {
        self.isSquare = square
        return self
    }
    
    /**
     * When enabled, the bezel center gets slightly affected by the device accelerometer data.
     * Has no effect on iOS < 7.0. Defaults to YES.
     */
    @discardableResult
    open func defaultMotionEffectsEnabled(_ defaultMotionEffectsEnabled: Bool) -> MBProgressHUD {
        self.areDefaultMotionEffectsEnabled = defaultMotionEffectsEnabled
        return self
    }
    
    /// @name Progress
    
    /**
     * The progress of the progress indicator, from 0.0 to 1.0. Defaults to 0.0.
     */
    @discardableResult
    open func progress(_ progress: Float) -> MBProgressHUD {
        self.progress = progress
        return self
    }
    
    /// @name ProgressObject
    
    /**
     * The NSProgress object feeding the progress information to the progress indicator.
     */
    @discardableResult
    open func progressObject(_ progressObject: Progress) -> MBProgressHUD {
        self.progressObject = progressObject
        return self
    }
    
    /// @name Views
    
    /**
     * The view containing the labels and indicator (or customView).
     */
    @discardableResult
    open func bezelView(_ block: (MBBackgroundView) -> Void) -> MBProgressHUD {
        block(self.bezelView)
        return self
    }
    
    /**
     * View covering the entire HUD area, placed behind bezelView.
     */
    @discardableResult
    open func backgroundView(_ block: (MBBackgroundView) -> Void) -> MBProgressHUD {
        block(self.backgroundView)
        return self
    }
    
    /**
     * The UIView (e.g., a UIImageView) to be shown when the HUD is in MBProgressHUDModeCustomView.
     * The view should implement intrinsicContentSize for proper sizing. For best results use approximately 37 by 37 pixels.
     */
    @discardableResult
    open func customView(_ customView: UIView) -> MBProgressHUD {
        self.customView = customView
        return self
    }
    
    /**
     * A label that holds an optional short message to be displayed below the activity indicator. The HUD is automatically resized to fit
     * the entire text.
     */
    @discardableResult
    open func label(_ block: (UILabel) -> Void ) -> MBProgressHUD {
        block(self.label)
        return self
    }
    
    
    /**
     * A label that holds an optional details message displayed below the labelText message. The details text can span multiple lines.
     */
    @discardableResult
    open func detailsLabel(_ block: (UILabel) -> Void ) -> MBProgressHUD {
        block(self.detailsLabel)
        return self
    }
    
    /**
     * A button that is placed below the labels. Visible only if a target / action is added.
     */
    @discardableResult
    open func button(_ block: (UIButton) -> Void ) -> MBProgressHUD {
        block(self.button)
        return self
    }
    
    /**
     * custom 自定义一些属性
     */
    @discardableResult
    open func labelText(_ labelText: String?) -> MBProgressHUD {
        self.label.text = labelText
        return self
    }
}


extension MBProgressHUD {
    
    convenience init(for view: UIView, block: (MBProgressHUD) -> Void) {
        self.init(for: view)!
        block(self)
    }
    
    convenience init(view: UIView, block: (MBProgressHUD) -> Void) {
        self.init(view: view)
        block(self)
    }
    
    open func showAdded(to view: UIView, animated: Bool) -> MBProgressHUD {
        return MBProgressHUD.showAdded(to: view, animated: animated)
    }
}


extension MBBackgroundView {
    /**
     * The background style.
     * Defaults to MBProgressHUDBackgroundStyleBlur on iOS 7 or later and MBProgressHUDBackgroundStyleSolidColor otherwise.
     * @note Due to iOS 7 not supporting UIVisualEffectView, the blur effect differs slightly between iOS 7 and later versions.
     */
    @discardableResult
    open func style(_ style: MBProgressHUDBackgroundStyle) -> MBBackgroundView {
        self.style = style
        return self
    }
    
    /**
     * The background color or the blur tint color.
     * @note Due to iOS 7 not supporting UIVisualEffectView, the blur effect differs slightly between iOS 7 and later versions.
     */
    @discardableResult
    open func color(_ color: UIColor) -> MBBackgroundView {
        self.color = color
        return self
    }
}

