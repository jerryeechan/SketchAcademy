//
//  RealTimeStrokeDiagnoser.swift
//  SwiftGL
//
//  Created by jerry on 2016/12/27.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import UIKit
import GLFramework
public class RealTimeStrokeDiagnoser {
    
    public init()
    {
    
    }
    
    public weak var forceLabel:UILabel!
    public weak var altitudeLabel:UILabel!
    public func newPoint(point:PaintPoint)
    {
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
        
        forceLabel.text = "force:\(forceText)"
        
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
        
        altitudeLabel.text = "altitude:\(altitudeText)"
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
        forceAvg = Sigma.average(forces)!
        if forces.count>1
        {
            forceStd = Sigma.standardDeviationSample(forces)!
        }
        else
        {
            forceStd = 0
        }
        
        let altitudes = stroke.points.map({Double($0.altitude)})
        altitudeAvg = Sigma.average(altitudes)!
        
        
    }
    
}
