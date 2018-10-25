//
//  GTMonthPickerView.swift
//  GTEDai
//
//  Created by Apple on 2017/9/5.
//  Copyright © 2017年 国投. All rights reserved.
//

import UIKit

class GTMonthPickerView: UIView {

    var selectBlock: ((_ content: Any?) -> ())?
    
//    fileprivate var dataDictionary: [String: Int] = [
//        "30天": 1,
//        "90天": 3,
//        "180天": 6,
//        "270天": 9,
//        "360天": 12,
//        "720天": 24,
//        "1080天": 36
//    ]

    fileprivate var dataArr: [Int]! {
        get {
            var datas:[Int] = []
            for i in 0...36 {
               // dic.updateValue(i * 30, forKey: "\(i * 30)天")
                datas.append(i * 30)
            }
            return datas
        }
    }
    
    fileprivate var keys = [
        "30天", "90天", "180天", "270天", "360天", "720天", "1080天"
    ]
    
    fileprivate var leftSelectIndex = 0
    fileprivate var rightSelectIndex = 0
    
    fileprivate let bgMask = UIView.init()
    fileprivate let alertContainer = UIView()
    fileprivate(set) var leftPickerView = UIPickerView()
    fileprivate(set) var rightPickerView = UIPickerView()
    
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
        
        let button = UIButton.init()
        button.frame = CGRect(x: SCREEN_WIDTH - 60, y: 0, width: 60, height: 40)
        button.setTitle("确定", for: .normal)
        button.setTitleColor(0x999999.rgbColor, for: .normal)
        button.setTitleColor(0x333333.rgbColor, for: .highlighted)
        button.addTarget(self, action: #selector(confirmButtonClick), for: .touchUpInside)
        alertContainer.addSubview(button)
        
        self.leftPickerView.frame = CGRect(x: 0, y: 40, width: SCREEN_WIDTH / 2.0, height: 210)
        self.leftPickerView.delegate = self
        self.leftPickerView.dataSource = self
        alertContainer.addSubview(self.leftPickerView)
        
        self.rightPickerView.frame = CGRect(x: SCREEN_WIDTH / 2.0, y: 40, width: SCREEN_WIDTH / 2.0, height: 210)
        self.rightPickerView.delegate = self
        self.rightPickerView.dataSource = self
        alertContainer.addSubview(self.rightPickerView)
    }
    
    @objc func confirmButtonClick() {
        let leftValue = dataArr[leftSelectIndex]
        let rightValue = dataArr[rightSelectIndex]

        if leftValue > rightValue || (leftValue == rightValue && leftValue == 0) {
          
            HUDUtil.showHudWithText(text: "请检查回款期限是否正确", delay: 1.5)
        } else {
            self.confirm(minMonth: leftValue, maxMonth: rightValue)
            dismiss()
        }
    }
    
    func confirm(minMonth: Int, maxMonth: Int) {
        let result = (minMonth: minMonth, maxMonth: maxMonth)
        self.selectBlock?(result)
    }
    
    func show() {
        APP.window!.addSubview(self)
        leftSelectIndex = 0
        rightSelectIndex = 0
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

extension GTMonthPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataArr.count
    }
}

extension GTMonthPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(dataArr[row])天"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.leftPickerView {
            self.leftSelectIndex = row
        } else if pickerView == self.rightPickerView {
            self.rightSelectIndex = row
        }
    }
}
