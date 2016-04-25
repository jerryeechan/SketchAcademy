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

struct StrokeInfo{
    var timeAfterLast:Double
}
class PaintStroke
{
    var rect:GLRect = GLRect(p1: Vec2(0,0), p2: Vec2(0,0))
    var points:[PaintPoint] = []
    //var position:[Vec2]=[]
    //var timestamps:[CFTimeInterval]=[]
    //var velocities:[Vec2] = []
    var pointData:[PointData]=[]
    
    var startTime:Double!
    var texture:Texture!
    var valueInfo:ToolValueInfo
    var stringInfo:ToolStringInfo
    var strokeInfo:StrokeInfo!
    
    init(tool:PaintBrush)   //use when recording
    {
        stringInfo = tool.sInfo
        valueInfo = tool.vInfo
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
    func addPoint(point:PaintPoint,time:CFAbsoluteTime)
    {
        points+=[point]
        pointData.append(PointData(paintPoint: point,t: time))
        expandBound(point.position)
    }
    func expandBound(position:Vec4)
    {
        if position.x < rect.leftTop.x
        {
            rect.leftTop.x = position.x
        }
        if position.y < rect.leftTop.y
        {
            rect.leftTop.y = position.y
        }
        if position.x > rect.rightButtom.x
        {
            rect.rightButtom.x = position.x
        }
        if position.y > rect.rightButtom.y
        {
            rect.rightButtom.y = position.y
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