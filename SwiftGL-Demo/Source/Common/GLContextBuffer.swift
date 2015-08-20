//
//  GLContext.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/22.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import OpenGLES.ES2
import SwiftGL
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
        
        //
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER_ENUM, viewRenderbuffer);
        
        
        glGetRenderbufferParameteriv(GL_RENDERBUFFER_ENUM, GL_RENDERBUFFER_WIDTH, &backingWidth);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER_ENUM, GL_RENDERBUFFER_HEIGHT, &backingHeight);
        
        renderTexture = GLRenderTextureFrameBuffer(width: backingWidth, height: backingHeight)
        
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
    var rectTexture:Texture!
    func resizeLayer(layer:CAEAGLLayer)
    {
        // This call associates the storage for the current render buffer with the EAGLDrawable (our CAEAGLLayer)
        // allowing us to draw into a buffer that will later be rendered to screen wherever the layer is (which corresponds with our view).
        
        context.renderbufferStorage(Int(GL_RENDERBUFFER), fromDrawable: layer)
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER),GL_RENDERBUFFER_WIDTH, &backingWidth);
        glGetRenderbufferParameteriv(GLenum(GL_RENDERBUFFER), GL_RENDERBUFFER_HEIGHT, &backingHeight);
    }
    func drawLayers(){
        //drawTexture(Texture(filename: "spongebob"))
        
        
        for layer in renderTexture.layers
        {

            drawTexture(layer.texture,alpha: 1)
            if layer == renderTexture.currentLayer
            {
                drawTexture(renderTexture.tempLayer.texture,alpha: 0.5)
            }
        }
        
    }
    
    func drawBrushVertex(vertextBuffer:[PaintPoint])
    {
        GLShaderBinder.instance.bindBrush()
        GLShaderBinder.instance.bindVertexs(vertextBuffer)
        GLShaderBinder.instance.drawShader.useProgram()
        
        if renderTexture.setTempBuffer() == false{
            print("Framebuffer fail")
        }
        
        glDrawArrays(GL_POINTS, 0, Int32(vertextBuffer.count));

        //renderTexture.currentLayer.clean()
        //drawTexture(renderTexture.currentLayer.texture)
        //println("draw point count:\(vertextBuffer.count)")
    }
    
    /**
    when stroke end, draw the temp layer to the current layer
    */
    func endStroke()
    {
        drawTextureOnRenderTexture(renderTexture.tempLayer.texture,alpha: 0.5)
        renderTexture.tempLayer.clean()
    }
    //draw texture on the RenderTexture layer
    func drawTextureOnRenderTexture(texture:Texture,alpha:Float)
    {
        GLShaderBinder.instance.drawShader.useProgram()
        glEnable(GL_BLEND);
        glBlendFunc (GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        
        if renderTexture.setBuffer() == false{
            print("Framebuffer fail")
        }
        GLShaderBinder.instance.drawImageTexture(texture,alpha:alpha)
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
        glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
        glBindRenderbuffer(GL_RENDERBUFFER_ENUM, viewRenderbuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER_ENUM, viewRenderbuffer)
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
        
        //println("GLcontextBuffer:display")
        
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
    var imgBuffer:UnsafeMutablePointer<GLubyte>!
    func contextImage()->UIImage!
    {
        
        let backingWidth = Int(self.backingWidth)
        let backingHeight = Int(self.backingHeight)
        
        var buffer = UnsafeMutablePointer<GLubyte>(malloc(backingWidth * backingHeight * 4))
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
}