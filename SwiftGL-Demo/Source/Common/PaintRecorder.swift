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

/**
    record the given input data and save into PaintArtwork
*/
class PaintRecorder {
    var stroke:PaintStroke!
    private var recordClip:PaintClip!
    //var artwork:PaintArtwork!
    /**
    * 
        When touch begin and stroke started, send in the location, velocity and current time
        
    
    */
    weak var context:GLContextBuffer!
    init(canvas:GLContextBuffer)
    {
        self.context = canvas
    }
    func setRecordClip(clip:PaintClip)
    {
        recordClip = clip
    }
    var strokeStartTime:CFAbsoluteTime = 0
    var strokeEndTime:CFAbsoluteTime = 0
    
    func startPoint(sender:UIPanGestureRecognizer,view:PaintView)
    {
        
        stroke = PaintStroke(tool: context.paintToolManager.currentTool)
        context.paintToolManager.useCurrentTool()
        stroke.addPoint(genPaintPoint(sender, view: view,context: context), time: 0)
        strokeStartTime = CFAbsoluteTimeGetCurrent()
    }
    func startPoint(touch:UITouch,view:PaintView)
    {
        stroke = PaintStroke(tool: context.paintToolManager.currentTool)
        context.paintToolManager.useCurrentTool()
        
        stroke.addPoint(genPaintPoint(touch, view: view,context: context), time: 0)
        strokeStartTime = CFAbsoluteTimeGetCurrent()
    }
    var isTemp:Bool = false
    var tempLastPoint:PaintPoint!
    
    func _movePoint(point:PaintPoint)
    {
        let time = CFAbsoluteTimeGetCurrent()
        if stroke != nil
        {
            context.paintToolManager.useCurrentTool()
            let lastPoint = stroke.last()!
            let newPoint = point
            
            /* if the distance of points more than stroke texture size...
            ??
            */
            if (newPoint.position-lastPoint.position).length2>1
            {
                //the time is offset by the begining of the touch
                if(!isTemp)
                {
                    stroke.addPoint(newPoint, time: time - strokeStartTime)
                }
                //var points = stroke.lastThree()
                let points = [lastPoint,newPoint]
                if(!points.isEmpty){
                    context.renderStaticLine(points)
                }
                
            }
            tempLastPoint = newPoint
        }

    }
    
    func movePoint(sender:UIPanGestureRecognizer,view:PaintView)
    {
        let newPoint = genPaintPoint(sender,view: view,context: context)
        _movePoint(newPoint)
    }
    func movePoints(touches:[UITouch],view:PaintView)
    {
        let time = CFAbsoluteTimeGetCurrent()
        var points:[PaintPoint] = []
        var lastPoint = stroke.last()
        points.append(lastPoint)
        for touch in touches
        {
            let newPoint = genPaintPoint(touch,view: view,context: context)
            if (newPoint.position-lastPoint.position).length2>10
            {
                //DLog("\(time - strokeStartTime)")
                points.append(newPoint)
                stroke.addPoint(newPoint, time: time - strokeStartTime)
                lastPoint = newPoint
            }
        }
        //PaintToolManager.instance.useCurrentTool()
        if(!points.isEmpty){
            context.renderStaticLine(points)
        }
    }
    func movePoint(touch:UITouch,view:PaintView)
    {
        let newPoint = genPaintPoint(touch,view: view,context: context)
        _movePoint(newPoint)
    }
    
    func disruptFingerStroke()
    {
        stroke = nil
        
        context.cleanTemp()
    }
    
    func endStroke()->PaintStroke!
    {
        let time = CFAbsoluteTimeGetCurrent()
        if stroke != nil
        {
            let oldStroke = stroke
            strokeEndTime = time
            recordClip.cleanRedos()
            recordClip.currentTime += strokeEndTime - strokeStartTime
            context.endStroke()
            recordClip.addPaintStroke(stroke)
            context.checkCache(recordClip.strokes.count)
            stroke = nil
            return oldStroke
            //PaintView.display()
        }
        return nil
    }
    
    
}

func genPaintPoint(sender:UIPanGestureRecognizer,view:PaintView,context:GLContextBuffer)->PaintPoint
{
    var location = sender.locationInView(view)
    //location.x -= context.currentCanvasShiftX
    location.y = CGFloat(view.bounds.height) - location.y
    let dis = sender.translationInView(view)
    
    //print(Vec2(point: dis).length)
    
    return PaintPoint(position: Vec4(point: location)*Float(view.contentScaleFactor)-Vec4(context.canvasShiftX,0,0,0), force:Float(1), altitude: Float(M_PI_2), azimuth: normalize(Vec2(1,0)),velocity: Vec2(point: dis))
}
func genPaintPoint(touch:UITouch,view:PaintView,context:GLContextBuffer)->PaintPoint!
{
    var location:CGPoint

    let previousLocation = touch.previousLocationInView(view)
    var force:CGFloat = 1
    var altitude:CGFloat = CGFloat(M_PI_2)
    var azimuth:CGVector = CGVector.zero
    
    if #available(iOS 9.1, *) {
        if touch.type == UITouchType.Stylus{
            location = touch.preciseLocationInView(view)
            let dir = CGPoint(x: location.x - previousLocation.x, y: location.y - previousLocation.y)
            force = touch.force/touch.maximumPossibleForce
            altitude = touch.altitudeAngle
            azimuth = touch.azimuthUnitVectorInView(view)
            location.y = CGFloat(view.bounds.height) - location.y
            //print(Vec2(point: dir).length)
            //DLog("Azimuth: \(azimuth)")
            //DLog("altitude: \(altitude)")
            return PaintPoint(position: Vec4(point: location)*Float(view.contentScaleFactor)-Vec4(context.canvasShiftX,0,0,0), force:Float(force), altitude: Float(altitude), azimuth: normalize(Vec2(cgVector:azimuth)),velocity: Vec2(point: dir))

        }
    }
    return nil
    

    
    
    //DLog("\(Vec4(point: location)*Float(view.contentScaleFactor)) scale\(view.contentScaleFactor)")
}
