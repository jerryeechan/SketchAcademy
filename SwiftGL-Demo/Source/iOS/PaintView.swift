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
//    var glcontext:EAGLContext!
    var eaglLayer:CAEAGLLayer!
    
    var glContextBuffer:GLContextBuffer!
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
        //setNeedsDisplay()
        //display()
        glContextBuffer.display()
    }
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
       
        
//        self.glcontext = EAGLContext(API: EAGLRenderingAPI.OpenGLES3)
//        if self.glcontext == nil {
//            print("Failed to create ES context")
//        }
//        context = glcontext
        
        contentScaleFactor = UIScreen.mainScreen().scale;
        //Painter.scale = Float(contentScaleFactor)
        
        //drawableDepthFormat = GLKViewDrawableDepthFormat.Format24;
        //drawableStencilFormat = GLKViewDrawableStencilFormat.Format8;
        
        // Enable multisampling
        //drawableMultisample = GLKViewDrawableMultisample.Multisample4X;
        
        initGL()
        
    }
    required override init(frame:CGRect,context:EAGLContext)
    {
        super.init(frame: frame, context: context)
        
        
        
//        if self.glcontext == nil {
//            print("Failed to create ES context")
//        }
//        context = glcontext
        contentScaleFactor = UIScreen.mainScreen().scale;
      //  Painter.scale = Float(contentScaleFactor)
        
        //self.context = context//EAGLContext(API: EAGLRenderingAPI.OpenGLES3)
        initGL()
    }
    
    var isInitialized:Bool = false
    
    func initGL()->Bool{
        
        
        
        EAGLContext.setCurrentContext(context)
        
        eaglLayer = layer as! CAEAGLLayer
        
        eaglLayer.drawableProperties = [kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8,kEAGLDrawablePropertyRetainedBacking:true]
        
        print("PaintView: create shader")
        
        glContextBuffer = GLContextBuffer(context: context)
        print("PaintView: create context buffer")

        
        
        glTransformation = GLTransformation(width: glContextBuffer.backingWidth, height: glContextBuffer.backingHeight)
        print("PaintView: create transformation")
        
        layer.magnificationFilter = kCAFilterNearest
        
        
        
        //glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        //glBlendFunc (GL_ONE, GL_ZERO);
        
        
        
        //glDepthFunc(GL_LESS)
        //glEnable(GL_DEPTH_TEST)
        
        resizeLayer()
        
        return true
    }
    
    
    func resizeLayer()
    {
        
        glContextBuffer.resizeLayer(eaglLayer)
        let width:GLint = GLint(frame.width * contentScaleFactor)//GLContextBuffer.instance.backingWidth
        let height:GLint = GLint(frame.height * contentScaleFactor) //GLContextBuffer.instance.backingHeight
        glTransformation.resize(width, height: height)

    }
    /*
    override func drawRect(rect: CGRect) {
        display()
        //glFlush();
    }

    override func display() {
        
        
    }
    */
    /*
    override func drawRect(rect: CGRect) {
        //Engine.render()
    }
    
*/

}
