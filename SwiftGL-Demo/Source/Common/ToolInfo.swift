//
//  ToolInfo.swift
//  SwiftGL
//
//  Created by jerry on 2016/12/19.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import Foundation
import SwiftGL
public struct ToolStringInfo {
    var toolName:String = "pen"
    var brushTexture:String = "brush"
    public init()
    {
        
    }
    public init(tool:String,texture:String)
    {
        toolName = tool
        brushTexture = texture
    }
}
public struct ToolValueInfo:Initable{
    public init()
    {
        
    }
    public init(color:Color, size:Float)
    {
        self.color = color
        self.size = size
    }
    public var color:Color = Color(25,25,25,255)
    public var size:Float = 0
}
