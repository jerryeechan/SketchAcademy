//
//  DemoScene.swift
//  SwiftGL-Demo
//
//  Created by Scott Bennett on 2014-06-09.
//  Copyright (c) 2014 Scott Bennett. All rights reserved.
//

import Foundation

#if os(OSX)
import OpenGL
#else
import OpenGLES.ES2
#endif

/// IMPORTANT: The SwiftGL framework must be imported to be able to use it
import SwiftGL


class DemoScene{
    
    /*
    let shader:Shader!
    var modelview  = Mat4.identity()
    var projection = Mat4.identity()
    
    init() {
        //qubeSetup()
    //flush()
    }
    func qubeSetup()
    {
        // Load the Shader files
        if !(shader.load("DemoShader1.vsh", "DemoShader1.fsh") {
            program in
            // Here we will bind the attibute names to the correct position
            // Doing this will allow us to use the VBO/VAO with more than one shader, ensuring that the right
            // values get passed in to the correct shader variables
            glBindAttribLocation(program, AttribPosition, "Position")
            glBindAttribLocation(program, AttribColor,    "Color")
            
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
    func setupShader()
    {
        
       
        /*
        // point size
        shader.bind("pointSize",Float(brush.texture.width)/kBrushScale)
        
        // initialize brush color
        shader.bind("vertexColor",brush.color.vec)
        */
        
    }
    
    func update() {
        // Rotate the matrix by 1 deg each frame (1 full rotation should take 6 seconds)
        modelview *= Mat4.rotateZ(radians(0.25))
        modelview *= Mat4.rotateY(radians(0.50))
        modelview *= Mat4.rotateX(radians(0.75))
    }
    func flush()
    {
        glDepthFunc(GL_LESS)
        glEnable(GL_DEPTH_TEST)
        // Clear the screen to white before we draw anything
        glClearColor(1, 1, 1, 1)
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
        println("flush")
    }
    func render() {
        

        flush()
        Painter.renderLine(Vec2(0,0),end: Vec2(300,300))
        Painter.renderLine(Vec2(300,0),end: Vec2(0,300))
        // Finally submit what we are drawing to the GPU
       println("render called")
        
        
    }
    
    func resize(#width: Float, height: Float) {
        glViewport(0, 0, GLsizei(width), GLsizei(height))
        
        let projectionMatrix = Mat4.ortho(left: 0, right:width, bottom: 0, top:height, near: -1, far: 1 );
        let modelViewMatrix = Mat4.identity(); // this sample uses a constant identity modelView matrix
        let MVPMatrix = projectionMatrix * modelViewMatrix
        
        //shader.useProgram()
        // glViewport(0, 0, GLsizei(width),GLsizei(height))
        //shader.bind("Matrix", MVPMatrix,transpose: GL_FALSE)

        //projection = projection
       // projection = Mat4.perspective(fovy: radians(45), width: width, height: height, near: 1, far: 9)
        //projection = projectionMatrix
        
       
        
        // Bind the updated matrix
       // shader.bind("Matrix", projection * Mat4.translate(x: 0, y: 0, z: -5) * modelview)
       
        shader.bind("MVP", MVPMatrix)
    */
}
