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
public enum ApplicationMode{
    case artWorkCreation
    case instructionTutorial
    case createTutorial
}
public class GLContextBuffer{
    
    public var paintToolManager:PaintToolManager!
    public var imgWidth:GLint = 0
    public var imgHeight:GLint = 0
    public var paintCanvas:GLRenderCanvas!
    
    var rectTexture:Texture!
    public var layer:CAEAGLLayer!
    let shaderBinder:GLShaderBinder
    let createCacheInterval = 400
    var lastCacheIndex = 0
    
    
    public var canvasShiftX:Float = 0
    public init()
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
    }
    var mvp:Mat4!
    var mvpOffset:Mat4!
    public func resizeLayer(_ width:GLint,height:GLint,offsetX:Float)
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
        
        
        glEnable((GL_BLEND));
        glBlendEquation((GLenum(GL_FUNC_ADD)))
        glBlendFunc((GL_ONE), (GL_ONE_MINUS_SRC_ALPHA))
        
    }
    
    /**
        draw all layers
        no need to bind any framebuffer, defaut done by GLKView
     */
    var currentBG = false
    public func switchBG()
    {
        if currentBG
        {paintCanvas.changeBackground("paper_sketch")}
        else
        {paintCanvas.changeBackground("blackpaper")}
        currentBG = !currentBG
        display()
    }
    public func drawLayersOfCanvas(_ canvas:GLRenderCanvas,mvp:Mat4)
    {
        //start of drawing loop
        shaderBinder.textureShader.bindMVP(mvp)
        if canvas.backgroundLayer != nil
        {
            drawTexture(canvas.backgroundLayer.texture, alpha: 1)
        }
        else
        {
            //white background
            glClearColor(1, 0, 1, 1)
            glClear(GL_COLOR_BUFFER_BIT)
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
        
        
        if((penAzimuth) != nil)
        {
            
            //drawFillRectangle(GLRect(p1: Vec2(Float(imgWidth/2),Float(imgHeight/2)),p2: azimuth.xy), color: Vec4(1,0,0,0))
            //let center = Vec4(Float(imgWidth/2),Float(imgHeight/2))
            //print("drawline\(penPos)\(penAzimuth)")
            //drawLine(penPos+Vec4(0,0,0,1),end:penPos+Vec4(penAzimuth.x,-penAzimuth.y,0,0)*100+Vec4(0,0,0,1))
            //drawGrid(60)
        }
 
        
    }
    public var penAzimuth:Vec2!
    public var penPos:Vec4!
    /**
        draw the points
     */
    var drawVertexCount:Int = 0;
    public func setReplayDrawSetting()
    {
        paintCanvas.renderMode = RenderMode.direct
    }
    
    public func setBrushDrawSetting(_ toolType:BrushType)
    {
        switch(toolType)
        {
        case .pencil:
                paintCanvas.renderMode = RenderMode.drawing
        case .eraser:
                paintCanvas.renderMode = RenderMode.direct
        default :
                paintCanvas.renderMode = RenderMode.drawing
        //case .:
          //      paintCanvas.renderMode = RenderMode.direct
        }
        
    }
    public var renderMode:RenderMode{
        get{
            return paintCanvas.renderMode
        }
    }
    
    
    var currentLayer = 0
    public func renderStaticLine(_ points:[PaintPoint])
    {
        
        let vertexBuffer = interpolatePoints(points)
        drawBrushVertex(vertexBuffer,layer: currentLayer)
    }
    
    public func drawBrushVertex(_ vertexBuffer:[PaintPoint],layer:Int)
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
    public func renderLine(_ points:[PaintPoint])
    {
        
    }
    
    public func renderVertex(_ vertexBuffer:[PaintPoint])
    {
       
        shaderBinder.currentBrushShader.bindBrush()
        shaderBinder.currentBrushShader.bindVertexs(vertexBuffer)
        shaderBinder.currentBrushShader.useShader()
       

        paintToolManager.useCurrentTool()
        glDrawArrays((GL_POINTS), 0, Int32(vertexBuffer.count));
        drawVertexCount += vertexBuffer.count

    }
    public func renderStroke(_ stroke:PaintStroke)
    {
        
        drawStroke(stroke, layer: currentLayer)
    }
    /**
     draw a stroke into paintCanvas
     */
    public func drawStroke(_ stroke:PaintStroke,layer:Int)
    {
        penAzimuth = stroke.points.last?.azimuth
        
        penPos = stroke.points.last?.position
        _ = paintToolManager.changeTool(stroke.stringInfo.toolName)
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
        glDrawArrays((GL_POINTS), 0, Int32(vertexBuffer.count));
    }

    /**
    when stroke end, draw the temp layer to the current layer
    */
    public func endStroke()
    {
        drawTextureOnCurrentLayer(paintCanvas.tempLayer.texture, alpha: 1)
        paintCanvas.blankTempLayer()
    }
    public func endStroke(_ leftTop:Vec4,rightBottom:Vec4)
    {
        drawTextureOnCurrentLayer(paintCanvas.tempLayer.texture,alpha: 1,leftTop:leftTop,rightBottom:rightBottom)
        paintCanvas.blankTempLayer()
    }
    public func cleanTemp()
    {
        paintCanvas.blankTempLayer()
    }
    public func interpolatePoints(_ points:[PaintPoint])->[PaintPoint]
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
            let dis = sqrt(xdis2+ydis2)
            let pnum = ceil(dis / kBrushPixelStep)
            
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
    public func loadCacheFrame(_ atStroke:Int)
    {
        if paintCanvas.setBuffer()==false{
            DLog("Framebuffer fail")
        }
        clear()
        drawTexture(paintCanvas.caches[atStroke]!.texture,alpha:1)
    }
    
    public func checkCache(_ strokeNum:Int)
    {
        if strokeNum - lastCacheIndex > createCacheInterval
        {
            saveCacheFrame(strokeNum)
            lastCacheIndex = strokeNum
            
        }
    }
    var image:UIImage!
    public func saveCacheFrame(_ atStroke:Int)
    {
        let layer = paintCanvas.genCacheFrame(atStroke)
        if paintCanvas.setBuffer(layer!)==false{
            print("Framebuffer fail", terminator: "")
        }
        clear()
        drawTexture(paintCanvas.currentLayer.texture, alpha: 1)
    }
    public func clearCacheAll()
    {
        paintCanvas.caches = [:]
    }
    public func clearCacheFrame(_ atStroke:Int)
    {
        
    }
   
    public func drawTextureOnCurrentLayer(_ texture:Texture,alpha:Float)
    {
        glEnable(GL_BLEND);
        glBlendEquation((GLenum(GL_FUNC_ADD)))
        glBlendFunc (GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
        
        if paintCanvas.setBuffer() == false{
            DLog("Framebuffer fail")
        }
        shaderBinder.textureShader.bindMVP(mvp)
        shaderBinder.textureShader.bindImageTexture(texture, alpha: alpha)
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
    public func drawTextureOnCurrentLayer(_ texture:Texture,alpha:Float,leftTop:Vec4,rightBottom:Vec4)
    {
        glEnable(GL_BLEND);
        glBlendEquation((GLenum(GL_FUNC_ADD)))
        glBlendFunc ((GL_ONE), (GL_ONE_MINUS_SRC_ALPHA));
        
        if paintCanvas.setBuffer() == false{
            DLog("Framebuffer fail")
        }
        shaderBinder.textureShader.bindMVP(mvp)
        shaderBinder.textureShader.bindImageTexture(texture,alpha:alpha,leftTop:leftTop,rightBottom:rightBottom)
        glDrawArrays((GL_TRIANGLE_STRIP), 0, 4);
    }
   
    public func drawTexture(_ texture:Texture,alpha:Float)
    {
        glEnable((GL_BLEND));
        glBlendEquation((GLenum(GL_FUNC_ADD)))
        glBlendFunc((GL_ONE), (GL_ONE_MINUS_SRC_ALPHA))
        shaderBinder.textureShader.bindMVP(mvpOffset)
        shaderBinder.textureShader.bindImageTexture(texture,alpha:alpha)
        glDrawArrays((GL_TRIANGLE_STRIP), 0, 4)
    }
        
    public func setRenderBufferToTarget()
    {
        /*
        glBindFramebuffer(GL_FRAMEBUFFER, viewFramebuffer);
        glBindRenderbuffer(GL_RENDERBUFFER_ENUM, viewRenderbuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER_ENUM, viewRenderbuffer);
        */

    }
    public func display()
    {
        //setRenderBufferToTarget()
        
        //redraw all layers
        
        drawLayersOfCanvas(paintCanvas, mvp: mvpOffset)
        
        drawVertexCount = 0
    }
    public func clear()
    {
        glClearColor(0, 0, 0, 0)
        glClear(GL_COLOR_BUFFER_BIT)//| GL_DEPTH_BUFFER_BIT)
    }
    public func blank()
    {
        paintCanvas.blankTempLayer()
        paintCanvas.blankCurrentLayer()    
    }
    
    public func setArtworkMode()
    {
        paintCanvas.revisionLayer.enabled = false
        paintCanvas.selectLayer(0)
        paintCanvas.setAllLayerAlpha(1)
    }
    public func setRevisionMode()
    {
        paintCanvas.revisionLayer.enabled = true
        paintCanvas.setAllLayerAlpha(0.5)
        paintCanvas.selectRevisionLayer()
    }
    public func getPixelColor(_ x:GLint,y:GLint)->UIColor
    {
        var pixels:[GLubyte] = [0,0,0,0]
        glReadPixels(x, y, 1, 1, (GLenum(GL_RGBA)), (GL_UNSIGNED_BYTE), &pixels)
        
        return UIColor(red: CGFloat(pixels[0])/255, green: CGFloat(pixels[1])/255, blue: CGFloat(pixels[2])/255, alpha: CGFloat(pixels[3])/255)
    }
    var imgBuffer:UnsafeMutablePointer<GLubyte>!
    public func contextImage()->UIImage!
    {
        let tick = CFAbsoluteTimeGetCurrent()
        let width = Int(self.imgWidth)
        let height = Int(self.imgHeight)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let cgBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.last.rawValue)
        
        // RGBA.
        let componentsPerPixel = 4
        
        // 8-bit.
        let bitsPerComponent = 8
        
        let imageBits = NSMutableData(length: width * height * componentsPerPixel)!
        
        let dataProvider = CGDataProvider(data: imageBits)
        
        glReadPixels(0, 0, GLsizei(imgWidth), GLsizei(imgHeight), (GLenum(GL_RGBA)), SwiftGL.GL_UNSIGNED_BYTE,
            imageBits.mutableBytes)
        
        let imageRef = CGImage(width: width, height: height, bitsPerComponent: bitsPerComponent, bitsPerPixel: componentsPerPixel * bitsPerComponent, bytesPerRow: width * componentsPerPixel, space: colorSpace, bitmapInfo: cgBitmapInfo, provider: dataProvider!, decode: nil, shouldInterpolate: false, intent: .defaultIntent)!
        
        
        let img = scaleImage(image:UIImage(cgImage: imageRef), scale: 0.2)
        
       
        //free(buffer)
        let tock = CFAbsoluteTimeGetCurrent()
        DLog("save image duration\(tock-tick)")
        return img
    }
    
    public func releaseImgBuffer()
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


