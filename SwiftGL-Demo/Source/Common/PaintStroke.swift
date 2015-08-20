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
        for var i = 0; i < pointData.count ;i++
        {
            points.append(genPaintPoint(pointData[i].position, velocity: pointData[i].velocity))
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
    func addPoint(point:PaintPoint,time:CFAbsoluteTime,vel:Vec2)
    {
        points+=[point]
        pointData.append(PointData(p: point.position.xy,t: time,v: vel))
    }
    
    func draw()
    {
        //genPointsFromPointData()
        drawBetween(0, endIndex: pointData.count)
    }
    func drawBetween(startIndex:Int,endIndex:Int)
    {
        
        for var i = startIndex; i<endIndex-2; i++
        {
            
            Painter.renderLine(valueInfo,prev2: points[i],prev1: points[i+1],cur: points[i+2])
        }
        //
    }
    func setBrush()
    {
        
    }
}