//
//  ShowHalfAlphaViewUtils.swift
//  VgSale
//
//  Created by ztsapp on 2017/9/15.
//  Copyright © 2017年 ztstech. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

///显示出半透明的
class ShowHalfAlphaViewUtils: NSObject {
    
    
    fileprivate weak var ctr:UIViewController!
    var alphaV:AlphaView!

    fileprivate var obsrver:AnyObserver<Int>!///点击第n项
    
    init(ctr:UIViewController) {
        self.ctr = ctr
        super.init()
        initView()
    }
    
    func initView() {
        
        alphaV = AlphaView.init(ctr: ctr)
        alphaV.backgroundColor = UIUtils.makeColor(r: 0, g: 0, b: 0, a: 0.5)
        ctr.view.addSubview(alphaV)
        alphaV.hidden()
    }
    
    func getViewSize(baseV:UIView,WIDTH:CGFloat) -> CGSize {
        let height = baseV.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let size = CGSize.init(width: WIDTH, height: height)
        return size
    }

    func hidden() {
        alphaV.hidden()
    }
    
}


//MARK:点击区域
extension ShowHalfAlphaViewUtils  {

    func showimgView(img: UIImage,complete: (()->Void)?) {
        let bgV = UIView()
        bgV.backgroundColor = UIColor.clear
        alphaV.addSubview(bgV)

        let imgV = UIImageView(image: img)
        imgV.backgroundColor =  0xffffff.rgbColor
        imgV.layer.cornerRadius = 9

        bgV.addSubview(imgV)
        imgV.snp.remakeConstraints { (make) in
            make.centerX.equalTo(bgV)
            make.width.equalTo(img.size.width)
            make.height.equalTo(img.size.height)
            make.top.equalTo(bgV)
        }

        let closeBtn = UIButton(type: .custom)
        closeBtn.setImage(#imageLiteral(resourceName: "close_btn"), for: UIControlState.normal)
        bgV.addSubview(closeBtn)
        closeBtn.snp.remakeConstraints { (make) in
            make.top.equalTo(imgV.snp.bottom).offset(30)
            make.centerX.equalTo(bgV)
            make.bottom.equalTo(bgV)
        }

        let _ = closeBtn.rx.controlEvent(UIControlEvents.touchUpInside).subscribe {[weak self] (event) in
            if let _ = event.element {
                self?.alphaV.hidden_Animation()
                complete?()
            }
        }

        let height = bgV.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        bgV.frame = CGRect.init(x: (SCREEN_WIDTH - 305) * 0.5, y: (SCREEN_HEIGHT - height) * 0.5, width: 305, height: height)
        alphaV.CLICKELSEHIDDEN = false
        alphaV.showVframe = bgV.frame
        alphaV.show_Animation()
    }

}


