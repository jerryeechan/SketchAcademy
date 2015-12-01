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
    
    //let player = SKSpriteNode(imageNamed: "doraemon")
    var faceGameStageLevelGenerator:FaceGameStageLevelGenerator!
    var ansRect:SKNode!
    var quesRect:SKNode!
    
    var quesPositions:[CGPoint]!
    var ansComponents:FaceComponentSet!
    
    var pointNum:Int = 10
    var difficulty = 1
    
    var hintImg:SKSpriteNode!//(imageNamed: "imghint")
    
    var levelName: FaceGameViewController.FaceGameLevelName!
    override func didMoveToView(view: SKView) {
        scaleMode = SKSceneScaleMode.AspectFill
        backgroundColor = SKColor.whiteColor()
        view.showsDrawCount = true
        view.showsFPS = true
        //player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        //addChild(player)
        faceGameStageLevelGenerator = FaceGameStageLevelGenerator(size: size,num: pointNum)
        prepareScene()
        

        
        newStage()
        
        self.addChild(scoreLabel)
        
    }
    func prepareScene()
    {
        //Question Area
        let quesRect = SKShapeNode(rect: CGRectMake(0, 0, size.width/2, size.height))
        quesRect.position = CGPointMake(0,0)
        addChild(quesRect)
        
        
        //Answer Area
        let ansRect = SKShapeNode(rect: CGRectMake(0, 0, size.width/2, size.height))
        ansRect.fillColor = SKColor.whiteColor()
        ansRect.position = CGPointMake(size.width/2,0)
        addChild(ansRect)
        
        
        self.quesRect = quesRect
        self.ansRect = ansRect
        
    }
    
    var scoreLabel:SKLabelNode = SKLabelNode(text:"");
    func calScore()->Float
    {
        var score = 1 - ansComponents.compareSet(quesPositions) / Float(200 * 10)
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
        
        calposition()
        return Float(score)
    }
    
    func calposition()
    {
        //ansComponents.sortComponents()
        for component in ansComponents.components {
            print("CGPoint(x:\(component.position.x),y:\(component.position.y)),")
        }
    }
    
    func showImg()
    {
        ansRect.addChild(hintImg)
    }
    
    func hideImg(){
        hintImg.removeFromParent()
    }
    
    func changeDifficulty(d:Int)
    {
        difficulty = d
        
    }
    func newStage()
    {
        if ansComponents != nil
        {
            ansComponents.removeFromParent()
        }
        
        //let levelName = "AngryBird"
        //let levelName = "Tumbler"
        //let levelName = "GreenMan"
        faceGameStageLevelGenerator.genGameLevel(levelName)
//        quesComponents = faceGameStageLevelGenerator.correctPosition()

        quesPositions = faceGameStageLevelGenerator.correctPosition()
        //quesComponents.addToNode(quesRect)
        
        
        
        ansComponents = faceGameStageLevelGenerator.freeComponents()
        ansComponents.setMovable(true)
        ansComponents.addToNode(ansRect)
        
        let quesImg = faceGameStageLevelGenerator.getMain()
        quesImg.setScale(0.2)
        quesImg.color = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        quesImg.colorBlendFactor = 1;
        quesRect.addChild(quesImg)
        
        hintImg = faceGameStageLevelGenerator.getMain()
        hintImg.setScale(0.2)
        hintImg.color = UIColor(red: 0, green: 0, blue: 0, alpha: 50/255)
        //hintImg.color = uIntColor(0, green: 0, blue: 0, alpha: 50)
        hintImg.colorBlendFactor = 1;
        
        setFixPoint()
        
        scoreLabel.hidden = true
    }
    
    func restart()
    {
        if ansComponents != nil
        {
            ansComponents.removeFromParent()
        }
        
        ansComponents = faceGameStageLevelGenerator.freeComponents()
        ansComponents.setMovable(true)
        ansComponents.addToNode(ansRect)
        
        setFixPoint()
        
        scoreLabel.hidden = true
    }
    
    
    func setFixPoint()
    {
        let index = faceGameStageLevelGenerator.gameLevelGened.fixPointIndex
        
        ansComponents.components[index].position = quesPositions[index]
        
        ansComponents.components[index].userInteractionEnabled = false
        
        
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

