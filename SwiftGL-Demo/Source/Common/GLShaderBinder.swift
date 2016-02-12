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
    var drawShader:Shader!
    
    var imageShader:Shader!
    
    //static var instance:GLShaderBinder!
    //binding Attributes
    /*
    var iLocAttribPosition:GLuint = 0
//    var iLocAttribSize:GLuint = 1
    var iLocAttribAngle:GLuint = 2
    //apple pencil attributes
    var iLocAttribPencilForce:GLuint = 3
    var iLocAttribPencilAltitude:GLuint = 4
    var iLocAttribPencilAzimuth:GLuint = 5
    */
    
    var iLocMVP:GLint = 0
    var iLocBrushSize:GLint = 0
    var iLocBrushColor:GLint = 0
    var iLocBrushTexture:GLint = 0
    
    
    
    var paintPointsAttributes=[Attribute]()
    
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
        //load()
        
        GLShaderBinder.instance = self
        load()
    }
    deinit
    {
        
    }
    func load()
    {
        loadBrushShader()
        loadImageShader()
    }
    
    func loadBrushShader()
    {

        drawShader = Shader()
        if !(drawShader.load( "point.vsh","point.fsh") {
            program in
            // Here we will bind the attibute names to the correct position
            // Doing this will allow us to use the VBO/VAO with more than one shader, ensuring that the right
            // values get passed in to the correct shader variables
            /*
            glBindAttribLocation(program, self.iLocAttribPosition, "vertexPosition")
            glBindAttribLocation(program, self.iLocAttribAngle, "vertexAngle")
            glBindAttribLocation(program, self.iLocAttribPencilForce, "pencilForce")
            glBindAttribLocation(program, self.iLocAttribPencilAltitude, "pencilAltitude")
            glBindAttribLocation(program, self.iLocAttribPencilAzimuth, "pencilAzimuth")
            */


            
            
            }) {
                // You can take this out after. Useful for debugging
                print("failed to load shader", terminator: "")
                glDebug(__FILE__, line: __LINE__)
        }
        
        /*
        self.paintPointsAttributes.append(Attribute(i: self.iLocAttribPosition, t: Vec4.self))
        self.paintPointsAttributes.append(Attribute(i: self.iLocAttribAngle, t: Float.self))
        self.paintPointsAttributes.append(Attribute(i: self.iLocAttribPencilForce, t: Float.self))
        self.paintPointsAttributes.append(Attribute(i: self.iLocAttribPencilAltitude, t: Float.self))
        
        self.paintPointsAttributes.append(Attribute(i: self.iLocAttribPencilAzimuth, t: Vec2.self))
*/
        addAttribute("vertexPosition", type: Vec4.self)
        addAttribute("pencilForce", type: Float.self)
        addAttribute("pencilAltitude", type: Float.self)
        addAttribute("pencilAzimuth", type: Vec2.self)
        addAttribute("vertexVelocity", type: Vec2.self)
        
        iLocMVP = glGetUniformLocation(drawShader.id, "MVP")
        iLocBrushColor = glGetUniformLocation(drawShader.id, "brushColor")
        iLocBrushSize = glGetUniformLocation(drawShader.id, "brushSize")
        iLocBrushTexture = glGetUniformLocation(drawShader.id,"texture")
        

    }
    
    func addAttribute<T:GLType>(name:String,type:T.Type)
    {
        let iLoc = GLuint(glGetAttribLocation(drawShader.id, name))
        paintPointsAttributes.append(Attribute(i: iLoc, t: type))
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
        imageShader.bind(iLocImageTexture,texture , index: 2)
        imageShader.bind(iLocImageAlpha, alpha)
        imageShader.useProgram()
        
        genImageVertices(leftTop, rightBottom: rightBottom)
        imageVbo.bind(imageVertices, count: 4)
        
        imagevao.bind(attribute: iLocImageAttribVertex, type: Vec4.self, vbo: imageVbo, offset: 0)
        imagevao.bind(attribute: iLocImageAttribTexturePosition, type: Vec4.self, vbo: imageVbo, offset: sizeof(Vec4))
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
    func drawImageTexture(texture:Texture,alpha:Float)
    {
        drawImageTexture(texture, alpha: alpha, leftTop: Vec4(0,0), rightBottom: Vec4(imgWidth,imgHeight))
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
        
        var offset:GLsizeiptr = 0
        for attrib in paintPointsAttributes
        {
            vao.bind(attribute: attrib.iLoc, glType: attrib.glType, glNormalized: attrib.glNormalized, glSize: attrib.glSize, vbo: vbo, offset: offset)
            offset+=attrib.offset
        }
        
        //vao.bind(attribute: AttribColor,    type: Vec4.self, vbo: vbo, offset: sizeof(Vec4))
    }
    func bindAttrib<T:GLType>(attrib:GLuint,type:T.Type,offset:GLsizeiptr)
    {
        vao.bind(attribute:attrib, type: type, vbo: vbo, offset: offset)
    }
    
}