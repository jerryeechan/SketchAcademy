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
    func compareSet(_ dotSet:DotSet)->Float
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
        dots.sort(by: {$0.position.x > $1.position.x})
        dots.sort(by: {$0.position.y > $1.position.y})
    }
    func addToNode(_ node:SKNode)
    {
        for dot in dots
        {
            node.addChild(dot)
        }
    }
    func setMovable(_ isMovable:Bool)
    {
        for dot in dots{
            dot.isUserInteractionEnabled = isMovable
        }
    }
    func removeFromParent()
    {
        for dot in dots{
            dot.removeFromParent()
        }
    }
}
