
//
//  FaceGameStageLevelGenerator.swift
//  SwiftGL
//
//  Created by CSC NTHU on 2015/8/15.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import SpriteKit
class FaceGameStageLevelGenerator {
    var size:CGSize!
    var componentNum:Int
    
    let imageNameSetGame1 = ["img2", "img3", "img4", "img1", "img5", "img6", "img7", "img8", "img9", "img10"]
    
    let imagePositionSetGame1 = [CGPoint(x:240.0 , y:412.0), CGPoint(x:216.0,y: 275.0), CGPoint(x:59.0, y:418.0), CGPoint(x:430.0, y:328.0), CGPoint(x:144.0, y:417.0), CGPoint(x:249.0, y:411.0), CGPoint(x:354.0, y: 370.0), CGPoint(x:142.0, y: 409.0), CGPoint(x:249.0, y: 402.0), CGPoint(x:347.0, y: 364.0)]
    
    var game_LittleGreenMan:GameLevelData
    var levelDictionary = Dictionary<String, GameLevelData>()
    
    init(size:CGSize,num:Int)
    {
        self.size = size
        componentNum = num
        
        //game 01
        game_LittleGreenMan = GameLevelData(nameArray: imageNameSetGame1, positionArray: imagePositionSetGame1)
        levelDictionary["Little Green Man"] = game_LittleGreenMan
    }
    
    func setDotNum(num:Int)
    {
        componentNum = num
    }
    
    //random dot position
   
    
    func freeComponents(gameName:String)->FaceComponentSet
    {
        let componentSet = FaceComponentSet(imageNameSet: levelDictionary[gameName]!.getNameSet())

        let dis = size.width / 32
        var count = 0
        for component in componentSet.components
        {
            component.position = CGPointMake(size.width / 8 + dis*CGFloat(count),size.height / 8)
            count++
        }
        return componentSet
    }
    
    func correctPosition(gameName:String) ->FaceComponentSet
    {
        
        let componentSet = FaceComponentSet(imageNameSet: levelDictionary[gameName]!.getNameSet())
        let positionSet = levelDictionary[gameName]!.getPositionSet()
        
        for var i = 0; i < componentSet.components.count; i++ {
            componentSet.components[i].position = positionSet[i]
        }
            
        return componentSet

    }
    /*
        dotSet.dots[0].position = CGPointMake(59.0, 418.0)
        dotSet.dots[1].position = CGPointMake(144.0, 417.0)
        dotSet.dots[2].position = CGPointMake(240.0, 412.0)
        dotSet.dots[3].position = CGPointMake(250.0, 411.0)
        dotSet.dots[4].position = CGPointMake(143.0, 409.0)
        dotSet.dots[5].position = CGPointMake(249.0, 402.0)
        dotSet.dots[6].position = CGPointMake(354.0, 370.0)
        dotSet.dots[7].position = CGPointMake(347.0, 364.0)
        dotSet.dots[8].position = CGPointMake(430.0, 328.0)
        dotSet.dots[9].position = CGPointMake(216.0, 275.0)
        */
    //所有關卡寫在這
    
    
}