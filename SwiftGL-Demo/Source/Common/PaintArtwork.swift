//
//  PaintArtwork.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/21.
//  Copyright (c) 2015年 Jerry Chan. All rights reserved.
//

import Foundation
class PaintArtwork
{
    var strokes:[PaintStroke] = []
    //var allPoints:[PaintPoint] = []

    var isEndPoint:[Bool] = []
    var pointsValueInfo:[ToolValueInfo] = []
    
    
    var isFileExist:Bool = false
    
    var notes:[Note] = []
    class var instance:PaintArtwork{
        
        struct Singleton {
            static let instance = PaintArtwork()
        }
        return Singleton.instance
    }

    init()
    {
    
    }
    deinit
    {
    }
    
    var currentTime:CFAbsoluteTime = 0
    func addPaintStroke(stroke:PaintStroke)
    {
        currentTime = (stroke.pointData.last?.timestamps)!
        strokes.append(stroke)
        PaintReplayer.instance.currentStrokeID = strokes.count-1
      //  allPoints += stroke.points
        //allTimeStamps += track.timestamps
        
        //only the first one is true
        
        for var i=1;i<stroke.points.count;i++
        {
            isEndPoint.append(false)
            pointsValueInfo.append(stroke.valueInfo)
        }
        isEndPoint.append(true)
        pointsValueInfo.append(stroke.valueInfo)
        
    }
    func undo()
    {
        strokes.removeLast()
    }
    var currentPointID:Int = 0
    
    
    var current_vInfo:ToolValueInfo!
    
    
}