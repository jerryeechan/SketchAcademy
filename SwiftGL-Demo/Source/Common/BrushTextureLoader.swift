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
import PaintStrokeData
class BrushTextureLoader {
    static weak var instance:BrushTextureLoader!
    
    init()
    {        
        
        load()
        BrushTextureLoader.instance = self
        
    }
    func load()
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
        loadTexture("crayonTexture")
        loadTexture("marker")
        loadTexture("circleTexture")
        loadTexture("circle")
        loadTexture("oilbrush")
    }
    func loadTexture(_ name:String)
    {
        //texture.append()
        textureDic[name] = Texture(filename: name+".png")
    }
    
    func getTexture(_ name:String)->Texture
    {
        let t:Texture! = textureDic[name]!
        if t == nil
        {
            loadTexture(name)
        }
        if t.check() == false
        {
            DLog("texture dead:\(name)")
        }
        return textureDic[name]!
    }
    deinit
    {
        DLog("successfully deinit")
    }
}
