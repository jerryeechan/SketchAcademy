//
//  GLShaderWrapper.swift
//  SwiftGL
//
//  Created by jerry on 2016/3/13.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//
import SwiftGL
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
class GLShaderWrapper:ModelViewProjectionProtocol{
    var shader:Shader!
    var uniformDict:[String:GLint] = [String:GLint]()
    var attributes = [Attribute]()
    
    //only load the shader, inherite custom class to add attribute and uniform
    init(name:String)
    {
        shader = Shader()
        if !(shader.load( "\(name).vsh","\(name).fsh") {
            program in
            }) {
                // You can take this out after. Useful for debugging
                DLog("failed to load \(name) shader")
                glDebug(#file, line: #line)
        }
    }
    func addUniform(uniformName:String)
    {
        uniformDict[uniformName] = glGetUniformLocation(shader.id, uniformName)
    }
    func addAttribute<T:GLType>(name:String,type:T.Type)
    {
        let iLoc = GLuint(glGetAttribLocation(shader.id, name))
        glEnableVertexAttribArray(iLoc)
        attributes.append(Attribute(i: iLoc, t: type))
    }
    func getUniform(name:String)->GLint!
    {
        let uniform = uniformDict[name]
        if uniform == nil
        {
            DLog("uniform not bound")
        }
        
        return uniform
    }
    func bindVertexs<T>(vertextBuffer:[T])
    {
        //bind vertex buffer to vertex buffer object
        let vao = GLShaderBinder.instance.vao
        let vbo = GLShaderBinder.instance.vbo
        
        vbo.bind(vertextBuffer, count: vertextBuffer.count)
        
        //bind attribute to vertex attribute object
        var offset:GLsizeiptr = 0
        for attrib in attributes
        {
            vao.bind(attribute: attrib.iLoc, glType: attrib.glType, glNormalized: attrib.glNormalized, glSize: attrib.glSize, vbo: vbo, offset: offset)
            offset+=attrib.offset
        }
    }
    func useShader()
    {
        shader.useProgram()
    }
    func bindMVP(mat4:Mat4)
    {
        shader.bind(getUniform("MVP"), mat4)
    }
    /*
    func bindAttrib<T:GLType>(attrib:GLuint,type:T.Type,offset:GLsizeiptr)
    {
        let vao = GLShaderBinder.instance.vao
        let vbo = GLShaderBinder.instance.vbo
        vao.bind(attribute:attrib, type: type, vbo: vbo, offset: offset)
    }
*/
}
