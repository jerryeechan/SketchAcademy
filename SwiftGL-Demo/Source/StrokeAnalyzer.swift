//
//  StrokeAnalyzer.swift
//  SwiftGL
//
//  Created by jerry on 2016/8/7.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import UIKit
import GLFramework
class StrokeAnalyzer{
    
    var speeds:[Double] = []
    var lengths:[Double] = []
    var forces:[Double] = []
    func analyze(_ strokes:[PaintStroke]){
        
        for stroke in strokes
        {
            let result = pointAnalyzer.analyze(points: stroke.pointData);
            speeds.append(Double(result.speed))
            forces.append(Double(result.paintPoint.force))
            lengths.append(Double(result.length))
        }
        let maxSpeed = speeds.max()
        let maxLength = lengths.max()
        
        //max force is 1
        for i in 0..<speeds.count
        {
            speeds[i] /= maxSpeed!
            lengths[i] /= maxLength!
        }
        
    }
    func briefLength()->[Double]
    {
        return reduceArray(lengths)
    }
    func briefSpeeds()->[Double]
    {
        return reduceArray(speeds)
    }
    func briefForces()->[Double]
    {
        return reduceArray(forces)
    }
    
    func reduceArray(_ array:[Double])->[Double]
    {
        if(array.count<100)
        {
            return array
        }
        var result:[Double] = []
        let target = 100
        let section = array.count/target
        var count = 0
        var v:Double = 0
        for i in 0..<array.count
        {
            v += array[i]
            count += 1
            if count == section
            {
                result.append(v/Double(section))
                count = 0
                v = 0
            }
        }
        return result
    }
    
    var pointAnalyzer:PointAttributeAnalyzer = PointAttributeAnalyzer(points: [])
    func updateStroke(_ stroke:PaintStroke)
    {
       // pointAnalyzer.addPoint(asdf)
    
    //    for var i=1;i<pointData.count;i=i+1{
 //                }
 
        //pointData.first?.paintPoint.velocity
        //pointData.last?.timestamps
    }
    
}
/*
extension _ArrayType where Iterator.Element == String {
    var doubleArray: [Double] {
        return flatMap{ Double($0) }
    }
    var floatArray: [Float] {
        return flatMap{ Float($0) }
    }
}
 */
