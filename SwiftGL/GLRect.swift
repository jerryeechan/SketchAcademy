//
//  GLRect.swift
//  SwiftGL
//
//  Created by jerry on 2016/5/10.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

public struct GLRect {
   public var leftTop:Vec2
   public var rightButtom:Vec2
    public var center:Vec2{
        get {
            return (leftTop+rightButtom)/2
        }
    }
    public var width:Float{
        get{
            return rightButtom.x - leftTop.x
        }
    }
    public var height:Float{
        get{
            return rightButtom.y - leftTop.y
        }
    }
   public init(p1:Vec2,p2:Vec2)
    {
        leftTop = p1
        rightButtom = p2
        _area = (leftTop.x-rightButtom.x)*(leftTop.y-rightButtom.y)
    }
    // intersect of another rectanble, include overlapping
    public func intersect(_ rect:GLRect)->Bool
    {
        return  intersect(rect.leftTop) || intersect(rect.rightButtom) || rect.intersect(leftTop) || rect.intersect(rightButtom)
    }
    
    // if the point inside the rect
    public func intersect(_ point:Vec2)->Bool
    {
        if leftTop <= point && rightButtom >= point
        {
            return true
        }
        return false
    }
    public func getUnionRect(_ point:Vec2)->GLRect
    {
        return getUnionRect(GLRect(p1: point, p2: point))
    }
    public func getUnionRect(_ rect:GLRect)->GLRect
    {
        let ltx = min(leftTop.x, rect.leftTop.x)
        let lty = min(leftTop.y, rect.leftTop.y)
        let rbx = max(rightButtom.x, rect.rightButtom.x)
        let rby = max(rightButtom.y, rect.rightButtom.y)
        return GLRect(p1: Vec2(ltx,lty), p2: Vec2(rbx,rby))
    }
    public mutating func union(_ rect:GLRect)
    {
        let ltx = min(leftTop.x, rect.leftTop.x)
        let lty = min(leftTop.y, rect.leftTop.y)
        let rbx = max(rightButtom.x, rect.rightButtom.x)
        let rby = max(rightButtom.y, rect.rightButtom.y)
        leftTop.x = ltx
        leftTop.y = lty
        rightButtom.x = rbx
        rightButtom.y = rby
        _area = (leftTop.x-rightButtom.x)*(leftTop.y-rightButtom.y)
    }
    var _area:Float
    public var area:Float{
         get{
            return _area
        }
    }
    
}
public func - (rect1:GLRect,rect2:GLRect)->Float
{
    return rect1.area - rect2.area
}
