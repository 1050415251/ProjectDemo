//
//  ImgAndTextView.swift
//  VgSale
//
//  Created by ztsapp on 2017/8/21.
//  Copyright © 2017年 ztstech. All rights reserved.
//

import Foundation

///图跟字在一个父view里面
class ImgAndTextView: UIView {
    
    private(set) var imgV:UIImageView!
    private(set) var lab:UILabel!
    
    var SIZE:CGSize!
    
 
    
    var clickcallback:(()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(ImgAndTextView.click(sender:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        self.layer.masksToBounds = true
        addView()
    }
    
    func addView() {
        imgV = UIImageView()
        self.addSubview(imgV)
        
        lab = UILabel()
        lab.textAlignment = .left
        self.addSubview(lab)
    }
    
    
    ///设置属性 调用此方法前需要设置一个frame属性
    /// - parameters:
    ///   - img:图 传nil是没有
    ///   - text:设置字
    ///   - textC:字体颜色
    ///   - textF:字体大小
    ///   - distance:字体距离图大小
    ///   - cornerRadious:倒角
    ///   - isLeft:图在左面或者右面
    func setResult(img:UIImage?,text:String,textC:UIColor,textF:CGFloat,distance:CGFloat,cornerRadious:CGFloat,isLeft:Bool,aligment:NSTextAlignment = .center) {
        imgV.image = img
        lab.text = text
        lab.textColor = textC
        lab.font = UIFont.systemFont(ofSize: textF)
        self.layer.cornerRadius = cornerRadious
        
        upConstraints(isLeft: isLeft, distance: distance,aligment:aligment)
    }
    
    private func upConstraints(isLeft:Bool,distance:CGFloat,aligment:NSTextAlignment) {
        if SIZE == nil {
            fatalError("请再调用此属性之前设置size大小")
        }
        
        lab.sizeToFit()
        if let _ = imgV.image {
            if isLeft {
                imgV.snp.remakeConstraints({ (make) in
                    if aligment == .center {
                        make.left.equalTo((SIZE.width - (lab.frame.width + distance + imgV.image!.size.width)) * 0.5)
                    }else if aligment == .left {
                        make.left.equalTo(0)
                    }else if aligment == .right {
                        make.left.equalTo(SIZE.width - (lab.frame.width + distance + imgV.image!.size.width))
                    }
                    make.centerY.equalTo(self)
                })
                
                lab.snp.remakeConstraints({ (make) in
                    make.left.equalTo(imgV.snp.right).offset(distance)
                    make.centerY.equalTo(self)
                })
            }else {
                lab.snp.remakeConstraints({ (make) in
                    if aligment == .center {
                        make.left.equalTo((SIZE.width - (lab.frame.width + distance + imgV.image!.size.width)) * 0.5)
                    }else if aligment == .left {
                        make.left.equalTo(0)
                    }else if aligment == .right {
                        make.left.equalTo(SIZE.width - (lab.frame.width + distance + imgV.image!.size.width))
                    }
                //    make.left.equalTo((SIZE.width - (lab.frame.width + distance + imgV.image!.size.width)) * 0.5)
                    make.centerY.equalTo(self)
                })
                
                
                imgV.snp.remakeConstraints({ (make) in
                    make.left.equalTo(lab.snp.right).offset(distance)
                    make.centerY.equalTo(self)
                })
            }
        }else {
            imgV.snp.removeConstraints()
            lab.snp.remakeConstraints({ (make) in
                make.left.equalTo((SIZE.width - lab.frame.width) * 0.5)
                make.centerY.equalTo(self)
            })
        }
        
    }
    
    @objc func click(sender:UITapGestureRecognizer) {
        clickcallback?()
    }
    
    
}












