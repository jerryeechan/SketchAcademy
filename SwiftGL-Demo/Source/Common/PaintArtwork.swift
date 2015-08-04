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
    var allPoints:[PaintPoint] = []
    var allTimeStamps:[Double]=[]
    var isEndPoint:[Bool] = []
    var playbackTimer:NSTimer!
    
    var isFileExist:Bool = false
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
    func addPaintStroke(track:PaintStroke)
    {
     //   trackEndIndex.append(track.points.count)
        print("PaintArtwork: add track")
        strokes.append(track)
        
        allPoints += track.points
        //allTimeStamps += track.timestamps
        
        for var i=0;i<track.points.count;i++
        {
            isEndPoint.append(false)
        }
        
        isEndPoint[isEndPoint.count - 1] = true
        
    }
    static func addPaintStroke(track:PaintStroke)
    {
        PaintArtwork.instance.addPaintStroke(track)
    }
    
    
    func undo()
    {
        
    }
    func replayAll()
    {
        PaintReplayer.instance.replayAll(self)
    }
    
    var currentPointID:Int = 0
    
    func drawAll()
    {
        for var i=0 ;i < strokes.count ;i++
        {
            strokes[i].draw()
        }
        
        GLContextBuffer.instance.display()
        
    }
    /*
    func drawProgress(startIndex:Int,endIndex:Int)->Bool
    {
        if startIndex+2 < endIndex {
            for var i = startIndex+2 ;i < endIndex ;i++ {
                println("PaintArtwork:render progress")
                Painter.renderLine(,allPoints[i-2], prev1: allPoints[i-1], cur: allPoints[i])
                if isEndPoint[i] == true{
                    i+=3
                }
            }
            return true
        }
        return false
    }

    func drawProgress(startPercentage:Float, endPercentage:Float)->Bool
    {
        //between 0~1
        return drawProgress(Int(startPercentage*Float(allPoints.count)), endIndex: Int(endPercentage*Float(allPoints.count)))
    }*/
    
    
}