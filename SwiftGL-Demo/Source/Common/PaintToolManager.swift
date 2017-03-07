//
//  PaintToolManager.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/29.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import Foundation
import OpenGLES.ES2
import SwiftGL
import UIKit
import PaintStrokeData
/*
enum PaintToolType:Int{
    case pen = 0,eraser,oil,smudge
}*/
public enum BrushType:String
{
    case pencil = "pen",oilBrush="oilbrush",eraser="eraser",calligraphy="calligraphy",flatpen="flatpen",calligraphyEdge="calligraphyEdge",calligraphyColor="calligraphyColor",chinesebrush="chinesebrush"
}
open class PaintToolManager {
    
    let brushTextureLoader:BrushTextureLoader = BrushTextureLoader()
    
    var colorInPalette:Color = Color(25,25,25,125)
    var pen:PaintBrush!
    var eraser:PaintBrush!
    var oilbrush:PaintBrush!
    
    public var lastBrush:PaintBrush!
    public var currentTool:PaintBrush!
//    static var instance:PaintToolManager!
    public init()
    {
//        PaintToolManager.instance = self
    }
    public func load()
    {
        //pen = PaintBrush(textureName: "oilbrush",color: Color(25,25,25,25),size: 10,type:PaintToolType.pen)
        
        pen = PaintBrush(textureName: "pencil",color: Color(25,25,25,25),size: 2,type:BrushType.pencil)
        eraser = PaintBrush(textureName: "circle", color: Color(255,255,255,0),size: 10,type:BrushType.eraser)
        oilbrush = PaintBrush(textureName: "circle", color: Color(25,25,25,25), size: 20, type: BrushType.oilBrush)
        
        brushDict[BrushType.calligraphyColor] = PaintBrush(textureName: "circleTexture", color: Color(25,25,25,25), size: 20, type: BrushType.calligraphyColor)
        
        
        
        brushDict[BrushType.calligraphy] = PaintBrush(textureName: "circleTexture", color: Color(25,25,25,25), size: 20, type: BrushType.calligraphy)
        brushDict[BrushType.calligraphyEdge] = PaintBrush(textureName: "rim", color: Color(25,25,25,25), size: 20, type: BrushType.calligraphyEdge)

        brushDict[BrushType.chinesebrush] = PaintBrush(textureName: "brush", color: Color(25,25,25,25), size: 20, type: BrushType.chinesebrush)
        
        
        //brushDict[BrushType.calligraphy] = PaintBrush(textureName: "rim", color: Color(25,25,25,25), size: 20, type: BrushType.calligraphy)
        
        
        brushDict[BrushType.flatpen] = PaintBrush(textureName: "marker", color: Color(25,25,25,25), size: 8, type: BrushType.flatpen)
        
        brushDict[BrushType.pencil] = pen
        brushDict[BrushType.eraser] = eraser
        brushDict[BrushType.oilBrush] = oilbrush
        
        _ = useTool(BrushType.oilBrush)
        
        //Painter.currentBrush = currentTool
    
    }
    var brushDict:[BrushType:PaintBrush] = [:]
    
    /*
    public func getTool(_ name:String)->BrushType{
        switch(name)
        {
        case "pencil":
            return .pencil
        case "pen":
            return .pencil
        case "marker":
            pen.changeTexture("Particle")
            return .pencil
        case "oil":
            return .oilBrush
        case "calligraphy":
            return .calligraphy
        case "flatpen":
            return .flatpen
        case "eraser":
            return .eraser
        default :
            return .pencil
        }
    }*/
    public func usePreviousTool()
    {
        useTool(lastBrush.toolType)
    }
    public func useCurrentTool()
    {
        useTool(currentTool.toolType)
    }
    public func useTool(_ type:BrushType)
    {
        currentTool = brushDict[type]
        switch(type)
        {
        
        case .eraser:
            useEraser()
        default:
            useBrush(type)
            lastBrush = currentTool
        }
    }
    
    public func changeTool(_ name:String)
    {
        useTool(BrushType.init(rawValue: name)!)
    }
    /*
    func changeTool(index:Int)->PaintBrush
    {
        print("change tool")
        let brush = useTool(PaintToolManager.PaintToolType(rawValue:index )!)
        return brush
    }
*/
    public func useBrush(_ type:BrushType)
    {
        glEnable((GL_BLEND))
        GLShaderBinder.instance.useBrush(type)
        let brush = brushDict[type]
        brush!.useTool()
        brush?.changeColor(
            colorInPalette)
        glBlendEquation((GLenum(GL_FUNC_ADD)))
        glBlendFunc((GL_ONE), (GL_ONE_MINUS_SRC_ALPHA))
    }
    
    public func usePen()
    {
        //glEnable((GL_BLEND))
        GLShaderBinder.instance.useBrush(BrushType.pencil)
        pen.useTool()
        pen.changeColor(colorInPalette)
        glBlendEquation((GLenum(GL_FUNC_ADD)))
        glBlendFunc((GL_ONE), (GL_ONE_MINUS_SRC_ALPHA))
        currentTool = pen
    }
    
    public func useEraser()
    {
        glEnable((GLenum(GL_POINT_SMOOTH)))
        glDisable((GL_BLEND))
        //***blend function as problem
        GLShaderBinder.instance.useBrush(BrushType.eraser)
        eraser.useTool()
        //        glBlendEquation((GL_FUNC_SUBTRACT))
        
        //glBlendEquation((GL_FUNC_REVERSE_SUBTRACT))
        //glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA)
        //currentTool.changeColor(Color(rf:0.5,gf: 0.5,bf: 0.5,af: 0.5))
        //glBlendFunc(GL_ONE,GL_ONE)
        
        
        
        //GLContextBuffer.instance.setReplayDrawSetting()
        
    }
    // var isToolAttributeChanged:Bool = true
    public func loadToolValueInfo(_ valueInfo:ToolValueInfo)
    {
        currentTool.changeColor(valueInfo.color)
        currentTool.changeSize(valueInfo.size)
        colorInPalette = valueInfo.color
    }
    
    var alpha:Float = 0.5
    public func changeColor(_ color:UIColor)
    {
        
        let rgb = color.cgColor.components
        let r = Float((rgb?[0])!)*alpha
        let g = Float((rgb?[1])!)*alpha
        let b = Float((rgb?[2])!)*alpha
        let c = Color(rf: r,gf: g,bf: b,af: alpha)
        colorInPalette = c
        
        //don't change the color of eraser
        if currentTool == eraser
        {
            print("erase change color", terminator: "")

            return
        }
        
        currentTool.changeColor(c)
    }
    public func changeSize(_ size:Float)
    {
        currentTool.changeSize(size)
    }
    deinit
    {
        
    }
}
