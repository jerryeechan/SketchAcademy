
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
    
    private let imageNameSetGame1 = ["img2", "img3", "img4","img1", "img5", "img6", "img7", "img8", "img9", "img10"]
 
    let angryBirdMain = "angrybird"
    
    let tumblerNames = ["body", "word", "rightPatternRight", "rightPatternMiddle", "rightPatternLeft", "leftPatternRight", "leftPatternMiddle", "leftPatternLeft", "beardRight", "beardLeft", "mouth", "eyebrowRight", "eyebrowLeft","eyeRight", "eyeLeft", "noseRight","noseLeft"]
    
    let angrybirdNames = ["angrybird_tailBottom", "angrybird_tailMiddle", "angrybird_tailTop", "angrybird_body", "angrybird_OrbitalRight", "angrybird_OrbitalLeft", "angrybird_mouth", "angrybird_eyebrowRight", "angrybird_eyebrowLeft", "angrybird_eyeRight", "angrybird_eyeLeft"]
    
    let greenMan = ["neck", "earRight", "earLeft", "face", "orbitalRight", "orbitalMiddle", "orbitalLeft", "eyeRight", "eyeMiddle", "eyeLeft"]
    

    
    let greenmanPosSet = [CGPoint(x:216.0,y: 275.0), CGPoint(x:59.0, y:418.0), CGPoint(x:430.0, y:328.0),CGPoint(x:240.0 , y:412.0), CGPoint(x:144.0, y:417.0), CGPoint(x:249.0, y:411.0), CGPoint(x:354.0, y: 370.0), CGPoint(x:142.0, y: 409.0), CGPoint(x:249.0, y: 402.0), CGPoint(x:347.0, y: 364.0)]
    
    let angrybirdPosSet = [CGPoint(x:293.0,y:462.0),
        CGPoint(x:358.5,y:450.0),
        CGPoint(x:143.0,y:404.0),
        CGPoint(x:271.0,y:401.0),
        CGPoint(x:136.0,y:393.0),
        CGPoint(x:298.0,y:382.0),
        CGPoint(x:350.0,y:380.0),
        CGPoint(x:306.5,y:376.0),
        CGPoint(x:339.5,y:374.0),
        CGPoint(x:140.5,y:370.0),
        CGPoint(x:334.0,y:321.5)]
    
    let tumblerPosSet=[CGPoint(x:249.5,y:400.5),CGPoint(x:199.5,y:482.0),
        CGPoint(x:300.333343505859,y:481.0),
        CGPoint(x:297.666656494141,y:455.0),
        CGPoint(x:202.5,y:455.0),
        CGPoint(x:233.166656494141,y:428.0),
        CGPoint(x:266.5,y:427.0),
        CGPoint(x:317.5,y:419.5),
        CGPoint(x:182.16667175293,y:419.5),
        CGPoint(x:250.33332824707,y:400.0),
        CGPoint(x:363.833312988281,y:345.5),
        CGPoint(x:135.166656494141,y:345.5),
        CGPoint(x:344.5,y:329.0),
        CGPoint(x:155.5,y:328.5),
        CGPoint(x:182.333343505859,y:313.5),
        CGPoint(x:316.666656494141,y:312.5),
        CGPoint(x:249.166687011719,y:306.0),]
    
    var levelDictionary = Dictionary<FaceGameViewController.FaceGameLevelName , GameLevelData>()
    var gameLevelGened:GameLevelData!
    init(size:CGSize,num:Int)
    {
        
        self.size = size
        componentNum = num
        
        //game 01

    
        levelDictionary[.GreenMan] = GameLevelData(main: "img", mainPosition: CGPoint(x: 250, y: 400), nameArray: imageNameSetGame1, positionArray: greenmanPosSet,fixPointIndex:3)

        levelDictionary[.AngryBird] = GameLevelData(main: "angrybird_all", mainPosition: CGPoint(x: 250, y: 400), nameArray: angrybirdNames, positionArray: angrybirdPosSet,fixPointIndex:3)
        
        levelDictionary[.Tumbler] = GameLevelData(main: "tumbler", mainPosition: CGPoint(x: 250, y: 400), nameArray: tumblerNames, positionArray: tumblerPosSet,fixPointIndex:0)
    }
    func genGameLevel(levelName:FaceGameViewController.FaceGameLevelName)
    {
        gameLevelGened = levelDictionary[levelName]
    }
    func setDotNum(num:Int)
    {
        componentNum = num
    }
    
    //random dot position
    func getMain()->SKSpriteNode
    {
        let sprite = SKSpriteNode(imageNamed:gameLevelGened.main)
        sprite.position = gameLevelGened.mainPosition
        return sprite
    }
    
    func freeComponents()->FaceComponentSet
    {
        let componentSet = FaceComponentSet(imageNameSet: gameLevelGened.getNameSet())

        let dis = size.width / 24
        var count = 0
        for component in componentSet.components
        {
            component.position = CGPointMake(size.width / 8 + dis * CGFloat(count%8),(size.height / 8) * CGFloat(count / 8 + 1))
            count++
        }
        return componentSet
    }
    
    func correctPosition() ->[CGPoint]
    {
        return gameLevelGened.getPositionSet()
     
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