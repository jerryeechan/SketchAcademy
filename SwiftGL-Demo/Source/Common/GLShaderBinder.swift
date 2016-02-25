//
//  GLShaderBuilder.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/22.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import Foundation
import SwiftGL
import OpenGLES.ES3
struct Attribute{
    var iLoc:GLuint
    var glType:GLenum
    var glNormalized:GLboolean
    var glSize:GLint
    var offset:Int
    init<T:GLType>(i:GLuint,t:T.Type)
    {
        iLoc = i
        glType = T.glType
        glNormalized = T.glNormalized
        glSize = T.glSize
        offset = sizeof(T)
    }
}

class GLShaderBinder{

    static var instance:GLShaderBinder!
    var pencilShader:Shader!
    var eraserShader:Shader!
    var imageShader:Shader!
    
    var uniformDict:[String:GLint] = [String:GLint]()
    
    var iLocMVP:GLint = 0
    var iLocBrushSize:GLint = 0
    var iLocBrushColor:GLint = 0
    var iLocBrushTexture:GLint = 0
    
    
    //var uniforms:[GLint] = [GLint]()
    var paintPointsAttributes=[Attribute]()
    
    let vao    = Vao()
    let vbo    = Vbo()
    
    init()
    {
        GLShaderBinder.instance = self
        load()
    }
    deinit
    {
        
    }
    func load()
    {
        loadPencilShader()
        //loadBrushShader()
        loadImageShader()
    }
    
    func loadBrushShader()
    {
        eraserShader = Shader()
        if !(eraserShader.load("eraser.vsh","eraser.fsh"){
            program in
        }) {
            print("failed to load shader")
            glDebug(__FILE__, line: __LINE__)
        }
        /*
        addAttribute(eraserShader, name: "vertexPosition", type: Vec4.self)
        addAttribute(eraserShader,name: "pencilForce", type: Float.self)
        addAttribute(eraserShader,name: "pencilAltitude", type: Float.self)
        
        */
        
    }
    func loadPencilShader()
    {
        pencilShader = Shader()
        if !(pencilShader.load( "pencil.vsh","pencil.fsh") {
            program in
            }) {
                // You can take this out after. Useful for debugging
                print("failed to load shader", terminator: "")
                glDebug(__FILE__, line: __LINE__)
        }
        
        
        addAttribute(pencilShader,name: "vertexPosition", type: Vec4.self)
        addAttribute(pencilShader,name: "pencilForce", type: Float.self)
        addAttribute(pencilShader,name: "pencilAltitude", type: Float.self)
        addAttribute(pencilShader,name: "pencilAzimuth", type: Vec2.self)
        addAttribute(pencilShader,name: "vertexVelocity", type: Vec2.self)
        
        iLocMVP = glGetUniformLocation(pencilShader.id, "MVP")
        iLocBrushColor = glGetUniformLocation(pencilShader.id, "brushColor")
        iLocBrushSize = glGetUniformLocation(pencilShader.id, "brushSize")
        iLocBrushTexture = glGetUniformLocation(pencilShader.id,"texture")
        
        /*
        addUniform(pencilShader,key:"pencilMVP", uniformName: "MVP")
        addUniform(pencilShader, key: "pencilBrushColor", uniformName: "brushColor")
        addUniform(pencilShader, key: "pencilBrushSize", uniformName: "brushSize")
        addUniform(pencilShader, key: "pencilTexture", uniformName: "texture")
        */
    }
    func loadImageShader()
    {
        imageShader = Shader()
        if !(imageShader.load("RenderTexture.vsh","RenderTexture.fsh"){
            program in
            
            glBindAttribLocation(program, self.iLocImageAttribVertex, "position")
            
            glBindAttribLocation(program, self.iLocImageAttribTexturePosition, "inputTextureCoordinate")
            
            
            }){}
        //addUniform(imageShader, key: "imageMVP", uniformName: "MVP")
        //addUniform(imageShader, key: "imageMVP", uniformName: "MVP")
        
        iLocImageMVP = glGetUniformLocation(imageShader.id, "MVP")
        iLocImageTexture = glGetUniformLocation(imageShader.id, "imageTexture")
        
        iLocImageAlpha = glGetUniformLocation(imageShader.id, "alpha")
        
        glEnableVertexAttribArray(iLocImageAttribVertex)
        glEnableVertexAttribArray(iLocImageAttribTexturePosition)
    }
    func addUniform(shader:Shader,key:String,uniformName:String)
    {
        uniformDict[key] = glGetUniformLocation(shader.id, uniformName)
    }
    func addAttribute<T:GLType>(shader:Shader,name:String,type:T.Type)
    {
        let iLoc = GLuint(glGetAttribLocation(shader.id, name))
        paintPointsAttributes.append(Attribute(i: iLoc, t: type))
    }
    enum ShaderType:String
    {
        case brush = "brush",image = "image"
    }
    func useShader(shader:ShaderType)
    {
        switch(shader)
        {
        case .brush:
            pencilShader.useProgram()
        case .image:
            imageShader.useProgram()
        }
    }
    
    
    struct ImageVertice{
        var position:Vec4
        var textureCoordinate:Vec4
    }
    
    var squareVertices:[GLfloat] = [
    0, 0,
    200, 0,
    0,  200,
    200,  200,
    ]
    
    let textureVertices:[GLfloat] = [
        0.0,  1.0,
        1.0, 1.0,
        0.0,  0.0,
        1.0, 0.0,
    
    ]
    
