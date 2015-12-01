//
//  PaintManager.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/1.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

class PaintManager {
    
    class var instance:PaintManager{
        struct Singleton{
            static let instance = PaintManager()
        }
        return Singleton.instance
    }
    
    
    
    let paintRecorder = PaintRecorder()
    let paintReplayer = PaintReplayer()
    let revisionReplayer = PaintReplayer()
    
    enum ReplayTarget{
        case Artwork
        case Revision
    }
    var currentReplayer:PaintReplayer
    
    init()
    {
        currentReplayer = paintReplayer
    }
    func clear()
    {
        paintReplayer.stopPlay()
        GLContextBuffer.instance.blank()
        GLContextBuffer.instance.display()
        
    }
    
    
    
    func pauseToggle()
    {
        currentReplayer.pauseToggle()
    }
    func doublePlayBackSpeed()
    {
        currentReplayer.doublePlayBackSpeed()
    }
    func restart()
    {
        currentReplayer.restart()
    }
    
}
