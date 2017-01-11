//
//  GLShaderBuilder.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/22.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import Foundation
import SwiftGL
import OpenGLES.ES3

// the attribute struct



public class GLShaderBinder{

    public static var instance:GLShaderBinder!
    
    let vao    = Vao()
    let vbo    = Vbo()
    
    var textureShader:TextureShader!
    var brushTexture:Texture!
    
    var primitiveShader:PrimitiveShader
    public var currentBrushShader:BrushShader
    
    var brushShaderDict:[BrushType:BrushShader] = [:]
    var shaderWrappers:[GLShaderWrapper]
    public init()
    {
        textureShader = TextureShader()
        
        primitiveShader = PrimitiveShader()
        
        shaderWrappers = [textureShader,primitiveShader]
        
        brushShaderDict[BrushType.oilBrush] = BrushShader(name: "oilbrush")
        brushShaderDict[BrushType.flatpen] = BrushShader(name: "flatpen")
        brushShaderDict[BrushType.calligraphy] = BrushShader(name: "calligraphyInk")
        brushShaderDict[BrushType.calligraphyColor] = BrushShader(name: "calligraphyColor")
        brushShaderDict[BrushType.calligraphyEdge] = BrushShader(name: "calligraphyEdge")
        brushShaderDict[BrushType.chinesebrush] = BrushShader(name: "chinesebrush")
        
        brushShaderDict[BrushType.pencil] = PencilShader()
        brushShaderDict[BrushType.eraser] = EraserShader()
        
        currentBrushShader = brushShaderDict[BrushType.pencil]!
        GLShaderBinder.instance = self
        useBrush(BrushType.pencil)
    }
    public enum ShaderType:String
    {
        case brush = "brush",image = "image"
    }
    public func setSize(_ width:Float,height:Float)
    {
        textureShader.setSize(width, height: height)
    }
    public func useBrush(_ type:BrushType)
    {
        useBrushShader(brushShaderDict[type]!)
    }
    
    public func useBrushShader(_ shader:BrushShader)
    {
        currentBrushShader = shader
        shader.useShader()
    }
    /*
    func bindMVP(MVPMatrix:Mat4)
    {
        for shader in shaderWrappers
        {
            shader.bindMVP(MVPMatrix)
        }
    }*/
    public func bindMVPBrush(_ MVP:Mat4)
    {
        for shader in brushShaderDict.values
        {
            shader.bindMVP(MVP)
        }
    }
    public func bindMVPRenderTexture(_ MVP:Mat4)
    {
        textureShader.bindMVP(MVP)
    }
    /*
    func useShader(shader:ShaderType)
    {
        switch(shader)
        {
        case .brush:
            pencilShader.useProgram()
        case .image:
            imageShader.useProgram()
        }
    }
    */
    
    
    deinit
    {
        DLog("GLSHaderbinder deinit")
    }
}
