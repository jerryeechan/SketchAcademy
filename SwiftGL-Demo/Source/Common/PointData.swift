//
//  PointData.swift
//  SwiftGL
//
//  Created by jerry on 2015/6/4.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import Foundation
import SwiftGL

public struct PointData:Initable {
    //the struct to store basic paint unit, saving data
    public var paintPoint:PaintPoint!
    public var timestamps:Double = 0

    public init(){
        
    }
    public init(paintPoint:PaintPoint,t:Double)
    {
        self.paintPoint = paintPoint
        timestamps = t
    }
    
    public var tojson:String
    {
        var str = "{"
        str += "\"time\":\(timestamps)"
        str += ",\"pos\":\(paintPoint.position.tojson)"
        str += ",\"force\":\(paintPoint.force)"
        str += ",\"alt\":\(paintPoint.altitude)"
        str += ",\"azi\":\(paintPoint.azimuth.tojson)"
        str += ",\"vel\":\(paintPoint.velocity.tojson)"
        str += "}"
        return str
    }
}
extension Sequence where Iterator.Element == PointData
{
    public var jsonArray:String
    {
        return "{\"points\":[" + self.map {$0.tojson}.joined(separator: ",") + "]}"
    }
}
