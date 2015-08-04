//
//  PaintView.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/21.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import OpenGLES.ES2
import GLKit
import SwiftGL
class PaintView: GLKView {
    var glcontext:EAGLContext!
    var eaglLayer:CAEAGLLayer!
    
    var glContextBuffer:GLContextBuffer!
    var glTransformation:GLTransformation!
    var glshaderBinder:GLShaderBinder!
    
    static var instance:PaintView!
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.glcontext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        if self.glcontext == nil {
            print("Failed to create ES context")
        }
        
        contentScaleFactor = UIScreen.mainScreen().scale;
        Painter.scale = Float(contentScaleFactor)
        
        //drawableDepthFormat = GLKViewDrawableDepthFormat.Format24;
        //drawableStencilFormat = GLKViewDrawableStencilFormat.Format8;
        
        // Enable multisampling
        drawableMultisample = GLKViewDrawableMultisample.Multisample4X;
        opaque = false
        
        initGL()
        PaintView.instance = self
        
    }
    var shader:Shader!
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
        //let filt = NSPredicate(".paw")
        //let files =dirContents?.filter()
        //Engine.initialize()
        
        //let width  = Float(frame.size.width )// * contentScaleFactor)
        // * contentScaleFactor)
        
        //Engine.resize(width: width, height: height)
        
        EAGLContext.setCurrentContext(self.glcontext)
        eaglLayer = layer as! CAEAGLLayer
    
        eaglLayer.opaque = false
        
        eaglLayer.drawableProperties = [kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8,kEAGLDrawablePropertyRetainedBacking:true]
        
        
        
        glContextBuffer = GLContextBuffer(context: glcontext, layer: eaglLayer)
        print("PaintView: create context buffer")
        glshaderBinder = GLShaderBinder()
        print("PaintView: create shader")
        glTransformation = GLTransformation(width: glContextBuffer.backingWidth, height: glContextBuffer.backingHeight)
        print("PaintView: create transformation")
        
        PaintToolManager.instance.usePen()
        
        
        //glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        //glBlendFunc (GL_ONE, GL_ZERO);
        
        
        
        //glDepthFunc(GL_LESS)
        //glEnable(GL_DEPTH_TEST)
        
        
        glshaderBinder.drawShader.useProgram()
//        glDrawElements(GL_TRIANGLE_STRIP, 34, GL_UNSIGNED_SHORT, nil)
        
  //      GLContextBuffer.display()
        
        GLContextBuffer.instance.blank()
        GLContextBuffer.instance.display()
        
        //Painter.renderLine(Vec2(300,0),end: Vec2(0,300))
        return true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        EAGLContext.setCurrentContext(self.glcontext)
        resizeLayer()
        
//        GLContextBuffer.instance.drawTexture(Texture(filename: "spongebob"))
        
        
        
        
    }
    func resizeLayer()
    {
        
        glContextBuffer.resizeLayer(eaglLayer)
        glTransformation.resize(glContextBuffer.backingWidth, height: glContextBuffer.backingHeight)
        GLContextBuffer.instance.blank()
        GLContextBuffer.instance.display()

    }
    
    
    /*
    override func drawRect(rect: CGRect) {
        //Engine.render()
    }
*/

}
