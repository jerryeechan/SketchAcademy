//
//  PaintPoint.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/26.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import SwiftGL

struct PaintPoint{
    var position: Vec4
    var color: Vec4 = Vec4(1,1,1,1)
    var size: Float
    var rotation:Float
}