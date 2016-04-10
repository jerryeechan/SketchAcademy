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


class GLShaderBinder{

    static var instance:GLShaderBinder!
    
    let vao    = Vao()
    let vbo    = Vbo()
    
    var textureShader:TextureShader!
    var brushTexture:Texture!
    var eraserShader:EraserShader
    var pencilShader:PencilShader
    var primitiveShader:PrimitiveShader
    var currentBrushShader:BrushShader
    
    var brushShaders:[GLShaderWrapper]
    var shaderWrappers:[GLShaderWrapper]
    init()
    {
        textureShader = TextureShader()
        pencilShader = PencilShader()
        primitiveShader = PrimitiveShader()
        eraserShader = EraserShader()
        shaderWrappers = [textureShader,pencilShader,primitiveShader,eraserShader]
        brushShaders = [pencilShader,eraserShader]
        currentBrushShader = pencilShader
        GLShaderBinder.instance = self
    }
    enum ShaderType:String
    {
        case brush = "brush",image = "image"
    }
    func setSize(width:Float,height:Float)
    {
        textureShader.setSize(width, height: height)
    }
    func usePencil()
    {
        useBrushShader(pencilShader)
    }
    func useEraser()
    {
        useBrushShader(eraserShader)
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
        for shader in brushShaders
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