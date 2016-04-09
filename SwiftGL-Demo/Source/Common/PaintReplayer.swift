//
//  PaintReplayer.swift
//  SwiftGL
//
//  Created by jerry on 2015/6/5.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import Foundation
import UIKit
class PaintReplayer:NSObject
{
    //private var strokes:[PaintStroke] = []
    //private var artwork:PaintArtwork!
    private var clip:PaintClip!
    weak var context:GLContextBuffer!
    weak var paintView:PaintView!
    init(paintView:PaintView,context:GLContextBuffer) {
        self.paintView = paintView
        self.context = context
    }
    var playbackTimer:NSTimer!
    
    
    var branchAt:Int = -1//not used yet
    
    var currentClip:PaintClip{
        get{
            return clip
        }
    }
    var currentPointID:Int = 0
    var currentPoints:[PaintPoint]!
    var c_PointData:[PointData]!
    var timeCounter:CFAbsoluteTime = 0
    var firstTimeStamps:CFAbsoluteTime = 0
    
    var timeScale:Double = 1
    var id = 0
    var playProgress:Float = 1
    var doStopAtNote:Bool = false
    /*
    var currentStrokeID:Int = 0
        {
        didSet{
            
            handleProgressValueChanged()
        }
    }
    */

    //XX no need?
    func strokeCount()->Int
    {
        return clip.strokes.count
    }
 
    

   
    func loadClip(clip:PaintClip)
    {
        //--playingArtwork = artwork
        self.clip = clip
        
        if playProgress == 1
        {
            clip.currentStrokeID = clip.strokes.count-1
        }
        
    }
    func cleanRewind()
    {
        let strokes = clip.strokes
        DLog("\(clip.currentStrokeID) \(strokes.count-1)")
        if clip.currentStrokeID <= strokes.count
        {
            clip.strokes.removeRange(clip.currentStrokeID...strokes.count-1)
        }
    }
    
    var isTimerValid:Bool = false
    var isPlaying:Bool = false
    
    /**
        is the progress have been changed
     */
    var isProgressChanged:Bool = false
    
    func pauseToggle()
    {
        
        isPlaying = !isPlaying
        if(isPlaying == true)
        {
            resume()
        }
        else
        {
            pause()
        }
        
    }
    func pause()
    {
        if((playbackTimer) != nil)
        {
            playbackTimer.fireDate = NSDate.distantFuture()
        }
        
        isPlaying = false
    }
    func resume()
    {
        if isTimerValid == false
        {
            startReplayAtCurrentStroke()
            
        }
        else
        {
            print("resume stroke_index:\(clip.currentStrokeID)", terminator: "")
            if isProgressChanged
            {
                currentPointID = 0
                c_PointData = clip.strokes[clip.currentStrokeID].pointData
                
                isProgressChanged = false
            }
            isPlaying = true
            timeCounter = c_PointData[0].timestamps
            playbackTimer.fireDate = NSDate()
        }
        
    }
    func restart()
    {
        context.blank()
        paintView.glDraw()
        stopPlay()
        DLog("start replay")
        startReplayAtStroke(0)
    }
    func stopPlay()
    {
        if playbackTimer != nil
        {
            playbackTimer.invalidate()
        }
    }
    
