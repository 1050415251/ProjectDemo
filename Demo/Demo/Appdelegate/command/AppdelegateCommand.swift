//
//  AppdelegateCommand.swift
//  Demo
//
//  Created by 国投 on 2018/10/25.
//  Copyright © 2018 FlyKite. All rights reserved.
//

import Foundation

protocol AppdelegateCommand {

    func execute()

}

final class AppdelegateManager {


    func build() -> [AppdelegateCommand] {
        return [
            WindowAppdelegate(),
            PushAppdelegate(),
            VendorAppdelegate(),
        ]
    }

}
