//
//  PaintReplayer.swift
//  SwiftGL
//
//  Created by jerry on 2015/6/5.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import Foundation
class PaintReplayer:NSObject
{
    var strokes:[PaintStroke]!
    var playbackTimer:NSTimer!
    
    class var instance:PaintReplayer{
        struct Singleton {
            static let instance = PaintReplayer()
        }
        return Singleton.instance
    }
    
    override init()
    {
        
    }
    func doublePlayBackSpeed()
    {
        timeScale *= 2
        if timeScale > 8
        {
            timeScale = 1
        }
    }
    func changePlayBackSpeed(scale:Double)
    {
        timeScale = scale;
        if timeScale < 0.1
        {
            timeScale = 0.1
        }
        else if timeScale > 10
        {
            timeScale = 10
        }
    }
    var isPlaying:Bool = false
    func pauseToggle()
    {
        isPlaying = !isPlaying
    }
    func resume()
    {
        isPlaying = true
    }
    func restart()
    {
        GLContextBuffer.instance.blank()
        stopPlay()
        print("PaintReplayer: start replay")
        playbackTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("timerUpdate"), userInfo: nil, repeats: true)
        
        currentStrokeID = 0
        currentPointID = 0
        currentPoints = strokes[0].points
        c_PointData = strokes[0].pointData
        firstTimeStamps = c_PointData[0].timestamps
        timeCounter = 0
        
        isPlaying = true
    }
    func stopPlay()
    {
        if playbackTimer != nil
        {
            playbackTimer.invalidate()
        }
        
    }
    
    func replayAll(artwork:PaintArtwork)
    {
        
        self.strokes = artwork.strokes
        print("PaintReplayer: start replay")
        playbackTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("timerUpdate"), userInfo: nil, repeats: true)
        
        currentStrokeID = 0
        currentPointID = 0
        currentPoints = strokes[0].points
        c_PointData = strokes[0].pointData
        firstTimeStamps = c_PointData[0].timestamps
        timeCounter = 0
        
        isPlaying = true
    }
    var currentStrokeID:Int = 0
    var currentPointID:Int = 0
    var currentPoints:[PaintPoint]!
    var c_PointData:[PointData]!
    var timeCounter:Double = 0
    var firstTimeStamps:CFAbsoluteTime = 0
    
    var timeScale:Double = 1
    
    func timerUpdate()
    {
        if isPlaying
        {
            //println("paintreplayer  time: \(timeCounter) \(c_PointData[currentPointID].timestamps - firstTimeStamps)")
            print("timecounter \(timeCounter)")
            while timeCounter >= (c_PointData[currentPointID].timestamps - firstTimeStamps)
            {
                print("timestamps: \(c_PointData[currentPointID].timestamps - firstTimeStamps)")
               // println("paintreplayer draw next")
                if currentPointID >= 2
                {
                    let i = currentPointID                    
                    draw(strokes[currentStrokeID], p1: currentPoints[i-2], p2: currentPoints[i-1], p3: currentPoints[i])
                }
                
                if nextPoint() == false
                {
                    playbackTimer.invalidate()
                    break
                }
            }
            GLContextBuffer.instance.display()
            timeCounter += (playbackTimer.timeInterval*timeScale)
            print("replayer: \(playbackTimer.timeInterval*timeScale) \(playbackTimer.timeInterval)")
        }
    }
    func nextPoint()->Bool
    {
        currentPointID++
        if currentPointID == c_PointData.count{
            GLContextBuffer.instance.endStroke()
            return nextStroke()
        }
        return true
    }
    func nextStroke()->Bool
    {
        currentPointID = 0
        currentStrokeID++
        if(currentStrokeID == strokes.count)
        {
            return false
        }
        PaintToolManager.instance.changeTool(strokes[currentStrokeID].stringInfo.toolName)
        
        print(strokes[currentStrokeID].valueInfo.color)
        PaintToolManager.instance.loadToolValueInfo(strokes[currentStrokeID].valueInfo)
        
        
        c_PointData = strokes[currentStrokeID].pointData
        currentPoints = strokes[currentStrokeID].points
        
        return true
    }
    func draw(stroke:PaintStroke,p1:PaintPoint,p2:PaintPoint,p3:PaintPoint)
    {
        
        //Painter.renderLine(PaintToolManager.instance.currentTool.vInfo, prev2: p1,prev1: p2,cur: p3)
        print(stroke.valueInfo.color)
        Painter.renderLine(stroke.valueInfo, prev2: p1,prev1: p2,cur: p3)
    }
}