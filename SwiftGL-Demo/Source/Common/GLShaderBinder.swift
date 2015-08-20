//
//  GLShaderBuilder.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/22.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import Foundation
import SwiftGL
import OpenGLES.ES2

class GLShaderBinder{
    var shader:Shader!
    var drawShader:Shader!
    
    var imageShader:Shader!
    
    static var instance:GLShaderBinder!
    //binding Attributes
    var iLocAttribPosition:GLuint = 0
    var iLocAttribSize:GLuint = 1
    var iLocAttribAngle:GLuint = 2
    
    var iLocMVP:GLint = 0
    var iLocBrushSize:GLint = 0
    var iLocBrushColor:GLint = 0
    var iLocBrushTexture:GLint = 0

    
    enum DrawShader:String
    {
        case brush = "brush",image = "image"
    }
    
    let vao    = Vao()
    let vbo    = Vbo()
    let ibo    = Vbo()
    
    let imageVbo = Vbo()
    let imagevao = Vao()
    init()
    {
        //shader = Shader()
        loadBrushShader()
        loadImageShader()
        
        GLShaderBinder.instance = self
         }
    
    func loadBrushShader()
    {
        drawShader = Shader()
        
        if !(drawShader.load( "point.vsh","point.fsh") {
            program in
            // Here we will bind the attibute names to the correct position
            // Doing this will allow us to use the VBO/VAO with more than one shader, ensuring that the right
            // values get passed in to the correct shader variables
            glBindAttribLocation(program, self.iLocAttribPosition, "vertexPosition")
            glBindAttribLocation(program, self.iLocAttribAngle, "vertexAngle")
            
            glBindAttribLocation(program, self.iLocAttribSize, "vertexSize")
            
            }) {
                // You can take this out after. Useful for debugging
                print("failed to load shader", appendNewline: false)
                glDebug(__FILE__, line: __LINE__)
        }
        
        iLocMVP = glGetUniformLocation(drawShader.id, "MVP")
        iLocBrushColor = glGetUniformLocation(drawShader.id, "brushColor")
        iLocBrushSize = glGetUniformLocation(drawShader.id, "brushSize")
        iLocBrushTexture = glGetUniformLocation(drawShader.id,"texture")
        

    }
    
