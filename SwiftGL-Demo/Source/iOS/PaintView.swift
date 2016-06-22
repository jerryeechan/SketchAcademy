//
//  PaintView.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/21.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import OpenGLES.ES3
import GLKit
import SwiftGL
class PaintView: GLKView {
    var glcontext:EAGLContext!
    var eaglLayer:CAEAGLLayer!
    
    var paintBuffer:GLContextBuffer!
    var tutorialBuffer:GLContextBuffer!
    var glTransformation:GLTransformation!

    var translation:CGPoint = CGPoint(x: 0, y: 0)
    var rotation:CGFloat = 0
    var scale:CGFloat = 1
    

    /*
    static func display()
    {
        paintView.setNeedsDisplay()
    }
*/
    func glDraw()
    {
        setNeedsDisplay()
    }
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
       
        
        self.glcontext = EAGLContext(API: EAGLRenderingAPI.OpenGLES3)
        if self.glcontext == nil {
            print("Failed to create ES context")
        }
        context = glcontext
        
        contentScaleFactor = UIScreen.mainScreen().scale;
        //Painter.scale = Float(contentScaleFactor)
        
        //drawableDepthFormat = GLKViewDrawableDepthFormat.Format24;
        //drawableStencilFormat = GLKViewDrawableStencilFormat.Format8;
        
        // Enable multisampling
        //drawableMultisample = GLKViewDrawableMultisample.Multisample4X;
        
        initGL()
        
    }
    required override init(frame:CGRect)
    {
        super.init(frame: frame)
        
        self.glcontext = EAGLContext(API: EAGLRenderingAPI.OpenGLES3)
        if self.glcontext == nil {
            print("Failed to create ES context")
        }
        context = glcontext
        contentScaleFactor = UIScreen.mainScreen().scale;
      //  Painter.scale = Float(contentScaleFactor)
        initGL()
        
    }
    
    var isInitialized:Bool = false
    
    func setContext()
    {
        EAGLContext.setCurrentContext(self.glcontext)
    }
    func initGL()->Bool{
        
        // Change the working directory so that we can use C code to grab resource files
        if let path = NSBundle.mainBundle().resourcePath {
            NSFileManager.defaultManager().changeCurrentDirectoryPath(path)
        }
        let path = NSBundle.mainBundle().bundlePath
        let fm = NSFileManager.defaultManager()
        
        let dirContents: [AnyObject]?
        do {
            dirContents = try fm.contentsOfDirectoryAtPath(path)
        } catch _ {
            dirContents = nil
        }
        print(dirContents)
        
        EAGLContext.setCurrentContext(self.glcontext)
        glcontext.multiThreaded = true
        eaglLayer = layer as! CAEAGLLayer
        
        eaglLayer.drawableProperties = [kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8,kEAGLDrawablePropertyRetainedBacking:true]
        
        print("PaintView: create shader")
        
        paintBuffer = GLContextBuffer()
        print("PaintView: create context buffer")

        
        
        glTransformation = GLTransformation()
        print("PaintView: create transformation")
        
        //layer.magnificationFilter = kCAFilterNearest
        
        //glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        //glBlendFunc (GL_ONE, GL_ZERO);
        
        
        
        //glDepthFunc(GL_LESS)
        //glEnable(GL_DEPTH_TEST)
        
        resizeLayer()
        
        return true
    }
    var canvasWidth:Float!
    var canvasHeight:Float!
    
    func resizeLayer()
    {
        let width:GLint = GLint(frame.width * contentScaleFactor)//GLContextBuffer.instance.backingWidth
        let height:GLint = GLint(frame.height * contentScaleFactor) //GLContextBuffer.instance.backingHeight
        canvasWidth = Float(width)
        canvasHeight = Float(height)
        glTransformation.resize(width, height: height)
        switch PaintViewController.appMode
        {
        
        case .InstructionTutorial:
            
            paintBuffer.resizeLayer(width/2,height: height,offsetX: Float(width/2))
            tutorialBuffer = GLContextBuffer()
            tutorialBuffer.resizeLayer(width/2, height: height, offsetX: 0)
            GLShaderBinder.instance.setSize(Float(width/2), height: Float(height))
            
        default:
            paintBuffer.resizeLayer(width,height: height,offsetX: 0)
            GLShaderBinder.instance.setSize(Float(width), height: Float(height))
        }
        //GLContextBuffer.instance.blank()
        //PaintView.display()

    }
    
    
    override func drawRect(rect: CGRect) {
        glEnable(GL_BLEND);
        glBlendEquation(GLenum(GL_FUNC_ADD))
        glBlendFunc (GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        //clear renderbuffer first
        glClearColor(0, 0, 0, 0)
        glClear(GL_COLOR_BUFFER_BIT )//| GL_DEPTH_BUFFER_BIT)
        paintBuffer.display()
        if tutorialBuffer != nil
        {
            tutorialBuffer.display()
            drawSeperator()
        }
        
        
    }
    func drawSeperator()
    {
        let seperatorWidth:Float = 10
        
        let rect = GLRect(p1: Vec2(canvasWidth/2-seperatorWidth,0) , p2: Vec2(canvasWidth/2+seperatorWidth,canvasHeight))
        tutorialBuffer.drawFillRectangle(rect, color: Vec4(0.15,0.15,0.15,1))
        
    }
    /*
    override func drawRect(rect: CGRect) {
        //Engine.render()
    }
    
*/

}
