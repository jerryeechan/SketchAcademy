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
        //print("width and height:\(width) \(height)")
        //GLShaderBinder.instance.shader.bind("Matrix", projection * Mat4.translate(x: 0, y: 0, z: -5) * modelview)
       // GLShaderBinder.instance.shader.bind("Matrix", MVPMatrix)
        GLShaderBinder.instance.bindMVP(MVPMatrix)
        
    }
    var modelview  = Mat4.identity()
    var projection = Mat4.identity()
    
}
