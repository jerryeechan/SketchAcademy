//
//  BrushTexture.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/31.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import Foundation

import OpenGLES.ES2
import SwiftGL

class BrushTextureLoader {
    
    class var instance:BrushTextureLoader{
        struct Singleton {
            static let instance = BrushTextureLoader()
        }
        return Singleton.instance
    }
    init()
    {
        
        
        buildTextureDic()
    }
    var textureDic = [String:Texture]()
    func buildTextureDic()
    {
        loadTexture("brush1")
        loadTexture("brush2")
        loadTexture("Particle")
        loadTexture("pencil")
    }
    func loadTexture(name:String)
    {
        //texture.append()
        textureDic[name] = Texture(filename: name+".png")
    }
    
    func getTexture(name:String)->Texture
    {
        let t:Texture! = textureDic[name]!
        if t != nil
        {
            loadTexture(name)
        }
        return textureDic[name]!
    }
}