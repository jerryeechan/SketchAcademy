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
enum ApplicationMode{
    case ArtWorkCreation
    case InstructionTutorial
    case CreateTutorial
}
class GLContextBuffer{
    
    var paintToolManager:PaintToolManager!
    var imgWidth:GLint = 0
    var imgHeight:GLint = 0
    var paintCanvas:GLRenderCanvas!
    
    var rectTexture:Texture!
    var layer:CAEAGLLayer!
    let shaderBinder:GLShaderBinder
    let createCacheInterval = 400
    var lastCacheIndex = 0
    
    
    var canvasShiftX:Float = 0
    init() 
    {
        paintToolManager = PaintToolManager()
        if GLShaderBinder.instance != nil
        {
            shaderBinder = GLShaderBinder.instance
        }
        else
        {
            shaderBinder = GLShaderBinder()
        }
        shaderBinder.usePencil()
        
    }
    var mvp:Mat4!
    var mvpOffset:Mat4!
    func resizeLayer(width:GLint,height:GLint,offsetX:Float)
    {
        mvp = GLTransformation.instance.mvpMatrix
        if offsetX == 0
        {
            mvpOffset = mvp
        }
        else
        {
            mvpOffset = GLTransformation.instance.mvpShiftedMatrix
        }
        paintToolManager.load()
        paintToolManager.usePen()
        
        imgWidth = width
        imgHeight =  height
        
        paintCanvas = GLRenderCanvas(w:imgWidth, h:imgHeight)
        canvasShiftX = offsetX
        
        
        glEnable(GL_BLEND);
        glBlendEquation(GLenum(GL_FUNC_ADD))
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA)
        
    }
    
    /**
        draw all layers
        no need to bind any framebuffer, defaut done by GLKView
     */
    
    func drawLayersOfCanvas(canvas:GLRenderCanvas,mvp:Mat4)
    {
        shaderBinder.textureShader.bindMVP(mvp)
        if canvas.backgroundLayer != nil
        {
            drawTexture(canvas.backgroundLayer.texture, alpha: 1)
        }
        else
        {
            //white background
            glClearColor(1, 1, 1, 1)
            glClear(GL_COLOR_BUFFER_BIT )
        }
        for i in 0 ..< 1
        {
            let layer = canvas.layers[i]
            if(layer.enabled)
            {
                drawTexture(layer.texture,alpha: layer.alpha)
            }
        }
        if canvas.renderMode == .drawing
        {
            drawTexture(canvas.tempLayer.texture,alpha: 1)
        }
        if(canvas.revisionLayer.enabled)
        {
            DLog("draw revision---")
            drawTexture(canvas.revisionLayer.texture, alpha: 1)
        }
        
        //drawGrid(40)
    }
    
    
    
    /**
        draw the points
     */
    var drawVertexCount:Int = 0;
    func setReplayDrawSetting()
    {
        paintCanvas.renderMode = RenderMode.direct
    }
    
    func setBrushDrawSetting(toolType:PaintToolType)
    {
        switch(toolType)
        {
        case .pen:
                paintCanvas.renderMode = RenderMode.drawing
        case .eraser:
                paintCanvas.renderMode = RenderMode.direct
        case .smudge:
                paintCanvas.renderMode = RenderMode.direct
        }
        
    }
    var renderMode:RenderMode{
        get{
            return paintCanvas.renderMode
        }
    }
    
    
    var currentLayer = 0
    func renderStaticLine(points:[PaintPoint])
    {
        let vertexBuffer = interpolatePoints(points)
        drawBrushVertex(vertexBuffer,layer: currentLayer)
    }
    
    func drawBrushVertex(vertexBuffer:[PaintPoint],layer:Int)
    {
        if paintCanvas.renderMode == RenderMode.direct
        {
            if paintCanvas.setBuffer() == false{
                DLog("Framebuffer fail")
            }
        }
        else if paintCanvas.renderMode == RenderMode.drawing
        {
            if paintCanvas.setTempBuffer() == false{
                DLog("Framebuffer fail")
            }
        }
        renderVertex(vertexBuffer)
    }
    func renderLine(points:[PaintPoint])
    {
        
    }
    func renderVertex(vertexBuffer:[PaintPoint])
    {
        shaderBinder.currentBrushShader.bindBrush()
        shaderBinder.currentBrushShader.bindVertexs(vertexBuffer)
        shaderBinder.currentBrushShader.useShader()
        
        paintToolManager.useCurrentTool()
        glDrawArrays(GL_POINTS, 0, Int32(vertexBuffer.count));
        drawVertexCount += vertexBuffer.count

    }
    func renderStroke(stroke:PaintStroke)
    {
        
        drawStroke(stroke, layer: currentLayer)
    }
    /**
     draw a stroke into paintCanvas
     */
    func drawStroke(stroke:PaintStroke,layer:Int)
    {
        paintToolManager.changeTool(stroke.stringInfo.toolName)
        paintToolManager.loadToolValueInfo(stroke.valueInfo)
        paintToolManager.useCurrentTool()
        //glBlendFunc(GL_ONE, GL_ZERO)
        let vertexBuffer = interpolatePoints(stroke.points)//stroke.points
        drawVertexCount += stroke.points.count;
        
        shaderBinder.currentBrushShader.bindVertexs(vertexBuffer)
        shaderBinder.currentBrushShader.useShader()
        
        //paintCanvas.selectLayer(layer)
        if paintCanvas.setBuffer()==false{
            print("Framebuffer fail", terminator: "")
        }
        /*
        if paintCanvas.setTempBuffer() == false{
        print("Framebuffer fail")
        }
        */
        //glDrawArrays(GL_LINES, 0, Int32(vertexBuffer.count));
        glDrawArrays(GL_POINTS, 0, Int32(vertexBuffer.count));
    }

    /**
    when stroke end, draw the temp layer to the current layer
    */
    func endStroke()
    {
        drawTextureOnCurrentLayer(paintCanvas.tempLayer.texture, alpha: 1)
        paintCanvas.blankTempLayer()
    }
    func endStroke(leftTop:Vec4,rightBottom:Vec4)
    {
        drawTextureOnCurrentLayer(paintCanvas.tempLayer.texture,alpha: 1,leftTop:leftTop,rightBottom:rightBottom)
        paintCanvas.blankTempLayer()
    }
    func cleanTemp()
    {
        paintCanvas.blankTempLayer()
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
        for i in 0  ..< points.count-1 
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
            for j in 0 ..< count {
                //let randAngle = Float(arc4random()) / Float(UINT32_MAX) * Pi/2
                //let randAngle = Float(rand() % 360) / 360 * Pi
                
                let d = Float(j)/Float(count)
                let px = sp.position.x + disx*d //~~shifttest
                let py = sp.position.y+disy*d
                
                let v = PaintPoint(position: Vec4(px,py), force: force, altitude: altitude, azimuth: azimuth,velocity: velocity)
                
                vertexBuffer.append(v)
            }
        }
        return vertexBuffer
    }
    
        //draw texture on the paintCanvas layer
    func loadCacheFrame(atStroke:Int)
    {
        if paintCanvas.setBuffer()==false{
            DLog("Framebuffer fail")
        }
        clear()
        drawTexture(paintCanvas.caches[atStroke]!.texture,alpha:1)
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
        let layer = paintCanvas.genCacheFrame(atStroke)
        if paintCanvas.setBuffer(layer)==false{
            print("Framebuffer fail", terminator: "")
        }
        clear()
        drawTexture(paintCanvas.currentLayer.texture, alpha: 1)
    }
    func clearCacheFrame(atStroke:Int)
    {
        
    }
   
    func drawTextureOnCurrentLayer(texture:Texture,alpha:Float)
    {
        glEnable(GL_BLEND);
        glBlendEquation(GLenum(GL_FUNC_ADD))
        glBlendFunc (GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        
        if paintCanvas.setBuffer() == false{
            DLog("Framebuffer fail")
        }
        shaderBinder.textureShader.bindMVP(mvp)
        shaderBinder.textureShader.bindImageTexture(texture, alpha: alpha)
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
    func drawTextureOnCurrentLayer(texture:Texture,alpha:Float,leftTop:Vec4,rightBottom:Vec4)
    {
        glEnable(GL_BLEND);
        glBlendEquation(GLenum(GL_FUNC_ADD))
        glBlendFunc (GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        
        if paintCanvas.setBuffer() == false{
            DLog("Framebuffer fail")
        }
        shaderBinder.textureShader.bindMVP(mvp)
        shaderBinder.textureShader.bindImageTexture(texture,alpha:alpha,leftTop:leftTop,rightBottom:rightBottom)
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
   
    func drawTexture(texture:Texture,alpha:Float)
    {
        glEnable(GL_BLEND);
        glBlendEquation(GLenum(GL_FUNC_ADD))
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA)
        shaderBinder.textureShader.bindMVP(mvpOffset)
        shaderBinder.textureShader.bindImageTexture(texture,alpha:alpha)
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4)
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
        
        //redraw all layers
        
        drawLayersOfCanvas(paintCanvas, mvp: mvpOffset)
        
        drawVertexCount = 0
    }
    func clear()
    {
        glClearColor(0, 0, 0, 0)
        glClear(GL_COLOR_BUFFER_BIT )//| GL_DEPTH_BUFFER_BIT)
    }
    func blank()
    {
        paintCanvas.blankCurrentLayer()    
    }
    
    func setArtworkMode()
    {
        paintCanvas.revisionLayer.enabled = false
        paintCanvas.selectLayer(0)
        paintCanvas.setAllLayerAlpha(1)
    }
    func setRevisionMode()
    {
        paintCanvas.revisionLayer.enabled = true
        paintCanvas.setAllLayerAlpha(0.5)
        paintCanvas.selectRevisionLayer()
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
        let width = Int(self.imgWidth)
        let height = Int(self.imgHeight)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let cgBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.Last.rawValue)
        
        // RGBA.
        let componentsPerPixel = 4
        
        // 8-bit.
        let bitsPerComponent = 8
        
        let imageBits = NSMutableData(length: width * height * componentsPerPixel)!
        
        let dataProvider = CGDataProviderCreateWithCFData(imageBits)
        
        glReadPixels(0, 0, GLsizei(imgWidth), GLsizei(imgHeight), GLenum(GL_RGBA), SwiftGL.GL_UNSIGNED_BYTE,
            imageBits.mutableBytes)
        
        let imageRef = CGImageCreate(width, height, bitsPerComponent, componentsPerPixel * bitsPerComponent, width * componentsPerPixel, colorSpace, cgBitmapInfo, dataProvider, nil, false, .RenderingIntentDefault)!
        
        
        let img = scaleImage(UIImage(CGImage: imageRef), scale: 0.2)
        
       
        //free(buffer)
        let tock = CFAbsoluteTimeGetCurrent()
        DLog("save image duration\(tock-tick)")
        return img
    }
    
    func releaseImgBuffer()
    {
        free(imgBuffer)
    }
    
    deinit
    {
        GLShaderBinder.instance = nil
        /*
        context.renderbufferStorage(Int(GL_RENDERBUFFER), fromDrawable: nil)
        layer = nil
        paintCanvas = nil
        context = nil
*/
//        PaintToolManager.instance = nil
        //GLpaintCanvasFrameBuffer.instance = nil
    }
}

func scaleImage(image:UIImage,scale:CGFloat)->UIImage{
    //let flipImage =
    let newSize = CGSize(width: Int(image.size.width * scale), height: Int(image.size.height * scale))
    
    UIGraphicsBeginImageContext(newSize)
    
    
    //Fliping the context y-axis
    //let context = UIGraphicsGetCurrentContext();
    //CGContextScaleCTM(context, 1, -1)
    //CGContextTranslateCTM(context, 0, -newSize.height);
    
    
    image.drawInRect(CGRect(origin: CGPoint.zero, size: newSize))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage;
}
