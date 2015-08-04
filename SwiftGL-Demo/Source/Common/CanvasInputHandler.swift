//
//  CanvasInput.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/21.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import Foundation
import GLKit
import SwiftGL
class CanvasInputHandler{
    /*
    var track:PaintTrack!
    init()
    {
        
    }
    func genPaintPoint(location:CGPoint,velocity:CGPoint)->PaintPoint
    {
        let vel = CGPointToVec2(velocity).length
        var size = vel / 166;
        size = clamp(size, 2,5);
        size = 40/size

        return PaintPoint(position: CGPointToVec4(location),color: Color(1,1,1,1).vec,size: size)
    }
    func touchBegin(location:CGPoint,time:Double,velocity:CGPoint)
    {
        let newPoint = genPaintPoint(location, velocity: velocity)
        track = PaintTrack()    //start to record the track
        
        track.begin(newPoint, time: CFAbsoluteTimeGetCurrent())
    }
    func touchMoved(location:CGPoint,time:Double,velocity:CGPoint)
    {
        let newPoint = genPaintPoint(location, velocity: velocity)
        
        track.move(newPoint,time: time)
        

        var points = track.lastThree()
        if(!points.isEmpty){
            Painter.renderLine(points[0],prev1: points[1],cur: points[2])
            GLContextBuffer.display()
        }
    
    }
    var p_last:Vec2 = Vec2(0,0)
    func touchEnded()
    {
        /*
        last_pos = nil
        canvasData.addTrack(paintingTrack)
        progressSlider.value = 1
        */
        PaintArtwork.addPaintTrack(track)
    }
    func CGPointToVec4(p:CGPoint)->Vec4
    {
        return Vec4(x:Float(p.x),y: Float(p.y))
    }
    
    func CGPointToVec2(p:CGPoint)->Vec2
    {
        return Vec2(x:Float(p.x),y: Float(p.y))
    }
*/
}