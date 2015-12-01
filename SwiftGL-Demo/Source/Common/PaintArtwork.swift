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
    var paintClip:PaintClip = PaintClip()
    var revisionClips:[PaintClip]
    var currentClip:PaintClip
    //var allPoints:[PaintPoint] = []

    //var isEndPoint:[Bool] = []
    //var pointsValueInfo:[ToolValueInfo] = []
    
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
        paintClip.currentTime = 0
        currentClip = paintClip
    }
    deinit
    {
    }
    
    //移到 PaintClip??
    func addPaintStroke(stroke:PaintStroke)
    {
        currentClip.addPaintStroke(stroke)
        //%%%
        PaintReplayer.instance.currentStrokeID = currentClip.strokes.count-1
    }
    
    
    
}