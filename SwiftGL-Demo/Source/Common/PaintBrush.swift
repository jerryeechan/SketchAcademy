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
class PaintBrush:NSObject{
    
    var texture:Texture!
    var name:String
    
    var sInfo:ToolStringInfo
    var vInfo:ToolValueInfo
    
    var toolType:BrushType
    
    init(textureName:String,color:Color,size:Float = 5,type:BrushType)
    {
        texture = BrushTextureLoader.instance.getTexture(textureName)
        name = textureName
    
        switch (type)
        {
        case .pencil:
            sInfo = ToolStringInfo(tool: "pen",texture: textureName)
        case .eraser:
            sInfo = ToolStringInfo(tool: "eraser",texture: textureName)
        case .oilBrush:
            sInfo = ToolStringInfo(tool: "oil",texture: textureName)
        
        }
        
        vInfo = ToolValueInfo(color: color, size: size)
        self.toolType = type
    }
    func changeTexture(_ name:String)
    {
        texture = BrushTextureLoader.instance.getTexture(name)
        self.name = name
    }
    func changeColor(_ color:Color)
    {
        
        vInfo.color = color
        GLShaderBinder.instance.currentBrushShader.bindBrushColor(vInfo.color.vec)
    }

    func changeSize(_ size:Float)
    {
        vInfo.size = size
        GLShaderBinder.instance.currentBrushShader.bindBrushSize(vInfo.size)
    }
    
    func useTool()
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
