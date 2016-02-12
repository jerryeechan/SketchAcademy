//
//  PaintViewControllerGestureHandler.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/5.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

extension PaintViewController
{
    func disableGesture()
    {
        for g in canvasBGView.gestureRecognizers!
        {
            g.enabled = false
        }
        paintView.removeGestureRecognizer(singlePanGestureRecognizer)
        
        
        singlePanGestureRecognizer.enabled = false
    }
    func enableGesture()
    {
        
        for g in canvasBGView.gestureRecognizers!
        {
            //            /canvasBGView.removeGestureRecognizer(g)
            g.enabled = true
        }
        singlePanGestureRecognizer.enabled = true
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if appState == AppState.viewArtwork || appState == AppState.viewRevision
        {
            return
        }
        guard let touchRaw = touches.first else { return }
        if #available(iOS 9.1, *) {
            
            if currentTouchType == "None"
            {
                if touchRaw.type == .Stylus
                {
                    currentTouchType = "Stylus"
                    disableGesture()
                    paintManager.paintRecorder.startPoint(touchRaw, view: paintView)
                }
                else
                {
                    currentTouchType = "Finger"
                }
            }
            else
            {
                if touchRaw.type == .Stylus
                {
                    DLog("interfere")
                }
            }
        }
        else
        {
                currentTouchType = "Finger"
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touchRaw = touches.first else { return }
        if #available(iOS 9.1, *) {
            if touchRaw.type == .Stylus
            {
                paintManager.paintRecorder.endStroke()
                paintView.addGestureRecognizer(singlePanGestureRecognizer)
                enableGesture()
            }
            currentTouchType = "None"
            
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if appState == AppState.viewArtwork || appState == AppState.viewRevision
        {
            return
        }
        //        print("touchMoved")
        print(touches.count)
        for touchRaw in touches
        {
            var toucharray = [UITouch]()
            if #available(iOS 9.1, *) {
                
                if currentTouchType == "Stylus" && touchRaw.type == .Stylus
                {
                    
                    if let coalescedTouches = event?.coalescedTouchesForTouch(touchRaw) {
                        toucharray = coalescedTouches
                    }
                    for touch in toucharray
                    {
                        paintManager.paintRecorder.movePoint(touch,view:paintView)
                    }
                    
                }
            }
        }
        paintView.setNeedsDisplay()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == singlePanGestureRecognizer || otherGestureRecognizer == singlePanGestureRecognizer
        {
            return false
        }
        else if gestureRecognizer is UIPanGestureRecognizer || gestureRecognizer is UIPinchGestureRecognizer || gestureRecognizer is UIRotationGestureRecognizer {
            return true
        } else {
            
            return false
        }
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
            paintView.scale *= sender.scale
            //print("scale: \(paintView.layer.transform.m11 * sender.scale)")
            if paintView.scale >= 3
            {
                paintView.scale = 3
                //paintView.layer.transform = CATransform3DMakeScale(3, 3, 1)
            }
            else if paintView.scale <= 0.2
            {
                paintView.scale = 0.2
                //paintView.layer.transform = CATransform3DMakeScale(0.2, 0.2, 1)
            }
            applyCATransform()
            
            //paintView.layer.transform = CATransform3DMakeScale(sender.scale, sender.scale, 1)
            //paintView.layer.transform = CGAffineTransformScale(paintView.transform, sender.scale, )
            sender.scale = 1
        case .Ended:()
            print(sender.velocity)
            if sender.velocity < -2 || sender.velocity > 4
            {
                UIView.animateWithDuration(0.5, animations: {
                    //self.paintView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
                    
                    self.resetAnchor()
                })
            }
            
            //paintView.layer.anchorPoint = CGPointZero
            //   paintView.layer.position = CGPointZero
            
        default: ()
        }
    }
    @IBAction func rotationGestureHandler(sender: UIRotationGestureRecognizer) {
        switch sender.state
        {
            
            //paintView.layer.anchorPoint = CGPointMake(0.5, 0.5)
        case UIGestureRecognizerState.Changed:
            paintView.rotation += sender.rotation
            applyCATransform()
            //paintView.layer.transform = CATransform3DRotate(paintView.layer.transform,sender.rotation,0,0,1)
        sender.rotation = 0
            
        default: ()
        }
    }
}
