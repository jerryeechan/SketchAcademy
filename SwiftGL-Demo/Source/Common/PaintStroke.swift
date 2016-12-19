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

public struct StrokeInfo{
    var timeAfterLast:Double
}

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
    var points:[PaintPoint] = []
    //var position:[Vec2]=[]
    //var timestamps:[CFTimeInterval]=[]
    //var velocities:[Vec2] = []
    
    var pointData:[PointData] = []
    
    var startTime:Double!
    var texture:Texture!
    var valueInfo:ToolValueInfo
    var stringInfo:ToolStringInfo
    var strokeInfo:StrokeInfo!
    
    //init(tool:PaintBrush)   //use when recording
    init(stringInfo:ToolStringInfo,valueInfo:ToolValueInfo)   //use when recording
    {
        self.stringInfo = stringInfo
        self.valueInfo = valueInfo
        //stringInfo = tool.sInfo
        //valueInfo = tool.vInfo
        startTime =  CFAbsoluteTimeGetCurrent()
    }
    init(s:ToolStringInfo,v:ToolValueInfo) //use when load data
    {
        //let brush = PaintToolManager.instance.getTool(s.toolName)
        stringInfo = s
        valueInfo = v
        //strokeInfo = sti
    }
    func genPointsFromPointData()
    {
        points = []
        for i in 0 ..< pointData.count 
        {
            points.append(pointData[i].paintPoint)
        }
    }
    func isPaintingAvalible()->Bool
    {
        return points.count>2
    }
    func last()->PaintPoint!
    {
        return points.last!
    }
    func lastTwo()->[PaintPoint]
    {
        if(points.count>1)
        {
            let c = points.count
            let array:[PaintPoint] = [points[c-2],points[c-1]]
            return array
        }
        return []
    }
    func lastThree()->[PaintPoint]
    {
        if(points.count>2)
        {
            let c = points.count
            let array:[PaintPoint] = [points[c-3],points[c-2],points[c-1]]
            return array
        }
        return []
    }
    func addPoint(_ point:PaintPoint,time:CFAbsoluteTime)
    {
        points+=[point]
        pointData.append(PointData(paintPoint: point,t: time))
        if points.count == 1
        {
            bound = GLRect(p1: point.position.xy,p2: point.position.xy)
        }
        expandBound(point.position)
    }
    func expandBound(_ position:Vec4)
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
    
}
extension Sequence where Iterator.Element == PaintStroke
{
    var tojson:String{
        get{
            return "[" + self.map {$0.pointData.jsonArray}.joined(separator: ",") + "]"
        }
    }
}
