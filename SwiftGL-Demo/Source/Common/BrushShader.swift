//
//  BrushShaderProtocol.swift
//  SwiftGL
//
//  Created by jerry on 2016/3/14.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//
import SwiftGL
class BrushShader:GLShaderWrapper{
    
    override init(name:String)
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
    func bindBrush()
    {
        shader.bind(getUniform("texture"), brushTexture,index: 0)
    }
    func bindBrushColor(color:Vec4)
    {
        shader.bind(getUniform("brushColor"), color)
    }
    func bindBrushSize(size:Float)
    {
        shader.bind(getUniform("brushSize"), size)
    }
    func bindBrushTexture(texture:Texture)
    {
        shader.bind(getUniform("texture"), texture,index: 0)
        brushTexture = texture
    }
    func bindBrushInfo(vInfo:ToolValueInfo)
    {
        bindBrushColor(vInfo.color.vec)
        bindBrushSize(vInfo.size)
    }
    
}
