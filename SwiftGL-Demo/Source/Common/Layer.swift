//
//  Layer.swift
//  SwiftGL
//
//  Created by jerry on 2015/7/22.
//  Copyright (c) 2015年 Jerry Chan. All rights reserved.
//

import SwiftGL
import OpenGLES.ES2
class Layer {
    var texture:Texture!
    
    init(w: GLsizei, h: GLsizei)
    {
        texture = Texture(w: w, h: h)
    }
    init(texture:Texture)
    {
        self.texture = texture
    }
    
    func clean()
    {
        texture.empty()
    }
}
