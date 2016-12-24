//
//  BrushShaderProtocol.swift
//  SwiftGL
//
//  Created by jerry on 2016/3/14.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//
import SwiftGL
import PaintStrokeData
public class BrushShader:GLShaderWrapper{
    
    public override init(name:String)
    {
        super.init(name: name)
        addAttribute( "vertexPosition", type: Vec4.self)
        addAttribute("pencilForce", type: Float.self)
        addAttribute("pencilAltitude", type: Float.self)
        addAttribute( "pencilAzimuth", type: Vec2.self)
        addAttribute( "vertexVelocity", type: Vec2.self)
        
        addUniform("MVP")
        addUniform("brushColor")
        addUniform("brushSize")
        addUniform("texture")
    }
    
    var brushTexture:Texture!
    public func bindBrush()
    {
        shader.bind(getUniform("texture"), brushTexture,index: 0)
    }
    public func bindBrushColor(_ color:Vec4)
    {
        shader.bind(getUniform("brushColor"), color)
    }
    public func bindBrushSize(_ size:Float)
    {
        shader.bind(getUniform("brushSize"), size)
    }
    public func bindBrushTexture(_ texture:Texture)
    {
        shader.bind(getUniform("texture"), texture,index: 0)
        brushTexture = texture
    }
    public func bindBrushInfo(_ vInfo:ToolValueInfo)
    {
        bindBrushColor(vInfo.color.vec)
        bindBrushSize(vInfo.size)
    }
    
}
