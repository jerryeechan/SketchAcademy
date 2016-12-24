//
//  PointAttributeAnalyzer.swift
//  SwiftGL
//
//  Created by jerry on 2016/8/15.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import Foundation
import SwiftGL
import GLFramework
struct PointAnalyzeResult {
    init()
    {
        
    }
    var paintPoint:PaintPoint!;
    var directionChange:Float = 0.0
    var azimuthChange:Float = 0.0
    var speed:Float = 0.0
    var length:Float = 0.0
}

class PointAttributeAnalyzer{
    var points:[PointData]=[]
    
    init(points:[PointData]) {
        
        addPoints(points)
    }
    func addPoints(_ points:[PointData])
    {
        self.points += points
    }
    func addPoint(_ point:PointData)
    {
        points.append(point)
        dataUpdated()
    }
    
    func dataUpdated()
    {
        _sumCaled = false
        _averageCaled = false
    }
    func clear()
    {
        self.points = []
        
        _averageCaled =  false
        _sumCaled = false
    }
    var result:PointAnalyzeResult!
    func analyze()->PointAnalyzeResult
    {
        //var pAnalyzeResult:PointAnalyzeResult;
        result = average
        return result
    }
    func analyze(points:[PointData])->PointAnalyzeResult
    {
        clear()
        addPoints(points)
        return analyze()
    }
    
    
    var _averageData:PointAnalyzeResult!
    var _averageCaled:Bool = false
    var average:PointAnalyzeResult
        {
        get{
            if(!_averageCaled)
            {
                _averageData = calAverage()
                _averageCaled = true
            }
            return _averageData
        }
    }
    
    
    var _sumData:PointAnalyzeResult!
    var _sumCaled:Bool = false;
    var sum:PointAnalyzeResult
        {
        get{
            if(!_sumCaled)
            {
                _sumData = calSum()
                _sumCaled = true
            }
            return _sumData
        }
    }
    
    var pointNumF:Float{
        get{
            return Float(points.count)
        }
    }
    func square(_ value:Float)->Float
    {
        return value*value
    }
    
    
    
    
    // math funcitons
    func calAverage()->PointAnalyzeResult
    {
        var pAnaResult = sum
        
        pAnaResult.speed /= pointNumF
        pAnaResult.paintPoint.altitude /= pointNumF
        pAnaResult.paintPoint.azimuth /= pointNumF
        pAnaResult.paintPoint.force /= pointNumF
        pAnaResult.paintPoint.velocity /= pointNumF
        
        return pAnaResult
    }
    
    func calVariance()->PointAnalyzeResult
    {
        let avg = calAverage()
        let avgp = avg.paintPoint
        var pResult = PaintPoint(position: Vec4(), force: 0, altitude: 0, azimuth: Vec2(), velocity: Vec2())
        var pAnaResult = PointAnalyzeResult()
        //sigma x[i]^2
        for i in 0...points.count
        {
            let p = points[i].paintPoint
            pResult.altitude += square((p?.altitude)!)
            pResult.force += square((p?.force)!)
            pAnaResult.speed += square(avg.speed)
            //pResult.azimuth += square(points[i].azimuth)
        }
        //-N*mu^2
        pResult.altitude -= pointNumF*square((avgp?.altitude)!)
        pResult.force -= pointNumF*square((avgp?.force)!)
        
        pAnaResult.paintPoint = pResult
        return pAnaResult
        
        //pResult.azimuth -= pointNumF*avg.azimuth
    }
    func calSum()->PointAnalyzeResult
    {
        var pAnaResult:PointAnalyzeResult = PointAnalyzeResult()
        var pResult = PaintPoint(position: Vec4(), force: 0, altitude: 0, azimuth: Vec2(), velocity: Vec2())
        for i in 0..<points.count
        {
            let p = points[i].paintPoint
            
            pResult.altitude += (p?.altitude)!
            pResult.azimuth += (p?.azimuth)!
            pResult.force += (p?.force)!
            pResult.position += (p?.position)!
            pResult.velocity += (p?.velocity)!
            
            pAnaResult.length += (p?.velocity.length)!
            
            if(i != 0)
            {
                //pAnaResult.directionChange += velocity[i].unit - velocity[i-1].unit
                let td = Float(points[i].timestamps-points[i-1].timestamps)
                if(td != 0)
                {
                    pAnaResult.speed += (p?.velocity.length)!/td
                }
                
            }
        }
        pAnaResult.paintPoint = pResult
        return pAnaResult
    }
}
