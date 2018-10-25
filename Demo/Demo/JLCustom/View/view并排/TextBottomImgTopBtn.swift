//
//  TextBottomImgTopBtn.swift
//  GTEDai
//
//  Created by 国投 on 2018/7/12.
//  Copyright © 2018年 国投. All rights reserved.
//

import Foundation


//TODO:- btn
class TextBottomImgTopBtn:UIButton {


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView?.contentMode = .scaleAspectFit
        self.titleLabel?.textAlignment = .center

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect.init(x: 0, y: 0, width: contentRect.size.width, height: contentRect.size.height * 0.6)
    }

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {

        return CGRect.init(x: 0, y: contentRect.size.height * 0.6, width: contentRect.size.width, height: contentRect.size.height * 0.4)
    }

}

//TODO:- btn
class TextLeftImgRightBtn:UIButton {


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView?.contentMode = .center
        self.titleLabel?.textAlignment = .center

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect.init(x: contentRect.size.width * 0.8, y: 0, width: contentRect.size.width * 0.2, height: contentRect.size.height)
    }

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
         return CGRect.init(x: 0, y: 0, width: contentRect.size.width * 0.8, height: contentRect.size.height)

    }

}
