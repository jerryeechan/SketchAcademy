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
        
        
        brushShaderDict[BrushType.pencil] = PencilShader()
        brushShaderDict[BrushType.eraser] = EraserShader()
        brushShaderDict[BrushType.oilBrush] = BrushShader(name: "oilbrush")
            
        currentBrushShader = brushShaderDict[BrushType.pencil]!
        GLShaderBinder.instance = self
        useBrush(BrushType.pencil)
    }
    enum ShaderType:String
    {
        case brush = "brush",image = "image"
    }
    func setSize(_ width:Float,height:Float)
    {
        textureShader.setSize(width, height: height)
    }
    func useBrush(_ type:BrushType)
    {
        useBrushShader(brushShaderDict[type]!)
    }
    
    func useBrushShader(_ shader:BrushShader)
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
    func bindMVPBrush(_ MVP:Mat4)
    {
        for shader in brushShaderDict.values
        {
            shader.bindMVP(MVP)
        }
    }
    func bindMVPRenderTexture(_ MVP:Mat4)
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
