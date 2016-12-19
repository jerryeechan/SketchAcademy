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
            g.isEnabled = false
        }
        paintView.removeGestureRecognizer(singlePanGestureRecognizer)
        
        
        singlePanGestureRecognizer.isEnabled = false
    }
    func enableGesture()
    {
        
        for g in canvasBGView.gestureRecognizers!
        {
            //            /canvasBGView.removeGestureRecognizer(g)
            g.isEnabled = true
        }
        singlePanGestureRecognizer.isEnabled = true
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if appState == AppState.viewArtwork || appState == AppState.viewRevision
        {
            return
        }
        guard let touchRaw = touches.first else { return }
        if #available(iOS 9.1, *) {
            if currentTouchType == "None"
            {
                
                if touchRaw.type == .stylus
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
                if touchRaw.type == .stylus
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
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //DLog(currentTouchType)
        if appState == AppState.viewArtwork || appState == AppState.viewRevision
        {
            return
        }
        for touchRaw in touches
        {
            var toucharray = [UITouch]()
            if #available(iOS 9.1, *) {
                
                if touchRaw.type == .stylus
                {
                    
                    if let coalescedTouches = event?.coalescedTouches(for: touchRaw) {
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
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchRaw = touches.first else { return }
        if #available(iOS 9.1, *) {
            if touchRaw.type == .stylus
            {
                paintManager.paintRecorder.endStroke()
                paintView.addGestureRecognizer(singlePanGestureRecognizer)
                //enableGesture()
                currentTouchType = "None"
            }
            
            
        }
    }
    
    @objc(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
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
    func viewPinchHandler(_ targetPaintView:PaintView,sender:UIPinchGestureRecognizer)
    {
        var center:CGPoint = CGPoint(x: 0, y: 0)
        for i in 0 ..< sender.numberOfTouches
        {
            let p = sender.location(ofTouch: i, in: targetPaintView)
            center.x += p.x
            center.y += p.y
        }
        center.x /= CGFloat(sender.numberOfTouches)
        center.y /= CGFloat(sender.numberOfTouches)
        
        setAnchorPoint(CGPoint(x: center.x/targetPaintView.bounds.size.width,y: center.y / targetPaintView.bounds.size.height), forView: targetPaintView)
        
        
        switch sender.state
        {
            
            //paintView.layer.anchorPoint = CGPointMake(0.5, 0.5)
            
        case UIGestureRecognizerState.changed:
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
        case .ended:()
        print(sender.velocity)
        if sender.velocity < -2 || sender.velocity > 4
        {
            UIView.animate(withDuration: 0.5, animations: {
                //self.paintView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1)
                
                self.resetAnchor(targetPaintView)
            })
            }
            
            //paintView.layer.anchorPoint = CGPointZero
            //   paintView.layer.position = CGPointZero
            
        default: ()
        }

    }
    
    @IBAction func uiPinchGestrueEvent(_ sender: UIPinchGestureRecognizer) {
        viewPinchHandler(paintView, sender: sender)
        
    }
    @IBAction func rotationGestureHandler(_ sender: UIRotationGestureRecognizer) {
        switch sender.state
        {
            
            //paintView.layer.anchorPoint = CGPointMake(0.5, 0.5)
        case UIGestureRecognizerState.changed:
            paintView.rotation += sender.rotation
            applyCATransform()
            //paintView.layer.transform = CATransform3DRotate(paintView.layer.transform,sender.rotation,0,0,1)
        sender.rotation = 0
            
        default: ()
        }
    }
    @IBAction func singleTapSingleTouchGestureHandler(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended
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
    
    @IBAction func doubleTapSingleTouchGestureHandler(_ sender: UITapGestureRecognizer) {
        DLog("double tap")
        if sender.state == .ended
        {
            DLog("\(appState)")
            switch appState
            {
            case .viewArtwork, .viewRevision:
                //TODO show replay panel
                let textViews = [noteTitleField, noteDescriptionTextView] as [UIView]
                for view in textViews
                {
                    let point = sender.location(in: view)
                    
                    //if sender.view == view
                    if view.point(inside: point, with: nil)
                    {
                        editNote()
                        (view as AnyObject).becomeFirstResponder()
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
