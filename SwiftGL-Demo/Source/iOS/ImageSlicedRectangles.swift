//
//  ImageSlicedRectangles.swift
//  SwiftGL
//
//  Created by jerry on 2015/7/19.
//  Copyright (c) 2015年 Jerry Chan. All rights reserved.
//
import UIKit
class ImageSlicedRectangles {
    
    class var instance:ImageSlicedRectangles{
        struct Singleton {
            static let instance = ImageSlicedRectangles()
        }
        return Singleton.instance
    }
    
    var rects:[SliceRect] = []
    init()
    {
        
    }
    func addRect(rect:SliceRect)
    {
        rects.append(rect)
    }
    
    func hideRect()
    {
        
    }
    func drawRects()
    {
        
    }
}