//
//  DotGameScene.swift
//  SwiftGL
//
//  Created by jerry on 2015/7/14.
//  Copyright (c) 2015年 Jerry Chan. All rights reserved.
//

import UIKit
import SpriteKit
import SwiftGL

class DotGameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "doraemon")
    var dotStageLevelGenerator:DotStageLevelGenerator!
    var ansRect:SKNode!
    var quesRect:SKNode!
    
    var quesDots:DotSet!
    var ansDots:DotSet!
    
    var pointNum:Int!
    var difficulty = 1
    
    override func didMove(to view: SKView) {
        scaleMode = SKSceneScaleMode.aspectFill
        backgroundColor = SKColor.white
        //player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        //addChild(player)
        
        prepareScene()
        
        pointNum = 6
        dotStageLevelGenerator = DotStageLevelGenerator(size: size,num: pointNum)
        newStage()
        
        self.addChild(scoreLabel)
        
        
    }
    
    var scoreLabel:SKLabelNode = SKLabelNode(text:"");
    func calScore()->Float
    {
        print(quesDots.compareSet(ansDots), terminator: "")
        
        var score = 1-quesDots.compareSet(ansDots) / Float(200 * difficulty)
        if score < 0
        {
            score = 0
        }
        
        score*=100
        
        let scorePercentString = NSString(format: "%.1f", score) as String
        scoreLabel.text = scorePercentString+"%"
        scoreLabel.isHidden = false
        scoreLabel.fontSize = 100
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        scoreLabel.fontColor = uIntColor(80, green: 151, blue: 255, alpha: 255)
        
        
        return Float(score)
    }
    func changeDifficulty(_ d:Int)
    {
        difficulty = d
        
    }
    func newStage()
    {
        if quesDots != nil
        {
            quesDots.removeFromParent()
        }
        if ansDots != nil
        {
           ansDots.removeFromParent()
        }
        
        
        quesDots = dotStageLevelGenerator.testLevel()
        quesDots.setMovable(false)
        quesDots.addToNode(quesRect)
        
        ansDots = dotStageLevelGenerator.freeDots()
        ansDots.setMovable(true)
        ansDots.addToNode(ansRect)
        
        setFixPoint()
        
        scoreLabel.isHidden = true
    }
    
    func restart()
    {
        if ansDots != nil
        {
            ansDots.removeFromParent()
        }
        
        ansDots = dotStageLevelGenerator.freeDots()
        ansDots.setMovable(true)
        ansDots.addToNode(ansRect)
        
        setFixPoint()
        
        scoreLabel.isHidden = true
    }
    
    
    func setFixPoint()
    {
        for i in 0...(pointNum-1-difficulty)
        {
            ansDots.dots[i].position = quesDots.dots[i].position
            ansDots.dots[i].setAsFixedPoint()
            quesDots.dots[i].setAsFixedPoint()
            ansDots.dots[i].isUserInteractionEnabled = false
        }
        /*
        ansDots.dots[0].position = fixPoint.position
        ansDots.dots[0].setAsFixedPoint()
        ansDots.dots[0].userInteractionEnabled = false
        */
    }
    
    func prepareScene()
    {
        let quesRect = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width/2, height: size.height))
        
        quesRect.fillColor = SKColor.white//uIntColor(231,green: 234,blue: 179,alpha: 255)
        quesRect.position = CGPoint(x: 0,y: 0)
        //quesRect.userInteractionEnabled = false
        addChild(quesRect)
        
        let ansRect = SKShapeNode(rect: CGRect(x: 0, y: 0, width: size.width/2, height: size.height))
        
        ansRect.fillColor = SKColor.white
        ansRect.position = CGPoint(x: size.width/2,y: 0)
        //ansRect.userInteractionEnabled = false
        addChild(ansRect)
        
        /*
        let spongeBG = SKSpriteNode(imageNamed: "spongebob")
        spongeBG.position = CGPointMake(300,400)
        quesRect.addChild(spongeBG)
        */
        self.quesRect = quesRect
        self.ansRect = ansRect
        
    }
    
    /*
    var selectedNode:SKNode!
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        let touch = touches.first as! UITouch
        let loc = touch.locationInNode(self)
        selectedNode = selectNodeForTouch(loc)
    }
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        let touch = touches.first as! UITouch
        let loc = touch.locationInNode(self)
        let prev_loc = touch.previousLocationInNode(self)
        //let node = selectNodeForTouch(prev_loc)
        let node = selectedNode
        if node != nil
        {
            let p = node.position
            node.position = CGPointMake(p.x+loc.x-prev_loc.x, p.y+loc.y-prev_loc.y)
        }
        
    }
    
    func selectNodeForTouch(location:CGPoint)->SKNode!
    {
        
        let node = nodeAtPoint(location)// as? SKSpriteNode
        println(node)
        if node.name == "dot"
        {
            return node
        }
        else
        {
            return nil
        }
        //return nil
    }
*/
}
