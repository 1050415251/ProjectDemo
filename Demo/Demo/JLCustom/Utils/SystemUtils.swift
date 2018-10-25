//
//  SystemUtils.swift
//  VgSale
//
//  Created by ztsapp on 2017/8/16.
//  Copyright © 2017年 ztstech. All rights reserved.
//

import Foundation

///系统utils
class SystemUtils: NSObject {
    
    // 获取 bundle version版本号
    class func getLocalAppBundleid() -> String? {
        if let bundleid:String = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String{
            
            return bundleid
        }
        return nil
    }
    
    // 获取 bundle build版本号
    class func getLocalAppBuild() -> String? {
        if let bundleid:String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String{
            
            return bundleid
        }
        return nil
    }
    
    class func getLocalAppVersion() -> String {
        if let version:String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        return "0.0"
    }
    
    class func getAppName() -> String? {
        if let appName:String = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            return appName
        }
        return nil
    }
    
    class func getLocalIPAddress() -> String? {
        var address: String?
        
        // get list of all interfaces on the local machine
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        guard getifaddrs(&ifaddr) == 0 else {
            return nil
        }
        guard let firstAddr = ifaddr else {
            return nil
        }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            
            let interface = ifptr.pointee
            
            // Check for IPV4 or IPV6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    
                    // Convert interface address to a human readable string
                    var addr = interface.ifa_addr.pointee
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostName)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
    
    class func getSystemVersion() -> Double {

        let version = UIDevice.current.systemVersion
        return Double(version.components(separatedBy: ".")[0]) ?? 8.0
    }

}
