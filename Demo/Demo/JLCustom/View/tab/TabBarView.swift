//
//  TabBarView.swift
//  VgSale
//
//  Created by ztsapp on 2017/8/26.
//  Copyright © 2017年 ztstech. All rights reserved.
//

import Foundation
import UIKit


class TabBarView: UIScrollView {
    
    
    var leftBackImg:UIImageView!
    ///所有标题label和提示数字label
    var labels: [UILabel] = []
    var tipsNews:[UILabel] = []
    
    var lineV:UIView!

    //文字+提示数字
    var data: [String]!
    ///tab文字之间距离
    var labelToLabel:CGFloat = 20
    var labelsWidth:CGFloat = 0 ///各个datas总共的宽度
    
    var clickcallback:((Int)->Void)?

    ///选中item字体大小
    private var SELECTED_FONT = UIFont.systemFont(ofSize: 16)
    ///未选中item字体大小
    private var UN_SELECTED_FONT = UIFont.systemFont(ofSize: 16)
    ///选中item下划线颜色
    private var SELECTEDLINE_COLOR = UIColor.white
    ///选中item字体颜色
    private var SELECTED_TEXTCOLOR = UIColor.white
    ///未选中item字体颜色
    private var UN_SELECTED_TEXTCOLOR = UIColor.white
    ///线条宽度
    private var LINE_WIDTH:CGFloat?
    
    ///选中提示字体大小
    private var TIPSSELECTTEXT_C:UIColor!
    ///未选择字体提示代销
    private var TIPSUNSELECTTEXT_C:UIColor!
    
    private var currentIndex:Int = 0
    
