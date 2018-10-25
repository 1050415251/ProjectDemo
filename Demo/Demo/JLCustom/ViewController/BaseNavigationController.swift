//
//  BaseNavigationController.swift
//  GTEDai
//
//  Created by 国投 on 2016/12/7.
//  Copyright © 2016年 国投. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    deinit {
        
    }
    
}

extension UINavigationController {
    func containsController(byClass: AnyClass!) -> Bool {
        for controller in self.viewControllers {
            if controller.classForCoder == byClass {
                return true
            }
        }
        return false
    }
    
    //MARK: pop到指定的controller
    @discardableResult

    func popToViewController(byClass: AnyClass!, animated: Bool) -> Bool {
        return self.popToViewController(byClass: byClass, animated: animated, depth: 0)
    }
    
    @discardableResult
    func popToViewController(byClass: AnyClass!, animated: Bool, depth: Int) -> Bool {
        var count = 0
        for controller in viewControllers {
            if controller.classForCoder == byClass {
                if count == depth {
                    _ = popToViewController(controller, animated: animated)
                    return true
                } else {
                    count += 1
                }
            }
        }
        return false
    }
}
