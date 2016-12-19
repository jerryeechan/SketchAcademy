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
        self.isOpaque = false;
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.clear(rect)
        context?.setFillColor(red: 18.0/255.0, green: 173.0/255.0, blue: 251.0/255.0,alpha: 1)
        context?.fillEllipse(in: rect)
    }
}
