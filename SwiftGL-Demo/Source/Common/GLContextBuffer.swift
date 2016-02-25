//
//  GLContext.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/22.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import SwiftGL
import OpenGLES.ES3

import GLKit

class GLContextBuffer{
    static var instance:GLContextBuffer!
    var paintToolManager:PaintToolManager!
    var shaderBinder:GLShaderBinder!
    var backingWidth:GLint = 0
    var backingHeight:GLint = 0
    var renderTexture:GLRenderTextureFrameBuffer!
    var rectTexture:Texture!
    var layer:CAEAGLLayer!
    
    let createCacheInterval = 200
    var lastCacheIndex = 0
    init(context:EAGLContext,layer:CAEAGLLayer)
    {
        GLContextBuffer.instance = self
        paintToolManager = PaintToolManager()
        shaderBinder = GLShaderBinder()
    }

    func resizeLayer(layer:CAEAGLLayer)
    {
        paintToolManager.load()
        paintToolManager.usePen()
        // This call associates the storage for the current render buffer with the EAGLDrawable (our CAEAGLLayer)
        // allowing us to draw into a buffer that will later be rendered to screen wherever the layer is (which corresponds with our view).
        /*
        context.renderbufferStorage(Int(GL_RENDERBUFFER), fromDrawable: layer)
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER),GL_RENDERBUFFER_WIDTH, &backingWidth)
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GL_RENDERBUFFER_HEIGHT, &backingHeight);
        
        print("GLCOntextBuffer resize layer");
        */
        
        backingWidth = GLint(layer.frame.width*layer.contentsScale)
        backingHeight =  GLint(layer.frame.height*layer.contentsScale)
        print(layer.frame, terminator: "")
        renderTexture = GLRenderTextureFrameBuffer(w:backingWidth, h:backingHeight)

        
        GLShaderBinder.instance.initVertex()
        glEnable(GL_BLEND);
        glBlendEquation(GLenum(GL_FUNC_ADD))
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA)
        
    }
    
    /**
        draw all layers
     */
    
    
    func drawLayers(){
        
        //background
        if(renderTexture.backgroundLayer != nil)
        {
            drawTexture(renderTexture.backgroundLayer.texture,alpha: 1)
        }
        else
        {
            //white background
            glClearColor(1, 1, 1, 1)
            glClear(GL_COLOR_BUFFER_BIT )
        }

        for var i = 0;i<1 ;i++
        {
            let layer = renderTexture.layers[i]
            if(layer.enabled)
            {
                drawTexture(layer.texture,alpha: layer.alpha)
            }
        }
        
        if renderTexture.renderMode == .drawing
        {
            drawTexture(renderTexture.tempLayer.texture,alpha: 1)
        }

        
        if(renderTexture.revisionLayer.enabled)
        {
            DLog("draw revision---")
            drawTexture(renderTexture.revisionLayer.texture, alpha: 1)
        }
    }
    /**
        draw the points
     */
    var drawVertexCount:Int = 0;
    func setReplayDrawSetting()
    {
        renderTexture.renderMode = RenderMode.direct
    }
    
    func setBrushDrawSetting(toolType:PaintToolType)
    {
        switch(toolType)
        {
        case .pen:
                renderTexture.renderMode = RenderMode.drawing
        case .eraser:
                renderTexture.renderMode = RenderMode.direct
        case .smudge:
                renderTexture.renderMode = RenderMode.direct
        }
        
    }
    var renderMode:RenderMode{
        get{
            return renderTexture.renderMode
        }
    }
    
    func drawBrushVertex(vertexBuffer:[PaintPoint],layer:Int)
    {
        //renderTexture.renderMode = RenderMode.direct
        if renderTexture.renderMode == RenderMode.direct
        {
            if renderTexture.setBuffer() == false{
                print("Framebuffer fail", terminator: "")
            }
        }
        else if renderTexture.renderMode == RenderMode.drawing
        {
            if renderTexture.setTempBuffer() == false{
                print("Framebuffer fail", terminator: "")
            }
        }
        renderVertex(vertexBuffer)
    }
    
    func renderVertex(vertexBuffer:[PaintPoint])
    {
        GLShaderBinder.instance.bindBrush()
        GLShaderBinder.instance.bindVertexs(vertexBuffer)
        GLShaderBinder.instance.pencilShader.useProgram()
        paintToolManager.useCurrentTool()
        glDrawArrays(GL_POINTS, 0, Int32(vertexBuffer.count));
        drawVertexCount += vertexBuffer.count

    }
    
    /**
     draw a stroke into rendertexture
     */
    func drawStroke(stroke:PaintStroke,layer:Int)
    {
        //glBlendFunc(GL_ONE, GL_ZERO)
        let vertexBuffer = interpolatePoints(stroke.points)//stroke.points
        drawVertexCount += stroke.points.count;
        
        GLShaderBinder.instance.bindVertexs(vertexBuffer)
        GLShaderBinder.instance.pencilShader.useProgram()
        
        
        //renderTexture.selectLayer(layer)
        if renderTexture.setBuffer()==false{
            print("Framebuffer fail", terminator: "")
        }
        
        /*
        if renderTexture.setTempBuffer() == false{
        print("Framebuffer fail")
        }
        */
        
        glDrawArrays(GL_POINTS, 0, Int32(vertexBuffer.count));
    }

    /**
    when stroke end, draw the temp layer to the current layer
    */
    func endStroke()
    {
        drawTextureOnCurrentLayer(renderTexture.tempLayer.texture, alpha: 1)
        renderTexture.blankTempLayer()
    }
    func endStroke(leftTop:Vec4,rightBottom:Vec4)
    {
        drawTextureOnCurrentLayer(renderTexture.tempLayer.texture,alpha: 1,leftTop:leftTop,rightBottom:rightBottom)
        renderTexture.blankTempLayer()
        
    }
    func cleanTemp()
    {
        renderTexture.blankTempLayer()
    }
    func interpolatePoints(points:[PaintPoint])->[PaintPoint]
    {
        let size:Float = 1
        var vertexBuffer:[PaintPoint] = []
        let kBrushPixelStep:Float =  size*3
        /*
        var left:Float = points.last!.position.x
        var right:Float = points.last!.position.x
        var top:Float = points.last!.position.y
        var bottom:Float = points.last!.position.y
        */
        //srand(0)
        for var i = 0 ; i < points.count-1 ; i++
        {
            //find the effect area
            /*
            if points[i].position.x < left
            {
            left = points[i].position.x
            }
            else if points[i].position.x > right
            {
            right = points[i].position.x
            }
            
            if points[i].position.y < top
            {
            top = points[i].position.y
            }
            else if points[i].position.y > bottom
            {
            bottom = points[i].position.y
            }
            */
            
            let ep = points[i]
            let sp = points[i+1]
            
            var count:Int;
            
            // Convert locations from Points to Pixels
            /* CGFloat scale = self.contentScaleFactor;
            start.x *= scale;
            start.y *= scale;
            end.x *= scale;
            end.y *= scale;*/
            
            //var sp = start*scale
            //var ep = end*scale
            
            let disx = (ep.position.x-sp.position.x)
            let disy = (ep.position.y-sp.position.y)

            let xdis2 = powf(disx,2)
            
            let ydis2 = powf(disy,2)
            
            // Add points to the buffer so there are drawing points every X pixels
            let pnum = ceil(sqrt(xdis2 + ydis2) / kBrushPixelStep)
            
            count = max(Int(pnum),1);
            if(count == 1)
            {
                
            }
            
            let force = (ep.force+sp.force)/2
            let altitude = (ep.altitude+sp.altitude)/2
            let azimuth = (ep.azimuth+sp.azimuth)/2
            let velocity = (ep.velocity+sp.velocity)/2
            //print("line vertext:\(count)")
            for var j = 0; j < count; ++j {
                //let randAngle = Float(arc4random()) / Float(UINT32_MAX) * Pi/2
                //let randAngle = Float(rand() % 360) / 360 * Pi
                
                let d = Float(j)/Float(count)
                let px = sp.position.x+disx*d
                let py = sp.position.y+disy*d
                
                let v = PaintPoint(position: Vec4(px,py), force: force, altitude: altitude, azimuth: azimuth,velocity: velocity)
                
                vertexBuffer.append(v)
            }
        }
        return vertexBuffer
    }
    
        //draw texture on the RenderTexture layer
    func loadCacheFrame(atStroke:Int)
    {
        if renderTexture.setBuffer()==false{
            print("Framebuffer fail", terminator: "")
        }
        clear()
        drawTexture(renderTexture.caches[atStroke]!.texture,alpha:1)
    }
    
    func checkCache(strokeNum:Int)
    {
        
        if strokeNum - lastCacheIndex > createCacheInterval
        {
            saveCacheFrame(strokeNum)
            lastCacheIndex = strokeNum
            
        }
    }
    var image:UIImage!
    func saveCacheFrame(atStroke:Int)
    {
        
        let layer = renderTexture.genCacheFrame(atStroke)
        if renderTexture.setBuffer(layer)==false{
            print("Framebuffer fail", terminator: "")
        }
        clear()
        drawTexture(renderTexture.currentLayer.texture, alpha: 1)
        
    }
    func clearCacheFrame(atStroke:Int)
    {
        
    }
   
    func drawTextureOnCurrentLayer(texture:Texture,alpha:Float)
    {
        if renderTexture.setBuffer() == false{
            print("Framebuffer fail", terminator: "")
        }
        
        drawTexture(texture, alpha: alpha)
    }
    func drawTextureOnCurrentLayer(texture:Texture,alpha:Float,leftTop:Vec4,rightBottom:Vec4)
    {
        glEnable(GL_BLEND);
        glBlendEquation(GLenum(GL_FUNC_ADD))
        glBlendFunc (GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        
        if renderTexture.setBuffer() == false{
            print("Framebuffer fail", terminator: "")
        }
        GLShaderBinder.instance.drawImageTexture(texture,alpha:alpha,leftTop:leftTop,rightBottom:rightBottom)
    }
   
    func drawTexture(texture:Texture,alpha:Float)
    {
        glEnable(GL_BLEND);
        glBlendEquation(GLenum(GL_FUNC_ADD))
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA)
        GLShaderBinder.instance.drawImageTexture(texture,alpha:alpha)
    }
        
    func setRenderBufferToTarget()
    {
        /*
        glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
        glBindRenderbuffer(GL_RENDERBUFFER_ENUM, viewRenderbuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER_ENUM, viewRenderbuffer);
        */

    }
    func display()
    {
        //setRenderBufferToTarget()
        glEnable(GL_BLEND);
        glBlendEquation(GLenum(GL_FUNC_ADD))
        glBlendFunc (GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        
        //clear renderbuffer first
        clear()
        //redraw all layers
        drawLayers()
        
        //present to context
        //EAGLContext.setCurrentContext(context)
        //context.presentRenderbuffer(Int(GL_RENDERBUFFER));
        
        
        //DLog("vertex drawn:\(drawVertexCount)")
        drawVertexCount = 0
    }
    func clear()
    {
        glClearColor(0, 0, 0, 0)
        glClear(GL_COLOR_BUFFER_BIT )//| GL_DEPTH_BUFFER_BIT)
    }
    func blank()
    {
        renderTexture.blankCurrentLayer()    
    }
    func getPixelColor(x:GLint,y:GLint)->UIColor
    {
        var pixels:[GLubyte] = [0,0,0,0]
        glReadPixels(x, y, 1, 1, GLenum(GL_RGBA), GL_UNSIGNED_BYTE, &pixels)
        
        return UIColor(red: CGFloat(pixels[0])/255, green: CGFloat(pixels[1])/255, blue: CGFloat(pixels[2])/255, alpha: CGFloat(pixels[3])/255)
    }
    var imgBuffer:UnsafeMutablePointer<GLubyte>!
    func contextImage()->UIImage!
    {
        let tick = CFAbsoluteTimeGetCurrent()
        let width = Int(self.backingWidth)
        let height = Int(self.backingHeight)
        
        //let buffer = UnsafeMutablePointer<GLubyte>(malloc(backingWidth * backingHeight * 4))
        //imgBuffer  = UnsafeMutablePointer<GLubyte>(malloc(backingWidth * backingHeight * 4))
        //GLvoid *pixel_data = nil;
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        
        let cgBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.Last.rawValue)
        
        // RGBA.
        let componentsPerPixel = 4
        
        // 8-bit.
        let bitsPerComponent = 8
        
        let imageBits = NSMutableData(length: width * height * componentsPerPixel)!
        
        let dataProvider = CGDataProviderCreateWithCFData(imageBits)
        
        glReadPixels(0, 0, GLsizei(backingWidth), GLsizei(backingHeight), GLenum(GL_RGBA), SwiftGL.GL_UNSIGNED_BYTE,
            imageBits.mutableBytes)
        /*
        for var y=0; y<backingHeight; y++ {
            for var x=0; x<backingWidth*4; x++ {
                imgBuffer[y * 4 * backingWidth + x] =
                    buffer[(backingHeight - y - 1) * backingWidth * 4 + x];
            }
        }
        */
        let imageRef = CGImageCreate(width, height, bitsPerComponent, componentsPerPixel * bitsPerComponent, width * componentsPerPixel, colorSpace, cgBitmapInfo, dataProvider, nil, false, .RenderingIntentDefault)!
        
        /*
        
        
        let provider:CGDataProviderRef = CGDataProviderCreateWithData(nil, imgBuffer,
            backingWidth * backingHeight * 4,
            nil)!;
        
        
        // set up for CGImage creation
        let bitsPerPixel = 32;
        let bytesPerRow = 4 * backingWidth;
        
        let bitmapInfo = CGBitmapInfo.ByteOrderDefault.union(CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue))
        
        // Use this to retain alpha
        //CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast;
        let imageRef = CGImageCreate(backingWidth, backingHeight, bitsPerComponent, bitsPerPixel, bytesPerRow, CGColorSpaceCreateDeviceRGB(),bitmapInfo, provider, nil, false, CGColorRenderingIntent.RenderingIntentDefault)
        */
        // this contains our final image.
        
        //let img = UIImage(CGImage: imageRef, scale: 0.1, orientation: UIImageOrientation.Down)
        
        let img = scaleImage(UIImage(CGImage: imageRef), scale: 0.1)
        
       
        //free(buffer)
        let tock = CFAbsoluteTimeGetCurrent()
        DLog("save image duration\(tock-tick)")
        return img
    }
    func scaleImage(image:UIImage,scale:CGFloat)->UIImage{
        //let flipImage =
        let newSize = CGSize(width: Int(image.size.width * scale), height: Int(image.size.height * scale))
        
        UIGraphicsBeginImageContext(newSize)
        
        let context = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(context, 1, -1)
        CGContextTranslateCTM(context, 0, -newSize.height);
        
        //CGContextDrawImage(flipedContext, CGRect(origin: CGPoint.zero, size: newSize), image.CGImage);
        //let flippedImage = CGBitmapContextCreateImage(flipedContext)
        
        
        
        image.drawInRect(CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage;
    }

    func releaseImgBuffer()
    {
        free(imgBuffer)
    }
    
    deinit
    {
        /*
        context.renderbufferStorage(Int(GL_RENDERBUFFER), fromDrawable: nil)
        layer = nil
        renderTexture = nil
        context = nil
*/
        PaintToolManager.instance = nil
        GLRenderTextureFrameBuffer.instance = nil
        GLShaderBinder.instance = nil
    }
}