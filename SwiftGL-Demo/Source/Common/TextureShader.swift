//
//  TextureShader.swift
//  SwiftGL
//
//  Created by jerry on 2016/3/13.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//
import SwiftGL
struct TextureMappingVertice{
    var position:Vec4
    var textureUV:Vec2
}
enum ImageMode{
    case Fill
    case Fit
    
}
class TextureShader: GLShaderWrapper {
    var imgWidth:Float = 0,imgHeight:Float = 0
    init() {
        super.init(name:"RenderTexture")
                //
        addAttribute("position", type: Vec4.self)
        addAttribute("textureUV", type: Vec2.self)
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
        
        
        
        let v1 = TextureMappingVertice(position: Vec4(leftTop.x,leftTop.y), textureUV: Vec2(ltx,lty))
        let v2 = TextureMappingVertice(position: Vec4(rightBottom.x,leftTop.y), textureUV: Vec2(rbx,lty))
        let v3 = TextureMappingVertice(position: Vec4(leftTop.x,rightBottom.y), textureUV: Vec2(ltx,rby))
        let v4 = TextureMappingVertice(position:Vec4(rightBottom.x,rightBottom.y), textureUV: Vec2(rbx,rby))
        
        imageVertices = [v1,v2,v3,v4]
    }
    
    func genImageVertices(position:Vec4,size:Vec2)
    {
        imageVertices[0].position = position
        imageVertices[1].position = Vec4(position.x+size.x,position.y)
        imageVertices[2].position = Vec4(position.x,position.y+size.y)
        imageVertices[3].position = Vec4(position.x+size.x,position.y+size.y)
    }
    var imageVertices:[TextureMappingVertice] = []
    
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
        
        imageVertices.append(TextureMappingVertice(position: Vec4(0,0), textureUV: Vec2(0,0)))
        
        imageVertices.append(TextureMappingVertice(position: Vec4(width,0), textureUV: Vec2(1,0)))
        
        imageVertices.append(TextureMappingVertice(position: Vec4(0,height), textureUV: Vec2(0,1)))
        
        imageVertices.append(TextureMappingVertice(position: Vec4(width,height), textureUV: Vec2(1,1)))
        
    }
    func bindImageTexture(texture:Texture,alpha:Float,leftTop:Vec4,rightBottom:Vec4)
    {
        shader.bind(getUniform("imageTexture")!,texture , index: 2)
        
        shader.bind(getUniform("alpha")!, alpha)
        shader.useProgram()
        genImageVertices(leftTop, rightBottom: rightBottom)
        bindVertexs(imageVertices)
    }
    func bindImageTexture(texture:Texture,alpha:Float,position:Vec4,size:Vec2)
    {
        
        shader.bind(getUniform("imageTexture")!,texture , index: 2)
        
        shader.bind(getUniform("alpha")!, alpha)
        shader.useProgram()
        genImageVertices(position, size: size)
        //genImageVertices(leftTop, rightBottom: rightBottom)
        bindVertexs(imageVertices)
    }
    func bindImageTexture(texture:Texture,alpha:Float)
    {
        bindImageTexture(texture, alpha: alpha, position: Vec4(0,0), size: Vec2(imgWidth,imgHeight))
        }
}
