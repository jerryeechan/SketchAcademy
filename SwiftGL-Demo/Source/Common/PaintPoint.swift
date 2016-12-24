//
//  PaintPoint.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/26.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import SwiftGL

public struct PaintPoint{
    //struct to send in OpenGL
    public var position: Vec4
    public var force:Float
    public var altitude:Float
    public var azimuth:Vec2
    public var velocity:Vec2
    
    public init(position:Vec4, force:Float, altitude:Float, azimuth:Vec2, velocity:Vec2)
    {
        self.position = position
        self.force = force
        self.altitude = altitude
        self.azimuth = azimuth
        self.velocity = velocity
    }
    
    public var tojson : String {
        
        return "{\"p\":\(position.tojson),\"f\":\(force),\"alti\":\(altitude)}"
    }
}
