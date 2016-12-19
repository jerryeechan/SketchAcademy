//
//  SelectingRectView.swift
//  SwiftGL
//
//  Created by jerry on 2016/5/7.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//
import UIKit
import SwiftGL
class SelectRectView: UIView{
    
    let enable = false
    override func draw(_ rect: CGRect) {
        if enable
        {
            let context = UIGraphicsGetCurrentContext()
            drawDashedBorder(context!)
        }
        
    }
    
    
    override func layoutSubviews() {
        superFrame = superview?.bounds
        
    }
    var superFrame:CGRect!
    func redraw(_ rect:GLRect)
    {
        DLog("\(rect)")
        
        frame =
            CGRect(x: rect.leftTop.x.cgFloat/2, y: superFrame.height - (rect.leftTop.y+rect.height).cgFloat/contentScaleFactor, width: CGFloat(rect.width/2), height: CGFloat(rect.height/2))
        
        setNeedsDisplay()
    }
    var phase:CGFloat = 0
    func drawDashedBorder(_ currentContext:CGContext) {
        //CGContextClearRect(currentContext, bounds)
        //let innerRect = CGRectInset(bounds, 20.0, 20.0)
        
        
        
        currentContext.setStrokeColor (red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) // Black
        
        currentContext.setLineWidth (1.0)
        currentContext.setLineDash(phase: phase, lengths: [3,3])
        
        currentContext.stroke(bounds)
        //CGContextStrokeEllipseInRect (currentContext, innerRect)
    }

}
extension Float
{
    var cgFloat:CGFloat
    {
        get{
            return CGFloat(self)
        }
    }
}
