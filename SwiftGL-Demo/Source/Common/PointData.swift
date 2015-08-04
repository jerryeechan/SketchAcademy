//
//  PointData.swift
//  SwiftGL
//
//  Created by jerry on 2015/6/4.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import Foundation
import SwiftGL
struct PointData {
    var position:Vec2 = Vec2()
    var timestamps:Double = 0
    var velocity:Vec2 = Vec2()
    init()
    {
        
    }
    init(p:Vec2,t:Double,v:Vec2)
    {
        position = p
        timestamps = t
        velocity = v
    }
}