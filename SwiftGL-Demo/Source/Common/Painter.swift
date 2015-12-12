//
//  Painter.swift
//  SwiftGL
//
//  Created by jerry on 2015/5/21.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import OpenGLES.ES2
import SwiftGL



class Painter{
    /*
    static let kBrushOpacity:Float	 =	(1.0 / 3.0)
    static let kBrushPixelStep:Float	 =	3
    static let kBrushScale:Float		=	2
    
    */
    
    static var scale:Float = 1
    static var layer:Int = 0
    static var currentBrush:PaintBrush!
    
    /**
        Render an entire stroke
     */
    
    static func renderStroke(stroke:PaintStroke)
    {
        /*
        GLShaderBinder.instance.bindBrushColor(stroke.valueInfo.color.vec)
        GLShaderBinder.instance.bindBrushSize(stroke.valueInfo.size)
        GLContextBuffer.instance.drawBrushVertex(stroke.points)
        GLContextBuffer.instance.endStroke()
        */
        PaintToolManager.instance.changeTool(stroke.stringInfo.toolName)
        PaintToolManager.instance.loadToolValueInfo(stroke.valueInfo)
        print(stroke.stringInfo.toolName)
        PaintToolManager.instance.useCurrentTool()
        GLContextBuffer.instance.drawStroke(stroke,layer: layer)
    }
    
    /**
        Render point array
    */
    static func renderStaticLine(points:[PaintPoint])
    {
        
        var vertexBuffer:[PaintPoint] = []
        let kBrushPixelStep:Float = 2 * points[0].size
        
        var left:Float = points.last!.position.x
        var right:Float = points.last!.position.x
        var top:Float = points.last!.position.y
        var bottom:Float = points.last!.position.y
        
        //srand(0)
        for var i = 0 ; i < points.count-1 ; i++
        {
            if points[i].position.x < left
            {
                left = points[i].position.x
            }
            else if points[i].position.x > right
            {
                right = points[i].position.x
            }
            
            if points[i].position.y < top
            {
                top = points[i].position.y
            }
            else if points[i].position.y > bottom
            {
                bottom = points[i].position.y
            }
            
            let ep = points[i]
            let sp = points[i+1]
            
            var count:Int;
            
            // Convert locations from Points to Pixels
            /* CGFloat scale = self.contentScaleFactor;
            start.x *= scale;
            start.y *= scale;
            end.x *= scale;
            end.y *= scale;*/
            
            //var sp = start*scale
            //var ep = end*scale
            
            
            let xdis2 = powf((ep.position.x - sp.position.x),2)
            
            let ydis2 = powf((ep.position.y - sp.position.y),2)
            
            // Add points to the buffer so there are drawing points every X pixels
            let pnum = ceil(sqrt(xdis2 + ydis2) / kBrushPixelStep)
            
            count = max(Int(pnum),1);
            if(count == 1)
            {
                print("...")
            }
            
            for var j = 0; j < count; ++j {
                //let randAngle = Float(arc4random()) / Float(UINT32_MAX) * Pi/2
                let randAngle = Float(rand() % 360) / 360 * Pi/2
                let d = Float(j)/Float(count)
                let px = sp.position.x+(ep.position.x-sp.position.x)*d
                let py = sp.position.y+(ep.position.y-sp.position.y)*d
                let v = PaintPoint(position: Vec4(px,py),color: sp.color,size: sp.size, rotation: randAngle)
                
                vertexBuffer.append(v)
            }
        }
        
        GLContextBuffer.instance.drawBrushVertex(vertexBuffer,layer: layer)

    }
    static func renderLine(vInfo:ToolValueInfo,prev2:PaintPoint,prev1:PaintPoint,cur:PaintPoint)
    {
        GLShaderBinder.instance.bindBrushInfo(vInfo)
        var vertextBuffer:[PaintPoint] = []
        //smooth line
        
        let midPoint1:Vec4 = (prev1.position+prev2.position)*0.5
        let midPoint2:Vec4 = (cur.position+prev1.position)*0.5

        //let segmentDistance:Float = 10  ;
        
        let dis = (midPoint1-midPoint2).length
        
        let numberOfSegments = max((dis/2/prev1.size),1)//min(128, max(floorf(dis / segmentDistance), 32));
        let noS = Int(numberOfSegments)
        var t:Float = 0.0;
        let step:Float = 1.0 / (numberOfSegments-1);
        
        for var j = 0; j < noS; j++
        {
            let p1 = powf(1-t, 2)
            let p2 = 2 * (1-t) * t
            let p3 = t * t
            
            let it1 = midPoint1 * p1
            let it2 = prev1.position * p2
            let it3 = midPoint2 * p3
            let pos = it1+it2+it3
            
            
            let s1 = (prev1.size + prev2.size) * 0.5 * p1
            let s2 = prev1.size * p2
            let s3 = (prev1.size+cur.size)*0.5*p3
            let size = s1+s2+s3
            
            var randAngle:Float = 0
            if PaintToolManager.instance.currentTool.name != "markerTexture"
            {
                randAngle = Float(rand() % 360) / 360 * Pi/2
            }
            let newVert:PaintPoint = PaintPoint(position: pos,color: vInfo.color.vec,size: size, rotation: randAngle)

                    // 6
                   // newPoint.pos = ccpAdd(ccpAdd(ccpMult(midPoint1, powf(1 - t, 2)), ccpMult(prev1.pos, 2.0f * (1 - t) * t)), ccpMult(midPoint2, t * t));
                   // newPoint.width = powf(1 - t, 2) * ((prev1.width %2B prev2.width) * 0.5f) %2B 2.0f * (1 - t) * t * prev1.width %2B t * t * ((cur.width %2B prev1.width) * 0.5f);
                    
            vertextBuffer.append(newVert)
            t+=step
        }
        
                // 7
        
       // let v = PaintPoint(position: Vec4(midPoint2.x,midPoint2.y),color: brush.color.vec,size:(cur.size+prev1.size) * 0.5 )
        //vertextBuffer.append(v)
        //        finalPoint.width = (cur.width %2B prev1.width) * 0.5f;
                //[smoothedPoints addObject:finalPoint];
            // 8
         //   [points removeObjectsInRange:NSMakeRange(0, [points count] - 2)];
        //  return smoothedPoints;
            

        /*
        var count:Int,i:Int;
        
        // Convert locations from Points to Pixels
       /* CGFloat scale = self.contentScaleFactor;
        start.x *= scale;
        start.y *= scale;
        end.x *= scale;
        end.y *= scale;*/
        
        var sp = start*scale
        var ep = end*scale
        
        
        var xdis2 = powf((ep.x - sp.x),2)
        
        var ydis2 = powf((ep.y - sp.y),2)
        
        // Add points to the buffer so there are drawing points every X pixels
        let pnum = ceil(sqrt(xdis2 + ydis2) / kBrushPixelStep)
        count = max(Int(pnum),1);
        
        for i = 0; i < count; ++i {
            let d = Float(i)/Float(count)
            let px = sp.x+(ep.x-sp.x)*d
            let py = sp.y+(ep.y-sp.y)*d
            let v = Vertex(position: Vec4(px,py),color: brush.color.vec)
            
            vertextBuffer.append(v)
        }
*/
       GLContextBuffer.instance.drawBrushVertex(vertextBuffer,layer: layer)
        
    }
    
}

