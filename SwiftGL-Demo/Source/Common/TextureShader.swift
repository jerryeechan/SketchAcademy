//
//  TextureShader.swift
//  SwiftGL
//
//  Created by jerry on 2016/3/13.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//
import SwiftGL
class TextureShader: GLShaderWrapper {
    init() {
        super.init(name:"RenderTexture")
        
        addAttribute("position", type: Vec4.self)
        addAttribute("inputTextureCoordinate", type: Vec4.self)
        
        addUniform("MVP")
        addUniform("imageTexture")
        addUniform("alpha")
    }
}
