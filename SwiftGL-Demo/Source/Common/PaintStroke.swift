//
//  PaintTrack.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/21.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import Foundation
import GLKit
import SwiftGL


/*
if _bound == nil
{
    for point in points
    {
        expandBound(point.position)
    }
}
*/

public class PaintStroke:HasBound
{
    var _bound:GLRect!
    public var bound:GLRect{
        get{
            if _bound == nil
            {
                _bound = GLRect(p1: points[0].position.xy, p2: points[0].position.xy)
                for point in points
                {
                    expandBound(point.position)
                }
            }
            return _bound
        }
        set{
            _bound = newValue
        }
    }
    public var points:[PaintPoint] = []
    //var position:[Vec2]=[]
    //var timestamps:[CFTimeInterval]=[]
    //var velocities:[Vec2] = []
    
    public var pointData:[PointData] = []
    
    public var startTime:Double
    public var texture:Texture!
    public var valueInfo:ToolValueInfo
    public var stringInfo:ToolStringInfo
    
    //init(tool:PaintBrush)   //use when recording
    
    //startTime
    public init(s:ToolStringInfo,v:ToolValueInfo,startTime:Double) //use when load data
    {
        //let brush = PaintToolManager.instance.getTool(s.toolName)
        stringInfo = s
        valueInfo = v
        self.startTime = startTime
        //strokeInfo = sti
    }
    public func genPointsFromPointData()
    {
        points = []
        for i in 0 ..< pointData.count 
        {
            points.append(pointData[i].paintPoint)
        }
    }
    public func isPaintingAvalible()->Bool
    {
        return points.count>2
    }
    public func last()->PaintPoint!
    {
        return points.last!
    }
    public func lastTwo()->[PaintPoint]
    {
        if(points.count>1)
        {
            let c = points.count
            let array:[PaintPoint] = [points[c-2],points[c-1]]
            return array
        }
        return []
    }
    public func lastThree()->[PaintPoint]
    {
        if(points.count>2)
        {
            let c = points.count
            let array:[PaintPoint] = [points[c-3],points[c-2],points[c-1]]
            return array
        }
        return []
    }
    public func addPoint(_ point:PaintPoint,time:CFAbsoluteTime)
    {
        points+=[point]
        pointData.append(PointData(paintPoint: point,t: time))
        if points.count == 1
        {
            bound = GLRect(p1: point.position.xy,p2: point.position.xy)
        }
        expandBound(point.position)
    }
    public func expandBound(_ position:Vec4)
    {
        if position.x < _bound.leftTop.x
        {
            _bound.leftTop.x = position.x
        }
        if position.y < _bound.leftTop.y
        {
            _bound.leftTop.y = position.y
        }
        if position.x > _bound.rightButtom.x
        {
            _bound.rightButtom.x = position.x
        }
        if position.y > _bound.rightButtom.y
        {
            _bound.rightButtom.y = position.y
        }

    }
    /*
    func drawBetween(startIndex:Int,endIndex:Int)
    {
        for var i = startIndex; i<endIndex-2; i++
        {
            
            Painter.renderLine(valueInfo,prev2: points[i],prev1: points[i+1],cur: points[i+2])
        }
        //
    }
*/
    func setBrush()
    {
        
    }
    public var jsonStrokeInfo:String
    {
        get{
            let s = "{\"tool\":\(stringInfo.toolName),\"startTime\":\(startTime),\"endTime\":\(pointData.last?.timestamps)}"
            return s
        }
    }

}
extension Sequence where Iterator.Element == PaintStroke
{
    public var tojson:String{
        get{
            var s = "["
            s += self.map {$0.pointData.jsonArray}.joined(separator: ",")
            s += "]"
            return s
        }
    }
    public var tojsonStrokeInfo:String{
        var s = "["
        s += self.map {$0.jsonStrokeInfo}.joined(separator: ",")
        s += "]"
        return s
    }
}

