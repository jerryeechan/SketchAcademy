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
class GLShaderWrapper {
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
                print("failed to load pencil shader")
                glDebug(__FILE__, line: __LINE__)
        }
    }
    func addUniform(uniformName:String)
    {
        uniformDict[uniformName] = glGetUniformLocation(shader.id, uniformName)
    }
    func addAttribute<T:GLType>(name:String,type:T.Type)
    {
        let iLoc = GLuint(glGetAttribLocation(shader.id, name))
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

}
