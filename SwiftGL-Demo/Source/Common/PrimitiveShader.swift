
//
//  PrimitiveShader.swift
//  SwiftGL
//
//  Created by jerry on 2016/3/14.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import SwiftGL
class PrimitiveShader:GLShaderWrapper
{
    init(){
        super.init(name:"primitive")
        //
        addAttribute("vertexPosition", type: Vec4.self)
        //
        addUniform("MVP")
        addUniform("color")
    }
    
    func bindColor(color:Vec4)
    {
        shader.bind(getUniform("color"), color)
    }
    
}
