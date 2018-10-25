//
//  SelectViewController.swift
//  GTEDai
//
//  Created by 国投 on 2018/4/27.
//  Copyright © 2018年 国投. All rights reserved.
//

import Foundation
import UIKit

@objcMembers
class SelectViewController : UIViewController {

    typealias SelectionCell = ItemBasicabCell

    fileprivate var tableView:UITableView!

    fileprivate var datas:[Any] = []
    fileprivate var selection:[Bool]!
    fileprivate var type:SelectType!
    fileprivate var headTitle:String = ""

    var selectioncallback:(([Int])->Void)?

    class func newinstance(headTitle:String,datas:[String],alreadySelect:[String],type:SelectType) -> SelectViewController {
        let instance = SelectViewController()
        instance.headTitle = headTitle
        instance.datas = datas
        instance.type = type
        var bools:[Bool] = [Bool].init(repeating: false, count: datas.count)
        alreadySelect.forEach {
            if let index = datas.index(of: $0) {
                bools[index] = true
            }
        }
        instance.selection = bools
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshstatubarstyle(UIStatusBarStyle.default)
    }

    private func initView() {
        addNav()
        addView()
    }

    private func addNav() {
        addTopNavView(bgcolor: UIColor.white, leftimg: "nav_back_dark", lefttext: nil, leftTextColor: nil, title:headTitle , titleTextColor: UIColor.black, rightimg: nil, righttitle: type ==  SelectType.SingleSelection ? nil:"完成", rightTextColor: UIColor.black)
        addlineView(offset: UIUtils.NAV_HEIGHT - 0.5)
    }

    private func addView() {
        tableView = UITableView()
        tableView.frame = CGRect.init(x: 0, y: UIUtils.NAV_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - UIUtils.NAV_HEIGHT)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(SelectionCell.classForCoder(), forCellReuseIdentifier: "SelectionCell")
        self.view.addSubview(tableView)
    }

    override func onNavgiationRightClick(sender: UITapGestureRecognizer) {
        super.onNavgiationRightClick(sender: sender)
        handlerselections()
    }

    fileprivate func handlerselections() {
        var indexs:[Int] = []

        for index in 0..<selection.count {
            if selection[index] {
                indexs.append(index)
            }
        }


        selectioncallback?(indexs)
        self.navigationController?.popViewController(animated: true)
    }

}

extension SelectViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell", for: indexPath) as! SelectionCell
        cell.selectionStyle = .none
        cell.setLeftInfo(datas[indexPath.row] as? String ?? "")
        if type == SelectType.MultiSelection {
            cell.arrowImgV.image = selection[indexPath.row] ? #imageLiteral(resourceName: "icon_correct_selected"):#imageLiteral(resourceName: "icon_correct_disabled")
        }else if type == SelectType.SingleSelection {
            cell.arrowImgV.image = nil
        }
        

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)


        if type == SelectType.SingleSelection {
            selection = [Bool].init(repeating: false, count: datas.count)
        }
        selection[indexPath.row] = !selection[indexPath.row]
        if type == SelectType.SingleSelection {
            handlerselections()
        }
        tableView.reloadData()
    }
    

}




enum SelectType {

    case SingleSelection

    case MultiSelection

}
