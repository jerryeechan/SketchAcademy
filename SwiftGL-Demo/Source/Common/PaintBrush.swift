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
import PaintStrokeData
public class PaintBrush:NSObject{
    
    var texture:Texture!
    var name:String
    
    public var sInfo:ToolStringInfo
    public var vInfo:ToolValueInfo
    
    public var toolType:BrushType
    
    public init(textureName:String,color:Color,size:Float = 5,type:BrushType)
    {
        texture = BrushTextureLoader.instance.getTexture(textureName)
        name = textureName
        sInfo = ToolStringInfo(tool: type.rawValue,texture: textureName)
        vInfo = ToolValueInfo(color: color, size: size)
        self.toolType = type
    }
    public func changeTexture(_ name:String)
    {
        texture = BrushTextureLoader.instance.getTexture(name)
        self.name = name
    }
    public func changeColor(_ color:Color)
    {
        
        vInfo.color = color
        GLShaderBinder.instance.currentBrushShader.bindBrushColor(vInfo.color.vec)
    }

    public func changeSize(_ size:Float)
    {
        vInfo.size = size
        GLShaderBinder.instance.currentBrushShader.bindBrushSize(vInfo.size)
    }
    
    public func useTool()
    {
        //print("Tool color: \(vInfo.color.vec)")
        //print(texture)
        //print(vInfo.size)
        
       // texture = Texture(filename:name)
        GLShaderBinder.instance.currentBrushShader.bindBrushSize(vInfo.size)
        GLShaderBinder.instance.currentBrushShader.bindBrushTexture(texture)
        // initialize brush color
        GLShaderBinder.instance.currentBrushShader.bindBrushColor(vInfo.color.vec)
       // Painter.currentBrush = self
        
    }
}
