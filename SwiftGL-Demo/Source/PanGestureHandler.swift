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
public func + (a: CGPoint, b: CGPoint) -> CGPoint {return CGPoint(x: a.x + b.x, y: a.y + b.y)}
public func += (inout a: CGPoint, b: CGPoint) {a = a + b};extension PaintViewController {
    
    func applyCATransform()
    {
        paintView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, paintView.translation.x, paintView.translation.y, 0)
        paintView.layer.transform = CATransform3DRotate(paintView.layer.transform, paintView.rotation, 0, 0, 1)
        paintView.layer.transform = CATransform3DScale(paintView.layer.transform, paintView.scale, paintView.scale, 1)
    }
    
    @IBAction func FingerPanGestureRecognizer(sender:UIPanGestureRecognizer) {
        //only take Finger
        switch appState
        {
        case .drawArtwork,.drawRevision:
            if currentTouchType == "Finger"
            {
                handleDrawingSinglePan(sender)
            }
        case .viewArtwork, .viewRevision:
            handleReplaySinglePan(sender)
        case .editNote:
            break
        }
        
    }

    
    @IBAction func uiPanGestureHandler(sender: UIPanGestureRecognizer) {
        
        /*
        velocity = sender.velocityInView(paintView)
        current_pos = sender.locationInView(paintView)
        current_pos.y = CGFloat(paintView.bounds.height) - current_pos.y
        dis = sender.translationInView(scrollView)
        */
        
            if sender.numberOfTouches() == 2
            {
                handleDrawingTwoPan(sender)
            }
                /*
            else
            {
                switch appState
                {
                case .drawArtwork, .drawRevision:
                //record painting
                handleDrawingSinglePan(sender)
                default:break
                }
            }
        
        */
        
        
        sender.setTranslation(CGPointZero, inView: canvasBGView)

    }
    
    func handleDrawingSinglePan(sender:UIPanGestureRecognizer)
    {
        
        switch(sender.state)
        {
        case UIGestureRecognizerState.Began:
            paintManager.paintRecorder.startPoint(sender, view: paintView)
        case UIGestureRecognizerState.Changed:
            paintManager.paintRecorder.movePoint(sender, view: paintView)
            PaintView.display()
        case UIGestureRecognizerState.Ended:
            paintManager.paintRecorder.endStroke()
            currentTouchType = "None"
        default :
            break
        }

        //print("pan single")

    }
    
    func handleDrawingTwoPan(sender:UIPanGestureRecognizer)
    {
        
        switch(sender.state)
        {
        case UIGestureRecognizerState.Began:
            //twoTouchSwipeCount = 0;
            //twoSwipeState = TwoSwipeState.Unknown
            break
        case UIGestureRecognizerState.Changed:
            /*
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
*/
            
            let dis = sender.translationInView(canvasBGView)
            paintView.translation += CGPoint(x: dis.x,y: dis.y)
            applyCATransform()
              //  paintView.layer.transform = CATransform3DTranslate(paintView.layer.transform, dis.x/scale , dis.y/scale, 0)
            /*
            }
            */
            sender.setTranslation(CGPoint.zero, inView: canvasBGView)
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
            disx += sender.translationInView(canvasBGView).x * 4
            
            sender.setTranslation(CGPoint.zero, inView: canvasBGView)
            
            if disx < 0
            {
                if disx > -10
                {
                    return
                }
            }
            DLog("\(replayProgressBar.progress)")
            DLog("\(Float(disx/viewWidth))")
            var progress = replayProgressBar.progress + Float(disx/viewWidth)
            if progress < 0
            {
                progress = 0.0
                
            }
            else if progress > 1
            {
                progress = 1.0
            }
            
            
            DLog("\(progress)")
            if paintManager.drawProgress(progress)
            {
                disx = 0
            }
            
            return
        default :
            return
            
        }

    }
}