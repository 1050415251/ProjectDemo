//
//  UIAnimationLab.swift
//  GTEDai
//
//  Created by 国投 on 2018/7/12.
//  Copyright © 2018年 国投. All rights reserved.
//

import Foundation


///自己写的一个类

class UIZJLAnimationLab: UILabel {



    ///计时器比 NSTimer 精确

    var timer: CADisplayLink!



    ///进程戳 从开始计时到实时的时间戳 后面会与传进来的最长时间对比

    var progress: TimeInterval!

    ///最后一次记录时间戳

    var lastupdate: TimeInterval!

    ///多长时间完成的参数

    var totalupdate: TimeInterval!



    ///最开始的计数

    var startValue: Float!

    ///将要结束的参数

    var endValue: Float!



    ///想要以 Int 类型 还是Float类型增长

    var type: ZJLAnimationType = .INT


    var newText: String{

        get {

            return updateNewinfo()

        }

    }

    convenience init(type:ZJLAnimationType) {
        self.init()
        self.type = type
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }


    func initCadisplayLink() {

        progress = 0


        timer = CADisplayLink.init(target: self, selector: #selector(UIZJLAnimationLab.timerclick(sender:)))
        timer.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
    }



    required init?( coder aDecoder: NSCoder) {

        fatalError ("init(coder:) has not been implemented")

    }



    @objc func timerclick(sender:CADisplayLink) {

        ///当执行这个方法时候 判断当前时间戳与 lastupdate这个参数的差 直到 将其相加 直到与 totalupdate 相等时 即为消耗了等量时间 此时强行将text职位endvalue



        ///记录当前时间戳

        let now: TimeInterval = Date.timeIntervalSinceReferenceDate

        ///当前时间 减去 开始事件

        progress = now - lastupdate



        if (now - lastupdate) >= totalupdate {

            progress = totalupdate

            stopLoop()

        }

        let text = newText

        self.text = text

    }



    func updateNewinfo() -> String {

        ///当前时间 / 总共所需要时间，来判断应该尽到哪里 (肯定不会大于1)

        let timebi: Float = Float (progress) / Float (totalupdate)

        let updateVal = startValue + (timebi * (self.endValue - self.startValue))

        if type == ZJLAnimationType.FLOAT {

            return String(format: "%.2f",updateVal)

        }

        return String(format: "%.0f",updateVal)

    }



    func countFrom(start:Float,to:Float,duration: TimeInterval) {

        ///将计时器销毁再重新生成

        if timer != nil {

            timer . invalidate()

            timer = nil

        }

        initCadisplayLink()



        ///记录时间戳

        lastupdate = Date.timeIntervalSinceReferenceDate

        ///耗时时间戳

        totalupdate = duration

        ///将其赋值

        startValue = start

        endValue = to

    }



    ///销毁计时器

    func stopLoop() {

        timer . invalidate()

        timer = nil

    }

}



enum ZJLAnimationType {

    case INT

    case FLOAT

}