    init(frame: CGRect,data:[String],labelToLabel:CGFloat,currentIndex:Int) {
        super.init(frame: frame)
        self.data = data
        self.labelToLabel = labelToLabel
        addTabbarViews()
        updateLabelColor(index: currentIndex)
        self.contentSize = CGSize.init(width: labels[labels.count - 1].frame.maxX, height: 44)
        self.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTabbarViews(){
        for index in 0..<data.count{
            let label = UILabel()
            label.text = data[index]
            label.textColor = UIColor.white
            label.font = UN_SELECTED_FONT
            label.textAlignment = NSTextAlignment.center
            label.isUserInteractionEnabled = true
            self.addSubview(label)
            let gesture = UITapGestureRecognizer(target: self, action: #selector(TabBarView.onLabelTab))
            label.addGestureRecognizer(gesture)
            labels.append(label)
            label.sizeToFit()
            labelsWidth = labelsWidth + label.frame.width + labelToLabel///得到labelsWidth
            
            let tipLab = UILabel()
            tipLab.textAlignment = .center
            self.addSubview(tipLab)
            tipsNews.append(tipLab)
        }
        
        labelsWidth = CGFloat(Int(labelsWidth - labelToLabel))///需要将最后一个间隙去掉
        
        
        for index in 0..<labels.count{
            getLabelFrame(index: index)
        }
        
        lineV = UIView(frame:CGRect.init(x: 0, y: 40, width: 35, height: 2))
        lineV.layer.masksToBounds = true
        lineV.layer.cornerRadius = 1
        lineV.backgroundColor = UIColor.white
        self.addSubview(lineV)
        
    }
    
    ///根据当前位置获取label的frame
    private func getLabelFrame(index: Int) {
      //  labels[index].sizeToFit()
        if index == 0 {
            let orgX = labelsWidth > (SCREEN_WIDTH - 24) ? 0:((SCREEN_WIDTH - 24) - labelsWidth) * 0.5
            labels[index].frame = CGRect.init(x: orgX, y: 0, width:labels[index].frame.width , height: 44)
        }else {
            labels[index].frame = CGRect.init(x: labels[index - 1].frame.maxX + labelToLabel, y: 0, width: labels[index].frame.width, height: 44)
        }

    }
    
    ///更新label颜色
    func updateLabelColor(index:Int) {
        currentIndex = index
        if labels[index].frame.maxX > SCREEN_WIDTH - 24 {
            self.setContentOffset(CGPoint.init(x:labels[index].frame.maxX  - SCREEN_WIDTH, y: 0), animated: true)
        }
        else if self.contentOffset.x > labels[index].frame.minX  {
            self.setContentOffset(CGPoint.init(x:labels[index].frame.minX , y: 0), animated: true)
        }
        for i in 0..<labels.count {
            if i == index {
                labels[i].font = SELECTED_FONT
                labels[i].textColor = SELECTED_TEXTCOLOR
                labels[i].sizeToFit()
                UIView.animate(withDuration: 0.25, animations: {[weak self] in
                    if let w = self!.LINE_WIDTH {
                        self?.lineV.frame = CGRect.init(x: self!.labels[i].frame.midX - w * 0.5, y: 40, width: w, height: 2)
                    }else {
                        self?.lineV.frame = CGRect.init(x: self!.labels[i].frame.minX, y: 40, width:  self!.labels[i].frame.width, height: 2)
                    }

                })
                tipsNews[i].textColor = TIPSSELECTTEXT_C
            }else {
                labels[i].font = UN_SELECTED_FONT
                labels[i].textColor = UN_SELECTED_TEXTCOLOR
                tipsNews[i].textColor = TIPSUNSELECTTEXT_C
            }
            labels[i].sizeToFit()
            labels[i].frame = CGRect.init(x: labels[i].frame.origin.x, y: 0, width: labels[i].frame.width, height: 44)
        }
    }
    
    ///TODO: 设置item的属性
    func setItemsPropretry(selecttextC:UIColor,unselecttextC:UIColor,selectlineColor:UIColor,selectfontSize:CGFloat,unselectfontSize:CGFloat,backGroundc:UIColor,lineWidth:CGFloat? = nil) {
        SELECTED_TEXTCOLOR = selecttextC
        UN_SELECTED_TEXTCOLOR = unselecttextC
        SELECTED_FONT = UIFont.systemFont(ofSize: selectfontSize)
        UN_SELECTED_FONT = UIFont.systemFont(ofSize: unselectfontSize)
        lineV.backgroundColor = selectlineColor
        LINE_WIDTH = lineWidth
        updateLabelColor(index: currentIndex)
    }
    
    ///TODO: 红点提示的属性
    func setTipsNewsView(news:String,selecttextC:UIColor,unselecttextC:UIColor,fontSize:CGFloat,backGroundc:UIColor,index:Int,frame:CGRect) {
        if frame.width != 0 {
            fatalError("frame的width请传0")
        }
        lineV.backgroundColor = selecttextC
        tipsNews[index].text = news
        TIPSSELECTTEXT_C = selecttextC
        TIPSUNSELECTTEXT_C = unselecttextC
        
        tipsNews[index].textColor = currentIndex == index ? TIPSSELECTTEXT_C:TIPSUNSELECTTEXT_C
        tipsNews[index].backgroundColor = backGroundc
        tipsNews[index].font = UIFont.systemFont(ofSize: fontSize)
        tipsNews[index].layer.masksToBounds = true
        tipsNews[index].layer.cornerRadius = frame.height * 0.5
        
        let width = (news as NSString).boundingRect(with:  CGSize(width:CGFloat(MAXFLOAT),height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize)], context: nil).width
        
        
        tipsNews[index].snp.remakeConstraints { (make) in
            make.left.equalTo(labels[index].snp.right).offset(frame.origin.x)
            make.top.equalTo(labels[index].snp.centerY).offset(frame.origin.y - frame.height * 0.5)
            make.width.equalTo(width + frame.height)
            make.height.equalTo(frame.height)
        }
        
    }
    
    @objc func onLabelTab(sender:UITapGestureRecognizer) {
        if let index = labels.index(of: sender.view as! UILabel) {
           
            updateLabelColor(index: index)
            clickcallback?(index)
        }
    }
    
}