    func startReplayAtCurrentStroke()
    {
        startReplayAtStroke(clip.currentStrokeID)
    }
    func startReplayAtStroke(strokeID:Int)
    {
        if strokeID < clip.strokes.count
        {
            playbackTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(PaintReplayer.timerUpdate), userInfo: nil, repeats: true)
            isTimerValid = true
            setReplayData(strokeID)
            isPlaying = true
        }
    }
    func setReplayData(strokeID:Int)
    {
        let strokes = clip.strokes
        
        clip.currentStrokeID = strokeID
        currentPointID = 0
        currentPoints = strokes[strokeID].points
        c_PointData = strokes[strokeID].pointData
        
        firstTimeStamps = strokes[clip.currentStrokeID].startTime//c_PointData[0].timestamps
        timeCounter = strokes[clip.currentStrokeID].startTime//c_PointData[0].timestamps
    }
    
    func timerUpdate()
    {
        if isPlaying
        {
            let strokes = clip.strokes
            //println("paintreplayer  time: \(timeCounter) \(c_PointData[currentPointID].timestamps - firstTimeStamps)")
            //print("timecounter \(timeCounter)")
            while timeCounter >= (c_PointData[currentPointID].timestamps + firstTimeStamps)
            {
                DLog("timestamps: \(c_PointData[currentPointID].timestamps + firstTimeStamps)")
                if currentPointID >= c_PointData.count
                {
                    testNextPoint()
                }
                
                if currentPointID >= 2
                {
                    let i = currentPointID
                    context.renderStaticLine([currentPoints[i-2],currentPoints[i-1],currentPoints[i]])
                    //draw(strokes[clip.currentStrokeID], p1: currentPoints[i-2], p2: currentPoints[i-1], p3: currentPoints[i])
                }
                
                clip.currentTime = strokes[clip.currentStrokeID].pointData[currentPointID].timestamps
                
                if testNextPoint() == false
                {
                    break
                }
                
            }
            paintView.glDraw()
            timeCounter += (playbackTimer.timeInterval*timeScale)
           // print("replayer: \(playbackTimer.timeInterval*timeScale) \(playbackTimer.timeInterval)")
        }
    }
    
    /**
        To see if there exist next paint point, or stop the playback
     */
    func testNextPoint()->Bool{
        if nextPoint() == false
        {
            playbackTimer.invalidate()
            isTimerValid = false
            return false
        }
        return true
    }
    
    /**
         Get next paint point
         if the stroke has finished then go to next stroke
     */
    func nextPoint()->Bool
    {
        currentPointID += 1
        
        if currentPointID == c_PointData.count{
            //GLContextBuffer.instance.endStroke()
            return nextStroke()
        }
        return true
    }
    func nextStroke()->Bool
    {
        currentPointID = 0
        clip.currentStrokeID += 1
        
        let strokes = clip.strokes
        
        if(clip.currentStrokeID == strokes.count)
        {
            return false
        }
        context.paintToolManager.changeTool(strokes[clip.currentStrokeID].stringInfo.toolName)
        context.paintToolManager.loadToolValueInfo(strokes[clip.currentStrokeID].valueInfo)
                
        c_PointData = strokes[clip.currentStrokeID].pointData
        currentPoints = strokes[clip.currentStrokeID].points
        firstTimeStamps = strokes[clip.currentStrokeID].startTime
        timeCounter = strokes[clip.currentStrokeID].startTime
        return true
    }
    private func draw(stroke:PaintStroke,p1:PaintPoint,p2:PaintPoint,p3:PaintPoint)
    {
        GLShaderBinder.instance.currentBrushShader.bindBrushInfo(stroke.valueInfo)
        context.renderStaticLine([p1,p2,p3])
    }
    
    
    //Play back functions
    //
    //
    //
    //
    
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
    
    
 //---------------------------------------------------------------------
    /*
    *
    *
    *   direct draw
    *
    */
    func drawCurrentStrokeProgress(offset:Int)
    {
        drawStrokeProgress(clip.currentStrokeID+offset)
    }
    
    //0 as blank, 1 as first stroke, stroke.count as all
    func drawStrokeProgress(index:Int)->Bool
    {
        let strokes = clip.strokes
        if isPlaying
        {
            pause()
        }

        //print("draw progress to index:\(index)");
        var startIndex = 0
        let endIndex = index
        // from start blank
        if index == 0
        {
            context.blank()
            //paintView.display()
            clip.currentStrokeID = 0
            last_startIndex = 0
            last_endIndex = 0
            isProgressChanged = true
            handleProgressValueChanged()
            paintView.glDraw()
            return true
        }
        // stroke index did not change
        // don't do anything
        if endIndex == last_endIndex
        {
            return false
        }
        
        //TODO
        //draw closest cache
        
        let cacheIndex = context.paintCanvas.getNearestCacheIndex(endIndex)
        
        if endIndex > clip.currentStrokeID && cacheIndex < clip.currentStrokeID
        {
            startIndex = clip.currentStrokeID
        }
        else if cacheIndex == 0
        {
            context.blank()
            startIndex = 0
        }
        else
        {
            startIndex = cacheIndex
            context.loadCacheFrame(cacheIndex)
            if startIndex == endIndex
            {
                clip.currentTime = (strokes[endIndex-1].pointData.last?.timestamps)!
                last_startIndex = startIndex
                last_endIndex = endIndex
                
                currentPointID = 0
                clip.currentStrokeID = endIndex
                isProgressChanged = true
                paintView.glDraw()
                handleProgressValueChanged()
                return true
            }
        }
        
        //DLog("cache at:\(cacheIndex) current:\(clip.currentStrokeID) start at:\(startIndex) end at:\(endIndex) last_end\(last_endIndex)")

        /*
        if index >= clip.currentStrokeID
        {
            startIndex = clip.currentStrokeID
        }
        else
        {
            
            GLContextBuffer.instance.blank()
        }
        */
        
        if startIndex < endIndex
        {
            
            for i in startIndex...endIndex-1
            {
                context.renderStroke(strokes[i])
            }
            
            clip.currentTime = (strokes[endIndex-1].pointData.last?.timestamps)!
            paintView.glDraw()
            last_startIndex = startIndex
            last_endIndex = endIndex
            
            currentPointID = 0
            clip.currentStrokeID = endIndex
            isProgressChanged = true
            handleProgressValueChanged()
            return true
        }
        else
        {
            last_endIndex = endIndex
            
        }
        return false
    }
    
    var last_startIndex:Int = 0
    var last_endIndex:Int = 0

    
    func drawProgress(percentage:Float)->Bool
    {
        //between 0~1
        //print("drawProgress \(percentage)")
        return drawStrokeProgress(Int(percentage*Float(clip.strokes.count)))
    
    }
    var progress:Float = 0
    func panOnReplayer(disx:CGFloat)
    {
        
    }
    
    func handleProgressValueChanged()
    {
        let value = Float(clip.currentStrokeID+1)/Float(clip.strokes.count)
        playProgress = value
        if let handler = onProgressValueChanged{
            handler(progressValue: value)
        }
    }
    
    func drawAll()
    {
        let strokes = clip.strokes
        context.setReplayDrawSetting()
        context.blank()
        let start = CFAbsoluteTimeGetCurrent()
        for i in 0  ..< strokes.count 
        {
            context.renderStroke(strokes[i])
            context.checkCache(i)
        }
        if(strokes.count>0)
        {
            clip.currentStrokeID = strokes.count-1
            last_endIndex = strokes.count-1
            
            
            let end = CFAbsoluteTimeGetCurrent()
            print("Paint replayer: loading time spent\(end-start)", terminator: "")
            DLog("\(clip.currentStrokeID) \(last_endIndex)")
            clip.currentTime = (strokes.last?.pointData.last?.timestamps)!
        }
        handleProgressValueChanged()
    }
    
    var onProgressValueChanged:((progressValue:Float)->Void)? = nil
    
    func exit()
    {
        if playbackTimer != nil
        {
            playbackTimer.invalidate()
        }
    }
}