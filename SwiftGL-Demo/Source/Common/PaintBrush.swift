//
//  PaintBrush.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/21.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import Foundation
import OpenGLES
import GLKit
import SwiftGL

struct ToolStringInfo {
    var toolName:String = "pen"
    var brushTexture:String = "brush"
    init()
    {
        
    }
    init(tool:String,texture:String)
    {
        toolName = tool
        brushTexture = texture
    }
}
public struct ToolValueInfo:Initable{
    init()
    {
        
    }
    init(color:Color, size:Float)
    {
        self.color = color
        self.size = size
    }
    public var color:Color = Color(25,25,25,255)
    public var size:Float = 0
}

class PaintBrush:NSObject{
    
    var texture:Texture!
    var name:String
    
    var sInfo:ToolStringInfo
    var vInfo:ToolValueInfo
    
    var toolType:PaintToolManager.PaintToolType
    
    init(textureName:String,color:Color,size:Float = 5,type:PaintToolManager.PaintToolType)
    {
        texture = BrushTextureLoader.instance.getTexture(textureName)
        name = textureName
    
        switch (type)
        {
        case .pen:
            sInfo = ToolStringInfo(tool: "pen",texture: textureName)
        case .eraser:
            sInfo = ToolStringInfo(tool: "eraser",texture: textureName)
        }
        
        vInfo = ToolValueInfo(color: color, size: size)
        self.toolType = type
    }
    func changeTexture(name:String)
    {
        texture = BrushTextureLoader.instance.getTexture(name)
        self.name = name
    }
    func changeColor(color:Color)
    {
        
        vInfo.color = color
        GLShaderBinder.instance.bindBrushColor(vInfo.color.vec)
    }

    func changeSize(size:Float)
    {
        vInfo.size = size
        GLShaderBinder.instance.bindBrushSize(vInfo.size)
    }
    
    func useTool()
    {
        //print("Tool color: \(vInfo.color.vec)")
        //print(texture)
        //print(vInfo.size)
        
       // texture = Texture(filename:name)
        GLShaderBinder.instance.bindBrushSize(vInfo.size)
        GLShaderBinder.instance.bindBrushTexture(texture)
        // initialize brush color
        GLShaderBinder.instance.bindBrushColor(vInfo.color.vec)
        Painter.currentBrush = self
        
    }
}