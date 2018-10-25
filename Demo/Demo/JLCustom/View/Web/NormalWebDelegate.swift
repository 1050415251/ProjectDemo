//
//  NormalWebDelegate.swift
//  GTEDai
//
//  Created by 国投 on 2018/2/22.
//  Copyright © 2018年 国投. All rights reserved.
//

import Foundation
import WebKit

//TODO: 普通web
class NormalWebDelegate:NSObject,WebDelegateProtocol {
    
    weak var controller:WebController!

    var finishcallback:(()->Void)?
    ///控制反转 web
    init(ctr:WebController,finshAction:(()->Void)?) {
        super.init()
        self.controller = ctr
        self.finishcallback = finshAction
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [weak self] in
            self?.addNav()
            self?.loadRequest(self!.controller.url)
        }
    }
    
    private func addNav() {
         controller.addTopNavView(bgcolor: UIColor.white, leftimg: "nav_back_dark", lefttext: nil, leftTextColor: nil, title: controller.headTitle ?? "", titleTextColor: UIColor.black, rightimg: nil, righttitle: nil, rightTextColor: UIColor.black)
    }
    
    private func loadRequest(_ url:String) {
        HUDUtil.showHud()
        if url == "" {
            HUDUtil.showHudWithText(text: "系统繁忙请稍候再试", delay: 1.0)
            controller.navigationController?.popViewController(animated: true)
            return
        }


        if url.hasPrefix("http") {
            let cookieScript = WKUserScript(source: "\(getCookie())", injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
            controller.webView.configuration.userContentController.removeAllUserScripts()
            controller.webView.configuration.userContentController.addUserScript(cookieScript)
            if let newUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),let _ = URL.init(string: newUrl) {
                ///如果url以http开头那么是一个网址 否则是文本标签
                let request = URLRequest.init(url: URL.init(string: newUrl)!, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 10.0)
                controller.webView.load(request)
            }else {
                HUDUtil.showHudWithText(text: "请求错误,请稍候再试", delay: 1.0)
                controller.navigationController?.popViewController(animated: true)
            }
        }else {
            controller.webView.loadHTMLString(url, baseURL: nil)
        }

    }

    private func getCookie() -> String {

        return ""
    }

    func handlerNetChangeInfo(_ status: NetworkStatus) {
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        finishcallback?()
        let js = "document.getElementsByTagName('title')[0].innerText"
        webView.evaluateJavaScript(js) {[weak self] (result, error) in
            if error == nil {
                if let title = result as? String,title != "" {
                   // if self?.controller.getNavHeadTitle() ！= ""{
                        self?.controller.setNavheadTitle(result as! String)
                    //}
                }
            }
        }
        HUDUtil.hideHud()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        HUDUtil.hideHud()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        DEBUG.DEBUGPRINT(obj:"JS调原生\n\(message.body)")
        guard let params = message.body as? [String:Any] else {
            return
        }

    }
    
    deinit {
       // controller.webView.scrollView.delegate = nil
       // controller.webView.uiDelegate = nil
       // controller.webView.navigationDelegate = nil
        DEBUG.DEBUGPRINT(obj: "释放了web代理")
    }
    
}
