//
//  DotStageLevelGenerator.swift
//  SwiftGL
//
//  Created by jerry on 2015/7/14.
//  Copyright (c) 2015年 Jerry Chan. All rights reserved.
//


import SpriteKit
class DotStageLevelGenerator {
    var size:CGSize!
    var dotNum:Int
    
    init(size:CGSize,num:Int)
    {
        self.size = size
        dotNum = num
    }
    
    func setDotNum(_ num:Int)
    {
        dotNum = num
    }
    func testLevel()->DotSet
    {
        let dotSet = DotSet(num: dotNum)
        
        for dot in dotSet.dots
        {
            dot.position = CGPoint(x: CGFloat(arc4random())/CGFloat(UINT32_MAX) * (size.width / 4)+(size.width / 8),y: CGFloat(arc4random())/CGFloat(UINT32_MAX) * (size.height / 2)+(size.height / 4))
        }
        
        return dotSet
    }
    
    func freeDots()->DotSet
    {
        let dotSet = DotSet(num: dotNum)
        let dis = size.width / 32
        var count = 0
        for dot in dotSet.dots
        {
            dot.position = CGPoint(x: size.width / 8 + dis*CGFloat(count),y: size.height / 8)
            count += 1
        }
        return dotSet
    }
    
}
