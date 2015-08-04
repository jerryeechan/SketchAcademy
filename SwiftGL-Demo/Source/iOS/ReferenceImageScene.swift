//
//  ReferenceImageScene.swift
//  SwiftGL
//
//  Created by jerry on 2015/7/15.
//  Copyright (c) 2015年 Jerry Chan. All rights reserved.
//

import SpriteKit
class ReferenceImageScene: SKScene {
    
    var refImg:SKSpriteNode!
    override func didMoveToView(view: SKView) {
        self.scaleMode = SKSceneScaleMode.AspectFit;
        backgroundColor = SKColor.whiteColor()
        refImg = SKSpriteNode(imageNamed: "spongebob.png")
        refImg.position = CGPointMake(self.size.width/2, self.size.height/2)
        addChild(refImg)
        print("2- didMoveToView")
        
    }
    func removeRefImg()
    {
        refImg.removeFromParent()
        print("remove from parent")
    }
    func putBackRefImg()
    {
        if refImg.parent != self
        {
            insertChild(refImg, atIndex: 0)
        }
        
    }
    var tempRect:SKShapeNode!
    
    var rects:[SKShapeNode]=[]
    var beganPoint:CGPoint!
    
    enum RectToolMode:Int{
        case draw = 0,erase
    }
    
    var rectToolMode:RectToolMode = .draw
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch =  touches.first as UITouch?
        
        switch rectToolMode
        {
        case .draw:
            
            tempRect = SKShapeNode(rectOfSize: CGSizeMake(0, 0))
            tempRect.strokeColor = UIColor.blackColor()
            tempRect.position = touch!.locationInNode(self)
            beganPoint = tempRect.position
            
            addChild(tempRect)
            rects.append(tempRect)
            
        case .erase:
            let rectNode = nodeAtPoint(touch!.locationInNode(self))
            if rectNode != refImg
            {
                rectNode.removeFromParent()
            }
            
        }
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch =  touches.first as UITouch?
        switch rectToolMode
        {
        case .draw:
            
            let pos = touch!.locationInNode(self)
            
            let path:CGMutablePathRef = CGPathCreateMutable()
            
            CGPathAddRect(path, nil, CGRectMake(0, 0, pos.x - beganPoint.x, pos.y-beganPoint.y))
            
            tempRect.path = path
        case .erase:
            let rectNode = nodeAtPoint(touch!.locationInNode(self))
            if rectNode != refImg
            {
                rectNode.removeFromParent()
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        switch rectToolMode
        {
        case .draw:
            let touch =  touches.first as UITouch?
            let pos = touch!.locationInNode(self)
            
            
            let rectData = SliceRect(p: tempRect.position, width:pos.x - beganPoint.x , height: pos.y-beganPoint.y,rectSKNode: tempRect)
            
            ImageSlicedRectangles.instance.addRect(rectData)
        default:
            print("nothing")
        }
        
        
    }
    func removeRect()
    {
        
    }
    func cleanUp()
    {
        removeChildrenInArray(rects)
    }
    
    
}