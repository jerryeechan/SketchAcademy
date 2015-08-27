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
    private var strokes:[PaintStroke]!
    private var artwork:PaintArtwork!
    var playingArtwork:PaintArtwork
        {
        set(newVal) {
            artwork = newVal
            strokes = artwork.strokes
        }
        get{
            return artwork
        }
    }
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
    //---------------------------------------------------------------------
    /*
    *
    *
    *   replay with timer
    *
    *
    */
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
    
    func startReplay(artwork:PaintArtwork)
    {
        playingArtwork = artwork
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
            while timeCounter >= (c_PointData[currentPointID].timestamps)
            {
               // print("timestamps: \(c_PointData[currentPointID].timestamps - firstTimeStamps)")
               
                if currentPointID >= 2
                {
                    let i = currentPointID                    
                    draw(strokes[currentStrokeID], p1: currentPoints[i-2], p2: currentPoints[i-1], p3: currentPoints[i])
                    artwork.currentTime = (strokes[currentStrokeID].pointData[currentPointID].timestamps)
                }
                
                playingArtwork.currentTime = strokes[currentStrokeID].pointData[currentPointID].timestamps
                
                if nextPoint() == false
                {
                    
                    playbackTimer.invalidate()
                    break
                }
            }
            GLContextBuffer.instance.display()
            timeCounter += (playbackTimer.timeInterval*timeScale)
           // print("replayer: \(playbackTimer.timeInterval*timeScale) \(playbackTimer.timeInterval)")
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
        
        //print(strokes[currentStrokeID].valueInfo.color)
        PaintToolManager.instance.loadToolValueInfo(strokes[currentStrokeID].valueInfo)
        
        
        c_PointData = strokes[currentStrokeID].pointData
        currentPoints = strokes[currentStrokeID].points
        
        return true
    }
    private func draw(stroke:PaintStroke,p1:PaintPoint,p2:PaintPoint,p3:PaintPoint)
    {
        
        //Painter.renderLine(PaintToolManager.instance.currentTool.vInfo, prev2: p1,prev1: p2,cur: p3)
        
        // draw the recorded data
        Painter.renderLine(stroke.valueInfo, prev2: p1,prev1: p2,cur: p3)
    }
 //---------------------------------------------------------------------
    /*
    *
    *
    *   direct draw
    *
    *
    */
    
    func drawStrokeProgress(artwork:PaintArtwork,index:Int)->Bool
    {
        var startIndex = 0
        let endIndex = index
        if startIndex == last_startIndex && endIndex == last_endIndex
        {
            return false
        }
        if index > last_stroke_index
        {
            startIndex = last_stroke_index
        }
        else
        {
            GLContextBuffer.instance.blank()
        }
        
        
        
        
        if startIndex < endIndex
        {
            for i in startIndex...endIndex-1
            {
                Painter.renderStroke(strokes[i])
            }
            
            artwork.currentTime = (strokes[endIndex-1].pointData.last?.timestamps)!
            GLContextBuffer.instance.display()
            last_startIndex = startIndex
            last_endIndex = endIndex
            last_stroke_index = index
            return true
        }
        return false
    }
    
    var last_startIndex:Int = 0
    var last_endIndex:Int = 0
    var last_stroke_index:Int = 0
    
    func drawProgress(artwork:PaintArtwork,percentage:Float)->Bool
    {
        playingArtwork = artwork
        //between 0~1
        return drawStrokeProgress(artwork,index: Int(percentage*Float(strokes.count)))
        //return drawProgress(Int(startPercentage*Float(allPoints.count)), endIndex: Int(endPercentage*Float(allPoints.count)))
    }
    
    
    
    func drawAll(artwork:PaintArtwork)
    {
        playingArtwork = artwork
        
        let start = CFAbsoluteTimeGetCurrent()
        for var i=0 ;i < strokes.count ;i++
        {
            Painter.renderStroke(strokes[i])
        }
        
        GLContextBuffer.instance.display()
        let end = CFAbsoluteTimeGetCurrent()
        print("loading time spent\(end-start)")
        artwork.currentTime = (strokes.last?.pointData.last?.timestamps)!
    }
    
}