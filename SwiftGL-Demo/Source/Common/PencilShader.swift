//
//  PencilShader.swift
//  SwiftGL
//
//  Created by jerry on 2016/3/13.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import SwiftGL
class PencilShader: GLShaderWrapper {
    init() {
        super.init(name:"pencil")
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
    
    
}