//
//  GLShaderWrapper.swift
//  SwiftGL
//
//  Created by jerry on 2016/3/13.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//
import SwiftGL
public struct Attribute{
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
        offset = MemoryLayout<T>.size
    }
}
public class GLShaderWrapper:ModelViewProjectionProtocol{
    var shader:Shader!
    var uniformDict:[String:GLint] = [String:GLint]()
    var attributes = [Attribute]()
    
    //only load the shader, inherite custom class to add attribute and uniform
    public init(name:String)
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
    public func addUniform(_ uniformName:String)
    {
        uniformDict[uniformName] = glGetUniformLocation(shader.id, uniformName)
    }
    public func addAttribute<T:GLType>(_ name:String,type:T.Type)
    {
        let iLoc = GLuint(glGetAttribLocation(shader.id, name))
        glEnableVertexAttribArray(iLoc)
        attributes.append(Attribute(i: iLoc, t: type))
    }
    public func getUniform(_ name:String)->GLint!
    {
        let uniform = uniformDict[name]
        if uniform == nil
        {
            DLog("uniform not bound")
        }
        
        return uniform
    }
    public func bindVertexs<T>(_ vertextBuffer:[T])
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
    public func useShader()
    {
        shader.useProgram()
    }
    public func bindMVP(_ mat4:Mat4)
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
