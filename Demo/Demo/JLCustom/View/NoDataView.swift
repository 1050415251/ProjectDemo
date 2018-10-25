//
//  NoDataView.swift
//  GTEDai
//
//  Created by 国投 on 2018/1/26.
//  Copyright © 2018年 国投. All rights reserved.
//

import Foundation
import UIKit

///没有数据的view
class NoDataView: UIView {
    
    var tipImg:UIImageView!
    var tipLabel:UILabel!
    var imgToTop:CGFloat = 20
    var labelToImg:CGFloat = 10
    
    var IMGTOTOP:CGFloat {
        get {
            return tipImg.frame.origin.y
        }set {
            tipImg.snp.updateConstraints { (make) in
                make.top.equalTo(newValue)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initViews(){
        addImgView()
        addTipLabel()
        updateViewFrame()
    }
    
    private func addImgView(){
        tipImg = UIImageView()
        self.addSubview(tipImg)
    }
    
    private func addTipLabel(){
        tipLabel = UILabel()
        tipLabel.font = UIFont.systemFont(ofSize: 13)
        tipLabel.textColor = UIUtils.makeColor(r: 177, g: 185, b: 191, a: 1.0)
        self.addSubview(tipLabel)
        
    }
    
    func updateViewFrame(){
        tipImg.snp.makeConstraints { (make) in
            make.top.equalTo(imgToTop)
            make.centerX.equalTo(self)
        }
        
        tipLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(tipImg)
            make.top.equalTo(tipImg.snp.bottom).offset(labelToImg)
        }
        
    }
    
}
