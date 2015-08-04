//
//  GameViewController.swift
//  SwiftGL-Demo-iOS
//
//  Created by Scott Bennett on 2015-04-14.
//  Copyright (c) 2015 Scott Bennett. All rights reserved.
//

//NOTE: The OpenGL ES option is still in progress for Swift.

import Foundation
import GLKit
import OpenGLES

class GameViewController: GLKViewController {
    var context: EAGLContext? = nil
    let canvasInputHandler = CanvasInputHandler()
    deinit {
        self.tearDownGL()

        if EAGLContext.currentContext() === self.context {
            EAGLContext.setCurrentContext(nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        context = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        if context == nil {
            println("Failed to create ES context")
        }

        let view = self.view as! GLKView
        view.context = self.context
        //view.drawableDepthFormat = .Format24
        view.drawableColorFormat = GLKViewDrawableColorFormat.RGBA8888
        
        view.opaque = true
        
        
        let eaglLayer:CAEAGLLayer = view.layer as! CAEAGLLayer;
        
        eaglLayer.opaque = true
        // In this application, we want to retain the EAGLDrawable contents after a call to presentRenderbuffer.
        
        view.enableSetNeedsDisplay = true
        
        // Set the view's scale factor as you wish
        //self.contentScaleFactor = [[UIScreen mainScreen] scale];
        
        self.setupGL()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        if self.isViewLoaded() && self.view.window != nil {
            self.view = nil

            self.tearDownGL()

            if EAGLContext.currentContext() === self.context {
                EAGLContext.setCurrentContext(nil)
            }
            self.context = nil
        }
    }
    /*
    @IBAction func uiPinchGesture(sender: UIPinchGestureRecognizer) {
        let current_pos = sender.locationInView(view)
        var current_time = CFAbsoluteTimeGetCurrent()
        
        switch(sender.state)
        {
            
        case UIGestureRecognizerState.Began:
            //canvasInputHandler.touchBegin(current_pos, time: current_time)

        case UIGestureRecognizerState.Changed:
            //canvasInputHandler.touchMoved(current_pos)
            
        case UIGestureRecognizerState.Ended:
            canvasInputHandler.touchEnded()
        default :
            return
        }
    }*/
    func setupGL() {
        EAGLContext.setCurrentContext(self.context)
        
        // Change the working directory so that we can use C code to grab resource files
        if let path = NSBundle.mainBundle().resourcePath {
            NSFileManager.defaultManager().changeCurrentDirectoryPath(path)
        }
        
        Engine.initialize()
        
        let width  = Float(view.frame.size.width )// * view.contentScaleFactor)
        let height = Float(view.frame.size.height)// * view.contentScaleFactor)
        Engine.resize(width: width, height: height)
    }

    func tearDownGL() {
        EAGLContext.setCurrentContext(self.context)
        
        Engine.finalize()
    }

    // MARK: - GLKView and GLKViewController delegate methods

/*func update() {
        Engine.update()
    }
*/
    // Render
    
    override func glkView(view: GLKView, drawInRect rect: CGRect) {
        Engine.render()
        print("render")
    }
}
