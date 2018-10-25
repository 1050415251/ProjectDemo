//
//  BottomManySelectView.swift
//  VgSale
//
//  Created by ztsapp on 2017/12/9.
//  Copyright © 2017年 ztstech. All rights reserved.
//

import Foundation
import UIKit

//n个view并排在下面
class BottomManySelectView: UIView {
    
    var topLine : UIView!
    typealias ItemV = ImgAndTextView
    
    var clickcomplete:((Int)->Void)?
    
    
    var dataSrcV:[ItemV] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        topLine = UIView()
        topLine.backgroundColor = 0xdcdcdc.rgbColor
        self.addSubview(topLine)
        topLine.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.height.equalTo(0.5)
            make.left.right.equalTo(0)
        }
       self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    ///设置view的属性从左往右带图的
    /// - parameters:
    ///   datas: labs的文字
    ///   textC:lab的字体颜色数组
    ///   bgColr: 背景颜色
    ///   bordColor: 边框颜色
    ///   distance: view与view的间距
    func setHavIcoResult(datas:[String],imgs:[UIImage?],isLefts:[Bool],textC:[UIColor],bgColr:[UIColor],bordColor:[UIColor],distance:CGFloat,fontsize:CGFloat = 13,cornerRadious: CGFloat = 2) {
        let WIDTH = (SCREEN_WIDTH - 30 - CGFloat(datas.count - 1) * distance)/CGFloat(datas.count)
        
        let maxcount = datas.count
        if maxcount == textC.count &&  maxcount == bgColr.count && maxcount == bordColor.count {
            for i in 0..<datas.count {
                let lab = ItemV()
                lab.SIZE = CGSize.init(width: WIDTH, height: 40)
                lab.backgroundColor = bgColr[i]
                lab.layer.borderColor = bordColor[i].cgColor
                lab.layer.cornerRadius = 2
                lab.layer.borderWidth = 0.5
                lab.setResult(img: imgs[i], text: datas[i], textC: textC[i], textF: fontsize, distance: distance, cornerRadious: cornerRadious, isLeft: isLefts[i])
                lab.isUserInteractionEnabled = true
                lab.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(BottomManySelectView.clickitem(sender:))))
                self.addSubview(lab)
                dataSrcV.append(lab)
            }
            upConstraints(distance:distance)
        }else {
            fatalError("请输入与 datas 一致的属性")
        }
    }
    
    ///设置view的属性从左往右不带图
    /// - parameters:
    ///   datas: labs的文字
    ///   textC:lab的字体颜色数组
    ///   bgColr: 背景颜色
    ///   bordColor: 边框颜色
    ///   distance: view与view的间距
    func setResult(datas:[String],textC:[UIColor],bgColr:[UIColor],bordColor:[UIColor],distance:CGFloat,fontsize:CGFloat,cornerRadious:CGFloat = 2) {
        let WIDTH = (SCREEN_WIDTH - 30 - CGFloat(datas.count - 1) * distance)/CGFloat(datas.count)
        
        let maxcount = datas.count
        if maxcount == textC.count &&  maxcount == bgColr.count && maxcount == bordColor.count {
            for i in 0..<datas.count {
                let lab = ItemV()
                lab.SIZE = CGSize.init(width: WIDTH, height: 40)
                lab.backgroundColor = bgColr[i]
                lab.layer.borderColor = bordColor[i].cgColor
                lab.layer.cornerRadius = 2
                lab.layer.borderWidth = 0.5
                lab.setResult(img: nil, text: datas[i], textC: textC[i], textF: fontsize, distance: distance, cornerRadious: cornerRadious, isLeft: true)
                lab.isUserInteractionEnabled = true
                lab.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(BottomManySelectView.clickitem(sender:))))
                self.addSubview(lab)
                dataSrcV.append(lab)
            }
            upConstraints(distance:distance)
        }else {
            fatalError("请输入与 datas 一致的属性")
        }
    }
    
    
    
    func upConstraints(distance:CGFloat) {
        let WIDTH = (SCREEN_WIDTH - 30 - CGFloat(dataSrcV.count - 1) * distance)/CGFloat(dataSrcV.count)
        for i in 0..<dataSrcV.count {
            dataSrcV[i].snp.remakeConstraints({ (make) in
                if i ==  0 {
                    make.top.equalTo(8)
                    make.bottom.equalTo(-8)
                    make.left.equalTo(15)
                }else {
                    make.centerY.equalTo(dataSrcV[0])
                    make.width.height.equalTo(dataSrcV[i - 1])
                    make.left.equalTo(dataSrcV[i - 1].snp.right).offset(distance)
                }
                make.width.equalTo(WIDTH)
               // make.height.equalTo(40)
            })
           
        }
    }
    
    @objc func clickitem(sender:UITapGestureRecognizer) {
        clickcomplete?(dataSrcV.index(of: sender.view as! ItemV)!)
    }
   
    
}
