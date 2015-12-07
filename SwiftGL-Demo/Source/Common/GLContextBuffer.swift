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
    var context:EAGLContext!;
    
    var viewFramebuffer:GLuint = 0
    var viewRenderbuffer:GLuint = 0
    var backingWidth:GLint = 0
    var backingHeight:GLint = 0
    var renderTexture:GLRenderTextureFrameBuffer!
    var layer:CAEAGLLayer!
    init(context:EAGLContext,layer:CAEAGLLayer)
    {
        self.context = context
        self.layer = layer
        GLContextBuffer.instance = self
        glGenFramebuffers(1, &viewFramebuffer)
        glGenRenderbuffers(1, &viewRenderbuffer)
        
        glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
        glBindRenderbuffer(GL_RENDERBUFFER_ENUM, viewRenderbuffer);
        
        
        //use context as render buffer storage
        context.renderbufferStorage(Int(GL_RENDERBUFFER), fromDrawable: layer)
        
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER_ENUM, viewRenderbuffer);
        
        //print("inti \(backingWidth) \(backingHeight)")
        
    }
    var rectTexture:Texture!
    func resizeLayer(layer:CAEAGLLayer)
    {
        // This call associates the storage for the current render buffer with the EAGLDrawable (our CAEAGLLayer)
        // allowing us to draw into a buffer that will later be rendered to screen wherever the layer is (which corresponds with our view).
        
        context.renderbufferStorage(Int(GL_RENDERBUFFER), fromDrawable: layer)
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER),GL_RENDERBUFFER_WIDTH, &backingWidth);
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GL_RENDERBUFFER_HEIGHT, &backingHeight);
        
        renderTexture = GLRenderTextureFrameBuffer(w: backingWidth, h: backingHeight)
        
        GLShaderBinder.instance.initVertex()
        
