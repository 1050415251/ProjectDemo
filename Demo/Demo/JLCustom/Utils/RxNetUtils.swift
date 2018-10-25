//
//  RxNetUtils.swift
//  GTEDai
//
//  Created by 国投 on 2018/1/23.
//  Copyright © 2018年 国投. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftyJSON


class RxNetUtils<T:BaseBean>:NSObject {

    typealias dataSrc = T

    @discardableResult
    class func getInfoBySerVer(url:String,params:[String:Any]?,getJSONdata:((JSON)->Void)?,dataKey:String? = nil,isasync:Bool = false,showErrmsg:Bool = true) -> BehaviorSubject<JLResource<T>> {
        if !isasync {
            HUDUtil.showHud()
        }
        let  loading: JLResource<T> = JLResource<T>.loading()
        let result = BehaviorSubject<JLResource<T>>(value: loading)
        RequestClient<T>.requestByget(url: url, params: params, jsonDatacallback: getJSONdata, successful: { (data) in

            let succeed: JLResource<T> = JLResource<T>.succeed(data: data)
            result.on(Event.next(succeed))
            if !isasync {
                HUDUtil.hideHud()
            }
        }, failed: { (err) in

            //失败，回调
            let failed: JLResource<T> = JLResource<T>.failed(error:err)
            result.on(Event.next(failed))
            if !isasync {
                HUDUtil.hideHud()
            }
            if showErrmsg {
                HUDUtil.showHudWithText(text: err.domain, delay: 1.5)
            }
        }, dataKey: dataKey)
        return result
    }

    ///上传信息到服务器
    class func upInfoToServer(url:String,params:[String:Any],disBg:DisposeBag,complete:(()->Void)?,failed:((String)->Void)?,isasync:Bool = false)  {
        if !isasync {
            HUDUtil.showHud()
        }

        let _ = RxNetUtils.request(url: url, params: params, getJSONdata: nil).subscribe { (event) in
            if !isasync {
                HUDUtil.hideHud()
            }

            guard let result = event.element else {
                return
            }
            if result.status == Status.SUCCEED{
                complete?()
            }
            if result.status == Status.FAILED {
                if let message = result.errmsg {
                    HUDUtil.showHudWithText(text: message, delay: 1.5)
                    failed?(message)
                }else {
                    HUDUtil.showHudWithText(text: "未知错误", delay: 1.5)
                    failed?("未知错误")
                }
            }
        }
    }

    ///创建BehaviorSubject信号请求网络用
    ///请求非list数据
    /// - parameter url:网址
    /// - parameter params:参数
    /// - parameter getJSONdata:拿到原始json数据可以为空
    /// - dataKey: 从返回的json里面拿数据防止后台饭会不以data解析的数据
    @discardableResult
    class func request(url:String,params:[String:Any],getJSONdata:((JSON)->Void)?,dataKey:String? = nil,isasync:Bool = false,showErrmsg:Bool = true) -> BehaviorSubject<JLResource<T>> {
        if !isasync {
            HUDUtil.showHud()
        }
        let  loading: JLResource<T> = JLResource<T>.loading()
        let result = BehaviorSubject<JLResource<T>>(value: loading)
        result.on(Event.next(loading))
        RequestClient<T>.requestByPost(url: url, params: params,byForm: false, jsonDatacallback: getJSONdata,
        successful: { (data) in

            let succeed: JLResource<T> = JLResource<T>.succeed(data: data)
            result.on(Event.next(succeed))
            if !isasync {
                HUDUtil.hideHud()
            }
        },
        failed:{ (err) in

            //失败，回调
            let failed: JLResource<T> = JLResource<T>.failed(error:err)
            result.on(Event.next(failed))
            if !isasync {
                HUDUtil.hideHud()
            }
            if showErrmsg {
                HUDUtil.showHudWithText(text: err.domain, delay: 1.5)
            }

        },dataKey: dataKey)
        return result
    }

    @discardableResult
    //TODO:创建form表单上传数据
    class func requestInfoByForm(url:String,params:[String:Any]?,getJSONdata:((JSON)->Void)?,dataKey:String? = nil,isasync:Bool = false,showErrmsg:Bool = true) -> BehaviorSubject<JLResource<T>> {
        if !isasync {
            HUDUtil.showHud()
        }
        let loading: JLResource<T> = JLResource<T>.loading()
        let result = BehaviorSubject<JLResource<T>>(value: loading)
        result.on(Event.next(loading))
        RequestClient<T>.requestByPost(url: url, params: params,byForm: true, jsonDatacallback: getJSONdata, successful: { (data) in

            let succeed: JLResource<T> = JLResource<T>.succeed(data: data)
            result.on(Event.next(succeed))
            if !isasync {
                HUDUtil.hideHud()
            }

        }, failed:{ (error) in

            let failed: JLResource<T> = JLResource<T>.failed(error: error)
            result.on(Event.next(failed))
            if !isasync {
                HUDUtil.hideHud()
            }
            if showErrmsg {
                HUDUtil.showHudWithText(text: error.domain, delay: 1.5)
            }
        },dataKey: dataKey)
        return result
    }



    ///请求list数据
    /// - parameter url:网址
    /// - parameter params:参数
    /// - parameter getJSONdata:拿到原始json数据可以为空
    @discardableResult
    class func requestlist(url:String,params:[String:Any]?,byForm:Bool,getJSONdata:((JSON)->Void)?,dataKey:String?,showErrmsg:Bool = true) -> BehaviorSubject<JLResource<T>> {
        let loading: JLResource<dataSrc> = JLResource<dataSrc>.loading()
        let result = BehaviorSubject<JLResource<dataSrc>>(value: loading)
        result.on(Event.next(loading))
        RequestClient<T>.requestList(method: .post, url: url, params: params,byForm: byForm, jsonDatacallback: getJSONdata, successful: { (data) in
            let succeed: JLResource<dataSrc> = JLResource<dataSrc>.listsucceed(data: data)
            result.onNext(succeed)
        }, failed: { error in
            //失败，回调
            let failed: JLResource<dataSrc> = JLResource<dataSrc>.failed(error: error)
            result.onNext(failed)
            if showErrmsg {
                HUDUtil.showHudWithText(text: error.domain, delay: 1.5)
            }
        }, dataKey: dataKey)
        return result
    }



}
