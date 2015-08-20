//
//  GLRenderTexture.swift
//  SwiftGL
//
//  Created by jerry on 2015/7/21.
//  Copyright (c) 2015年 Jerry Chan. All rights reserved.
//

import OpenGLES.ES2
import SwiftGL


class GLRenderTextureFrameBuffer{
    var tempLayer:Layer
    var layers:[Layer] = []
    var drawBuffers:[GLenum]  = [GL_COLOR_ATTACHMENT0]
    var framebuffer:GLuint=0
    var width,height:GLsizei
    var currentLayer:Layer
    
    init(width:GLint,height:GLint)
    {
        self.width = width
        self.height = height
        glGenFramebuffers(1,&framebuffer)
        
        tempLayer = Layer(w: width, h: height)
        layers.append(Layer(w: width, h: height))
        currentLayer = layers[0]
        setBuffer()
        glClearColor(255, 255, 255, 255)
        glClear(GL_COLOR_BUFFER_BIT )
        addEmptyLayer()
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
    func selectLayer(index:Int)
    {
        if (index >= 0 && index < layers.count)
        {
            currentLayer = layers[index]
            
        }
    }
    func blankCurrentLayer()
    {
        currentLayer.clean()
    }
    func setTempBuffer()->Bool{
        glBindFramebuffer(GL_FRAMEBUFFER, framebuffer)
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,GL_TEXTURE_2D,tempLayer.texture.id, 0)
        
        return (glCheckFramebufferStatus(GL_FRAMEBUFFER) == GLenum(GL_FRAMEBUFFER_COMPLETE))
    }
    func setBuffer()->Bool
    {
        glBindFramebuffer(GL_FRAMEBUFFER, framebuffer)
        glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,GL_TEXTURE_2D,currentLayer.texture.id, 0)
        
        return (glCheckFramebufferStatus(GL_FRAMEBUFFER) == GLenum(GL_FRAMEBUFFER_COMPLETE))
    }
}
