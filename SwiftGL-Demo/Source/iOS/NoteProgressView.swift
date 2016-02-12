//
//  NoteProgressView.swift
//  SwiftGL
//
//  Created by jerry on 2016/2/10.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import Foundation
class NoteProgressView:UIView{
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        setNeedsDisplay()
        for subview in subviews
        {
            if subview.pointInside(self.convertPoint(point, toView: subview), withEvent: event)
            {
                return true
            }
        }
        return super.pointInside(point, withEvent: event)
    }
    override func drawRect(rect: CGRect) {
        DLog("droaw")
      
    }
}