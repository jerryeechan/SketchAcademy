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

enum PaintToolType:Int{
    case pen = 0,eraser,smudge
}
public class PaintToolManager {
    
    
    var colorInPalette:Color = Color(25,25,25,125)
    var pen:PaintBrush!
    var eraser:PaintBrush!
    
    var currentTool:PaintBrush!
//    static var instance:PaintToolManager!
    init()
    {
//        PaintToolManager.instance = self
    }
    func load()
    {
        pen = PaintBrush(textureName: "pencil",color: Color(25,25,25,25),size: 2,type:PaintToolType.pen)
        eraser = PaintBrush(textureName: "circleTexture", color: Color(255,255,255,0),size: 10,type:PaintToolType.eraser)
        
        currentTool = pen
        //Painter.currentBrush = currentTool
        pen.useTool()
    }

    func getTool(name:String)->PaintToolType    {
        switch(name)
        {
        case "pen":
            
            
            return .pen
        case "marker":
            pen.changeTexture("Particle")
            return .pen
        case "eraser":
            return .eraser
        default :
            return .pen
        }
    }
    public func useCurrentTool()
    {
        useTool(currentTool.toolType)
    }
    private func useTool(type:PaintToolType)->PaintBrush!
    {
        //GLContextBuffer.instance.setBrushDrawSetting(type)
        switch(type)
        {
        case .pen:
            usePen()
            return pen
        case .eraser:
            useEraser()
            return eraser
        default:
            return pen
        }
        
        
    }
    func changeTool(name:String)->PaintBrush
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
    func usePen()
    {
        
        pen.useTool()
        pen.changeColor(colorInPalette)
        glBlendEquation(GLenum(GL_FUNC_ADD))
        glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA)
        //print("PaintToolManager: use pen")
        currentTool = pen
    }
    
    func useEraser()
    {
        //***blend function as problem
        
        currentTool = eraser
        //        glBlendEquation(GLenum(GL_FUNC_SUBTRACT))
        glBlendEquation(GLenum(GL_FUNC_REVERSE_SUBTRACT))
        //glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA)
        currentTool.changeColor(Color(rf:0,gf: 0,bf: 0,af: 0.5))
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
        
        //GLContextBuffer.instance.setReplayDrawSetting()
        eraser.useTool()
        print("use eraser", terminator: "")
    }
    // var isToolAttributeChanged:Bool = true
    func loadToolValueInfo(valueInfo:ToolValueInfo)
    {
        currentTool.changeColor(valueInfo.color)
        currentTool.changeSize(valueInfo.size)
        colorInPalette = valueInfo.color
    }
    
    var alpha:Float = 0.5
    func changeColor(color:UIColor)
    {
        
        let rgb = CGColorGetComponents(color.CGColor)
        let r = Float(rgb[0])*alpha
        let g = Float(rgb[1])*alpha
        let b = Float(rgb[2])*alpha
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
    func changeSize(size:Float)
    {
        currentTool.changeSize(size)
    }
}