//
//  PaintViewControllerGestureHandler.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/5.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

extension PaintViewController
{
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer || gestureRecognizer is UIPinchGestureRecognizer {
            return true
        } else {
            return false
        }
    }
    @IBAction func uiPanGestureHandler(sender: UIPanGestureRecognizer) {
        canvasPanGestureHandler.panGestureHandler(sender)
    }
    @IBAction func uiTapGestureEvent(sender: UITapGestureRecognizer) {
        
        switch(appState)
        {
        case .drawArtwork, .drawRevision:
            print("controller double tap")
            resetAnchor()
        case .viewArtwork, .viewRevision:
            //view.addSubview(noteEditView)
            if isCanvasManipulationEnabled
            {
                showNoteEditView()
            }
            break
        }
    }
    
    @IBAction func uiPinchGestrueEvent(sender: UIPinchGestureRecognizer) {
        
        var center:CGPoint = CGPointMake(0, 0)
        for i in 0...sender.numberOfTouches()-1
        {
            let p = sender.locationOfTouch(i, inView: paintView)
            center.x += p.x
            center.y += p.y
        }
        
        center.x /= CGFloat(sender.numberOfTouches())
        center.y /= CGFloat(sender.numberOfTouches())
        
        setAnchorPoint(CGPointMake(center.x/paintView.bounds.size.width,center.y / paintView.bounds.size.height), forView: paintView)
        
        
        switch sender.state
        {
            
            //paintView.layer.anchorPoint = CGPointMake(0.5, 0.5)
        case UIGestureRecognizerState.Changed:
            
            
            if paintView.layer.transform.m11 * sender.scale > 3
            {
                paintView.layer.transform = CATransform3DMakeScale(3, 3, 1)
            }
            else
            {
                paintView.layer.transform = CATransform3DScale(paintView.layer.transform, sender.scale, sender.scale, 1)
            }
            
            //paintView.layer.transform = CATransform3DMakeScale(sender.scale, sender.scale, 1)
            //paintView.layer.transform = CGAffineTransformScale(paintView.transform, sender.scale, )
            sender.scale = 1
        case .Ended:()
        if paintView.layer.transform.m11 * sender.scale <= 0.8
        {
            UIView.animateWithDuration(0.5, animations: {
                self.paintView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
                self.resetAnchor()
            })
            }
            
            //paintView.layer.anchorPoint = CGPointZero
            //   paintView.layer.position = CGPointZero
            
        default: ()
        }
    }
}
