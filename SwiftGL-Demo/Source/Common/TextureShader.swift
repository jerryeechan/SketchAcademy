//
//  TextureShader.swift
//  SwiftGL
//
//  Created by jerry on 2016/3/13.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//
import SwiftGL
struct ImageVertice{
    var position:Vec4
    var textureCoordinate:Vec4
}
class TextureShader: GLShaderWrapper {
    var imgWidth:Float = 0,imgHeight:Float = 0
    init() {
        super.init(name:"RenderTexture")
                //
        addAttribute("position", type: Vec4.self)
        addAttribute("inputTextureCoordinate", type: Vec4.self)
        //
        addUniform("MVP")
        addUniform("imageTexture")
        addUniform("alpha")
    }
    func setSize(width:Float,height:Float)
    {
        initVertex(width, height: height)
    }
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
    var imageVertices:[ImageVertice] = []
    
//    var squareVertices:[GLfloat] = [
//        0, 0,
//        200, 0,
//        0,  200,
//        200,  200,
//    ]
//    
//    let textureVertices:[GLfloat] = [
//        0.0,  1.0,
//        1.0, 1.0,
//        0.0,  0.0,
//        1.0, 0.0,
//        
//    ]
    

    func initVertex(width:Float,height:Float)
    {
        imgWidth = width
        imgHeight = height
        
        imageVertices.append(ImageVertice(position: Vec4(0,0), textureCoordinate: Vec4(0,0)))
        
        imageVertices.append(ImageVertice(position: Vec4(width,0), textureCoordinate: Vec4(1,0)))
        
        imageVertices.append(ImageVertice(position: Vec4(0,height), textureCoordinate: Vec4(0,1)))
        
        imageVertices.append(ImageVertice(position: Vec4(width,height), textureCoordinate: Vec4(1,1)))
        
    }
    func bindImageTexture(texture:Texture,alpha:Float,leftTop:Vec4,rightBottom:Vec4)
    {
        shader.bind(getUniform("imageTexture")!,texture , index: 2)
        
        shader.bind(getUniform("alpha")!, alpha)
        shader.useProgram()
        genImageVertices(leftTop, rightBottom: rightBottom)
        bindVertexs(imageVertices)
    }
    
    func bindImageTexture(texture:Texture,alpha:Float)
    {
        bindImageTexture(texture, alpha: alpha, leftTop: Vec4(0,0), rightBottom: Vec4(imgWidth,imgHeight))
    }
}
