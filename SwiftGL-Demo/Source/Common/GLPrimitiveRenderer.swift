//
//  GLPrimitiveDrawer.swift
//  SwiftGL
//
//  Created by jerry on 2016/3/13.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//
import SwiftGL


extension GLContextBuffer
{
    func setLineAttribute(){
        
    }
    func drawLine(_ start:Vec4,end:Vec4){
        let vertexBuffer:[Vec4] = [start,end]
        
        shaderBinder.primitiveShader.bindColor(Vec4(0,0,0,1))
        shaderBinder.primitiveShader.bindVertexs(vertexBuffer)
        shaderBinder.primitiveShader.useShader()
        glLineWidth(8)
        //glDrawArrays(GL_POINTS, 0, 4)
        let size = vertexBuffer.count
        glDrawArrays(GL_LINES, 0, GLsizei(size))

    }
    func drawLines(_ points:[Vec4])
    {
        shaderBinder.primitiveShader.bindColor(Vec4(0,0,0,1))
        shaderBinder.primitiveShader.bindVertexs(points)
        shaderBinder.primitiveShader.useShader()
        glDrawArrays(GL_LINES, 0, GLsizei(points.count))
    }
    func drawGrid(_ size:Float){
        shaderBinder.primitiveShader.bindMVP(mvpOffset)
        let height = Float(imgHeight)
        let width = Float(imgWidth)
        var vertexBuffer:[Vec4] = []
        for i in stride(from: 0, to: width, by: size)
        {
            vertexBuffer.append(Vec4(i,0))
            vertexBuffer.append(Vec4(i,height))
        }
        for j in stride(from: 0, to: height, by: size)
        {
            vertexBuffer.append(Vec4(0,j))
            vertexBuffer.append(Vec4(width,j))
        }
        shaderBinder.primitiveShader.bindColor(Vec4(0,0,0,1))
        shaderBinder.primitiveShader.bindVertexs(vertexBuffer)
        shaderBinder.primitiveShader.useShader()
        glLineWidth(4)
        glDrawArrays(GL_LINES, 0, GLsizei(vertexBuffer.count))
    }
    
    func drawLineRectangle(_ rect:GLRect,color:Vec4)
    {
        let leftTop = rect.leftTop
        let rightButtom = rect.rightButtom
        var vertexBuffer:[Vec4] = []
        vertexBuffer.append(Vec4(leftTop.x,leftTop.y))
        vertexBuffer.append(Vec4(leftTop.x,rightButtom.y))
        vertexBuffer.append(Vec4(rightButtom.x,rightButtom.y))
        vertexBuffer.append(Vec4(rightButtom.x,leftTop.y))
        
        /*
         if renderTexture.setPrimitiveBuffer() == false{
         print("Framebuffer fail")
         }
         */
        shaderBinder.primitiveShader.bindColor(color)
        shaderBinder.primitiveShader.bindVertexs(vertexBuffer)
        shaderBinder.primitiveShader.useShader()
        glLineWidth(8)
        glDrawArrays(GL_LINE_LOOP, 0, 4)
    }
    func drawFillRectangle(_ rect:GLRect,color:Vec4)
    {
        let leftTop = rect.leftTop
        let rightButtom = rect.rightButtom
        var vertexBuffer:[Vec4] = []
        vertexBuffer.append(Vec4(leftTop.x,leftTop.y))
        vertexBuffer.append(Vec4(leftTop.x,rightButtom.y))
        vertexBuffer.append(Vec4(rightButtom.x,leftTop.y))
        vertexBuffer.append(Vec4(rightButtom.x,rightButtom.y))
        
        
        /*
         if renderTexture.setPrimitiveBuffer() == false{
         print("Framebuffer fail")
         }
         */
        shaderBinder.primitiveShader.bindMVP(mvpOffset)
        shaderBinder.primitiveShader.bindColor(color)
        shaderBinder.primitiveShader.bindVertexs(vertexBuffer)
        shaderBinder.primitiveShader.useShader()
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4)
    }
        
}
