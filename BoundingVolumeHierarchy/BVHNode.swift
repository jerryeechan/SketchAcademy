//
//  BVHNode.swift
//  SwiftGL
//
//  Created by jerry on 2016/5/10.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

public class BVHNode:Equatable {
    
    var children:[BVHNode] = []
    var childrenLimit:Int = 2
    var parent:BVHNode!
    var rect:GLRect
    var data:HasBound!
    var isLeaf:Bool{
        get{
            return children.count == 0
        }
        
    }
    
    var getData:HasBound!{
        get{
            //only leaf contain data
            if children.count == 0
            {
                return data
            }
            return nil
        }
    }
    

    public init(rect:GLRect,data:HasBound!)
    {
        self.rect = rect
        self.data = data
    }
    public func expand(rect:GLRect)
    {
        self.rect.union(rect)
        if parent != nil
        {
            parent.expand(rect)
        }
    }
    public func mergeNode(node:BVHNode)->BVHNode
    {
        // always create a new parent as binary tree
        // worth to try with more nodes
        let newParent = BVHNode(rect: rect, data: nil)
        newParent.children.append(self)
        newParent.children.append(node)
        node.parent = newParent
        newParent.parent = parent
        
        if parent != nil
        {
            parent.children.append(newParent)
            parent.children.removeObject(self)
        }
        
        parent = newParent
        newParent.expand(node.rect)
        
        return newParent
    }
    public func insertParent()->BVHNode
    {
        parent.children.removeObject(self)
        let newParent = BVHNode(rect: rect, data: nil)
        newParent.children.append(self)
        newParent.parent = parent
        parent.children.append(newParent)
        parent = newParent
        return newParent
    }
    /*
    public func mergeNode(node:BVHNode)
    {
        //create a node as self and become child
        let dropNode = BVHNode(rect: rect,data:data)
        
        children.append(dropNode)
        children.append(node)
        dropNode.parent = self
        node.parent = self
        
        //become a inner node
        rect = dropNode.rect.getUnionRect(node.rect)
        data = nil
    }
 */    
    
    public func search(point:Vec2,inout nodes:[BVHNode])
    {
        if rect.intersect(point)
        {
            if children.count == 0
            {
                nodes.append(self)
            }
            for node in children
            {
                node.search(point,nodes: &nodes)
            }
        }
    }
}
public func ==(lhs:BVHNode, rhs:BVHNode) -> Bool
{
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}
