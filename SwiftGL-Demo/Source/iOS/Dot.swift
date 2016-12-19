//
//  Dot.swift
//  SwiftGL
//
//  Created by jerry on 2015/7/14.
//  Copyright (c) 2015年 Jerry Chan. All rights reserved.
//

import SpriteKit
import SwiftGL
class Dot: SKNode {
    
    
    override init()
    {
        super.init()
        //self.name = "dot"
        
        let touchArea = SKShapeNode(circleOfRadius: 30) // Size of Circle
        touchArea.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        touchArea.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.addChild(touchArea)
        
        //let image = SKSpriteNode(imageNamed: "spongebob")
        
        //self.addChild(image)
        
        let Circle = SKShapeNode(circleOfRadius: 20) // Size of Circle
        Circle.position = CGPoint(x: 0,y: 0)  //Middle of Screen
        
        //Circle.strokeColor = uIntColor(0, 0, 0, 0)//SKColor(red: 0.2, green: 0.5, blue: 0.6, alpha: 1)
        
        //Circle.strokeColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        
        //Circle.fillColor = uIntColor(80, 151, 255, 255)
        Circle.fillColor = uIntColor(80, green: 151, blue: 255, alpha: 255)

        self.addChild(Circle)
        isUserInteractionEnabled = true
        shape = Circle
        
    }
    convenience init(name:String)
    {
        self.init()
    }
    var shape:SKShapeNode!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func changeColor(_ color:UIColor)
    {
        shape.fillColor = color
    }
    func setAsFixedPoint()
    {
        changeColor(uIntColor(255, green: 70, blue: 142, alpha: 255))
    }
    func getPos()->Vec2
    {
        return Vec2(Float(self.position.x),Float(self.position.y))
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //let touch = touches.first as UITouch?
        //let loc = touch!.locationInNode(self)
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first as UITouch?
        let loc = touch!.location(in: self)
        let prev_loc = touch!.previousLocation(in: self)
        //let node = selectNodeForTouch(prev_loc)
        
        let p = position
        position = CGPoint(x: p.x+loc.x-prev_loc.x, y: p.y+loc.y-prev_loc.y)
        
    }
    
}
