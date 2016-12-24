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

public class GLTransformation{
    var projectionMatrix = Mat4.identity()
    var modelViewMatrix = Mat4.identity()
    public static var instance:GLTransformation!
    public init()
    {
        GLTransformation.instance = self
        //qubeTest()
    }
    public var width:Float!
    public var height:Float!
    public func getTransformPercentMatrix(_ left:Float,right:Float,top:Float,bottom:Float)->Mat4
    {
        
        projectionMatrix = Mat4.ortho(left: left*width, right: right*width, bottom: bottom*height, top:top*height, near: -1, far: 1 );
        // this sample uses a constant identity modelView matrix
        modelViewMatrix = Mat4.identity();
        mvpMatrix = projectionMatrix * modelViewMatrix
        return mvpMatrix
    }
    public func resize(_ width:GLint,height:GLint)
    {
        self.width = Float(width)
        self.height = Float(height)
        
        //orthoview of full screen, original width
        projectionMatrix = Mat4.ortho(left: 0, right:self.width, bottom: 0, top:Float(height), near: -1, far: 1 );
        // this sample uses a constant identity modelView matrix
        modelViewMatrix = Mat4.identity();
        mvpMatrix = projectionMatrix * modelViewMatrix
        
        //GLContextBuffer.shader.bind("MVP", MVPMatrix)
        
        
        
        
        glViewport(0, 0, GLsizei(width), GLsizei(height))
        //print("width and height:\(width) \(height)")
        //GLShaderBinder.instance.shader.bind("Matrix", projection * Mat4.translate(x: 0, y: 0, z: -5) * modelview)
       
        //GLShaderBinder.instance.bindMVP(MVPMatrix)
        DLog("\(self.width)")
        
        //shift half size of screen
        mvpShiftedMatrix = mvpMatrix * Mat4.translate(Vec2(self.width/2,0))
        GLShaderBinder.instance.bindMVPBrush(mvpMatrix)
        GLShaderBinder.instance.bindMVPRenderTexture(mvpShiftedMatrix)
        
    }
    var mvpShiftedMatrix:Mat4 = Mat4.identity()
    var mvpMatrix:Mat4 = Mat4.identity()
    public func calTransformMat(_ translation:Vec2,rotation:Float,scale:Float)
    {
        modelview = Mat4.identity()*Mat4.translate(translation) * Mat4.rotateZ(rotation) * Mat4.scale(scale)
        //GLShaderBinder.instance.bindMVP(MVPMatrix)
    }
    var modelview  = Mat4.identity()
    var projection = Mat4.identity()
    
}