    func useShader(shader:DrawShader)
    {
        switch(shader)
        {
        case .brush:
            drawShader.useProgram()
        case .image:
            imageShader.useProgram()
        }
    }
    func loadImageShader()
    {
        imageShader = Shader()
        if !(imageShader.load("RenderTexture.vsh","RenderTexture.fsh"){
            program in
            
            glBindAttribLocation(program, self.iLocImageAttribVertex, "position")
            
            glBindAttribLocation(program, self.iLocImageAttribTexturePosition, "inputTextureCoordinate")
            
        
            }){}
        
        iLocImageMVP = glGetUniformLocation(imageShader.id, "MVP")
        iLocImageTexture = glGetUniformLocation(imageShader.id, "imageTexture")
        
        iLocImageAlpha = glGetUniformLocation(imageShader.id, "alpha")
            
        glEnableVertexAttribArray(iLocImageAttribVertex)
        glEnableVertexAttribArray(iLocImageAttribTexturePosition)
        
        initVertex()
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
    func initVertex()
    {
        let width:GLfloat = GLfloat(GLContextBuffer.instance.backingWidth)
        let height:GLfloat = GLfloat(GLContextBuffer.instance.backingHeight)
        
        
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
    func drawImageTexture(texture:Texture,alpha:Float)
    {
        imageShader.bind(iLocImageTexture,texture , index: 2)
        imageShader.bind(iLocImageAlpha, alpha)
        imageShader.useProgram()
        
        print(glGetAttribLocation(imageShader.id, "position"))
        
        imageVbo.bind(imageVertices, count: 4)
        
        imagevao.bind(attribute: iLocImageAttribVertex, type: Vec4.self, vbo: imageVbo, offset: 0)
        imagevao.bind(attribute: iLocImageAttribTexturePosition, type: Vec4.self, vbo: imageVbo, offset: sizeof(Vec4))
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
    func bindBrush()
    {
        drawShader.bind(iLocBrushTexture, brushTexture,index: 0)
    }
    var brushTexture:Texture!
    func bindBrushTexture(texture:Texture)
    {
        brushTexture = texture
        drawShader.bind(iLocBrushTexture, texture,index: 0)
    }
    func bindMVP(mvp:Mat4)
    {
        drawShader.bind(iLocMVP, mvp)
        imageShader.bind(iLocImageMVP,mvp)
        
    }
    func bindBrushInfo(vInfo:ToolValueInfo)
    {
        drawShader.bind(iLocBrushColor,vInfo.color.vec)
        drawShader.bind(iLocBrushSize,vInfo.size)
    }
    func bindBrushColor(color:Vec4)
    {
        print(color)
        drawShader.bind(iLocBrushColor,color)
    }
    func bindBrushSize(size:Float)
    {
        self.drawShader.bind(iLocBrushSize, size)
    }

    func bindVertexs(vertextBuffer:[PaintPoint])
    {
        // Load data to the Vertex Buffer Object
        vbo.bind(vertextBuffer, count: vertextBuffer.count)
        // After binding some data to our VBO, we must bind our VBO's data
        // into our Vertex Array Object (VAO) using the associated Shader attributes
        vao.bind(attribute:iLocAttribPosition, type: Vec4.self, vbo: vbo, offset: 0)
        
        vao.bind(attribute:iLocAttribSize,type:Float.self,vbo:vbo,offset:sizeof(Vec4)*2)
        vao.bind(attribute:iLocAttribAngle,type:Float.self,vbo:vbo,offset:sizeof(Vec4)*2+sizeof(Float))
        
        
        //vao.bind(attribute: AttribColor,    type: Vec4.self, vbo: vbo, offset: sizeof(Vec4))

    }
    
    
    /*
    func qubetest()
    {
        // Load the Shader files
        if !(shader.load("DemoShader1.vsh", "DemoShader1.fsh") {
            program in
            // Here we will bind the attibute names to the correct position
            // Doing this will allow us to use the VBO/VAO with more than one shader, ensuring that the right
            // values get passed in to the correct shader variables
            glBindAttribLocation(program, self.AttribPosition, "Position")
            glBindAttribLocation(program, self.AttribColor,    "Color")
            
            }) {
                // You can take this out after. Useful for debugging
                glDebug(__FILE__, __LINE__)
                print("dse")
        }
        shader.useProgram()
        
        // Bind the vertices into the Vertex Buffer Object (VBO)
        let vertices: [Vertex] = [
            // Front Face (+Z) - Yellow
            Vertex(position: Vec4(x: -0.5, y: -0.5, z: 0.5), color: Vec4(x: 1, y: 1, z: 0, w: 1)),
            Vertex(position: Vec4(x:  0.5, y: -0.5, z: 0.5), color: Vec4(x: 1, y: 1, z: 0, w: 1)),
            Vertex(position: Vec4(x: -0.5, y:  0.5, z: 0.5), color: Vec4(x: 1, y: 1, z: 0, w: 1)),
            Vertex(position: Vec4(x:  0.5, y:  0.5, z: 0.5), color: Vec4(x: 1, y: 1, z: 0, w: 1)),
            
            // Back Face (-Z) - Red
            Vertex(position: Vec4(x:  0.5, y: -0.5, z: -0.5), color: Vec4(x: 1, y: 0, z: 0, w: 1)),
            Vertex(position: Vec4(x: -0.5, y: -0.5, z: -0.5), color: Vec4(x: 1, y: 0, z: 0, w: 1)),
            Vertex(position: Vec4(x:  0.5, y:  0.5, z: -0.5), color: Vec4(x: 1, y: 0, z: 0, w: 1)),
            Vertex(position: Vec4(x: -0.5, y:  0.5, z: -0.5), color: Vec4(x: 1, y: 0, z: 0, w: 1)),
            
            // Left Face (-X) - Green
            Vertex(position: Vec4(x: -0.5, y: -0.5, z: -0.5), color: Vec4(x: 0, y: 1, z: 0, w: 1)),
            Vertex(position: Vec4(x: -0.5, y: -0.5, z:  0.5), color: Vec4(x: 0, y: 1, z: 0, w: 1)),
            Vertex(position: Vec4(x: -0.5, y:  0.5, z: -0.5), color: Vec4(x: 0, y: 1, z: 0, w: 1)),
            Vertex(position: Vec4(x: -0.5, y:  0.5, z:  0.5), color: Vec4(x: 0, y: 1, z: 0, w: 1)),
            
            // Right Face (+X) - Blue
            Vertex(position: Vec4(x:  0.5, y: -0.5, z:  0.5), color: Vec4(x: 0, y: 0, z: 1, w: 1)),
            Vertex(position: Vec4(x:  0.5, y: -0.5, z: -0.5), color: Vec4(x: 0, y: 0, z: 1, w: 1)),
            Vertex(position: Vec4(x:  0.5, y:  0.5, z:  0.5), color: Vec4(x: 0, y: 0, z: 1, w: 1)),
            Vertex(position: Vec4(x:  0.5, y:  0.5, z: -0.5), color: Vec4(x: 0, y: 0, z: 1, w: 1)),
            
            // Bottom Face (-Y) - Magenta
            Vertex(position: Vec4(x: -0.5, y: -0.5, z: -0.5), color: Vec4(x: 1, y: 0, z: 1, w: 1)),
            Vertex(position: Vec4(x:  0.5, y: -0.5, z: -0.5), color: Vec4(x: 1, y: 0, z: 1, w: 1)),
            Vertex(position: Vec4(x: -0.5, y: -0.5, z:  0.5), color: Vec4(x: 1, y: 0, z: 1, w: 1)),
            Vertex(position: Vec4(x:  0.5, y: -0.5, z:  0.5), color: Vec4(x: 1, y: 0, z: 1, w: 1)),
            
            // Top Face (+Y) - White
            Vertex(position: Vec4(x: -0.5, y:  0.5, z:  0.5), color: Vec4(x: 1, y: 1, z: 1, w: 1)),
            Vertex(position: Vec4(x:  0.5, y:  0.5, z:  0.5), color: Vec4(x: 1, y: 1, z: 1, w: 1)),
            Vertex(position: Vec4(x: -0.5, y:  0.5, z: -0.5), color: Vec4(x: 1, y: 1, z: 1, w: 1)),
            Vertex(position: Vec4(x:  0.5, y:  0.5, z: -0.5), color: Vec4(x: 1, y: 1, z: 1, w: 1)),
        ]
        vbo.bind(vertices, count: vertices.count)
        
        let indices: [GLushort] = [
            GLushort(0), GLushort(1), GLushort(2), GLushort(3),
            GLushort(3), GLushort(4),
            GLushort(4), GLushort(5), GLushort(6), GLushort(7),
            GLushort(7), GLushort(8),
            GLushort(8), GLushort(9), GLushort(10), GLushort(11),
            GLushort(11), GLushort(12),
            GLushort(12), GLushort(13), GLushort(14), GLushort(15),
            GLushort(15), GLushort(16),
            GLushort(16), GLushort(17), GLushort(18), GLushort(19),
            GLushort(19), GLushort(20),
            GLushort(20), GLushort(21), GLushort(22), GLushort(23),
        ]
        ibo.bindElements(indices, count: indices.count)
        
        
        // After binding some data to our VBO, we must bind our VBO's data
        // into our Vertex Array Object (VAO) using the associated Shader attributes
        vao.bind(attribute: AttribPosition, type: Vec4.self, vbo: vbo, offset: 0)
        vao.bind(attribute: AttribColor,    type: Vec4.self, vbo: vbo, offset: sizeof(Vec4))
        vao.bindElements(ibo)
        // Bind the VAO we plan to use
        vao.bind()
        
        
    }
    */
}