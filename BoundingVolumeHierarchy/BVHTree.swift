//
//  BVHTree.swift
//  SwiftGL
//
//  Created by jerry on 2016/5/10.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//
extension Array where Element: Equatable {
    mutating func removeObject(_ object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    
    mutating func removeObjectsInArray(_ array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
}
let eps:Float = 0.001
open class NodePair: Comparable {
    open let node:BVHNode
    open let inducedCost:Float
    open let priority:Float
    public init(node:BVHNode,inducedCost:Float)
    {
        self.node = node
        self.inducedCost = inducedCost
        self.priority = 1/(inducedCost+eps)
    }
}
public func ==(lhs: NodePair, rhs: NodePair) -> Bool
{
    return lhs.priority - rhs.priority == 0
}
public func <(lhs: NodePair, rhs: NodePair) -> Bool
{
    return lhs.priority - rhs.priority < 0
}
public func >(lhs: NodePair, rhs: NodePair) -> Bool
{
    return lhs.priority - rhs.priority > 0
}
public func <=(lhs: NodePair, rhs: NodePair) -> Bool
{
    return lhs.priority - rhs.priority <= 0
}
public func >=(lhs: NodePair, rhs: NodePair) -> Bool
{
    return lhs.priority - rhs.priority >= 0
}
open class BVHTree {
    var root:BVHNode!
    public init()
    {
        
    }
    open func searchNodes(_ point:Vec2)->[HasBound]
    {
        var coverNode:[HasBound] = []
        
        var PQ = [BVHNode]()
        PQ.append(root)
        
        while !PQ.isEmpty
        {
            let currentNode = PQ.removeFirst()
            
            if currentNode.rect.intersect(point)
            {
                if !currentNode.isLeaf
                {
                    for child in currentNode.children{
                        PQ.append(child)
                    }
                }
                else
                {
                    //leaf
                    if currentNode.data == nil
                    {
                        print("eroor")
                    }
                    coverNode.append(currentNode.data)
                }

            }
        }
        return coverNode
    }
    fileprivate func addNodeToTree(_ node:BVHNode)
    {
     //   print(node.data.rect)
        if root == nil
        {
            root = node
            return
        }
        
        var bestCost = Float.infinity
        var bestNode:BVHNode!
        var PQ = PriorityQueue<NodePair>()
        PQ.push(NodePair(node: root, inducedCost: 0))
        
        while !PQ.isEmpty
        {
            let nodePair = PQ.pop()!
            let currentNode = nodePair.node
            if (nodePair.inducedCost) + node.rect.area >= bestCost
            {
                break
            }
            let directCost = currentNode.rect.getUnionRect(node.rect).area
            let totalCost = directCost + (nodePair.inducedCost)
            
            if totalCost < bestCost
            {
                //merge
                bestCost = totalCost
                bestNode = currentNode
            }
            
            let inducedCost = totalCost - currentNode.rect.area
            if inducedCost + node.rect.area < bestCost
            {
                if !currentNode.isLeaf
                {
                    for child in currentNode.children{
                        PQ.push(NodePair(node: child, inducedCost: inducedCost))
                    }
                }
            }
            
            
            
        }
            //insert in the middle of the subtree
            //merge node N to X
            //----------------------------------
            //--------------------------------
            //--------0-----------------0------
            //-------/-\-----=>--------/-\-----
            //------X---0-------------P---0-----
            //-----/-\---------------/-\--------
            //----0---0-------------X---N------
            //---------------------/-\----------
            
            //or X is a leaf
            //----------------------------------
            //--------------------------------
            //--------0-----------------0------
            //-------/-\-----=>--------/-\-----
            //------X---0-------------P---0-----
            //-----------------------/-\--------
            //----------------------X---N------
            //----------------------------------
        
            //insert a parent node P to replace X and make X and N children of P
            let insertParentNode = bestNode.mergeNode(node)
            //print(insertParentNode.rect)
        
            if bestNode == root
            {
                //if X was root, replace root with P
                root = insertParentNode
                
            }
        
        
    }
    open func buildTree(_ data:[HasBound])
    {
        for obj in data{
            addNodeToTree(BVHNode(rect: obj.bound, data: obj))
        }
        //root =
        
    }
}
