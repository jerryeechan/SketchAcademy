//
//  PaintRecorder.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/31.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import SwiftGL
import Darwin
import Foundation
import UIKit
class PaintRecorder {
    class var instance:PaintRecorder{
        struct Singleton {
            static let instance = PaintRecorder()
        }
        return Singleton.instance
    }
    var stroke:PaintStroke!
    var artwork:PaintArtwork!
    
    init()
    {
        newArtwork()
    }
    func newArtwork()
    {
        artwork = PaintArtwork()
    }
    func clear()
    {
        PaintReplayer.instance.stopPlay()
        GLContextBuffer.instance.blank()
        GLContextBuffer.instance.display()
        artwork = nil
        artwork = PaintArtwork()
        artwork.currentTime = 0
    }
    
    func loadArtwork(filename:String)->Bool
    {
        clear()
        GLContextBuffer.instance.blank()
        GLContextBuffer.instance.display()
        //call filemanager to load the file to PaintArtwork
        artwork = FileManager.instance.loadPaintArtWork(filename)
        NoteManager.instance.loadNotes(filename)
        
        if(artwork != nil)
        {
            //paint the process by Painter
            PaintReplayer.instance.loadArtwork(artwork)
            PaintReplayer.instance.startReplay()
            
            //PaintReplayer.instance.drawAll(artwork)
            
            return true
        }
        else
        {
            return false
        }
        
    }
    
    func saveArtwork(filename:String,img:UIImage)
    {
        
        //call filemanager to  save the current PaintArtwork with name
        FileManager.instance.savePaintArtWork(filename, artwork: artwork, img: img, noteList:NoteManager.instance.getNotes())
        
    }
    
    /**
    * 
        When touch begin and stroke started, send in the location, velocity and current time
        
    
    */
    var strokeStartTime:CFAbsoluteTime = 0
    var strokeEndTime:CFAbsoluteTime = 0
    
    func startPoint(location:Vec2,velocity:Vec2,time:CFAbsoluteTime)
    {
        stroke = PaintStroke(tool: PaintToolManager.instance.currentTool)
        
        stroke.addPoint(genPaintPoint(location, velocity: velocity), time: artwork.currentTime,vel: velocity)
        
        strokeStartTime = time
        //stroke.addPoint(genPaintPoint(location, velocity: velocity), time: time,vel: velocity)
    }
    func movePoint(location:Vec2,velocity:Vec2,time:CFAbsoluteTime)
    {
        if stroke != nil
        {
            let lastPoint = stroke.last()
            
            let newPoint = genPaintPoint(location, velocity:velocity)
            
            if lastPoint != nil
            {
                /* if the distance of points more than stroke texture size...
                ??
                */
                if (newPoint.position-lastPoint.position).length2>3
                {
                    //the time is offset by the begining of the touch
                    stroke.addPoint(newPoint, time: artwork.currentTime + time - strokeStartTime,vel: velocity)
                    
                    
                    var points = stroke.lastThree()
                    if(!points.isEmpty){
                        Painter.renderLine(stroke.valueInfo, prev2: points[0],prev1: points[1],cur: points[2])
                        GLContextBuffer.instance.display()
                    }
                }
            }
            else
            {
                stroke.addPoint(newPoint, time: time,vel: velocity)
            }
            
        }
        
    }
    func endStroke(time:CFAbsoluteTime)
    {
        if stroke != nil
        {
            strokeEndTime = time
            artwork.currentTime += strokeEndTime - strokeStartTime
            
            GLContextBuffer.instance.endStroke()
            //GLContextBuffer.instance.drawStroke(stroke)
            artwork.addPaintStroke(stroke)
            stroke = nil
            GLContextBuffer.instance.display()
        }
        
    }
}
func genPaintPoint(location:Vec2,velocity:Vec2)->PaintPoint
{
    let vel = velocity.length
    var size = vel / 166;
    size = clamp(size, min: 2,max: 5);
    size = 40/size

    let randAngle = Float(arc4random() / UINT32_MAX) * Pi
    return PaintPoint(position:Vec4(location.x,location.y),color: Color(1,1,1,1).vec,size: 5, rotation: randAngle)
}