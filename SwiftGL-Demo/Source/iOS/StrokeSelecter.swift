//
//  StrokeSelecter.swift
//  SwiftGL
//
//  Created by jerry on 2016/5/8.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//
import SwiftGL
class StrokeSelecter {
    var area:GLRect!
    var selectRectView:SelectRectView!
    var originalClip:PaintClip!
    var selectingClip:PaintClip!
    var selectedStrokes:[PaintStroke] = []
    var isSelectingClip:Bool = false
    
    init()
    {
        selectingClip = PaintClip(name: "selecting", branchAt: 0)
    }
    convenience init(selectRectView:SelectRectView)
    {
        self.init()
        self.selectRectView = selectRectView
        
    }
    
    var lastPoint:Vec2!
    var selectingPolyPoints:[Vec2]!
    
    
    
    func startSelectPolygon()
    {
        selectingPolyPoints = []
    }
    
    func addSelectPoint(point:Vec2)
    {
        DLog("\(point)")
        selectingPolyPoints.append(point)
        
        //testStrokes(point)
    }
    func selectStrokesInPolygon()->[PaintStroke]
    {
        return selectStrokesInPolygon(selectingPolyPoints)
    }
    //select strokes from a polygon area
    func selectStrokesInPolygon(points:[Vec2])->[PaintStroke]
    {
        selectedStrokes = []
        area = nil
        DLog("\(points)")
        for stroke in originalClip.strokes {
            DLog("\(stroke.bound)")
            if stroke.bound.center.isInsidePolygon(points)
            {
                selectedStrokes.append(stroke)
                expand(stroke)
            }
        }
        if area != nil
        {
            selectRectView.redraw(area)
        }
        selectingClip.strokes = selectedStrokes
        return selectedStrokes
    }
    
    func testStrokes(point:Vec2)->[PaintStroke]
    {
        let strokes = originalClip.selectStrokes(point)
        selectedStrokes = strokes
        return strokes
    }
    
    func expand(stroke:PaintStroke)
    {
        DLog("\(stroke.bound)")
        if area == nil
        {
            area = stroke.bound
        }
        else
        {
            area.union(stroke.bound)
        }
        
    }
    func exitSelectionMode()
    {
        selectedStrokes = []
    }
}

extension Vec2 {
    func isInsidePolygon(vertices: [Vec2]) -> Bool {
        guard !vertices.isEmpty else { return false }
        var j = vertices.last!, c = false
        for i in vertices {
            let a = (i.y > y) != (j.y > y)
            let b = (x < (j.x - i.x) * (y - i.y) / (j.y - i.y) + i.x)
            if a && b { c = !c }
            j = i
        }
        return c
    }
}
