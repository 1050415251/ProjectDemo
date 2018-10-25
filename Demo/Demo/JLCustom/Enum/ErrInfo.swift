//
//  ErrInfo.swift
//  Demo
//
//  Created by 国投 on 2018/10/25.
//  Copyright © 2018 FlyKite. All rights reserved.
//

import Foundation


struct  ResultCode {

    static let PASS = 0
    static let NETERROR = 999
    ///请求失败
    static let GETERROR = 3840
}

enum LocalError:LocalizedError {


    var errorDescription: String? {
        get {
            switch self {

            case .JAVAERROR:
                return "数据错误"
            case .GETERROR:
                return "请求失败"
            case .NOMOREDATA:
                return "没有更多数据了"
            case .BADNETWORD:
                return "网络状态差"
            default:
                break
            }
            return "未知错误"
        }
    }

    case JAVAERROR
    case GETERROR
    case NOMOREDATA
    case BADNETWORD
}

