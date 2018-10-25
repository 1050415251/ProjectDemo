//
//  InputInfoView.swift
//  VgSale
//
//  Created by ztsapp on 2017/9/29.
//  Copyright © 2017年 ztstech. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import YYText

class InputinfoView: UIView  {
    
    
    ///不要写成私有的
    static let HEIGHT:CGFloat = 40
    
    var leftLab:UILabel!
    var inputTextField:UITextField!
    var imgV:UIImageView!
    
    ///文本改变的回调
    var textchangecallback:((String)->Void)?
    var clickselfcallback:(()->Void)?
    var textbegindeditcallback:(()->Void)?
    var textendeditcallback:(()->Void)?
    
    private var tap:UITapGestureRecognizer!
    private let inputBg = DisposeBag()
    
    
    var showimg:Bool {///如果leftText不为空 那么设置img的时候需要设置一下img的frame同时文本框不能编辑
        get {
            return self.showimg
        }set {
            if padingToLeft == nil {
                fatalError("请先设置padingleft")
            }else {
                imgV.isHidden = !newValue
                inputTextField.isEnabled = !newValue
                tap.isEnabled = newValue
                if !imgV.isHidden {
                    imgV.snp.remakeConstraints { (make) in
                        make.right.equalTo(-7)
                        make.centerY.equalTo(inputTextField)
                    }
                    inputTextField.snp.updateConstraints({ (make) in
                        make.right.equalTo(-(imgV.image!.size.width + 7 + 5))
                    })
                }
            }
        }
    }

    
    var padingToLeft:CGFloat! {
        get {
            return inputTextField.frame.origin.x
        }set {
            
            updateFrame(width: newValue)
        }
    }
    
    
    var leftText:String {
        get {
            return self.leftText
        }set {
            leftLab.text = newValue
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.layer.masksToBounds = true
        self.layer.cornerRadius = 2
        initView()
        addGesture()
        initObserVer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initView() {
        addView()
    }
    
    func addGesture() {
        tap = UITapGestureRecognizer(target:self,action:#selector(InputinfoView.clickself))
        tap.isEnabled = false
        self.addGestureRecognizer(tap)
    }
    
    func addView() {
        leftLab = UILabel()
        leftLab.font = UIFont.systemFont(ofSize: 14)
        leftLab.textColor = 0x333333.rgbColor
        leftLab.textAlignment = .left
        leftLab.isUserInteractionEnabled = false
        self.addSubview(leftLab)
        
        inputTextField = UITextField()
        inputTextField.font = UIFont.systemFont(ofSize: 14)
        inputTextField.textColor = 0x333333.rgbColor
        self.addSubview(inputTextField)
        
        imgV = UIImageView(image:#imageLiteral(resourceName: "arrow.png"))
        imgV.isHidden = true
        self.addSubview(imgV)
    }
    
    func setPlaceText(newValue:String) {
       // self.toolbarPlaceholder = newValue
        let attritu = NSMutableAttributedString.init(string: newValue)
        attritu.yy_font = UIFont.systemFont(ofSize: 14)
        attritu.yy_color = 0x999999.rgbColor
        inputTextField.attributedPlaceholder = attritu
    }
    
    
    func updateFrame(width:CGFloat) {
        leftLab.snp.remakeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(8)
            make.bottom.equalTo(0)
        }
        
        inputTextField.snp.remakeConstraints { (make) in
            ///50 + 10 lab 距离左面的距离
            make.left.equalTo(width)
            make.top.equalTo(0.5)
            make.right.equalTo(-7)
            make.bottom.equalTo(0)
        }
        
        if !imgV.isHidden {
            imgV.snp.remakeConstraints { (make) in
                make.right.equalTo(-7)
                make.centerY.equalTo(inputTextField)
            }
            inputTextField.snp.updateConstraints({ (make) in
                make.right.equalTo(-(imgV.image!.size.width + 7 + 5))
            })
        }
    }
    
    func initObserVer() {
        (inputTextField.rx.text).subscribe {[weak self] (event) in
            if  event.element != nil {
                if let text = event.element! {
                    self?.textchangecallback?(text)
                }
            }
            }.disposed(by:inputBg)
        
        inputTextField.rx.controlEvent(UIControlEvents.editingDidBegin).subscribe {[weak self] (_) in
            self?.textbegindeditcallback?()
        }.disposed(by:inputBg)
        
        inputTextField.rx.controlEvent(UIControlEvents.editingDidEnd).subscribe {[weak self] (_) in
            self?.textendeditcallback?()
        }.disposed(by:inputBg)
    }
    
    ///设置间距的重新优化约束
    func setLineSpacing(spacing:CGFloat,text:String) {
        let attritu = NSMutableAttributedString.init(string: text)
        attritu.yy_lineSpacing = spacing
        leftLab.attributedText = attritu
        leftLab.frame.origin.x = leftLab.frame.origin.x - spacing
    }
    
    
    @objc func clickself() {
        clickselfcallback?()

    }
    
}
