//
//  FaceGameScene.swift
//  SwiftGL
//
//  Created by CSC NTHU on 2015/8/15.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import UIKit
import SpriteKit
import SwiftGL
/*func uIntColor(red:UInt8,green:UInt8,blue:UInt8,alpha:UInt8)->UIColor
{
    return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: CGFloat(alpha)/255)
}*/
class FaceGameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "doraemon")
    var faceGameStageLevelGenerator:FaceGameStageLevelGenerator!
    var ansRect:SKNode!
    var quesRect:SKNode!
    
    var quesComponents:FaceComponentSet!
    var ansComponents:FaceComponentSet!
    
    var pointNum:Int = 10
    var difficulty = 1
    
    let sampleImg2 = SKSpriteNode(imageNamed: "img")
    
    override func didMoveToView(view: SKView) {
        scaleMode = SKSceneScaleMode.AspectFill
        backgroundColor = SKColor.whiteColor()
        //player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        //addChild(player)
        
        prepareScene()
        
        faceGameStageLevelGenerator = FaceGameStageLevelGenerator(size: size,num: pointNum)
        
        newStage()
        
        self.addChild(scoreLabel)
    
    }
    
    var scoreLabel:SKLabelNode = SKLabelNode(text:"");
    func calScore()->Float
    {
        print(quesComponents.compareSet(ansComponents))
        
        var score = 1 - quesComponents.compareSet(ansComponents) / Float(200 * 10)
        if score < 0
        {
            score = 0
        }
        
        score *= 100
        
        let scorePercentString = NSString(format: "%.1f", score) as String
        scoreLabel.text = scorePercentString+"%"
        scoreLabel.hidden = false
        scoreLabel.fontSize = 100
        scoreLabel.position = CGPointMake(size.width/2, size.height/2)
        scoreLabel.fontColor = UIColor(red: 80/255, green: 151/255, blue: 1, alpha: 1)
        //scoreLabel.fontColor = uIntColor(80, green: 151, blue: 255, alpha: 255)
        
        
        return Float(score)
    }
    
    func calposition()
    {
        ansComponents.sortComponents()
        for component in ansComponents.components {
            print("\(component.position.x), \(component.position.y)")
        }
    }
    
    func showImg()
    {
        ansRect.addChild(sampleImg2)
    }
    
    func hideImg(){
        sampleImg2.removeFromParent()
    }
    
    func changeDifficulty(d:Int)
    {
        difficulty = d
        
    }
    func newStage()
    {
        if quesComponents != nil
        {
            quesComponents.removeFromParent()
        }
        if ansComponents != nil
        {
            ansComponents.removeFromParent()
        }
        
        quesComponents = faceGameStageLevelGenerator.correctPosition("Little Green Man")
        //quesDots = dotStageLevelGenerator.testLevel()
        quesComponents.setMovable(false)
        quesComponents.addToNode(quesRect)
        
        
        ansComponents = faceGameStageLevelGenerator.freeComponents("Little Green Man")
        ansComponents.setMovable(true)
        ansComponents.addToNode(ansRect)
        
        sampleImg2.position = CGPointMake(250,400)
        sampleImg2.setScale(0.2)
        sampleImg2.color = UIColor(red: 0, green: 0, blue: 0, alpha: 50/255)
        //sampleImg2.color = uIntColor(0, green: 0, blue: 0, alpha: 50)
        sampleImg2.colorBlendFactor = 1;
        
        setFixPoint()
        
        scoreLabel.hidden = true
    }
    
    func restart()
    {
        if ansComponents != nil
        {
            ansComponents.removeFromParent()
        }
        
        ansComponents = faceGameStageLevelGenerator.freeComponents("Little Green Man")
        ansComponents.setMovable(true)
        ansComponents.addToNode(ansRect)
        
        setFixPoint()
        
        scoreLabel.hidden = true
    }
    
    
    func setFixPoint()
    {
        for i in 0...9
        {
            quesComponents.components[i].setAsFixedPoint()
        }
        
        ansComponents.components[3].position = CGPointMake(240.0, 412.0)
        //ansDots.dots[3].setAsFixedPoint()
        ansComponents.components[3].userInteractionEnabled = false
        
        /*
        ansDots.dots[0].position = fixPoint.position
        ansDots.dots[0].setAsFixedPoint()
        ansDots.dots[0].userInteractionEnabled = false
        */
    }
    
    func prepareScene()
    {
        let quesRect = SKShapeNode(rect: CGRectMake(0, 0, size.width/2, size.height))
        
        quesRect.fillColor = SKColor.whiteColor()//uIntColor(231,green: 234,blue: 179,alpha: 255)
        quesRect.position = CGPointMake(0,0)
        //quesRect.userInteractionEnabled = false
        addChild(quesRect)
        
        let ansRect = SKShapeNode(rect: CGRectMake(0, 0, size.width/2, size.height))
        
        ansRect.fillColor = SKColor.whiteColor()
        ansRect.position = CGPointMake(size.width/2,0)
        //ansRect.userInteractionEnabled = false
        addChild(ansRect)
        
        /*let spongeBG = SKSpriteNode(imageNamed: "spongebob")
        spongeBG.position = CGPointMake(300,400)
        quesRect.addChild(spongeBG)*/
        
        //底圖移到generater
        //img name  : string
        let sampleImg = SKSpriteNode(imageNamed: "img")
        sampleImg.position = CGPointMake(250,400)
        sampleImg.setScale(0.2)
        //sampleImg.color = uIntColor(0, green: 0, blue: 0, alpha: 255)
        sampleImg.color = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        sampleImg.colorBlendFactor = 1;
        quesRect.addChild(sampleImg)
        
        //        let sampleImg2 = SKSpriteNode(imageNamed: "img")
        //        sampleImg2.position = CGPointMake(250,400)
        //        sampleImg2.setScale(0.2)
        //        sampleImg2.color = uIntColor(0, green: 0, blue: 0, alpha: 0)
        //        sampleImg2.colorBlendFactor = 1;
        //        ansRect.addChild(sampleImg2)
        
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

