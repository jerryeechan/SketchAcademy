//
//  GLRenderCanvas.swift
//  SwiftGL
//
//  Created by jerry on 2015/7/21.
//  Copyright (c) 2015年 Jerry Chan. All rights reserved.
//

import OpenGLES.ES2
import SwiftGL

enum RenderMode{
    case direct
    case drawing
}

class GLRenderCanvas{
    var tempLayer:Layer!
    var layers:[Layer] = []
    var caches:Dictionary<Int,LayerCache> = Dictionary<Int,LayerCache>()
    var revisionLayer:Layer!
    //var drawBuffers:[GLenum] = [GL_COLOR_ATTACHMENT0]
    var framebuffer:GLuint = 0
    var width,height:GLsizei!
    var currentLayer:Layer!
    var backgroundLayer:Layer!
    var renderMode:RenderMode = .drawing
    
    var primitiveLayer:Layer

    
    init(w:GLint,h:GLint)
    {
        self.width = w
        self.height = h
        glGenFramebuffers(1,&framebuffer)
        tempLayer = Layer(w:width, h:height)
        revisionLayer = Layer(w:width, h:height)
        primitiveLayer = Layer(w:width, h:height)
        changeBackground("paper_sketch")
        addEmptyLayer()
        /*
        for i in 0...10
            {
                addEmptyLayer()
            }
        for i in 0...10
        {
            selectLayer(i)
            blankCurrentLayer()
            print("error: \(glGetError())")
        }

        //setBuffer()
        glClearColor(255, 255, 255, 255)
        glClear(GL_COLOR_BUFFER_BIT )
       */
        
    }
    
    
    func changeBackground(filename:String)
    {
        if(filename != "none")
        {
            backgroundLayer = Layer(texture: Texture(filename: filename))
        }
        else
        {
            backgroundLayer = nil
        }
        
    }
    func addEmptyLayer()
    {
        layers.append(Layer(w: width, h: height))
        currentLayer = layers.last!
    }
    func addImageLayer(texture:Texture,index:Int = 0)
    {
        let newLayer = Layer(texture: texture)
        layers.insert(newLayer, atIndex: 0)
        //currentLayer = layers.last!
    }
    func selectRevisionLayer()
    {
        currentLayer = revisionLayer
    }
    func setAllLayerAlpha(alpha:Float)
    {
        for layer in layers
        {
            layer.alpha = alpha
        }
    }
    func enableAllLayer()
    {
        for layer in layers
        {
            layer.enabled = true
        }
    }
    func disableAllLayer()
    {
        for layer in layers
        {
            layer.enabled = false
        }
    }
    func selectLayer(index:Int)
    {
        if (index >= 0 && index < layers.count)
        {
            currentLayer = layers[index]
        }
        else{
            
        }
    }
    func setPrimitiveBuffer()->Bool
    {
        return setBuffer(primitiveLayer)
    }
    func setTempBuffer()->Bool
    {
        return setBuffer(tempLayer)
    }
    func blankTempLayer()
    {
        setTempBuffer()
        glClearColor(0, 0, 0, 0)
        glClear(GL_COLOR_BUFFER_BIT )
    }
    func blankCurrentLayer()
    {
        if(setBuffer(currentLayer)==true)
        {
            glClearColor(0, 0, 0, 0)
            glClear(GL_COLOR_BUFFER_BIT )
            
        }
        else
        {
            DLog("dead")
        }
        
    }
    func genCacheFrame(atStroke:Int)->LayerCache!
    {
        DLog("gen cache \(atStroke)")
        //check cache exist
        if caches[atStroke] == nil
        {caches[atStroke] = LayerCache(atStroke: atStroke,w: width, h: height)}
        return caches[atStroke]
    }
    
        
    func getCaches()->[LayerCache]
    {
        let array = Array(caches.values).sort({$0.atStroke < $1.atStroke})
        return array
    }
    func getNearestCacheIndex(targetIndex:Int)->Int{
        let array = Array(caches.values).sort({$0.atStroke < $1.atStroke})
        //the index in Layer Cache arraya
        
        if array.count != 0
        {
            let atIndex = binarySearch(array, searchIndex: targetIndex)
            if atIndex == -1 {return 0}
            else {return array[atIndex].atStroke}
        }
        else
        {
            return 0
        }
        
    }
    func cloneLayer(){
        
    }
    func setBuffer()->Bool
    {
        return setBuffer(currentLayer)
    }
    func setBuffer(layer:Layer)->Bool
    {
        glBindFramebuffer(GL_FRAMEBUFFER, framebuffer)
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,GL_TEXTURE_2D,layer.texture.id, 0)
        
        return (glCheckFramebufferStatus(GL_FRAMEBUFFER) == GLenum(GL_FRAMEBUFFER_COMPLETE))
    }
    
    private func binarySearch(inputArr:[LayerCache], searchIndex: Int)->Int{
        var lowerIndex = 0;
        var upperIndex = inputArr.count - 1
        
        while (true) {
            let currentIndex = (lowerIndex + upperIndex)/2
            if(inputArr[currentIndex].atStroke == searchIndex) {
                return currentIndex
            } else if (lowerIndex > upperIndex) {
                return upperIndex
            } else {
                if (inputArr[currentIndex].atStroke > searchIndex) {
                    upperIndex = currentIndex - 1
                } else {
                    lowerIndex = currentIndex + 1
                }
            }
        }
    }
    deinit
    {
        layers.removeAll()
        revisionLayer = nil
        glDeleteFramebuffers(1, [framebuffer])
    }
    
}

