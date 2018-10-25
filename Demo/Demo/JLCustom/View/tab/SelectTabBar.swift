//
//  SelectTabBar.swift
//  VgSale
//
//  Created by ztsapp on 2017/8/26.
//  Copyright © 2017年 ztstech. All rights reserved.
//

import Foundation

class SelectTabBar: UIView {
    
    var leftBackImg:UIImageView!
    ///所有标题label和提示数字label
    var labels: [UILabel] = []
    var tipsNews:[UILabel] = []
   
    var lineV:UIView!
   
    private(set) var centerV:TabBarView!
    
    //文字+提示数字
    var data: [String]!
    ///tab文字之间距离
    var labelToLabel:CGFloat = 20

    ///选中
    var onItemSelecte: ((Int) -> ())?
    var callbackLeftClick:(()->Void)?
    
    var currentIndex = 0
    ///选中字体大小
    private let SELECTED_FONT = UIFont.systemFont(ofSize: 16)
    ///未选中字体大小
    private let UN_SELECTED_FONT = UIFont.systemFont(ofSize: 16)
    private let LINE_W:CGFloat = 35
    
    
    
    init(frame: CGRect,labelToLabel:CGFloat,data:[String]) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.labelToLabel = labelToLabel
        self.data = data
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initViews(){
        addTabbarV()
        addLeftView()

    }
    
    func addTabbarV() {
        centerV = TabBarView.init(frame: CGRect(), data: data,labelToLabel:labelToLabel,currentIndex:currentIndex)
        centerV.clickcallback = { [weak self] index in
            self?.currentIndex = index
            self?.onItemSelecte?(index)
        }
        self.addSubview(centerV)
        centerV.snp.remakeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.height.equalTo(44)
        }
    }
    
    private func addLeftView(){
        leftBackImg = UIImageView(frame:CGRect(x:0,y:20,width:55,height:44))
        leftBackImg.image = #imageLiteral(resourceName: "nav_back_dark")
        leftBackImg.contentMode = .center
        leftBackImg.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(SelectTabBar.onNavgiationLeftClick))
        leftBackImg.addGestureRecognizer(tap)
        self.addSubview(leftBackImg)
        leftBackImg.snp.remakeConstraints { (make) in
            make.width.equalTo(55)
            make.height.equalTo(44)
            make.left.bottom.equalTo(0)
        }
    }
    

    func selectIndex(index:Int) {
        centerV.updateLabelColor(index: index)
    }
    
    

    
    ///设置新消息view的方法
    /// - parameters:
    ///   - news: 提示字
    ///   - textC: 的字体颜色
    ///   - backGroundc: 的背景颜色
    ///   - fontSize: 的字体代小
    ///   - frame:提示红点的大小
    func setNewsView(news:String,selecttextC:UIColor,unselecttextC:UIColor,fontSize:CGFloat,backGroundc:UIColor,index:Int,frame:CGRect) {
        if frame.width != 0 {
            fatalError("frame的width请传0")
        }
        centerV.setTipsNewsView(news: news, selecttextC:selecttextC, unselecttextC: unselecttextC, fontSize: fontSize, backGroundc: backGroundc, index: index, frame: frame)
    }
 
    
    @objc func onNavgiationLeftClick(sender:UITapGestureRecognizer){
        callbackLeftClick?()
    }
    
    
}
