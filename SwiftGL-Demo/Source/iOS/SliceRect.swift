//
//  SliceRect.swift
//  SwiftGL
//
//  Created by jerry on 2015/7/19.
//  Copyright (c) 2015年 Jerry Chan. All rights reserved.
//

import UIKit
import SpriteKit
class SliceRect{
    var x:Int
    var y:Int
    var width:Int
    var height:Int
    var strokewidth:Float = 5
    var color:UIColor = UIColor.black
    
    var rectSKNode:SKShapeNode!
    
    init(p:CGPoint,width:CGFloat,height:CGFloat,rectSKNode:SKShapeNode)
    {
        self.x = Int(p.x)
        self.y = Int(p.y)
        self.height = Int(height)
        self.width = Int(width)
        self.rectSKNode = rectSKNode
    }
    
}
