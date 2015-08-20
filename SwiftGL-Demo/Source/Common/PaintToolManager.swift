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

public class PaintToolManager {
    
    class var instance:PaintToolManager{
    struct Singleton {
        static let instance = PaintToolManager()
    }
    return Singleton.instance
    }
    
    var colorInPalette:Color = Color(0,0,0,125)
    var pen:PaintBrush = PaintBrush(textureName: "pencil",color: Color(0,0,0,25),size: 10,type:PaintToolType.pen)
    
    
    var eraser:PaintBrush = PaintBrush(textureName: "Particle", color: Color(255,255,255,255),size: 10,type:PaintToolType.eraser)
    var currentTool:PaintBrush!
    
    init()
    {
        currentTool = pen
        Painter.currentBrush = currentTool
        pen.useTool()
    }
    enum PaintToolType:Int{
        case pen = 0,eraser
    }
    func getTool(name:String)->PaintToolType    {
        switch(name)
        {
            case "pen":
             return .pen
            case "eraser":
             return .eraser
        default :
            return .pen
        }
    }
   public func useCurrentTool()
    {
        print("useCurrentTool")
        useTool(currentTool.toolType)
    }
    private func useTool(type:PaintToolType)->PaintBrush!
    {
        switch(type)
        {
        case .pen:
            usePen()
            return pen
        case .eraser:
            useEraser()
            return eraser
        }
    }
    func changeTool(name:String)->PaintBrush
    {
        
        let brush = useTool(getTool(name))
        return brush
    }
    func changeTool(index:Int)->PaintBrush
    {
        print("change tool")
        let brush = useTool(PaintToolManager.PaintToolType(rawValue:index )!)
       return brush
    }
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
        currentTool = eraser
        
        glBlendEquation(GLenum(GL_FUNC_REVERSE_SUBTRACT))
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
        currentTool.changeColor(Color(rf: 1,gf: 1,bf: 1,af: 1))
        //glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA)
        eraser.useTool()
        print("use eraser")
    }
   // var isToolAttributeChanged:Bool = true
    func loadToolValueInfo(valueInfo:ToolValueInfo)
    {
        currentTool.changeColor(valueInfo.color)
        currentTool.changeSize(valueInfo.size)
    }
    
    
    func changeColor(color:UIColor)
    {
        let rgb = CGColorGetComponents(color.CGColor)
        let r = Float(rgb[0])
        let g = Float(rgb[1])
        let b = Float(rgb[2])
        let c = Color(rf: r,gf: g,bf: b,af: 1)
        colorInPalette = c
        
        //don't change the color of eraser
        if currentTool == eraser
        {
            print("erase change color")
            return
        }
        
        currentTool.changeColor(c)
    }
    func changeSize(size:Float)
    {
        currentTool.changeSize(size)
    }
}