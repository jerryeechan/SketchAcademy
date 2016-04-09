//
//  DotSet.swift
//  SwiftGL
//
//  Created by jerry on 2015/7/14.
//  Copyright (c) 2015年 Jerry Chan. All rights reserved.
//

import SpriteKit
import SwiftGL
class DotSet {
    var dots:[Dot] = []
    init(num:Int)
    {
        for _ in 1...num
        {
            dots.append(Dot())
        }
        sortDots()
    }
    func compareSet(dotSet:DotSet)->Float
    {
        sortDots()
        dotSet.sortDots()
        
        var score:Float = 0
        for i in 0 ..< dots.count
        {
            let dis = (dots[i].getPos() - dotSet.dots[i].getPos()).length
            score += dis
        }
        return score
    }
    
    func sortDots()
    {
        dots.sortInPlace({$0.position.x > $1.position.x})
        dots.sortInPlace({$0.position.y > $1.position.y})
    }
    func addToNode(node:SKNode)
    {
        for dot in dots
        {
            node.addChild(dot)
        }
    }
    func setMovable(isMovable:Bool)
    {
        for dot in dots{
            dot.userInteractionEnabled = isMovable
        }
    }
    func removeFromParent()
    {
        for dot in dots{
            dot.removeFromParent()
        }
    }
}
