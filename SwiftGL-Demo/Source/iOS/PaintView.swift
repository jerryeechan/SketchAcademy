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

    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        

        
        self.glcontext = EAGLContext(API: EAGLRenderingAPI.OpenGLES3)
        if self.glcontext == nil {
            print("Failed to create ES context")
        }
        
        contentScaleFactor = UIScreen.mainScreen().scale;
        Painter.scale = Float(contentScaleFactor)
        
        //drawableDepthFormat = GLKViewDrawableDepthFormat.Format24;
        //drawableStencilFormat = GLKViewDrawableStencilFormat.Format8;
        
        // Enable multisampling
        //drawableMultisample = GLKViewDrawableMultisample.Multisample4X;
        opaque = false
        
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
    
        eaglLayer.opaque = false
        
        eaglLayer.drawableProperties = [kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8,kEAGLDrawablePropertyRetainedBacking:true]
        
        
        glContextBuffer = GLContextBuffer(context: glcontext, layer: eaglLayer)
        print("PaintView: create context buffer")

        GLShaderBinder.instance.load()
        print("PaintView: create shader")
        glTransformation = GLTransformation(width: glContextBuffer.backingWidth, height: glContextBuffer.backingHeight)
        print("PaintView: create transformation")
        
        PaintToolManager.instance.load()
        PaintToolManager.instance.usePen()
        
        
        //glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        //glBlendFunc (GL_ONE, GL_ZERO);
        
        
        
        //glDepthFunc(GL_LESS)
        //glEnable(GL_DEPTH_TEST)
        
        
        GLShaderBinder.instance.drawShader.useProgram()
        resizeLayer()
        
        return true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        EAGLContext.setCurrentContext(self.glcontext)
        //resizeLayer()
        
//        GLContextBuffer.instance.drawTexture(Texture(filename: "spongebob"))
        
        
        
        
    }
    
    func resizeLayer()
    {
        
        var width:GLint = 200
        var height:GLint = 200

        glContextBuffer.resizeLayer(eaglLayer,w: width,h: height)
        
        glTransformation.resize(width, height: height)
        print("\(glContextBuffer.backingWidth) \(glContextBuffer.backingHeight)")
        
        GLContextBuffer.instance.blank()
        GLContextBuffer.instance.display()

    }
    
    
    /*
    override func drawRect(rect: CGRect) {
        //Engine.render()
    }
*/

}
