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
    
    weak var glContextBuffer:GLContextBuffer!
    var glTransformation:GLTransformation!

    var translation:CGPoint = CGPoint(x: 0, y: 0)
    var rotation:CGFloat = 0
    var scale:CGFloat = 1
    
    static var instance:PaintView!
    static func display()
    {
        instance.setNeedsDisplay()
    }
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
       
        
        self.glcontext = EAGLContext(API: EAGLRenderingAPI.OpenGLES3)
        if self.glcontext == nil {
            print("Failed to create ES context")
        }
        context = glcontext
        
        contentScaleFactor = UIScreen.mainScreen().scale;
        Painter.scale = Float(contentScaleFactor)
        
        //drawableDepthFormat = GLKViewDrawableDepthFormat.Format24;
        //drawableStencilFormat = GLKViewDrawableStencilFormat.Format8;
        
        // Enable multisampling
        //drawableMultisample = GLKViewDrawableMultisample.Multisample4X;
        
        initGL()
        
    }
    required override init(frame:CGRect)
    {
        super.init(frame: frame)
        PaintView.instance = self
        self.glcontext = EAGLContext(API: EAGLRenderingAPI.OpenGLES3)
        if self.glcontext == nil {
            print("Failed to create ES context")
        }
        context = glcontext
        contentScaleFactor = UIScreen.mainScreen().scale;
        Painter.scale = Float(contentScaleFactor)
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
        
        eaglLayer = layer as! CAEAGLLayer
        
        eaglLayer.drawableProperties = [kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8,kEAGLDrawablePropertyRetainedBacking:true]
        
        print("PaintView: create shader")
        
        glContextBuffer = GLContextBuffer(context: glcontext, layer: eaglLayer)
        print("PaintView: create context buffer")

        
        
        glTransformation = GLTransformation(width: glContextBuffer.backingWidth, height: glContextBuffer.backingHeight)
        print("PaintView: create transformation")
        
        
        
        
        //glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        //glBlendFunc (GL_ONE, GL_ZERO);
        
        
        
        //glDepthFunc(GL_LESS)
        //glEnable(GL_DEPTH_TEST)
        
        
        GLShaderBinder.instance.drawShader.useProgram()
        resizeLayer()
        
        return true
    }
    
    
    func resizeLayer()
    {
        
        glContextBuffer.resizeLayer(eaglLayer)
        let width:GLint = GLint(frame.width * contentScaleFactor)//GLContextBuffer.instance.backingWidth
        let height:GLint = GLint(frame.height * contentScaleFactor) //GLContextBuffer.instance.backingHeight
        glTransformation.resize(width, height: height)
        
        GLContextBuffer.instance.blank()
        PaintView.display()

    }
    override func drawRect(rect: CGRect) {
        GLContextBuffer.instance.display()
    }
    
    /*
    override func drawRect(rect: CGRect) {
        //Engine.render()
    }
    
*/

}
