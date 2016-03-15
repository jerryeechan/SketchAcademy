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
    var pencilShader:PencilShader
    var primitiveShader:PrimitiveShader
    var currentBrushShader:BrushShader
    
    var shaderWrappers:[GLShaderWrapper]
    init()
    {
        textureShader = TextureShader()
        pencilShader = PencilShader()
        primitiveShader = PrimitiveShader()
        shaderWrappers = [textureShader,pencilShader,primitiveShader]
        
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
        pencilShader.shader.useProgram()
    }
    func bindMVP(MVPMatrix:Mat4)
    {
        for shader in shaderWrappers
        {
            shader.bindMVP(MVPMatrix)
        }
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
    
    
    
    
    

}