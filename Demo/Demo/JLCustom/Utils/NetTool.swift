//
//  NetTool.swift
//  GTEDai
//  网络请求
//  Created by 国投 on 2016/12/7.
//  Copyright © 2016年 国投. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RequestManager {
    static var shared = RequestManager()
    
    fileprivate var dataDictionary = [String: Request]()
    
    func cancelAllRequest() {
        for (_, value) in self.dataDictionary {
            value.cancel()
        }
        self.dataDictionary.removeAll()
    }
    
    func addRequest(requestUrlString: String, request: Request) {
        self.dataDictionary[requestUrlString] = request
    }
    
    func removeRequestWith(urlString: String) {
        if let _ = self.dataDictionary[urlString] {
            self.dataDictionary.removeValue(forKey: urlString)
        }
    }
    
    func cancelRequestWith(urlString: String) {
        if let request = self.dataDictionary[urlString] {
            request.cancel()

        }
    }

    func containsRequestWith(urlString:String) -> Bool {
        return dataDictionary.keys.sorted().contains(urlString)
    }
}
