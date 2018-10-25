//
//  ItemLabCell.swift
//  GTEDai
//
//  Created by 国投 on 2018/3/20.
//  Copyright © 2018年 国投. All rights reserved.
//

import Foundation

class ItemBasicabCell:UITableViewCell {
    
    private var leftLab:UILabel!
    private(set) var rightLab:UILabel!
    private(set) var arrowImgV:UIImageView!
    var lineV:UIView!

    var longpressclickcallback:(()->Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
        self.addGestureRecognizer(UILongPressGestureRecognizer.init(target: self, action: #selector(longpressclick(sender:))))
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        addView()
    }
    
    private func addView() {
        leftLab = UILabel()
        leftLab.font = UIFont.systemFont(ofSize: 14)
        leftLab.textColor = 0x333333.rgbColor
        self.addSubview(leftLab)
        leftLab.snp.remakeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(self)
        }
        
        
        rightLab = UILabel()
        rightLab.font = UIFont.systemFont(ofSize: 14)
        rightLab.textColor = 0x333333.rgbColor
        rightLab.textAlignment = .right
        self.addSubview(rightLab)
        rightLab.snp.remakeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(self)
            make.left.lessThanOrEqualTo(leftLab.snp.right)
        }
        
        arrowImgV = UIImageView(image:#imageLiteral(resourceName: "arrow"))
        self.addSubview(arrowImgV)
        arrowImgV.snp.remakeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(self)
        }
        
        lineV = UIView()
        lineV.backgroundColor = 0xe6e6e6.rgbColor
        self.addSubview(lineV)
        lineV.snp.remakeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(0.5)
            make.bottom.equalTo(0)
        }
    }

    @objc func longpressclick(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            longpressclickcallback?()
        }
    }
    
    func setResult(leftInfo:String,rightInfo:String,canclick:Bool) {
        
        setLeftInfo(leftInfo)
        setRightInfo(rightInfo)
        
        setCanClick(canclick)
        
    }
    
    func setLeftInfo(_ leftInfo:String) {
        leftLab.text = leftInfo
    }
    
    func setRightInfo(_ rightInfo:String) {
        rightLab.text = rightInfo
    }
    
    func setCanClick(_ canClick:Bool) {
        arrowImgV.isHidden = !canClick
        self.selectionStyle = canClick ? .default:.none
      
        rightLab.snp.remakeConstraints { (make) in
            make.right.equalTo(-15 - #imageLiteral(resourceName: "arrow").size.width - 10)
            make.centerY.equalTo(self)
            make.left.equalTo(leftLab.snp.right)
        }
    }

}






































