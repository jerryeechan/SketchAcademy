//
//  GLRect.swift
//  SwiftGL
//
//  Created by jerry on 2015/8/12.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//
import SwiftGL
class GLRect {
    var leftTop:Vec2
    var rightButtom:Vec2
    init(p1:Vec2,p2:Vec2)
    {
        leftTop = p1
        rightButtom = p2
    }
}
