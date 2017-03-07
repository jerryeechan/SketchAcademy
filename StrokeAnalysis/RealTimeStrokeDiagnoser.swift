//
//  RealTimeStrokeDiagnoser.swift
//  SwiftGL
//
//  Created by jerry on 2016/12/27.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import UIKit
import GLFramework
import SwiftGL
public class RealTimeStrokeDiagnoser {
    
    public class var instance:RealTimeStrokeDiagnoser{
        struct Singleton{
            static let instance = RealTimeStrokeDiagnoser()
        }
        return Singleton.instance
    }
    public init()
    {
        
        
    }
    
    public func reset()
    {
        pointCount = 0
        azimuthCorrect = 0
    }
    public func result()->Float
    {
        var r = Float(azimuthCorrect)/Float(pointCount)
        if pointCount == 0
        {
            r = 1
        }
        reset()
        return r
    }
    public func realtime()->Float
    {
        return current
    }
    public weak var forceLabel:UILabel!
    public weak var altitudeLabel:UILabel!
    
    var pointCount:Int = 0
    var azimuthCorrect:Int = 0
    var current:Float = 0
    public func newPoint(point:PaintPoint)
    {
        print(point.azimuth.unit)
        pointCount = pointCount+1
        let diff = (point.azimuth.unit-Vec2(0.7,0.7)).length2
        
        current = diff
        if(diff < 0.025)
        {
            azimuthCorrect = azimuthCorrect+1
        }
        
        var forceText = "剛好";
        let forceRatio = point.force/Float(forceAvg)
        
        if(forceRatio>1.2)
        {
            forceText = "輕點"
        }
        else if forceRatio < 0.8
        {
            forceText = "用力點"
        }
        
        //forceLabel.text = "force:\(forceText)"
        
        var altitudeText = "剛好"
        let altRatio = point.altitude/Float(altitudeAvg)
        
        if(altRatio>1.1)
        {
            altitudeText = "斜一點"
        }
        else if altRatio < 0.9
        {
            altitudeText = "直一點"
        }
        
        //altitudeLabel.text = "altitude:\(altitudeText)"
    }
    var _refStroke:PaintStroke!
    public var refStroke:PaintStroke{
        set{
            _refStroke = newValue
            parseStroke(stroke: _refStroke)
        }
        get{
            return _refStroke
        }
    }
    
    var forceAvg:Double = 0
    var forceStd:Double = 0
    var altitudeAvg:Double = 0
    var altitudeStd:Double = 0
    func parseStroke(stroke:PaintStroke)
    {
        let forces = stroke.points.map({Double($0.force)})
        let altitudes = stroke.points.map({Double($0.altitude)})
        if forces.count>1
        {
            forceAvg = Sigma.average(forces)!
            forceStd = Sigma.standardDeviationSample(forces)!
            altitudeAvg = Sigma.average(altitudes)!
        }
        else
        {
            forceStd = 0
        }
        
        
        
        
        
    }
    
}
