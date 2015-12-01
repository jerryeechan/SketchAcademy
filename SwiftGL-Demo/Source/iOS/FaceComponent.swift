//
//  FaceComponent.swift
//  SwiftGL
//
//  Created by CSC NTHU on 2015/8/15.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import SpriteKit
import SwiftGL

class FaceComponent : SKNode {
    
    override init()
    {
        super.init()
        
    }
    
    var filename:String!
    
    convenience init(name:String)
    {
        self.init()
        sprite = SKSpriteNode(imageNamed: name)
        self.filename = name
        sprite.position = CGPointMake(0, 0)
        sprite.setScale(0.2)
        self.addChild(sprite)
        
        sprite.userInteractionEnabled = false    //?
        
        userInteractionEnabled = true
        
    }
    
    var sprite:SKSpriteNode!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func changeColor(color:UIColor) -> FaceComponent
    {
        sprite.color = color
        sprite.colorBlendFactor = 0.5;
        return self
    }
    
    func setAsFixedPoint()
    {
        //sprite.color = uIntColor(red: 255, green: 70, blue: 142, alpha: 0)
        sprite.color = UIColor(red: 1, green: 70/255, blue: 142/255, alpha: 0)
        sprite.colorBlendFactor = 1;
    }
    
    func getPos()->Vec2
    {
        return Vec2(Float(self.position.x),Float(self.position.y))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        //let touch = touches.first as UITouch?
        //let loc = touch!.locationInNode(self)
        print(filename)
        
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        let touch = touches.first as UITouch?
        let loc = touch!.locationInNode(self)
        let prev_loc = touch!.previousLocationInNode(self)
        //let node = selectNodeForTouch(prev_loc)
        
        let p = position
        position = CGPointMake(p.x+loc.x-prev_loc.x, p.y+loc.y-prev_loc.y)
        
    }
    
}

extension CGPoint{
    func getPos()->Vec2
    {
        return Vec2(Float(x),Float(y))
    }
}
