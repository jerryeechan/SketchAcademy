//
//  PaintArtwork.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/21.
//  Copyright (c) 2015年 Jerry Chan. All rights reserved.
//

import Foundation
class PaintArtwork
{
    var strokes:[PaintStroke] = []
    //var allPoints:[PaintPoint] = []

    var isEndPoint:[Bool] = []
    var pointsValueInfo:[ToolValueInfo] = []
    var playbackTimer:NSTimer!
    
    var isFileExist:Bool = false
    
    var notes:[Note] = []
    class var instance:PaintArtwork{
        
        struct Singleton {
            static let instance = PaintArtwork()
        }
        return Singleton.instance
    }

    init()
    {
        playbackTimer = NSTimer()
    }
    deinit
    {
        playbackTimer = nil        
    }
    
    var currentTime:CFAbsoluteTime = 0
    func addPaintStroke(stroke:PaintStroke)
    {
        currentTime = (stroke.pointData.last?.timestamps)!
        strokes.append(stroke)
        
      //  allPoints += stroke.points
        //allTimeStamps += track.timestamps
        
        //only the first one is true
        
        for var i=1;i<stroke.points.count;i++
        {
            isEndPoint.append(false)
            pointsValueInfo.append(stroke.valueInfo)
        }
        isEndPoint.append(true)
        pointsValueInfo.append(stroke.valueInfo)
        
    }
    func undo()
    {
        strokes.removeLast()
    }
    var currentPointID:Int = 0
    
    
    var current_vInfo:ToolValueInfo!
    /*
    func drawProgress(startIndex:Int,endIndex:Int)->Bool
    {
        
        if startIndex+2 < endIndex {
            for var i = startIndex+2 ;i < endIndex ;i++ {
                Painter.renderLine(pointsValueInfo[i-2],prev2:allPoints[i-2], prev1: allPoints[i-1], cur: allPoints[i])
                if isEndPoint[i] == true{
                    i+=3
                }
            }
            
            print("index:\(startIndex) \(endIndex)")
            GLContextBuffer.instance.display()
            return true
        }
        return false
    }
    */
    /*
    func drawStrokeProgress(startIndex:Int,endIndex:Int)->Bool
    {
        
        if startIndex < endIndex
        {
            for i in startIndex...endIndex-1
            {
                Painter.renderStroke(strokes[i])
            }
            GLContextBuffer.instance.display()
            return true
        }
        return false
    }
    func drawProgress(startPercentage:Float, endPercentage:Float)->Bool
    {
       // print("allPoints:\(allPoints.count)")
        //between 0~1
        return drawStrokeProgress(Int(startPercentage*Float(strokes.count)), endIndex: Int(endPercentage*Float(strokes.count)))
        //return drawProgress(Int(startPercentage*Float(allPoints.count)), endIndex: Int(endPercentage*Float(allPoints.count)))
    }
    */
    
}