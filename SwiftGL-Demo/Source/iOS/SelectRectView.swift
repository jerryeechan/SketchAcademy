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
    override func drawRect(rect: CGRect) {
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
    func redraw(rect:GLRect)
    {
        DLog("\(rect)")
        
        frame =
            CGRect(x: rect.leftTop.x.cgFloat/2, y: superFrame.height - (rect.leftTop.y+rect.height).cgFloat/contentScaleFactor, width: CGFloat(rect.width/2), height: CGFloat(rect.height/2))
        
        setNeedsDisplay()
    }
    var phase:CGFloat = 0
    func drawDashedBorder(currentContext:CGContext) {
        //CGContextClearRect(currentContext, bounds)
        //let innerRect = CGRectInset(bounds, 20.0, 20.0)
        
        
        
        CGContextSetRGBStrokeColor (currentContext, 0.0, 0.0, 0.0, 1.0) // Black
        
        CGContextSetLineWidth (currentContext, 1.0)
        CGContextSetLineDash(currentContext, phase, [3,3], 2)
        CGContextStrokeRect(currentContext, bounds)
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
