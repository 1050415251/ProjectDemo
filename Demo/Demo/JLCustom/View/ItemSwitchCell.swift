//
//  ItemSwitchCell.swift
//  GTEDai
//
//  Created by 国投 on 2018/7/16.
//  Copyright © 2018年 国投. All rights reserved.
//

import Foundation



class ItemSwitchCell: ItemBasicabCell {

    private(set) var rightSwitch: UISwitch!

    var changeswitchcallback:((Bool)->Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSwitchView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSwitchView() {
        arrowImgV.isHidden = true

        
        rightSwitch = UISwitch(frame: CGRect.init(x: SCREEN_WIDTH - 15 - 75, y: (self.frame.height - 30) * 0.5, width: 75, height: 30))

        self.addSubview(rightSwitch)

        
        

    }


}



