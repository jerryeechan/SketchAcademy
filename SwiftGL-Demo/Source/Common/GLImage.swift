//
//  GLImage.swift
//  SwiftGL
//
//  Created by jerry on 2016/4/30.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import SwiftGL
public class GLImage{
    
    var texture:Texture!
    var alpha:Float = 1
    var enabled:Bool = true
    public convenience init(texture:Texture)
    {
        self.init()
        self.texture = texture
    }

}
