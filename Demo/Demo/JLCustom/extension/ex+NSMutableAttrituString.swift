//
//  ex+NSMutableAttrituString.swift
//  CustomFile
//
//  Created by 国投 on 2018/9/12.
//  Copyright © 2018年 FlyKite. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {

    func fitAttributedHeight(padding: CGFloat,width:CGFloat) -> CGFloat {

        let bounds = self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)),
                                       options: [.usesLineFragmentOrigin, .usesFontLeading, .usesDeviceMetrics],
                                       context: nil)
        return ceil(bounds.height + padding * 2)

    }


    func fitWidth(padding: CGFloat,height:CGFloat) -> CGFloat {

        let bounds = self.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height),
                                       options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                       context: nil)
        return ceil(bounds.width + padding * 2)

    }
}
