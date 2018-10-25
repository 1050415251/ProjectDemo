//
//  PermissionUtils.swift
//  GTEDai
//
//  Created by 国投 on 2018/6/27.
//  Copyright © 2018年 国投. All rights reserved.
//

import Foundation

class PermissionUtils: NSObject {

    //MARK: ----获取相册权限
    static func authorizePhotoWith(comletion:@escaping (Bool)->Void )
    {
        let granted = PHPhotoLibrary.authorizationStatus()
        switch granted {
        case PHAuthorizationStatus.authorized:
            comletion(true)
        case PHAuthorizationStatus.denied,PHAuthorizationStatus.restricted:
            comletion(false)
        case PHAuthorizationStatus.notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    comletion(status == PHAuthorizationStatus.authorized ? true:false)
                }
            })
        }
    }


    //MARK: ---相机权限
    static func authorizeCameraWith(comletion:@escaping (Bool)->Void )
    {
        let granted = AVCaptureDevice.authorizationStatus(for: AVMediaType.video);

        switch granted {
        case AVAuthorizationStatus.authorized:
            comletion(true)
            break;
        case AVAuthorizationStatus.denied:
            comletion(false)
            break;
        case AVAuthorizationStatus.restricted:
            comletion(false)
            break;
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted:Bool) in
                DispatchQueue.main.async {
                    comletion(granted)
                }
            })
        }
    }

    //MARK: ---位置权限
    static func authorizeLocationWith(comletion:@escaping (Bool)->Void )
    {
        let enable = CLLocationManager.locationServicesEnabled()
        if enable {
            let granted = CLLocationManager.authorizationStatus()
            switch granted {
            case CLAuthorizationStatus.authorized:
                comletion(true)
                break;
            case CLAuthorizationStatus.denied:
                comletion(false)
                break;
            case CLAuthorizationStatus.restricted:
                comletion(false)
                break;
            case CLAuthorizationStatus.notDetermined:
                comletion(true)
            case .authorizedWhenInUse:
                comletion(true)
            default:
                break
            }
        }else {
            comletion(false)
        }
    }

    static func showRequestPermission(type: PermissionType) {
        let appname =  SystemUtils.getAppName() == nil ? "应用程序":SystemUtils.getAppName()!
        let message = "请在\(appname)的\"设置-隐私-\(type.rawValue)\"选项中，允许\(appname)访问。"
        let alertUtils = AlertUtils()
        alertUtils.showAlert(title: message, message: nil, leftText: "以后", rightText: "设置", leftCallback: nil) {
            if UIApplication.shared.canOpenURL(URL.init(string: UIApplication.openSettingsURLString)!) {
                OpenAppUtils.openApp(url: UIApplication.openSettingsURLString)
            }else {
               // let alertUtils = AlertUtils()
                alertUtils.showAlert(title: "打开设置失败，请手动操作", message: nil, leftText: "好的", rightText: nil, leftCallback: nil, rightCallback: nil)
            }
        }
    }

    //MARK:跳转到APP系统设置权限界面
    static func jumpToSystemPrivacySetting()
    {
        let appSetting = URL(string:UIApplication.openSettingsURLString)

        if appSetting != nil
        {
            if #available(iOS 10, *) {
                UIApplication.shared.open(appSetting!, options: [:], completionHandler: nil)
            }
            else{
                UIApplication.shared.openURL(appSetting!)
            }
        }
    }

}

enum PermissionType: String {
    case CAMERA = "相机"
    case ALBUM = "相册"
    case LOCATION = "定位"
}
