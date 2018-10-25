//
//  SaveUseInfoUtils.swift
//  VgSale
//
//  Created by ztsapp on 2017/7/25.
//  Copyright © 2017年 ZhanTengMr'S Zhang. All rights reserved.
//

import Foundation


///系统存储类
class UserDefaultUtils: NSObject {

    static let FIRSTPAGEHIDDENCONTACTME = "firstpagehiddencontactme_key"
    static let LOGIN_PHONE = "loginphone_key"

    
    class func saveBoolData(key: String, value: Bool, containsUserId: Bool) {
      
        let userDefault = UserDefaults()
        var realKey = key
        if containsUserId {
            let uid = ""
//            if let user = UserRepository.instance.getlocaluser().getlocalUser() {
//                uid = user.uid
//            }
            
            
            realKey = "\(key)_\(uid)"
        }
        
        userDefault.set(value, forKey: realKey)
        userDefault.synchronize()
    }
    
    class func getBoolData(key: String, containsUserId: Bool) -> Bool {
        let userDefault = UserDefaults()
        var realKey = key
        if containsUserId {
           let uid =  ""
            //            if let user = UserRepository.instance.getlocaluser().getlocalUser() {
            //                uid = user.uid
            //            }
            
            realKey = "\(key)_\(uid)"
        }
        return userDefault.bool(forKey: realKey)
    }
    
    class func saveStringData(key: String, value: String, containsUserId: Bool) {
    
        let userDefault = UserDefaults()
        var realKey = key
        if containsUserId {
            let uid =  ""
//            if let user = UserRepository.instance.getlocaluser().getlocalUser() {
//                uid = user.uid
//            }
            realKey = "\(key)_\(uid)"
        }
        userDefault.set(value, forKey: realKey)
        userDefault.synchronize()
    }
    
    class func getStringData(key: String, containsUserId: Bool) -> String? {
        
        let userDefault = UserDefaults()
        var realKey = key
        if containsUserId {
            let uid = ""
            //            if let user = UserRepository.instance.getlocaluser().getlocalUser() {
            //                uid = user.uid
            //            }
            realKey = "\(key)_\(uid)"
        }
        return userDefault.object(forKey: realKey) as? String
    }


    
    class func saveIntData(key: String, value: Int, containsUserId: Bool) {
       
        
        let userDefault = UserDefaults()
        var realKey = key
        if containsUserId {
           let uid =  ""
            //            if let user = UserRepository.instance.getlocaluser().getlocalUser() {
            //                uid = user.uid
            //            }
            realKey = "\(key)_\(uid)"
        }
        userDefault.set(value, forKey: realKey)
        userDefault.synchronize()
    }
    
    class func getIntData(key: String, containsUserId: Bool) -> Int {
        let userDefault = UserDefaults()
        var realKey = key
        if containsUserId {
           let uid =  ""
            //            if let user = UserRepository.instance.getlocaluser().getlocalUser() {
            //                uid = user.uid
            //            }
            realKey = "\(key)_\(uid)"
        }
        userDefault.synchronize()
        return userDefault.integer(forKey: realKey)
    }
    
    
    
    class func deleteUserDefaultData(key: String, containsUserId: Bool){

        let userDefault = UserDefaults()
        var realKey = key
        if containsUserId {
            let uid =  ""
            //            if let user = UserRepository.instance.getlocaluser().getlocalUser() {
            //                uid = user.uid
            //            }
            realKey = "\(key)_\(uid)"
        }
        userDefault.removeObject(forKey: realKey)

        userDefault.synchronize()
    }
    
    
    class func SAVE_LIST_DATA(key:String,data:[BaseBean],containsUserId:Bool) {
        let preference = UserDefaults()
        
        
        //let datapath = "\(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask,true).first!)/userAccount.data"
        //压缩对象成二进制数据
        let obj = NSKeyedArchiver.archivedData(withRootObject: data)
        var realKey = key
        if containsUserId {
            let uid =  ""
            //            if let user = UserRepository.instance.getlocaluser().getlocalUser() {
            //                uid = user.uid
            //            }
            realKey = "\(key)_\(uid)"
        }
        let path = (realKey as NSString).replacingOccurrences(of: "/", with: "_")

        preference.setValue(obj, forKey: "JSON_\(path)")
        preference.synchronize()
    }
    
    class func GET_LIST_DATA(key:String,containsUserId:Bool) -> [BaseBean]? {
        
        var realKey = key
        if containsUserId {
            let uid = ""
            //            if let user = UserRepository.instance.getlocaluser().getlocalUser() {
            //                uid = user.uid
            //            }s
            realKey = "\(key)_\(uid)"
        }
        let path = (realKey as NSString).replacingOccurrences(of: "/", with: "_")

        if let data = UserDefaults.standard.object(forKey: "JSON_\(path)") as? Data {
            //解压缩二进制数据
            let result = NSKeyedUnarchiver.unarchiveObject(with: data) as? [BaseBean]
            return result
        }
        return nil
        
    }
    
    class func SAVE_DATA(key:String,data:BaseBean,containsUserId:Bool) {
        let preference = UserDefaults()
        //压缩对象成二进制数据
        var realKey = key
        if containsUserId {
            let uid = ""
            //            if let user = UserRepository.instance.getlocaluser().getlocalUser() {
            //                uid = user.uid
            //            }
            realKey = "\(key)_\(uid)"
        }
        
        let path = (realKey as NSString).replacingOccurrences(of: "/", with: "_")
        let datapath = "\(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask,true).first!)/\(path).data"
        let obj = NSKeyedArchiver.archiveRootObject(data, toFile: datapath)
        preference.setValue(obj, forKey: "JSON_\(path)")
        preference.synchronize()
    }
    
    class func GET_DATA(key:String,containsUserId:Bool) -> BaseBean? {
        var realKey = key
        if containsUserId {
            let uid = ""
            //            if let user = UserRepository.instance.getlocaluser().getlocalUser() {
            //                uid = user.uid
            //            }
            realKey = "\(key)_\(uid)"
        }
        
        let path = (realKey as NSString).replacingOccurrences(of: "/", with: "_")
        let datapath = "\(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask,true).first!)/\(path).data"
        if NSKeyedUnarchiver.unarchiveObject(withFile:datapath) != nil {
            
            if let result = NSKeyedUnarchiver.unarchiveObject(withFile:datapath) as?  BaseBean {
                return result
            }
        }
        return nil
    }
    
    class func DELETE_DATA(key:String,containsUserId:Bool)  {
        let preference = UserDefaults()
        //压缩对象成二进制数据
        var realKey = key
        if containsUserId {
            let uid =  ""
            //            if let user = UserRepository.instance.getlocaluser().getlocalUser() {
            //                uid = user.uid
            //            }
            realKey = "\(key)_\(uid)"
        }
        
        let path = (realKey as NSString).replacingOccurrences(of: "/", with: "_")

        preference.removeObject(forKey: "JSON_\(path)")
        preference.synchronize()
        
        let datapath = "\(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask,true).first!)/\(path).data"
        let defaultmanager = FileManager.default
        if defaultmanager.isDeletableFile(atPath: datapath) {
            do{
              try defaultmanager.removeItem(atPath: datapath)
                DEBUG.DEBUGPRINT(obj: "删除本地数据成功")
            }catch {
               DEBUG.DEBUGPRINT(obj: "删除本地数据失败")
            }
        }
    }
}
