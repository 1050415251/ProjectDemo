//
//  WebController.swift
//  GTEDai
//
//  Created by 国投 on 2018/2/22.
//  Copyright © 2018年 国投. All rights reserved.
//

import Foundation
import WebKit

@objcMembers
class WebController:UIViewController {
    
    
    //webview
    private(set) var webView:WKWebView!
    //web的代理
    private var webDelegate:WebDelegateProtocol!
    //没有网络的图片
    private var noNetImgV:UIImageView!
    //设置headTitle
    
    private(set) var url:String = ""
    private(set) var headTitle:String?
    
    
    
    //普通H5的回调
    class func normalWebInstance(url:String,_ headtitle:String? = nil,finish:(()->Void)? = nil) -> WebController {
        let instance = WebController()
        instance.webDelegate = NormalWebDelegate(ctr: instance,finshAction: finish)
        instance.url = url
        instance.headTitle = headtitle
        return instance
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        initDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        refreshstatubarstyle(url == "" ? .lightContent:.default)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        HUDUtil.hideHud()
    }
    

 
    private func initView() {
        addNav()
        addWeb()
        addNonetView()
    }
    
    private func initDelegate() {
        
    }
    
    private func addNav() {
       
        addlineView(offset: UIUtils.NAV_HEIGHT - 0.5)
    }
    
    private func addWeb() {
        webView = WKWebView.init(frame: CGRect.init(x: 0, y: UIUtils.NAV_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - UIUtils.NAV_HEIGHT))
        webView.isOpaque = false
        webView.uiDelegate = webDelegate
        webView.scrollView.delegate = webDelegate
        webView.navigationDelegate = webDelegate
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.view.addSubview(webView)
        webView.configuration.userContentController.add(webDelegate, name: "App")
        //TODO: 清除缓存
        clearCache()
    }

    private func addNonetView() {
        noNetImgV = UIImageView(image: #imageLiteral(resourceName: "web_nonet"))
        noNetImgV.isHidden = true
        self.view.addSubview(noNetImgV)
        noNetImgV.snp.remakeConstraints { (make) in
            make.center.equalTo(self.view)
            make.size.equalTo(#imageLiteral(resourceName: "web_nonet").size)
        }
    }
    
    fileprivate func clearCache() {
        if #available(iOS 9.0, *) {
            let types: Set<String> = [
                WKWebsiteDataTypeMemoryCache,
                WKWebsiteDataTypeDiskCache,
                WKWebsiteDataTypeOfflineWebApplicationCache,
                WKWebsiteDataTypeCookies,
                WKWebsiteDataTypeSessionStorage,
                WKWebsiteDataTypeLocalStorage,
                WKWebsiteDataTypeLocalStorage,
                WKWebsiteDataTypeWebSQLDatabases,
                WKWebsiteDataTypeIndexedDBDatabases
            ]
            WKWebsiteDataStore.default().removeData(ofTypes: types, modifiedSince:             Date(timeIntervalSince1970: 0), completionHandler: {
                print("清理缓存成功")
            })
        }
    }
 
    
    override func onNavgiationLeftClick(sender: UITapGestureRecognizer) {
        
        if webView.canGoBack {
            webView.goBack()
        } else {
            super.onNavgiationLeftClick(sender: sender)
            
        }
    }
    
    override func onNavgiationRightClick(sender: UITapGestureRecognizer) {
        
    }
    
    
    deinit {
        
        
        //TODO:释放代理
        if webView != nil {
            webView.scrollView.delegate = nil
            webView.uiDelegate = nil
            webView.navigationDelegate = nil
            webDelegate = nil
            webView.configuration.userContentController.removeScriptMessageHandler(forName: "App")
        }
      
        DEBUG.DEBUGPRINT(obj: "Web界面已经被释放")
    }
    
}




