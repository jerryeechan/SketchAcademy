//
//  ControlPointView.swift
//  SwiftGL
//
//  Created by jerry on 2015/8/18.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import UIKit
class ControlPointView: UIView{
    var color:UIColor!
    
    override init(frame : CGRect)
    {
        
        super.init(frame: frame)
        
        // Initialization code
        self.color = UIColor(red: 18.0/255.0, green: 173.0/255.0, blue: 251.0/255.0, alpha: 1)
        self.opaque = false;
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        CGContextClearRect(context, rect)
        CGContextSetRGBFillColor(context,18.0/255.0, 173.0/255.0, 251.0/255.0,1)
        CGContextFillEllipseInRect(context, rect)
    }
}