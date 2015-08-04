//
//  RefImgManager.swift
//  SwiftGL
//
//  Created by jerry on 2015/7/25.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//
import UIKit
class RefImgManager{
    class var instance:RefImgManager{
        struct Singleton {
            static let instance = RefImgManager()
        }
        return Singleton.instance
    }
    
    init()
    {
        
    }
    var rectImg:UIImage!
    var refImg:UIImage!
    
}
