//
//  BaseLoadataFromServer.swift
//  VgSale
//
//  Created by ztsapp on 2017/8/14.
//  Copyright © 2017年 ZhanTengMr'S Zhang. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftyJSON

class BaseLoadataFromServer<T:BaseBean>:NSObject {


    typealias ResultData = T
    
    var pageNo = 0//请求页数

    var byForm: Bool = false
    
    let disBg = DisposeBag()
    
    
    var js:JSON?//原始json数据
    
    var pageSize:Int = 10
    
    private let dataKey:String?
    
    init(dataKey:String?) {
      ///为可选类型赋值
        self.dataKey = dataKey
    }
    
    ///请求list类型的数据
    /// - parameters:
    ///   - add: true上啦加载 false 下拉刷新
    ///   - url: 请求接口
    ///   - params: 请求接口负责的参数
    ///   - complete: 成功的回到把数据回到出去
    ///   - failed: 失败的回调，回调错误信息
    func loadlistDataFromeServer(add:Bool,url:String,params:[String:Any]?,complete:(([ResultData]) -> Void)?,failed:((String)->Void)?) {
      
        if !add {
            pageNo = 1
        }else {
            pageNo = pageNo + 1
        }
        var p:[String:Any]!
        if let _ = params {
            p = params!
            p["page"] = pageNo
        }else {
            p = ["page":pageNo]
        }
        //p["pageSize"] = 10
        p["rows"] = pageSize
        let _ = RxNetUtils<ResultData>.requestlist(url: url, params: p,byForm: byForm, getJSONdata: {[weak self]  (json) in
            self?.js = json
        },dataKey: dataKey).subscribe {[weak self] (event) in
            if let _ = self {
                guard let RESULT = event.element else {return}
                if RESULT.status == Status.SUCCEED {
                    ///如果返回的数据 < 每页最大数据
                    if RESULT.listdata.count < self!.pageSize {
                        RESULT.msg = LocalError.NOMOREDATA.errorDescription
                    }
                    complete?(RESULT.listdata)
                }
                if RESULT.status == Status.FAILED {
                    failed?(RESULT.error!.domain)
                }
            }
        }
    }
 
    func getCurrentJson() -> JSON? {
        
        
        return js
    }

}
