//
//  GLTransformation.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/22.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import Foundation
import SwiftGL
import OpenGLES.ES2

class GLTransformation{
    var projectionMatrix = Mat4.identity()
    var modelViewMatrix = Mat4.identity()
    var MVPMatrix = Mat4.identity()
    
    init(width:GLint,height:GLint)
    {
        resize(width, height: height)
        
        //qubeTest()
    }
    func resize(width:GLint,height:GLint)
    {
        projectionMatrix = Mat4.ortho(left: 0, right:Float(width), bottom: 0, top:Float(height), near: -1, far: 1 );
        // this sample uses a constant identity modelView matrix
        modelViewMatrix = Mat4.identity();
        MVPMatrix = projectionMatrix * modelViewMatrix
        
        //GLContextBuffer.shader.bind("MVP", MVPMatrix)
        GLShaderBinder.instance.bindMVP(MVPMatrix)
        
        glViewport(0, 0, GLsizei(width), GLsizei(height))
        print("\(width) \(height)")
        //GLShaderBinder.instance.shader.bind("Matrix", projection * Mat4.translate(x: 0, y: 0, z: -5) * modelview)
       // GLShaderBinder.instance.shader.bind("Matrix", MVPMatrix)
        GLShaderBinder.instance.bindMVP(MVPMatrix)
        
    }
    var modelview  = Mat4.identity()
    var projection = Mat4.identity()
    func qubeTest()
    {
        
        let width = Float(600)
        let height = Float(600)
        glViewport(0, 0, GLsizei(width), GLsizei(height))
        
        //let projectionMatrix = Mat4.ortho(left: 0, right:width, bottom: 0, top:height, near: -1, far: 1 );
//        /let modelViewMatrix = Mat4.identity(); // this sample uses a constant identity modelView matrix
        //let MVPMatrix = projectionMatrix * modelViewMatrix
        
        //shader.useProgram()
        // glViewport(0, 0, GLsizei(width),GLsizei(height))
        //shader.bind("Matrix", MVPMatrix,transpose: GL_FALSE)
        
        //projection = projection
         projection = Mat4.perspective(fovy: radians(45), width: width, height: height, near: 1, far: 9)
        //projection = projectionMatrix
        
        
        
        // Bind the updated matrix
         GLShaderBinder.instance.shader.bind("Matrix", projection * Mat4.translate(x: 0, y: 0, z: -5) * modelview)
        
        //shader.bind("MVP", MVPMatrix)

    }
}
