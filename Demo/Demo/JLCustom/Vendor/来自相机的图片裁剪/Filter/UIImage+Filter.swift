//
//  UIImage+Filter.swift
//  PhotoCutter
//
//  Created by 王望 on 16/9/1.
//  Copyright © 2016年 Will. All rights reserved.
//

import UIKit
import CoreImage

/// 滤镜的统一出口
extension UIImage{
    var filter:PFImageValue{
        return PFImageValue(value: nil, image: self)
    }
}

//default filter
extension CIImage{
    public var InstantFilter:PFImageFilter{
        return PFImageFilter(filter: CIFilter(name: "CIPhotoEffectInstant", parameters: [kCIInputImageKey:self])!)
    }
    
    public var ProcessFilter:PFImageFilter{
        return PFImageFilter(filter: CIFilter(name: "CIPhotoEffectProcess", parameters: [kCIInputImageKey:self])!)
    }
    
    public var ChromeFilter:PFImageFilter{
        return PFImageFilter(filter: CIFilter(name: "CIPhotoEffectChrome", parameters: [kCIInputImageKey:self])!)
    }
    
    public var MonoFilter:PFImageFilter{
        return PFImageFilter(filter: CIFilter(name: "CIPhotoEffectMono", parameters: [kCIInputImageKey:self])!)
    }
    
    public var TonalFilter:PFImageFilter{
        return PFImageFilter(filter: CIFilter(name: "CIPhotoEffectTonal", parameters: [kCIInputImageKey:self])!)
    }
    
    public var FadeFilter:PFImageFilter{
        return PFImageFilter(filter: CIFilter(name: "CIPhotoEffectFade", parameters: [kCIInputImageKey:self])!)
    }
    
    public var NoirFilter:PFImageFilter{
        return PFImageFilter(filter: CIFilter(name: "CIPhotoEffectNoir", parameters: [kCIInputImageKey:self])!)
    }
    
    public var TransferFilter:PFImageFilter{
        return PFImageFilter(filter: CIFilter(name: "CIPhotoEffectTransfer", parameters: [kCIInputImageKey:self])!)
    }
}



