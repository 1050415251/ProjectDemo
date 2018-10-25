//
//  ex+CALayer.swift
//  Demo
//
//  Created by 国投 on 2018/10/25.
//  Copyright © 2018 FlyKite. All rights reserved.
//

import Foundation


extension CALayer {
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(value) {
            var frame = self.frame
            frame.origin.x = value
            self.frame = frame
        }
    }

    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(value) {
            var frame = self.frame
            frame.origin.y = value
            self.frame = frame
        }
    }

    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(value) {
            var frame = self.frame
            frame.size.width = value
            self.frame = frame
        }
    }

    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(value) {
            var frame = self.frame
            frame.size.height = value
            self.frame = frame
        }
    }
}