//        print("renderTexture frame: \(backingWidth) \(backingHeight)")
        if glCheckFramebufferStatus(GL_FRAMEBUFFER) != GLenum(GL_FRAMEBUFFER_COMPLETE)
        {
            print("failed to make complete framebuffer object\(glCheckFramebufferStatus(GL_FRAMEBUFFER))");
        }
        blank()
        
        if (RefImgManager.instance.rectImg != nil)
        {
            rectTexture = Texture(image: RefImgManager.instance.rectImg)
            renderTexture.addImageLayer(rectTexture)
        }
    }
    
    /**
        draw all layers
     */
    
    func drawLayers(){
        drawTexture(renderTexture.backgroundLayer.texture,alpha: 1)
        //glClearColor(1, 1, 1, 1)
        //glClear(GL_COLOR_BUFFER_BIT )//| GL_DEPTH_BUFFER_BIT)

        for layer in renderTexture.layers
        {
            
            if(layer.enabled)
            {
                
                drawTexture(layer.texture,alpha: layer.alpha)
            }
            /*
            if layer == renderTexture.currentLayer
            {
                drawTexture(renderTexture.tempLayer.texture,alpha: 1)
            }*/
        }
        if(renderTexture.revisionLayer.enabled)
        {
            drawTexture(renderTexture.revisionLayer.texture, alpha: 1)
        }
    }
    /**
        draw the points
     */
    
    func drawBrushVertex(vertexBuffer:[PaintPoint],layer:Int)
    {
        GLShaderBinder.instance.bindBrush()
        GLShaderBinder.instance.bindVertexs(vertexBuffer)
        GLShaderBinder.instance.drawShader.useProgram()
        PaintToolManager.instance.useCurrentTool()
        //renderTexture.selectLayer(layer)
        if renderTexture.setBuffer() == false{
            print("Framebuffer fail")
        }
        
        glDrawArrays(GL_POINTS, 0, Int32(vertexBuffer.count));
        //glDrawArraysInstanced(GL_POINTS, 0, Int32(vertexBuffer.count), 1)
        //renderTexture.currentLayer.clean()
        //drawTexture(renderTexture.currentLayer.texture)
        //println("draw point count:\(vertextBuffer.count)")
    }
    
    /**
    when stroke end, draw the temp layer to the current layer
    */
    func endStroke()
    {
        drawTextureOnRenderTexture(renderTexture.tempLayer.texture, alpha: 1)
        //renderTexture.blankTempLayer()
    }
    func endStroke(leftTop:Vec4,rightBottom:Vec4)
    {
        drawTextureOnRenderTexture(renderTexture.tempLayer.texture,alpha: 1,leftTop:leftTop,rightBottom:rightBottom)
        renderTexture.blankTempLayer()
        
    }
    //var vertexBuffer:[PaintPoint]!
    func interpolatePoints(stroke:PaintStroke)->[PaintPoint]
    {
        var vertexBuffer:[PaintPoint] = []
        let kBrushPixelStep:Float = 10
        var left:Float = stroke.points.last!.position.x
        var right:Float = stroke.points.last!.position.x
        var top:Float = stroke.points.last!.position.y
        var bottom:Float = stroke.points.last!.position.y
        
        srand(0)
        for var i = 0 ; i < stroke.points.count-1 ; i++
        {
            if stroke.points[i].position.x < left
            {
                left = stroke.points[i].position.x
            }
            else if stroke.points[i].position.x > right
            {
                right = stroke.points[i].position.x
            }
            
            if stroke.points[i].position.y < top
            {
                top = stroke.points[i].position.y
            }
            else if stroke.points[i].position.y > bottom
            {
                bottom = stroke.points[i].position.y
            }
            
            let ep = stroke.points[i]
            let sp = stroke.points[i+1]
            
            var count:Int;
            
            // Convert locations from Points to Pixels
            /* CGFloat scale = self.contentScaleFactor;
            start.x *= scale;
            start.y *= scale;
            end.x *= scale;
            end.y *= scale;*/
            
            //var sp = start*scale
            //var ep = end*scale
            
            
            let xdis2 = powf((ep.position.x - sp.position.x),2)
            
            let ydis2 = powf((ep.position.y - sp.position.y),2)
            
            // Add points to the buffer so there are drawing points every X pixels
            let pnum = ceil(sqrt(xdis2 + ydis2) / kBrushPixelStep)
            count = max(Int(pnum),1);
            
            for var j = 0; j < count; ++j {
                //let randAngle = Float(arc4random()) / Float(UINT32_MAX) * Pi/2
                let randAngle = Float(rand() % 360) / 360 * Pi/2
                let d = Float(j)/Float(count)
                let px = sp.position.x+(ep.position.x-sp.position.x)*d
                let py = sp.position.y+(ep.position.y-sp.position.y)*d
                let v = PaintPoint(position: Vec4(px,py),color: sp.color,size: sp.size, rotation: randAngle)
                
                vertexBuffer.append(v)
            }
            
        }
        return vertexBuffer
    }
    
    /**
        draw stroke
     */
    func drawStroke(stroke:PaintStroke,layer:Int)
    {
        //glBlendFunc(GL_ONE, GL_ZERO)
        let vertexBuffer = interpolatePoints(stroke)//stroke.points
       // print("draw stroke with layer\(layer)")
        
        //GLShaderBinder.instance.bindBrushInfo(stroke.valueInfo)
        //GLShaderBinder.instance.bindBrush()
        
        
        GLShaderBinder.instance.bindVertexs(vertexBuffer)
        GLShaderBinder.instance.drawShader.useProgram()
        
        //renderTexture.selectLayer(layer)
        if renderTexture.setBuffer()==false{
         print("Framebuffer fail")
        }
        
        /*
        if renderTexture.setTempBuffer() == false{
            print("Framebuffer fail")
        }
        */
        
        glDrawArrays(GL_POINTS, 0, Int32(vertexBuffer.count));
        //endStroke(Vec4(left,top),rightBottom: Vec4(right,bottom))
        //endStroke()
       // renderTexture.tempLayer.clean()
    }
    //draw texture on the RenderTexture layer
    func drawTextureOnRenderTexture(texture:Texture,alpha:Float)
    {
        glEnable(GL_BLEND);
        glBlendEquation(GLenum(GL_FUNC_ADD))
        glBlendFunc (GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        
        if renderTexture.setBuffer() == false{
            print("Framebuffer fail")
        }
        
        GLShaderBinder.instance.drawImageTexture(texture, alpha: alpha)
    }
    func drawTextureOnRenderTexture(texture:Texture,alpha:Float,leftTop:Vec4,rightBottom:Vec4)
    {
        glEnable(GL_BLEND);
        glBlendEquation(GLenum(GL_FUNC_ADD))
        glBlendFunc (GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        
        if renderTexture.setBuffer() == false{
            print("Framebuffer fail")
        }
        GLShaderBinder.instance.drawImageTexture(texture,alpha:alpha,leftTop:leftTop,rightBottom:rightBottom)
    }
    
    func drawRectangle(rect:GLRect)
    {
        
        let leftTop = rect.leftTop
        let rightButtom = rect.rightButtom
        var vertexBuffer:[PaintPoint] = []
        
        vertexBuffer.append(PaintPoint(position:Vec4(leftTop.x,leftTop.y),color: Color(0,0,0,1).vec,size: 5, rotation: 0))
        vertexBuffer.append(PaintPoint(position:Vec4(leftTop.x,rightButtom.y),color: Color(0,0,0,1).vec,size: 5, rotation: 0))
        
        vertexBuffer.append(PaintPoint(position:Vec4(rightButtom.x,rightButtom.y),color: Color(0,0,0,1).vec,size: 5, rotation: 0))
        
        vertexBuffer.append(PaintPoint(position:Vec4(rightButtom.x,leftTop.y),color: Color(0,0,0,1).vec,size: 5, rotation: 0))
        
        if renderTexture.setBuffer() == false{
            print("Framebuffer fail")
        }
        
        GLShaderBinder.instance.bindBrush()
        GLShaderBinder.instance.bindBrushColor(Vec4(0,0,0,1))
        GLShaderBinder.instance.drawShader.useProgram()
        GLShaderBinder.instance.bindVertexs(vertexBuffer)
        
        //glLineWidth(8)
        glDrawArrays(GL_LINE_LOOP, 0, 4)
    }
    
    func drawTexture(texture:Texture,alpha:Float)
    {
        //print("drawTexture\(texture.id)")
        glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
        glBindRenderbuffer(GL_RENDERBUFFER_ENUM, viewRenderbuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
            GL_RENDERBUFFER_ENUM, viewRenderbuffer)
        
        glBlendEquation(GLenum(GL_FUNC_ADD))
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA)
        
        //blank()  //blank to test if texture can be draw
        
        GLShaderBinder.instance.drawImageTexture(texture,alpha:alpha)
    }
    
    func display()
    {
        glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
        glBindRenderbuffer(GL_RENDERBUFFER_ENUM, viewRenderbuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER_ENUM, viewRenderbuffer);
        
        glEnable(GL_BLEND);
        glBlendFunc (GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        clear()
        drawLayers()
        EAGLContext.setCurrentContext(context)

        context.presentRenderbuffer(Int(GL_RENDERBUFFER));
    }
    func clear()
    {
        glClearColor(0, 0, 0, 0)
        glClear(GL_COLOR_BUFFER_BIT )//| GL_DEPTH_BUFFER_BIT)
    }
    func blank()
    {
        glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
        glBindRenderbuffer(GL_RENDERBUFFER_ENUM, viewRenderbuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER_ENUM, viewRenderbuffer);
        
        EAGLContext.setCurrentContext(context)
        
        glClearColor(1, 1, 1, 1)
        glClear(GL_COLOR_BUFFER_BIT )//| GL_DEPTH_BUFFER_BIT)
        
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
        let backingWidth = Int(self.backingWidth)
        let backingHeight = Int(self.backingHeight)
        
        let buffer = UnsafeMutablePointer<GLubyte>(malloc(backingWidth * backingHeight * 4))
        imgBuffer  = UnsafeMutablePointer<GLubyte>(malloc(backingWidth * backingHeight * 4))
        //GLvoid *pixel_data = nil;
        
        glReadPixels(0, 0, GLsizei(backingWidth), GLsizei(backingHeight), GLenum(GL_RGBA), SwiftGL.GL_UNSIGNED_BYTE,
            buffer)
        
        for var y=0; y<backingHeight; y++ {
            for var x=0; x<backingWidth*4; x++ {
                imgBuffer[y * 4 * backingWidth + x] =
                    buffer[(backingHeight - y - 1) * backingWidth * 4 + x];
            }
        }
        
        
        let provider:CGDataProviderRef = CGDataProviderCreateWithData(nil, imgBuffer,
            backingWidth * backingHeight * 4,
            nil)!;
        
        
        // set up for CGImage creation
        let bitsPerComponent = 8;
        let bitsPerPixel = 32;
        let bytesPerRow = 4 * backingWidth;
        
        let bitmapInfo = CGBitmapInfo.ByteOrderDefault.union(CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue))
        
        // Use this to retain alpha
        //CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast;
        let imageRef = CGImageCreate(backingWidth, backingHeight, bitsPerComponent, bitsPerPixel, bytesPerRow, CGColorSpaceCreateDeviceRGB(),bitmapInfo, provider, nil, false, CGColorRenderingIntent.RenderingIntentDefault)
        
        // this contains our final image.
        let img = UIImage(CGImage: imageRef!)
        free(buffer)
        
        return img
    }
    func releaseImgBuffer()
    {
        free(imgBuffer)
    }
    
    deinit
    {
        context.renderbufferStorage(Int(GL_RENDERBUFFER), fromDrawable: nil)
        renderTexture = nil
        context = nil
    }
}