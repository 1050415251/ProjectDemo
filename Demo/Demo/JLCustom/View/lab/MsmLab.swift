//
//  MsmLab.swift
//  VgMap
//
//  Created by 国投 on 2018/1/18.
//  Copyright © 2018年 国投. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class MsMNumLab: UILabel {
    
    var CLICKED_GET:Bool = false//点击获取验证码
    
    var clickcomplete:(()->Void)?
    
    static var STARTTIMESTAMP:TimeInterval = 0
    
    private var disBg:DisposeBag?
   
    fileprivate var countdowntime:Int = 60
    
    var canclickcomplete:(()->Void)?
    var uncanclickcomplete:(()->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textColor = 0x999999.rgbColor
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(MsMNumLab.clickself)))
        initObserVer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initObserVer() {
        ///监听进入到了后台 将计时器销毁
        let _ =  NotificationCenter.default.rx.notification(UIApplication.willResignActiveNotification, object: nil).subscribe { [weak self] (event) in
            if let _ = event.element {
                self?.disBg = nil
            }
        }

        ///监听进入到了前台
        let _ = NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification, object: nil).subscribe { [weak self] (event) in
            if let _ = event.element {
                self?.checkhaveLastTime()
            }
        }

    }
    
    ///异步执行 当上次有计时且未计时完成的时候 不可再次点击验证码
    func checkhaveLastTime() {
        let time:Int = Int(Date().timeIntervalSince1970 - MsMNumLab.STARTTIMESTAMP)
        if MsMNumLab.STARTTIMESTAMP != 0  {
            if time < countdowntime {
                CLICKED_GET = true
                countdowntime = 60 - time
                countDownTime()
            }else {
                CLICKED_GET = false
                    ///开始的时间戳
                countdowntime = 60
                canclickcomplete?()
            }
        }
    }
    
    func countDownTime() {
        self.uncanclickcomplete?()
        disBg = DisposeBag()
        self.rx_msmnumcountdown.subscribe(onNext: { [weak self] time in
            self?.text = "\(time)s"
            }, onError: nil, onCompleted: { [weak self] in
                self?.canclickcomplete?()
            }, onDisposed: nil).disposed(by:disBg!)
    }
  
    
    @objc func clickself() {
        if !CLICKED_GET {
            clickcomplete?()
        }
    }

    deinit {
        DEBUG.DEBUGPRINT(obj: "释放了 短信验证码控件")
    }
}

extension MsMNumLab {
    
    var rx_canclick:AnyObserver<Bool> {
        return Binder(self, binding: {[weak self] (lab, result) in
            result && !lab.CLICKED_GET ? self?.canclickcomplete?():self?.uncanclickcomplete?()
        }).asObserver()
    }
    
    ///短信验证码倒计时
   fileprivate var rx_msmnumcountdown:Observable<String> {
        CLICKED_GET = true
        let time:Int = Int(Date().timeIntervalSince1970 - MsMNumLab.STARTTIMESTAMP)
       
        ///如果当前时间
        if time > 60 || MsMNumLab.STARTTIMESTAMP == 0{
            MsMNumLab.STARTTIMESTAMP = Date().timeIntervalSince1970
        }
        return Observable.create({[weak self] (observer) -> Disposable in
            
            self?.refreshText(observer: observer,text:"\(self!.countdowntime)")

            return Disposables.create { [weak self] in
                self?.CLICKED_GET = false
            }
        })
    }
    
    ///倒计时的方法
    private func refreshText(observer:AnyObserver<String>,text:String) {
        observer.onNext(text)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) { [weak self] in
            let num = Int(text)! - 1
            if num == 0 {
                self?.countdowntime = 60
                observer.onCompleted()
            }else {
                self?.refreshText(observer: observer,text: String(Int(text)! - 1))
            }
        }
    }
}
