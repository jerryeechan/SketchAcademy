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

enum BrushType:Int
{
    case Pencil = 0,OilBrush,Eraser
}

class GLShaderBinder{

    static var instance:GLShaderBinder!
    
    let vao    = Vao()
    let vbo    = Vbo()
    
    var textureShader:TextureShader!
    var brushTexture:Texture!
    
    var primitiveShader:PrimitiveShader
    var currentBrushShader:BrushShader
    
    var brushShaderDict:[BrushType:BrushShader] = [:]
    var shaderWrappers:[GLShaderWrapper]
    init()
    {
        textureShader = TextureShader()
        
        primitiveShader = PrimitiveShader()
        
        shaderWrappers = [textureShader,primitiveShader]
        //brushShaders = [pencilShader,eraserShader]
        
        
        brushShaderDict[BrushType.Pencil] = PencilShader()
        brushShaderDict[BrushType.Eraser] = EraserShader()
        brushShaderDict[BrushType.OilBrush] = BrushShader(name: "oilbrush")
            
        currentBrushShader = brushShaderDict[BrushType.Pencil]!
        GLShaderBinder.instance = self
        useBrush(BrushType.Pencil)
    }
    enum ShaderType:String
    {
        case brush = "brush",image = "image"
    }
    func setSize(width:Float,height:Float)
    {
        textureShader.setSize(width, height: height)
    }
    func useBrush(type:BrushType)
    {
        useBrushShader(brushShaderDict[type]!)
    }
    
    func useBrushShader(shader:BrushShader)
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
    func bindMVPBrush(MVP:Mat4)
    {
        for shader in brushShaderDict.values
        {
            shader.bindMVP(MVP)
        }
    }
    func bindMVPRenderTexture(MVP:Mat4)
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