//
//  BaseBean.swift
//  Demo
//
//  Created by 国投 on 2018/10/25.
//  Copyright © 2018 FlyKite. All rights reserved.
//

import Foundation


class JLResource<T:BaseBean>:NSObject {

    var status:Int = -1
    var msg:String?
    var errmsg:String?
    var data: T?
    var html:String?
    var error:NSError?
    var listdata:[T] = []

    override init() {
        super.init()
    }

    ///加载中静态工厂构造器
    static func loading<U>() -> JLResource<U>{
        let result = JLResource<U>()
        result.status = Status.LOADING
        return result
    }

    static func failed<V>(error:NSError) -> JLResource<V> {
        let result = JLResource<V>()
        result.status = Status.FAILED
        result.error = error
        result.errmsg = error.domain
        DEBUG.DEBUGPRINT(obj: error.domain)
        return result
    }

    static func succeed<W>(data: W?) -> JLResource<W> {
        let result = JLResource<W>()
        result.status = Status.SUCCEED
        result.data = data
        return result
    }


    static func listsucceed<Y>(data: [Y]?) -> JLResource<Y> {
        let result = JLResource<Y>()
        result.status = Status.SUCCEED
        result.listdata = data ?? []

        return result
    }
}


class Status {
    ///网络成功
    static let SUCCEED = 1
    ///网络失败
    static let FAILED = 2
    ///网络加载中
    static let LOADING = 3
}


@objcMembers
@objc class BaseBean:NSObject {

}



class CacheBaseBean:BaseBean,NSCoding {


    @objc required init?(coder aDecoder: NSCoder) {
        super.init()

        let mir = Mirror(reflecting: self)

        for item in mir.children {
            if let info = item.label {
                let cachedValue = aDecoder.decodeObject(forKey: item.label!)
                if cachedValue == nil {
                    continue
                }
                if  let value = cachedValue as? String {
                    self.setValue(value, forKey: info)
                }else if let value = cachedValue as? Int {
                    self.setValue(value, forKey: info)
                }else if let value = cachedValue as? [String] {
                    self.setValue(value, forKey: info)
                }else if let value = cachedValue as? Double {
                    self.setValue(value, forKey: info)
                }
            }
        }
    }

    @objc func encode(with aCoder: NSCoder) {
        let mir = Mirror(reflecting: self)

        for item in mir.children {
            if self.value(forKey: item.label!) == nil {
                continue
            }

            if let label = item.label {

                aCoder.encode(self.value(forKey: label), forKey: label)

            }

        }
    }

    override func setValue(_ value: Any?, forUndefinedKey key: String) {

    }


}
