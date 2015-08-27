//
//  Layer.swift
//  SwiftGL
//
//  Created by jerry on 2015/7/22.
//  Copyright (c) 2015年 Jerry Chan. All rights reserved.
//

import SwiftGL
import OpenGLES.ES2
class Layer:NSObject{
    var texture:Texture!
    var alpha:Float = 1
    var w,h:GLsizei!
    convenience init(w: GLsizei, h: GLsizei)
    {
        self.init()
        texture = Texture(w: w, h: h)
        self.w = w
        self.h = h
        
    }
    convenience init(texture:Texture)
    {
        self.init()
        self.texture = texture
    }
    override init()
    {
        super.init()
    }
    deinit
    {
        glDeleteTextures(1,[texture.id])
    }
    
    func clean()
    {
        //texture = Texture(w: w, h: h)
        texture.empty()
    }
}
