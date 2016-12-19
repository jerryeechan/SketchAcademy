
//
//  FaceComponentSet.swift
//  SwiftGL
//
//  Created by CSC NTHU on 2015/8/15.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import SpriteKit
import SwiftGL
class FaceComponentSet {
    var components:[FaceComponent] = []
    init(imageNameSet:[String])
    {
        for imageName in imageNameSet {
            components.append(FaceComponent(name:imageName))
            
        }
                
        sortComponents()
    }
    func compareSet(_ componentsSet:FaceComponentSet)->Float
    {
        sortComponents()
        componentsSet.sortComponents()
        
        var score:Float = 0
        for i in 0 ..< components.count
        {
            let dis = (components[i].getPos() - componentsSet.components[i].getPos()).length
            score += dis
        }
        return score
    }
    
    func sortCGPoints(_ array:[CGPoint])->[CGPoint]
    {
        var array = array
        array.sort(by: {$0.x > $1.x})
        array.sort(by: {$0.y > $1.y})
        return array
    }
    func compareSet(_ positionArray:[CGPoint])->Float
    {
        var pos = positionArray
        var comps = components
        
        var score:Float = 0
        while(pos.count != 0)
        {
            var mindis:Float = 10000
            var minId = 0
            for i in 0 ..< pos.count
            {
                let dis = (comps[0].getPos() - pos[i].getPos()).length2
                if(dis < mindis)
                {
                    mindis = dis
                    minId = i
                }
            }
            
            comps.remove(at: 0)
            pos.remove(at: minId)
            print("mindis:"+"\(mindis)")
            score += mindis
        }
        /*sortComponents()
        positionArray = sortCGPoints(positionArray)
        */
        
        /*
        var score:Float = 0
        for var i=0; i < positionArray.count; i++
        {
            print(components[i].getPos(),positionArray[i].getPos())
            let dis = (components[i].getPos() - positionArray[i].getPos()).length
            score += dis
        }
        */
        
        return score
    }
    func sortComponents()
    {
        components.sort(by: {$0.position.x > $1.position.x})
        components.sort(by: {$0.position.y > $1.position.y})
    }
    func addToNode(_ node:SKNode)
    {
        for component in components
        {
            print(component.position)
            node.addChild(component)
        }
    }
    func setMovable(_ movable:Bool)
    {
        for component in components{
            component.isUserInteractionEnabled = movable
        }
    }
    func removeFromParent()
    {
        for component in components{
            component.removeFromParent()
        }
    }
}
