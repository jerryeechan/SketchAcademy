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
enum BrushType:Int
{
    case pencil = 0,oilBrush,eraser
}
open class PaintToolManager {
    
    let brushTextureLoader:BrushTextureLoader = BrushTextureLoader()
    
    var colorInPalette:Color = Color(25,25,25,125)
    var pen:PaintBrush!
    var eraser:PaintBrush!
    var oilbrush:PaintBrush!
    var currentTool:PaintBrush!
    var lastBrush:PaintBrush!
//    static var instance:PaintToolManager!
    init()
    {
//        PaintToolManager.instance = self
    }
    func load()
    {
        //pen = PaintBrush(textureName: "oilbrush",color: Color(25,25,25,25),size: 10,type:PaintToolType.pen)
        
        pen = PaintBrush(textureName: "pencil",color: Color(25,25,25,25),size: 2,type:BrushType.pencil)
        eraser = PaintBrush(textureName: "circle", color: Color(255,255,255,0),size: 10,type:BrushType.eraser)
        oilbrush = PaintBrush(textureName: "oilbrush", color: Color(25,25,25,25), size: 20, type: BrushType.oilBrush)
        brushDict[BrushType.pencil] = pen
        brushDict[BrushType.eraser] = eraser
        brushDict[BrushType.oilBrush] = oilbrush
        useTool(BrushType.pencil)
        
        //Painter.currentBrush = currentTool
    
    }
    var brushDict:[BrushType:PaintBrush] = [:]
    func getTool(_ name:String)->BrushType{
        switch(name)
        {
        case "pen":
            return .pencil
        case "marker":
            pen.changeTexture("Particle")
            return .pencil
        case "oil":
            return .oilBrush
        case "eraser":
            return .eraser
        default :
            return .pencil
        }
    }
    open func usePreviousTool()
    {
        useTool(lastBrush.toolType)
    }
    open func useCurrentTool()
    {
        useTool(currentTool.toolType)
    }
    fileprivate func useTool(_ type:BrushType)->PaintBrush!
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
        
        return currentTool
        
    }
    
    func changeTool(_ name:String)->PaintBrush
    {
        currentTool = useTool(getTool(name))
        return currentTool
    }
    /*
    func changeTool(index:Int)->PaintBrush
    {
        print("change tool")
        let brush = useTool(PaintToolManager.PaintToolType(rawValue:index )!)
        return brush
    }
*/
    func useBrush(_ type:BrushType)
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
    func usePen()
    {
        glEnable((GL_BLEND))
        GLShaderBinder.instance.useBrush(BrushType.pencil)
        pen.useTool()
        pen.changeColor(colorInPalette)
        glBlendEquation((GLenum(GL_FUNC_ADD)))
        glBlendFunc((GL_ONE), (GL_ONE_MINUS_SRC_ALPHA))
        currentTool = pen
    }
    
    func useEraser()
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
    func loadToolValueInfo(_ valueInfo:ToolValueInfo)
    {
        currentTool.changeColor(valueInfo.color)
        currentTool.changeSize(valueInfo.size)
        colorInPalette = valueInfo.color
    }
    
    var alpha:Float = 0.5
    func changeColor(_ color:UIColor)
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
    func changeSize(_ size:Float)
    {
        currentTool.changeSize(size)
    }
    deinit
    {
        
    }
}
