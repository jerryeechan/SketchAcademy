//
//  PointData.swift
//  SwiftGL
//
//  Created by jerry on 2015/6/4.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import Foundation
import SwiftGL
struct PointData:Initable {
    //the struct to store basic paint unit, saving data
    var paintPoint:PaintPoint!
    var timestamps:Double = 0

    init(){
        
    }
    init(paintPoint:PaintPoint,t:Double)
    {
        self.paintPoint = paintPoint
        timestamps = t
    }
}