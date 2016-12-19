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
    override func didMove(to view: SKView) {
        self.scaleMode = SKSceneScaleMode.aspectFit;
        backgroundColor = SKColor.white
        refImg = SKSpriteNode(imageNamed: "spongebob.png")
        refImg.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        addChild(refImg)
        print("2- didMoveToView", terminator: "")
        
    }
    func removeRefImg()
    {
        refImg.removeFromParent()
        print("remove from parent", terminator: "")
    }
    func putBackRefImg()
    {
        if refImg.parent != self
        {
            insertChild(refImg, at: 0)
        }
        
    }
    var tempRect:SKShapeNode!
    
    var rects:[SKShapeNode]=[]
    var beganPoint:CGPoint!
    
    enum RectToolMode:Int{
        case draw = 0,erase
    }
    
    var rectToolMode:RectToolMode = .draw
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch =  touches.first as UITouch?
        
        switch rectToolMode
        {
        case .draw:
            
            tempRect = SKShapeNode(rectOf: CGSize(width: 0, height: 0))
            tempRect.strokeColor = UIColor.black
            tempRect.position = touch!.location(in: self)
            beganPoint = tempRect.position
            
            addChild(tempRect)
            rects.append(tempRect)
            
        case .erase:
            let rectNode = atPoint(touch!.location(in: self))
            if rectNode != refImg
            {
                rectNode.removeFromParent()
            }
            
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch =  touches.first as UITouch?
        switch rectToolMode
        {
        case .draw:
            /*
            let pos = touch!.location(in: self)
            
            let path:CGMutablePath = CGMutablePath()
            
            CGPathAddRect(path, nil, CGRect(x: 0, y: 0, width: pos.x - beganPoint.x, height: pos.y-beganPoint.y))
            
            tempRect.path = path
 */
            break
        case .erase:
            let rectNode = atPoint(touch!.location(in: self))
            if rectNode != refImg
            {
                rectNode.removeFromParent()
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch rectToolMode
        {
        case .draw:
            let touch =  touches.first as UITouch?
            let pos = touch!.location(in: self)
            
            
            let rectData = SliceRect(p: tempRect.position, width:pos.x - beganPoint.x , height: pos.y-beganPoint.y,rectSKNode: tempRect)
            
            ImageSlicedRectangles.instance.addRect(rectData)
        default:
            print("nothing", terminator: "")
        }
        
        
    }
    func removeRect()
    {
        
    }
    func cleanUp()
    {
        removeChildren(in: rects)
    }
    
    
}
