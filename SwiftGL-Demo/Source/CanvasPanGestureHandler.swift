//
//  CanvasPanHandler.swift
//  SwiftGL
//
//  Created by jerry on 2015/8/21.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import SwiftGL
import UIKit
enum TwoSwipeState{
    case Unknown
    case FastSwipe
    case Dragging
}

class CanvasPanGestureHandler {
    
    var paintView:PaintView!
    var scrollView:UIScrollView!
    var paintViewController:PaintViewController!
    
    
    init(pvController:PaintViewController)
    {
        self.paintView = pvController.paintView
        scrollView = pvController.scrollView
        paintViewController = pvController
        paintRecorder = paintViewController.paintManager.paintRecorder
    }
    
    var twoTouchSwipeCount:Int = 0;
    
    
    
    var twoSwipeState:TwoSwipeState = .Unknown
    
    var velocity:CGPoint!
    var current_pos:CGPoint!
    var dis:CGPoint!
    func panGestureHandler(sender:UIPanGestureRecognizer)
    {
        
        
        velocity = sender.velocityInView(paintView)
        current_pos = sender.locationInView(paintView)
        current_pos.y = CGFloat(paintView.bounds.height) - current_pos.y
        dis = sender.translationInView(scrollView)
        
        switch paintViewController.mode
        {
        case .drawing:
            if sender.numberOfTouches() == 2
            {
                handleDrawingTwoPan(sender)
            }
            else
            {
                //record painting
                handleDrawingSinglePan(sender)
            }
        default:break
        }
        
        
        
        sender.setTranslation(CGPointZero, inView: scrollView)

    }
    var paintRecorder:PaintRecorder!
    func handleDrawingSinglePan(sender:UIPanGestureRecognizer)
    {
        let current_time = CFAbsoluteTimeGetCurrent()
        switch(sender.state)
        {
        case UIGestureRecognizerState.Began:
            paintRecorder.startPoint(CGPointToVec2(current_pos) * Float(paintView.contentScaleFactor), velocity: CGPointToVec2(velocity), time: current_time)
        case UIGestureRecognizerState.Changed:
            paintRecorder.movePoint(CGPointToVec2(current_pos) * Float(paintView.contentScaleFactor), velocity: CGPointToVec2(velocity), time: current_time)
        case UIGestureRecognizerState.Ended:
            paintRecorder.endStroke(current_time)
            
        default :
            break
        }

    }
    /*
    drag the canvas
    */
    func handleDrawingTwoPan(sender:UIPanGestureRecognizer)
    {
        
        switch(sender.state)
        {
        case UIGestureRecognizerState.Began:
            twoTouchSwipeCount = 0;
            twoSwipeState = TwoSwipeState.Unknown
        case UIGestureRecognizerState.Changed:
            if twoSwipeState == TwoSwipeState.Unknown
            {
                let v = sender.velocityInView(scrollView)
               
                if v.x < -800
                {
                    twoSwipeState = TwoSwipeState.FastSwipe
                    print("fast swipe")
                    return
                }
                else if v.x>800
                {
                    twoSwipeState = TwoSwipeState.FastSwipe
                    print("fast swipe")
                    return
                }
                
                twoTouchSwipeCount++
                if twoTouchSwipeCount > 10
                {
                    twoSwipeState = TwoSwipeState.Dragging
                }
            }
            else if twoSwipeState == TwoSwipeState.Dragging
            {
                let scale = paintView.layer.transform.m11
                paintView.layer.transform = CATransform3DTranslate(paintView.layer.transform, dis.x/scale , dis.y/scale, 0)
            }
            
        default: ()
            
        }
    }
    
    //drag to the frame of replaying artwork
    
    func handleReplaySinglePan(sender:UIPanGestureRecognizer)
    {
        switch(sender.state)
        {
        case UIGestureRecognizerState.Began:
            
            return
        case UIGestureRecognizerState.Changed:
            
            return
        default :
            return
            
        }

    }
}