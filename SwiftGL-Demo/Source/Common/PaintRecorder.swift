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
import GLFramework
import StrokeAnalysis
/**
    record the given input data and save into PaintArtwork
*/
class PaintRecorder {
    var stroke:PaintStroke!
    fileprivate var recordClip:PaintClip!
    let strokeDiagnoser:RealTimeStrokeDiagnoser = RealTimeStrokeDiagnoser.instance
    //var artwork:PaintArtwork!
    /**
    * 
        When touch begin and stroke started, send in the location, velocity and current time
        
    
    */
    var soundGenerator = SoundGenerator()
    weak var context:GLContextBuffer!
    init(canvas:GLContextBuffer)
    {
        self.context = canvas
        strokeDiagnoser.forceLabel = PaintViewController.instance.strokeDiagnosisForceLabel
        strokeDiagnoser.altitudeLabel = PaintViewController.instance.strokeDiagnosisAltitudeLabel
    }
    func setRecordClip(_ clip:PaintClip)
    {
        if(recordClip != nil)
        {
            //clip.strokeDelegate = recordClip.strokeDelegate
            recordClip.strokeDelegate = nil
        }
        recordClip = clip
        recordClip.strokeDelegate = PaintViewController.instance
    }
    var strokeStartTime:CFAbsoluteTime = 0
    var strokeEndTime:CFAbsoluteTime = 0
    
    func startPoint(_ sender:UIPanGestureRecognizer,view:PaintView)
    {
        let tool = context.paintToolManager.currentTool
        strokeStartTime = CFAbsoluteTimeGetCurrent()
        stroke = PaintStroke(s: (tool?.sInfo)!, v: (tool?.vInfo)!,startTime: strokeStartTime)
        context.paintToolManager.useCurrentTool()
        stroke.addPoint(genPaintPoint(sender, view: view,context: context), time: 0)
        
    }
    func startPoint(_ touch:UITouch,view:PaintView)
    {
        let tool = context.paintToolManager.currentTool
        strokeStartTime = CFAbsoluteTimeGetCurrent()
        stroke = PaintStroke(s: (tool?.sInfo)!, v: (tool?.vInfo)!,startTime: strokeStartTime)
        context.paintToolManager.useCurrentTool()
        var point = genPaintPoint(touch, view: view,context: context)
        //FAKE
        point?.force = 0
        point?.altitude = 0
        //stroke.addPoint(point!, time: 0)
//        soundGenerator.start()
        
    }
    var isTemp:Bool = false
    var tempLastPoint:PaintPoint!
    
    func _movePoint(_ point:PaintPoint)
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
                //soundGenerator.play(point: newPoint)
            }
            tempLastPoint = newPoint
        }

    }
    
    func movePoint(_ sender:UIPanGestureRecognizer,view:PaintView)
    {
        let newPoint = genPaintPoint(sender,view: view,context: context)
        _movePoint(newPoint)
    }
    func movePoints(_ touches:[UITouch],view:PaintView)
    {
        let time = CFAbsoluteTimeGetCurrent()
        var points:[PaintPoint] = []
        
        var lastPoint = stroke.last()
        if(lastPoint != nil)
        {
            points.append(lastPoint!)
        }
        for touch in touches
        {
            let newPoint = genPaintPoint(touch,view: view,context: context)
            
            //if ((newPoint?.position)!-(lastPoint?.position)!).length2>10
            //{
                //DLog("\(time - strokeStartTime)")
                print("\(touch.force) \(touch.maximumPossibleForce)")
            
                if(abs(touch.force - 0.333333) < 0.00001)
                {
                        return
                }
            
                points.append(newPoint!)
                strokeDiagnoser.newPoint(point: newPoint!)
                stroke.addPoint(newPoint!, time: time - strokeStartTime)
                lastPoint = newPoint
            //}
            //soundGenerator.play(point: newPoint!)
        }
        //PaintToolManager.instance.useCurrentTool()
        if(!points.isEmpty){
            context.renderStaticLine(points)
        }
    }
    func movePoint(_ touch:UITouch,view:PaintView)
    {
        let newPoint = genPaintPoint(touch,view: view,context: context)
        _movePoint(newPoint!)
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
            if stroke.points.count == 0
            {return nil}
            
            let oldStroke = stroke
            strokeEndTime = time
            recordClip.cleanRedos()
            recordClip.currentTime += strokeEndTime - strokeStartTime
            context.endStroke()
            if recordClip.strokes.count == 0
            {
                strokeDiagnoser.refStroke = stroke
            }
            recordClip.addPaintStroke(stroke)
            
            context.checkCache(recordClip.strokes.count)
            stroke = nil
            //soundGenerator.stop()
            return oldStroke
            //PaintView.display()
        }
        return nil
    }
    deinit {
        print("deinit")
    }
    
    
}

func genPaintPoint(_ sender:UIPanGestureRecognizer,view:PaintView,context:GLContextBuffer)->PaintPoint
{
    var location = sender.location(in: view)
    //location.x -= context.currentCanvasShiftX
    location.y = CGFloat(view.bounds.height) - location.y
    let dis = sender.translation(in: view)
    
    //print(Vec2(point: dis).length)
    
    return PaintPoint(position: Vec4(point: location)*Float(view.contentScaleFactor)-Vec4(context.canvasShiftX,0,0,0), force:Float(1), altitude: Float(M_PI_2), azimuth: normalize(Vec2(1,0)),velocity: Vec2(point: dis))
}
func genPaintPoint(_ touch:UITouch,view:PaintView,context:GLContextBuffer)->PaintPoint!
{
    var location:CGPoint

    let previousLocation = touch.previousLocation(in: view)
    var force:CGFloat = 1
    var altitude:CGFloat = CGFloat(M_PI_2)
    var azimuth:CGVector = CGVector.zero
    
    if #available(iOS 9.1, *) {
        if touch.type == UITouchType.stylus{
            location = touch.preciseLocation(in: view)
            let dir = CGPoint(x: location.x - previousLocation.x, y: location.y - previousLocation.y)
            force = touch.force/touch.maximumPossibleForce
            
            altitude = touch.altitudeAngle
            azimuth = touch.azimuthUnitVector(in: view)
            //context.azimuth = Vec4(Float(azimuth.dx),Float(-azimuth.dy),0,0)
            location.y = CGFloat(view.bounds.height) - location.y
            
            //DLog("Azimuth: \(azimuth)")
            //DLog("altitude: \(altitude)")
            
            return PaintPoint(position: Vec4(point: location)*Float(view.contentScaleFactor)-Vec4(context.canvasShiftX,0,0,0), force:Float(force), altitude: Float(altitude), azimuth: normalize(Vec2(cgVector:azimuth)),velocity: Vec2(point: dir))
        }
    }
    return nil
    

    
    
    //DLog("\(Vec4(point: location)*Float(view.contentScaleFactor)) scale\(view.contentScaleFactor)")
}
