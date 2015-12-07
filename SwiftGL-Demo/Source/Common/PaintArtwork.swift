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
    var masterClip:PaintClip = PaintClip(name: "master",branchAt: 0)
    var revisionClips:[Int:PaintClip] = [Int:PaintClip]()
    var currentClip:PaintClip
    
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
        masterClip.currentTime = 0
        currentClip = masterClip
    }
    
    func addRevisionClip(atStroke:Int)
    {
        
    }
}