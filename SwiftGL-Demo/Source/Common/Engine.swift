//
//  Engine.swift
//  SwiftGL-Demo
//
//  Created by Scott Bennett on 2014-06-09.
//  Copyright (c) 2014 Scott Bennett. All rights reserved.
//

import Foundation

var currentScene: Scene?

class Engine {
    // "Class variables are not yet supported"
//    class var width: Float
//    class var height: Float
//    class var scene: Scene?
    
    class var scene: Scene? {
        get {
            return currentScene
        }
        set {
            currentScene = scene
            //currentScene?.resize(width: viewWidth, height: viewHeight)
        }
    }
    
    class func initialize() {
        //currentScene = DemoScene()
        //currentScene = PaintCanvas()
    }
    
    class func finalize() {
        currentScene = nil
    }

    
    class func update() {
        currentScene?.update()
    }
    
    class func render() {
        currentScene?.render()
    }
    
    class func resize(width width: Float, height: Float) {
        //viewWidth  = width
        //viewHeight = height
        //currentScene?.resize(width: viewWidth, height: viewHeight)
    }
}

extension Engine {
   }
