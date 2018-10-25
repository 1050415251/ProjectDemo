//
//  ex+String.swift
//  CustomFile
//
//  Created by 国投 on 2018/9/12.
//  Copyright © 2018年 FlyKite. All rights reserved.
//

import Foundation

extension String {

    var length: Int {
        return self.count
    }

    var dateValue: Date? {
        get {
            let fmt = DateFormatter()
            fmt.dateFormat = "yyyy/MM/dd HH:mm:ss"
            fmt.timeZone = TimeZone.current
            if let date = fmt.date(from: self) {
                return date
            }
            fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = fmt.date(from: self) {
                return date
            }
            fmt.dateFormat = "yyyy-MM-dd"
            if let date = fmt.date(from: self) {
                return date
            }
            return Date(timeIntervalSince1970: Double(self)! / 1000)
        }
    }

    var matchsPasswordType: Bool {
        if self.length < 8 || self.length > 16 {
            return false
        }
        var containsNumber = false
        var containsLetter = false
        var containsOthers = false
        for c in self.utf8 {
            if !containsNumber && c >= 48 && c <= 57 {
                containsNumber = true
            } else if !containsLetter && (c >= 65 && c <= 90) || (c >= 97 && c <= 122) {
                containsLetter = true
            } else {
                containsOthers = true
            }
        }
        return containsNumber ? containsLetter || containsOthers : containsLetter && containsOthers
    }

    var htmlAttributedString: NSAttributedString? {
        do {
            if let d = self.data(using: String.Encoding.utf16, allowLossyConversion: true) {
                let str = try NSAttributedString.init(data: d, options: [.documentType :NSAttributedString.DocumentType.html], documentAttributes: nil)
                return str
            }

        } catch {
        }
        return nil
    }

    func pinYinZChines()->String{

        let transformContents = CFStringCreateMutableCopy(nil, 0, self as CFString)

        CFStringTransform( transformContents, nil, kCFStringTransformMandarinLatin, false)

        CFStringTransform( transformContents, nil, kCFStringTransformStripDiacritics,  false)

        let ztransformContents = transformContents! as String

        let index = ztransformContents.startIndex

        let firstString = ztransformContents[index]

        let stringZ = String.init(firstString)

        return stringZ.uppercased()

    }

    func deleteWhiteSpace() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }

    func fitHeight(padding: CGFloat,width:CGFloat,font: UIFont) -> CGFloat {

        let bounds = self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)),
                                       options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                       attributes: [NSAttributedString.Key.font: font],
                                       context: nil)
        return ceil(bounds.height + padding * 2)
    }

    func fitWidth(padding: CGFloat,height: CGFloat,font: UIFont) -> CGFloat {

        let bounds = self.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height),
                                       options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                       attributes: [NSAttributedString.Key.font: font],
                                       context: nil)
        return  ceil(bounds.width + padding * 2)
    }

}
