//
//  BaselistController.swift
//  GTEDai
//
//  Created by 国投 on 2018/1/26.
//  Copyright © 2018年 国投. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh
import RxSwift
import RxCocoa
import SwiftyJSON
import SnapKit

@objcMembers
class BaseListController<T:BaseBean>:UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView:UITableView!
    

    internal var noDataView:NoDataView = NoDataView()
    private var netRequest:BaseLoadataFromServer<T>!


    var dataSrc:[T] = [] {
        didSet {
            if tableView != nil {
                tableView.reloadData()
            }
        }
    }

    private var nodataimg: UIImage?
    private var nodataText = "暂无记录"
    
    var js:JSON?{
        get {
            return netRequest.js
        }
    }
    
    var VIEW_APPEAR:Bool = false
    
    
    var rx_loadData:AnyObserver<BaseBean> {
        return Binder.init(self, binding: { (item, datas) in
            item.tableView.reloadData()
        }).asObserver()
    }
    
    ///后台返回json array对应的key
    internal var dataKey:String?
    internal var byForm: Bool!

    internal var USER_CACHE = false
    internal var CACHEKEY = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        initDelegate()
        initTableView()
        addNoDataView()

        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !VIEW_APPEAR {
            VIEW_APPEAR = true
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                HUDUtil.showHud()
                self.loadData()
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    func initDelegate() {
        netRequest = BaseLoadataFromServer<T>.init(dataKey: dataKey)
        netRequest.byForm = byForm
    }

    
    func initTableView() {
        tableView = UITableView()
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIUtils.BG_COLOR
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(UIUtils.STATUSBAR_HEIGHT + 44)
        }
        
        let header = MJRefreshHeader.init(refreshingBlock: { [weak self] in
            self?.loadData()
        })
        //下拉刷新

      
        tableView.mj_header = header
     

        ///上啦加载
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            self.appendData()
        })
        tableView.mj_footer.isHidden = true
    }
    
    
    //MARK:---------------------数据填充
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if AppDelegate.KEYBOARDSHOW {
            self.view.endEditing(true)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSrc.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < dataSrc.count {
            let bean = dataSrc[indexPath.row]
            return self.tableView(tableView, cellForRowAt: indexPath, bean: bean)
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let bean = dataSrc[indexPath.row]
        self.tableView(tableView, didSelectRowAt: indexPath, bean: bean)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath,bean:T) -> UITableViewCell {
        fatalError("请在子类中实现这个方法")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath,bean:T) {
        fatalError("请在子类中实现这个方法")
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return UITableViewCell.EditingStyle.init(rawValue: UITableViewCell.EditingStyle.insert.rawValue | UITableViewCell.EditingStyle.delete.rawValue)!
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
 
    
    //MARK:---------------------数据请求
    ///下拉刷新
    func loadData() {
        if tableView != nil {
            netRequest.loadlistDataFromeServer(add: false, url: getRequestUrl(), params: getParams(), complete: { [weak self] (data) in
                self?.tableView.mj_header?.endRefreshing()
                self?.tableView.mj_footer?.isHidden = !(data.count == 10)
                self?.tableView.mj_footer?.resetNoMoreData()
                self?.dataSrc = data
                self?.cacheData()
                self?.loadataFinsh()///先走这个方法在reloaddata
                self?.tableView.reloadData()
                HUDUtil.hideHud()
            }) {[weak self] (error) in
                if error == LocalError.BADNETWORD.errorDescription {
                   self?.noDataView.tipImg.image = #imageLiteral(resourceName: "no_net")
                   self?.noDataView.tipLabel.text = "网络状态差"
                   self?.showNodataView()
                   self?.dataSrc = []
                   self?.tableView.reloadData()
                }
                else if self?.dataSrc.count == 0 {
                    self?.noDataView.tipImg.image = self!.nodataimg
                    self?.noDataView.tipLabel.text = self!.nodataText
                    self?.showNodataView()
                }else {
                    self?.hiddenNodataView()
                    self?.tableView.isHidden = false
                }
                self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
                self?.tableView.mj_header?.endRefreshing()
                HUDUtil.hideHud()
                HUDUtil.showHudWithText(text: error, delay: 1.5)
            }
        }
        
    }
    
    ///上拉加载
    func appendData() {
        
        netRequest.loadlistDataFromeServer(add: true, url: getRequestUrl(), params: getParams(), complete: {[weak self] (data) in
            if data.count == 0 {
             self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
                return
            }
            self?.dataSrc =  self!.dataSrc + data///数据源拼接
            self?.loadataFinsh()
            self?.tableView.reloadData()
            self?.tableView.mj_footer.endRefreshing()
        }) {[weak self] (error) in
            if error == LocalError.NOMOREDATA.errorDescription {
                self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
            }else {
                self?.tableView.mj_footer?.endRefreshing()
                HUDUtil.showHudWithText(text: error, delay: 1.5)

            }
        }
    }
    ///数据加载完回掉
    func loadataFinsh() {
        // fatalError("请在子类中实现这个方法")
        
        
    }
    
    func cacheData() {
        hiddenNodataView()
        if USER_CACHE {
            if CACHEKEY == "" {
                CACHEKEY = getRequestUrl()
            }
            if dataSrc.count == 0 {
                showNodataView()
            }
            UserDefaultUtils.SAVE_LIST_DATA(key: CACHEKEY, data: dataSrc, containsUserId: true)
        }else {
            if dataSrc.count == 0 {
                showNodataView()
            }
        }
    }
    
    
    final func getData() {
        if USER_CACHE {
            if CACHEKEY == "" {
                CACHEKEY = getRequestUrl()
            }
            if let data = UserDefaultUtils.GET_LIST_DATA(key: CACHEKEY, containsUserId: true) as? [T] {
                if data.count > 0 {
                    dataSrc = data
                    loadataFinsh()
                    tableView.mj_footer?.isHidden = !(data.count == 10)
                }
                tableView.reloadData()
                return
            }
        }

    }
    
    private func addNoDataView(){
        noDataView.isHidden = true
        self.view.addSubview(noDataView)
        noDataView.snp.remakeConstraints { (make) in
            make.top.equalTo(tableView).offset(80)
            make.centerX.equalTo(tableView)
        }
    }
    
    func setNodataView(image:UIImage,tipText:String) {
        nodataimg = image
        nodataText = tipText
        noDataView.tipImg.image = image
        noDataView.tipLabel.text = tipText
        
    }
    
    ///显示没有数据的view
    func showNodataView(){
        
        noDataView.isHidden = false
    }
    
    ///隐藏没有数据的view
    func hiddenNodataView() {
        
        if !noDataView.isHidden {
            noDataView.isHidden =  true
        }
        
    }
    
    
    ///数据请求的url
    func getRequestUrl() -> String {
        fatalError("请在子类中实现这个方法")
    }
    
    ///数据请求的parmas
    func getParams() -> [String:Any]? {
        fatalError("请在子类中实现这个方法")
    }
    
    
}
