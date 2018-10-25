//
//  TabBarController.swift
//  VgMap
//
//  Created by zhiyuan wang on 2018/1/10.
//  Copyright © 2018年 ztstech.VgMap. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

///顶部tab栏 的统一conntroller
@objcMembers
class TabBarController:UIViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
    fileprivate(set) var pager:UIPageViewController!
    
    fileprivate var headTexts:[String] = []
    
    fileprivate var vcs:[UIViewController] = []
    
    fileprivate(set) var tabbar:SelectTabBar!
    
    fileprivate var labelToLabel:CGFloat = 0
    
    @objc dynamic var currentindex:Int = 0
    
    fileprivate var transitionFinish:Bool = false
    
    var enableSliderGesture:Bool = false {
        didSet {
            if enableSliderGesture {
                enableSideslipGesture()
            }
        }
    }
    
    class func newInstance(headTexts:[String],vcs:[UIViewController],labelToLabel:CGFloat,selectIndex:Int) -> TabBarController {
        let instance = TabBarController()
        instance.headTexts = headTexts
        instance.currentindex = selectIndex
        instance.labelToLabel = labelToLabel
        instance.vcs = vcs
        return instance
    }
    
    
    override func viewDidLoad() {
        self.title = "统一tab栏"
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        APP.navController.navigationController?.fd_fullscreenPopGestureRecognizer.isEnabled = true
    }
    

    func initView() {
        addTopNav()
        initPager()
    }
    
    func addTopNav() {
        tabbar = SelectTabBar.init(frame: CGRect(),labelToLabel:labelToLabel,data: headTexts)
        
        tabbar.onItemSelecte = {[weak self] selectIndex in
            self?.showSelectedController(index: selectIndex)
        }
        tabbar.callbackLeftClick = { [weak self] in
            if self?.navigationController != nil {
                self?.navigationController?.popViewController(animated: true)
            }else {
                APP.navController.popViewController(animated: true)
            }
        }
        tabbar.selectIndex(index: currentindex)
        self.view.addSubview(tabbar)
        
        addlineView(offset: UIUtils.STATUSBAR_HEIGHT + 43.5)
        tabbar.snp.remakeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(UIUtils.STATUSBAR_HEIGHT + 44)
        }
        
    }
    
    
    func initPager() {
        self.automaticallyAdjustsScrollViewInsets = false
        pager = UIPageViewController(transitionStyle: UIPageViewController.TransitionStyle.scroll,navigationOrientation:UIPageViewController.NavigationOrientation.horizontal,options: nil)
        pager.delegate = self
        pager.dataSource = self
        self.view.addSubview(pager.view)
        pager.view.snp.remakeConstraints { (make) in
            make.top.equalTo(tabbar.snp.bottom)
            make.left.right.bottom.equalTo(0)
        }
        showSelectedController(index: currentindex)
    }
 
    private func enableSideslipGesture() {
        weak var scrollView:UIScrollView!
        for subView in pager.view.subviews {
            if "_UIQueuingScrollView" == NSStringFromClass(subView.classForCoder) {
                scrollView = subView as? UIScrollView
            }
        }
        if scrollView != nil {
            scrollView.panGestureRecognizer.require(toFail: APP.navController.fd_fullscreenPopGestureRecognizer)
        }
    }
    
    ///选择当前页
    func showSelectedController(index:Int) {
        currentindex = index
        if enableSliderGesture {
            APP.navController.fd_fullscreenPopGestureRecognizer.isEnabled = currentindex == 0
        }
        if vcs.count > index {
            tabbar.selectIndex(index: index)
            pager.setViewControllers([vcs[index]], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = vcs.index(of: viewController) {
            currentindex = index
            if index == 0 {
                
                return nil
            }
            return vcs[index - 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if  let index = vcs.index(of: viewController) {
            
            if index == vcs.count - 1 {
                return nil
            }
            return vcs[index + 1]
        }
        return nil
    }
    
    //结束滑动时候 topview下面的线需要定位到指定的位置
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if  let index = vcs.index(of: pageViewController.viewControllers!.last!) {
            if currentindex != index {
                currentindex = index
                tabbar.selectIndex(index: index)
                if enableSliderGesture {
                    APP.navController.fd_fullscreenPopGestureRecognizer.isEnabled = currentindex == 0
                }
            }
        }
        transitionFinish = true
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        transitionFinish = false
    }
    

    
}








































