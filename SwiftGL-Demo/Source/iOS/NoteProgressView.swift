//
//  NoteProgressView.swift
//  SwiftGL
//
//  Created by jerry on 2016/2/10.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import Foundation
class NoteProgressView:UIView{
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        setNeedsDisplay()
        for subview in subviews
        {
            if subview.point(inside: self.convert(point, to: subview), with: event)
            {
                return true
            }
        }
        return super.point(inside: point, with: event)
    }
    override func draw(_ rect: CGRect) {
        DLog("droaw")
      
    }
}
