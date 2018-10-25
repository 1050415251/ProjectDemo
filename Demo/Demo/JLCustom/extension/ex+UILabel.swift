//
//  ex+UILabel.swift
//  CustomFile
//
//  Created by 国投 on 2018/9/12.
//  Copyright © 2018年 FlyKite. All rights reserved.
//

import Foundation

extension UILabel {


    ///把每一行文字加成一个数组
    func getSeparatedLinesFromLabel() -> NSArray {
        let text = self.text!
        let font = self.font!
        let rect = self.frame
        let myFont = CTFontCreateWithName(font.fontName as CFString, font.pointSize,nil)
        let attstr = NSMutableAttributedString(string: text)
        //kCTFontAttributeName
        attstr.addAttributes([NSAttributedString.Key(rawValue: kCTFontAttributeName as String) : myFont], range: NSRange(location: 0,length: attstr.length))
        let frameSetter = CTFramesetterCreateWithAttributedString(attstr)
        let path = CGMutablePath()
        //      var transform = CGAffineTransform.identity
        //        CGPathAddRect(path,&transform,CGRect(x: 0,y: 0,width: rect.size.width,height: 100000))
        path.addRect(CGRect(x: 0,y: 0,width: rect.size.width,height: 100000))

        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        let lines:NSArray = CTFrameGetLines(frame)
        let linesArray:NSMutableArray = NSMutableArray()

        for line in lines {
            let lineRef:CTLine = line as! CTLine
            let lineRange = CTLineGetStringRange(lineRef)
            let range:NSRange = NSRange(location: lineRange.location,length: lineRange.length)
            let linestrig:NSString = (text as NSString).substring(with: range) as NSString
            linesArray.add(linestrig)
        }
        return linesArray
    }

   

}
