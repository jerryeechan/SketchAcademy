//
//  GLImage.swift
//  SwiftGL
//
//  Created by jerry on 2016/4/30.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import SwiftGL
class GLImage{
    
    var texture:Texture!
    var alpha:Float = 1
    var enabled:Bool = true
    convenience init(texture:Texture)
    {
        self.init()
        self.texture = texture
    }

}
