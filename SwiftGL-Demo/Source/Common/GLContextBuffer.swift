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
    case practiceCalligraphy
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
    
    func EnglishCalligraphyHelpingLine()
    {
        var ps1:[Vec4] = []
        let height = imgHeight/2-300
        for i in [0,2,4,5,6]
        {
            ps1.append(Vec4(0.0,Float(i*100+height)))
            ps1.append(Vec4(Float(imgWidth),Float(i*100+height)))
    
        }
        drawLines(ps1, lineType: GL_LINES,width: 4,color: Vec4(0.2,0.2,0.2,0.5))
    }
    func ChineseCalligraphyHelpingLine(offsetX:Float)
    {
        let size:Float = 1200
        let x_offset = Float(imgWidth/2) - size/2 + offsetX
        let y_offset = Float(imgHeight/2) - size/2
        let topLeft = Vec4(x_offset,y_offset)
        let topRight = Vec4(x_offset+size,y_offset)
        let bottomLeft = Vec4(x_offset,y_offset+size)
        let bottomRight = Vec4(x_offset+size,y_offset+size)
        
        let top1 = topLeft+Vec4(size/3,0,0,0)
        let top2 = topLeft+Vec4(size/3*2,0,0,0)
        
        let bottom1 = bottomLeft+Vec4(size/3,0,0,0)
        let bottom2 = bottomLeft+Vec4(size/3*2,0,0,0)
        
        let left1 = topLeft+Vec4(0,size/3,0,0)
        let left2 = topLeft+Vec4(0,size/3*2,0,0)
        
        let right1 = topRight+Vec4(0,size/3,0,0)
        let right2 = topRight+Vec4(0,size/3*2,0,0)
        
        
        let ps1:[Vec4] = [topLeft,topRight,bottomRight,bottomLeft]
        //let ps2:[Vec4] = [bottomRight,topLeft,bottomLeft,topRight]
        let ps2:[Vec4] = [top1,bottom1,top2,bottom2,left1,right1,left2,right2]
        
        //drawLines([centerTop,centerBottom,centerleft,centerRight], lineType: GL_LINES,width: 4,color: Vec4(1,0,0,1))
        drawLines(ps1, lineType: GL_LINE_LOOP,width: 4,color: Vec4(1,0,0,1))
        
        drawLines(ps2, lineType: GL_LINES,width: 2,color: Vec4(1,0,0,1))
    }
    var helpingLine = 1;
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
        
        //
        
        //EnglishCalligraphyHelpingLine()
        //ChineseCalligraphyHelpingLine(offsetX: -700.0)
        //ChineseCalligraphyHelpingLine(offsetX: 700.0)
        
        
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
        
        if cp1 != nil
        {
            drawColorPicker(x: cp1.x, y: cp1.y,color:Vec4(0,0,1,1))
        }
        if cp2 != nil
        {
            drawColorPicker(x: cp2.x, y: cp2.y,color:Vec4(1,0,0,1))
        }
        
        
        if((penPos) != nil)
        {
            /*
            let diff = (penAzimuth-Vec2(0.7,0.7)).length2
            
            var color = Vec4(0.2,0.8,0.2,1)
            if(diff > 0.025)
            {
                color = Vec4(0.8,0.2,0.2,1)
            }
            DLog("\(diff)")
            let dir = Vec4(0.7,-0.7,0,0)
            drawLines([penPos-dir*90,penPos-dir*50,penPos,penPos+dir*800], lineType: GL_LINES, width: 40, color: color)
            */
            //drawLine(,end:+Vec4(0,0,0,0))
            //drawFillRectangle(GLRect(p1: Vec2(Float(imgWidth/2),Float(imgHeight/2)),p2: azimuth.xy), color: Vec4(1,0,0,0))
            //let center = Vec4(Float(imgWidth/2),Float(imgHeight/2))
            //print("drawline\(penPos)\(penAzimuth)")
            
            //drawGrid(60)
        }
        
        
    }
    func drawColorPicker(x:Float,y:Float,color:Vec4)
    {
        let size:Float = 40.0
        drawLineRectangle(GLRect(p1: Vec2(Float(x)-size,Float(y)-size),p2:Vec2(Float(x)+size,Float(y)+size)), color: color)
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
    var colorPicker:UIColor!
    public func renderVertex(_ vertexBuffer:[PaintPoint])
    {
       
        shaderBinder.currentBrushShader.bindBrush()
        shaderBinder.currentBrushShader.bindVertexs(vertexBuffer)
        shaderBinder.currentBrushShader.useShader()
        penPos = vertexBuffer.last?.position
        penAzimuth = vertexBuffer.last?.azimuth
        
        
        if penPos != nil
        {
           //colorPicker = getPixelColor(GLint((penPos.x)), y: GLint((penPos.y)))
        }
        
        paintToolManager.useCurrentTool()
        glDrawArrays((GL_POINTS), 0, Int32(vertexBuffer.count));
        drawVertexCount += vertexBuffer.count
    }
    public func renderStroke(_ stroke:PaintStroke)
    {
        if(stroke.points.count<2)
        {return}
        drawStroke(stroke, layer: currentLayer)
    }
    /**
     draw a stroke into paintCanvas
     */
    
    public var forceBrush:Bool = false
    public func drawStroke(_ stroke:PaintStroke,layer:Int)
    {
        penAzimuth = stroke.points.last?.azimuth
        
        penPos = stroke.points.last?.position
        if forceBrush
        {
            paintToolManager.changeTool(BrushType.calligraphyEdge.rawValue)
        }
        else
        {
            paintToolManager.changeTool(stroke.stringInfo.toolName)
        }
        
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
    public func setTraceMode()
    {
        paintCanvas.revisionLayer.enabled = true
        paintCanvas.setAllLayerAlpha(1)
        paintCanvas.selectRevisionLayer()
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
    var cp1:Vec2!
    var cp2:Vec2!
    var turn:Int = 0
    public func getPixelColor(_ x:GLint,y:GLint)->UIColor
    {
        if turn == 0
        {
            cp1 = Vec2(Float(x),Float(y))
            turn = 1
        }
        else
        {
            cp2 = Vec2(Float(x),Float(y))
            turn = 0
            
        }
        
        
        _ = paintCanvas.setBuffer()
        var pixels:[GLubyte] = [0,0,0,0]
        glReadPixels(x, y, 1, 1, (GLenum(GL_RGBA)), (GL_UNSIGNED_BYTE), &pixels)
        DLog("\(pixels)")
        paintCanvas.setTempBuffer()
        
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


