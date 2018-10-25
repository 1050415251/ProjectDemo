//
//  AppdelegateType.swift
//  Demo
//
//  Created by 国投 on 2018/10/25.
//  Copyright © 2018 FlyKite. All rights reserved.
//

import Foundation

typealias AppdelegateType = UIResponder & UIApplicationDelegate

class CombinationAppdelegate:  AppdelegateType {

    private var appdelegates: [AppdelegateType] = []

    convenience init(appdelegates: [AppdelegateType]) {
        self.init()
        self.appdelegates = appdelegates
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        appdelegates.forEach({
           _ = $0.application?(application, didFinishLaunchingWithOptions: launchOptions)
        })
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }
}
