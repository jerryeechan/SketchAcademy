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
    private var strokes:[PaintStroke]!
    //private var artwork:PaintArtwork!
    private var paintClip:PaintClip!
    var playbackTimer:NSTimer!
    var revisionTimer:NSTimer!
    
    func strokeCount()->Int
    {
        return strokes.count
    }
   /* --
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
    */
    class var instance:PaintReplayer{
        struct Singleton {
            static let instance = PaintReplayer()
        }
        return Singleton.instance
    }
    
    
    var progressSlider:UISlider!
   
    func loadClip(clip:PaintClip)
    {
        //--playingArtwork = artwork
        paintClip = clip
        self.strokes = clip.strokes
    }
    /*--
    func reloadArtwork()
    {
        playingArtwork = PaintRecorder.instance.artwork
        self.strokes = playingArtwork.strokes        
    }
*/
    
    var isTimerValid:Bool = false
    var isPlaying:Bool = false
    
    /**
        is the progress have been changed
     */
    var isDrawProgressed:Bool = false
    
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
        playbackTimer.fireDate = NSDate.distantFuture()
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
            print("resume stroke_index:\(currentStrokeID)")
            if isDrawProgressed
            {
                currentPointID = 0
                c_PointData = strokes[currentStrokeID].pointData
                
                isDrawProgressed = false
            }
            isPlaying = true
            timeCounter = c_PointData[0].timestamps
            playbackTimer.fireDate = NSDate()
        }
        
    }
    func restart()
    {
        GLContextBuffer.instance.blank()
        stopPlay()
        print("PaintReplayer: start replay")
        startReplay()
    }
    func stopPlay()
    {
        if playbackTimer != nil
        {
            playbackTimer.invalidate()
        }
        
    }
    
    func startReplay()
    {
        //replay from first stroke
        startReplayAtStroke(0)

    }
    func startReplayAtCurrentStroke()
    {
        startReplayAtStroke(currentStrokeID)
    }
    func startReplayAtStroke(strokeID:Int)
    {
        playbackTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("timerUpdate"), userInfo: nil, repeats: true)
        isTimerValid = true
        setReplayData(strokeID)
        isPlaying = true
        progressSlider.value = Float(strokeID)/Float(strokes.count)
    }
    func setReplayData(strokeID:Int)
    {
        currentStrokeID = strokeID
        currentPointID = 0
        currentPoints = strokes[strokeID].points
        c_PointData = strokes[strokeID].pointData
        
        firstTimeStamps = c_PointData[0].timestamps
        timeCounter = c_PointData[0].timestamps
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
            //print("timecounter \(timeCounter)")
            while timeCounter >= (c_PointData[currentPointID].timestamps)
            {
               // print("timestamps: \(c_PointData[currentPointID].timestamps - firstTimeStamps)")
                if currentPointID >= c_PointData.count
                {
                    testNextPoint()
                }
                
                if currentPointID >= 2
                {
                    let i = currentPointID                    
                    draw(strokes[currentStrokeID], p1: currentPoints[i-2], p2: currentPoints[i-1], p3: currentPoints[i])
                }
                
                paintClip.currentTime = strokes[currentStrokeID].pointData[currentPointID].timestamps
                
                if testNextPoint() == false
                {
                    break
                }
                
            }
            GLContextBuffer.instance.display()
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
        progressSlider.value = Float(currentStrokeID)/Float(strokes.count)
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
    *
    */
    
    func drawStrokeProgress(index:Int)->Bool
    {
        if isPlaying
        {
            pause()
        }

        //print("draw progress to index:\(index)");
        var startIndex = 0
        let endIndex = index
        if index == 0
        {
            GLContextBuffer.instance.blank()
            GLContextBuffer.instance.display()
            currentStrokeID = 0
            last_startIndex = 0
            last_endIndex = 0
            //--playingArtwork.currentTime = 0
            isDrawProgressed = true
            return true
        }
        if startIndex == last_startIndex && endIndex == last_endIndex
        {
            return false
        }
        if index >= currentStrokeID
        {
            startIndex = currentStrokeID
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
            
            paintClip.currentTime = (strokes[endIndex-1].pointData.last?.timestamps)!
            GLContextBuffer.instance.display()
            last_startIndex = startIndex
            last_endIndex = endIndex
            
            currentPointID = 0
            currentStrokeID = endIndex
            print("current_stroke index:\(currentStrokeID)")
            isDrawProgressed = true
            return true
        }
        return false
    }
    
    var last_startIndex:Int = 0
    var last_endIndex:Int = 0

    
    func drawProgress(percentage:Float)->Bool
    {
        //between 0~1
        
        return drawStrokeProgress(Int(percentage*Float(strokes.count)))
    }
    
    
    
    func drawAll()
    {
        let start = CFAbsoluteTimeGetCurrent()
        for var i=0 ;i < strokes.count ;i++
        {
            Painter.renderStroke(strokes[i])
        }
        currentStrokeID = strokes.count-1
        
        GLContextBuffer.instance.display()
        let end = CFAbsoluteTimeGetCurrent()
        print("loading time spent\(end-start)")
        paintClip.currentTime = (strokes.last?.pointData.last?.timestamps)!
        progressSlider.value = 1
    }
    
}