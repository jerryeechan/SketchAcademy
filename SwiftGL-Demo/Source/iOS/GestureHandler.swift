//
//  PaintViewControllerGestureHandler.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/5.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

extension PaintViewController
{
    func gestureHandlerSetUp()
    {
    }
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
                    //disableGesture()
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
                    paintManager.paintRecorder.disruptFingerStroke()
                    
                    currentTouchType = "Stylus"
                    //disableGesture()
                    paintManager.paintRecorder.startPoint(touchRaw, view: paintView)
                }
            }
        }
        else
        {
                currentTouchType = "Finger"
        }
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //DLog(currentTouchType)
        if appState == AppState.viewArtwork || appState == AppState.viewRevision
        {
            return
        }
        for touchRaw in touches
        {
            var toucharray = [UITouch]()
            if #available(iOS 9.1, *) {
                
                if touchRaw.type == .Stylus
                {
                    
                    if let coalescedTouches = event?.coalescedTouchesForTouch(touchRaw) {
                        toucharray = coalescedTouches
                    }
                    /*
                    for touch in toucharray
                    {
                        paintManager.paintRecorder.movePoint(touch,view:paintView)
                    }*/
                    
                    paintManager.paintRecorder.movePoints(toucharray, view: paintView)
                    /*
                    let predictTouchs = event?.predictedTouchesForTouch(touchRaw)
                    DLog("\(predictTouchs?.count)")
                    for touch in predictTouchs!
                    {
                        paintManager.paintRecorder.movePoint(touch,view:paintView)
                    }
                    
                    */
                    
                    paintView.glDraw()
                }
                
            }
        }
        
        
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touchRaw = touches.first else { return }
        if #available(iOS 9.1, *) {
            if touchRaw.type == .Stylus
            {
                paintManager.paintRecorder.endStroke()
                paintView.addGestureRecognizer(singlePanGestureRecognizer)
                //enableGesture()
                currentTouchType = "None"
            }
            
            
        }
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
    func viewPinchHandler(targetPaintView:PaintView,sender:UIPinchGestureRecognizer)
    {
        var center:CGPoint = CGPointMake(0, 0)
        for i in 0 ..< sender.numberOfTouches()
        {
            let p = sender.locationOfTouch(i, inView: targetPaintView)
            center.x += p.x
            center.y += p.y
        }
        center.x /= CGFloat(sender.numberOfTouches())
        center.y /= CGFloat(sender.numberOfTouches())
        
        setAnchorPoint(CGPointMake(center.x/targetPaintView.bounds.size.width,center.y / targetPaintView.bounds.size.height), forView: targetPaintView)
        
        
        switch sender.state
        {
            
            //paintView.layer.anchorPoint = CGPointMake(0.5, 0.5)
            
        case UIGestureRecognizerState.Changed:
            targetPaintView.scale *= sender.scale
            //print("scale: \(paintView.layer.transform.m11 * sender.scale)")
            if targetPaintView.scale >= 3
            {
                targetPaintView.scale = 3
                //paintView.layer.transform = CATransform3DMakeScale(3, 3, 1)
            }
            else if targetPaintView.scale <= 0.2
            {
                targetPaintView.scale = 0.2
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
                
                self.resetAnchor(targetPaintView)
            })
            }
            
            //paintView.layer.anchorPoint = CGPointZero
            //   paintView.layer.position = CGPointZero
            
        default: ()
        }

    }
    
    @IBAction func uiPinchGestrueEvent(sender: UIPinchGestureRecognizer) {
        viewPinchHandler(paintView, sender: sender)
        
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
    @IBAction func singleTapSingleTouchGestureHandler(sender: UITapGestureRecognizer) {
        if sender.state == .Ended
        {
            //DLog("Single tap")
            switch appState
            {
            case AppState.editNote:
                hideKeyBoard()
            case .viewArtwork, .viewRevision:
                playbackControlPanel.toggle()
            default:
                break
            }
        }
        
    }
    
    @IBAction func doubleTapSingleTouchGestureHandler(sender: UITapGestureRecognizer) {
        DLog("double tap")
        if sender.state == .Ended
        {
            DLog("\(appState)")
            switch appState
            {
            case .viewArtwork, .viewRevision:
                //TODO show replay panel
                let textViews = [noteTitleField, noteDescriptionTextView]
                for view in textViews
                {
                    let point = sender.locationInView(view)
                    
                    //if sender.view == view
                    if view.pointInside(point, withEvent: nil)
                    {
                        editNote()
                        view.becomeFirstResponder()
                        return
                    }
                }
                
                
                break
            default:
                break
            }
        }
    }
    
}