    var imageVertices:[ImageVertice] = []
    var imgWidth:Float!
    var imgHeight:Float!
    func initVertex()
    {
        let width:GLfloat = GLfloat(GLContextBuffer.instance.backingWidth)
        let height:GLfloat = GLfloat(GLContextBuffer.instance.backingHeight)
        
        imgWidth = width
        imgHeight = height
        
        /*
        imageVertices.append(ImageVertice(position: Vec4(0,0), textureCoordinate: Vec4(0,1)))
        
        imageVertices.append(ImageVertice(position: Vec4(width,0), textureCoordinate: Vec4(1,1)))
        
        imageVertices.append(ImageVertice(position: Vec4(0,height), textureCoordinate: Vec4(0,0)))
        
        imageVertices.append(ImageVertice(position: Vec4(width,height), textureCoordinate: Vec4(1,0)))
        */
        imageVertices.append(ImageVertice(position: Vec4(0,0), textureCoordinate: Vec4(0,0)))
        
        imageVertices.append(ImageVertice(position: Vec4(width,0), textureCoordinate: Vec4(1,0)))
        
        imageVertices.append(ImageVertice(position: Vec4(0,height), textureCoordinate: Vec4(0,1)))
        
        imageVertices.append(ImageVertice(position: Vec4(width,height), textureCoordinate: Vec4(1,1)))
       
    }

    /*
1.0, 1.0,
1.0, 0.0,
0.0,  1.0,
0.0,  0.0,
*/
    var iLocImageAttribVertex:GLuint = 3
    var iLocImageAttribTexturePosition:GLuint = 4
    
    var iLocImageTexture:GLint = 0
    var iLocImageMVP:GLint = 0
    var iLocImageAlpha:GLint = 0
    func genImageVertices(leftTop:Vec4,rightBottom:Vec4)
    {
        let ltx = leftTop.x / imgWidth
        let lty = leftTop.y / imgHeight
        let rbx = rightBottom.x / imgWidth
        let rby = rightBottom.y / imgHeight
        
        let v1 = ImageVertice(position: Vec4(leftTop.x,leftTop.y), textureCoordinate: Vec4(ltx,lty))
        let v2 = ImageVertice(position: Vec4(rightBottom.x,leftTop.y), textureCoordinate: Vec4(rbx,lty))
        let v3 = ImageVertice(position: Vec4(leftTop.x,rightBottom.y), textureCoordinate: Vec4(ltx,rby))
        let v4 = ImageVertice(position:Vec4(rightBottom.x,rightBottom.y), textureCoordinate: Vec4(rbx,rby))
        
        imageVertices = [v1,v2,v3,v4]
        
    }
    
    func drawImageTexture(texture:Texture,alpha:Float,leftTop:Vec4,rightBottom:Vec4)
    {
        //imageShader.bind(uniformDict["imageTexture"]!,texture, index: 2)
        //imageShader.bind(uniformDict["imageAlpha"]!, alpha)
        
        imageShader.bind(iLocImageTexture,texture , index: 2)
        imageShader.bind(iLocImageAlpha, alpha)
        imageShader.useProgram()
        
        genImageVertices(leftTop, rightBottom: rightBottom)
        vbo.bind(imageVertices, count: 4)
        vao.bind(attribute: iLocImageAttribVertex, type: Vec4.self, vbo: vbo, offset: 0)
        vao.bind(attribute: iLocImageAttribTexturePosition, type: Vec4.self, vbo: vbo, offset: sizeof(Vec4))
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
    func drawImageTexture(texture:Texture,alpha:Float)
    {
        drawImageTexture(texture, alpha: alpha, leftTop: Vec4(0,0), rightBottom: Vec4(imgWidth,imgHeight))
    }
    func bindBrush()
    {
        pencilShader.bind(iLocBrushTexture, brushTexture,index: 0)
    }
    var brushTexture:Texture!
    func bindBrushTexture(texture:Texture)
    {
        brushTexture = texture
        pencilShader.bind(iLocBrushTexture, texture,index: 0)
    }
    func bindMVP(mvp:Mat4)
    {
        pencilShader.bind(iLocMVP, mvp)
        imageShader.bind(iLocImageMVP,mvp)
        
    }
    func bindBrushInfo(vInfo:ToolValueInfo)
    {
        pencilShader.bind(iLocBrushColor,vInfo.color.vec)
        pencilShader.bind(iLocBrushSize,vInfo.size)
    }
    func bindBrushColor(color:Vec4)
    {
        pencilShader.bind(iLocBrushColor,color)
    }
    func bindBrushSize(size:Float)
    {
        self.pencilShader.bind(iLocBrushSize, size)
    }

    func bindVertexs(vertextBuffer:[PaintPoint])
    {
        //bind vertex buffer to vertex buffer object
        vbo.bind(vertextBuffer, count: vertextBuffer.count)
        
        //bind attribute to vertex attribute object
        var offset:GLsizeiptr = 0
        for attrib in paintPointsAttributes
        {
            vao.bind(attribute: attrib.iLoc, glType: attrib.glType, glNormalized: attrib.glNormalized, glSize: attrib.glSize, vbo: vbo, offset: offset)
            offset+=attrib.offset
        }
    }
    
    func bindAttrib<T:GLType>(attrib:GLuint,type:T.Type,offset:GLsizeiptr)
    {
        vao.bind(attribute:attrib, type: type, vbo: vbo, offset: offset)
    }
    
}