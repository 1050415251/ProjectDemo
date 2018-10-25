//
//  GTDatePickerView.swift
//  GTEDai
//
//  Created by Apple on 2017/8/17.
//  Copyright © 2017年 国投. All rights reserved.
//

import UIKit

class GTDatePickerView: UIView {

    var selectBlock: ((_ content: Any?) -> ())?
    
    fileprivate let bgMask = UIView.init()
    fileprivate let alertContainer = UIView()
    
    fileprivate(set) var datePickerView = UIDatePicker()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        bgMask.frame = self.bounds
        bgMask.backgroundColor = UIColor.black
        bgMask.alpha = 0
        bgMask.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(dismiss)))
        self.addSubview(bgMask)
        
        alertContainer.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 250)
        alertContainer.backgroundColor = UIColor.white
        self.addSubview(alertContainer)

        let centerLab = UILabel(frame: CGRect(x:60, y: 0, width: SCREEN_WIDTH - 120, height: 40))
        centerLab.text = "请选择"
        centerLab.textAlignment = .center
     
        centerLab.textColor = 0x999999.rgbColor
        alertContainer.addSubview(centerLab)
        
        let button = UIButton.init()
        button.frame = CGRect(x: SCREEN_WIDTH - 60, y: 0, width: 60, height: 40)
        button.setTitle("确定", for: .normal)
        button.setTitleColor(0x999999.rgbColor, for: .normal)
        button.setTitleColor(0x333333.rgbColor, for: .highlighted)
        button.addTarget(self, action: #selector(confirmButtonClick), for: .touchUpInside)
        alertContainer.addSubview(button)
        
        datePickerView.frame = CGRect(x: 0, y: 40, width: SCREEN_WIDTH, height: 210)
        datePickerView.datePickerMode = .date
        alertContainer.addSubview(datePickerView)
    }
    
    func setInfo(maxDate: Date?, minDate: Date?) {
        datePickerView.minimumDate = minDate
        datePickerView.maximumDate = maxDate
    }
    
    @objc func confirmButtonClick() {
        self.confirm()
        dismiss()
    }
    
    func confirm() {
        // 子类block回调
        let selectDate = self.datePickerView.date
        let zone = TimeZone.current
        let interval:TimeInterval = TimeInterval(zone.secondsFromGMT(for: selectDate))
        let localeDate = selectDate.addingTimeInterval(interval)
        self.selectBlock?(localeDate)
    }
    
    func show() {
        APP.window!.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.bgMask.alpha = 0.5
            self.alertContainer.y = SCREEN_HEIGHT - 250
        }
    }
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bgMask.alpha = 0
            self.alertContainer.y = SCREEN_HEIGHT
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
}
