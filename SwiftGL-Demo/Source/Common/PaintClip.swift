//
//  PaintClip.swift
//  SwiftGL
//
//  Created by jerry on 2015/11/30.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

class PaintClip{
    var startAtStrokeIndex:Int = 0
    var strokes:[PaintStroke] = []
    
    var currentTime:CFAbsoluteTime = 0
    var currentPointID:Int = 0
    var current_vInfo:ToolValueInfo!
    
    func addPaintStroke(stroke:PaintStroke)
    {
        currentTime = (stroke.pointData.last?.timestamps)!
        strokes.append(stroke)
    }
    func undo()
    {
        strokes.removeLast()
    }

}