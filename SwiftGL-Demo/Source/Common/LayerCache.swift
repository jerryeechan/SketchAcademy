//
//  LayerCache.swift
//  SwiftGL
//
//  Created by jerry on 2015/9/24.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import UIKit
public class LayerCache:Layer {
    public var atStroke:Int = 0
    public convenience init(atStroke:Int,w: GLsizei, h: GLsizei)
    {
        self.init(w: w, h: h)
        self.atStroke = atStroke
    }
}
