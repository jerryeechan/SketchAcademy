
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
    func compareSet(componentsSet:FaceComponentSet)->Float
    {
        sortComponents()
        componentsSet.sortComponents()
        
        var score:Float = 0
        for var i = 0; i < components.count; i++
        {
            let dis = (components[i].getPos() - componentsSet.components[i].getPos()).length
            score += dis
        }
        return score
    }
    
    func sortComponents()
    {
        components.sortInPlace({$0.position.x > $1.position.x})
        components.sortInPlace({$0.position.y > $1.position.y})
    }
    func addToNode(node:SKNode)
    {
        for component in components
        {
            node.addChild(component)
        }
    }
    func setMovable(movable:Bool)
    {
        for component in components{
            component.userInteractionEnabled = movable
        }
    }
    func removeFromParent()
    {
        for component in components{
            component.removeFromParent()
        }
    }
}
