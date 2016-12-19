//
//  CanvasCropView.swift
//  SwiftGL
//
//  Created by jerry on 2015/8/18.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import UIKit

let square:Bool = false
let IMAGE_MIN_HEIGHT:CGFloat = 100;
let IMAGE_MIN_WIDTH:CGFloat = 100;

func SquareCGRectAtCenter(_ centerX:CGFloat,  centerY:CGFloat,  size:CGFloat)->CGRect {
     let x = centerX - size / 2.0;
     let y = centerY - size / 2.0;
    return CGRect(x: x, y: y, width: size, height: size);
}

struct DragPoint {
    var dragStart: CGPoint
    var topLeftCenter: CGPoint
    var bottomLeftCenter: CGPoint
    var bottomRightCenter: CGPoint
    var topRightCenter: CGPoint
    var clearAreaCenter: CGPoint
}

class CanvasCropView:  UIView{
    
    var shadeView:ShadeView!
    var cropAreaView:UIView!
    var controlPointSize:CGFloat = 5
    
    var topLeftPoint:ControlPointView!
    var bottomLeftPoint:ControlPointView!
    var bottomRightPoint:ControlPointView!
    var topRightPoint:ControlPointView!
    
    var pointsArray:[ControlPointView]!
    
    var dragViewOne:UIView!
    var dragPoint:DragPoint!
    
    var imageFrameInView:CGRect!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initView()
    {
        let centerInView:CGPoint = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        let initialClearAreaSize = self.frame.size.width / 10;
        
        topLeftPoint = ControlPointView(frame: SquareCGRectAtCenter(centerInView.x - initialClearAreaSize, centerY: centerInView.y - initialClearAreaSize, size:controlPointSize))
        
        bottomLeftPoint = ControlPointView(frame: SquareCGRectAtCenter(centerInView.x - initialClearAreaSize, centerY: centerInView.y + initialClearAreaSize, size:controlPointSize))
        
        bottomRightPoint = ControlPointView(frame: SquareCGRectAtCenter(centerInView.x + initialClearAreaSize, centerY: centerInView.y + initialClearAreaSize, size:controlPointSize))
        
        topRightPoint = ControlPointView(frame: SquareCGRectAtCenter(centerInView.x + initialClearAreaSize, centerY: centerInView.y - initialClearAreaSize, size:controlPointSize))
        
        
        
        shadeView = ShadeView(frame: self.bounds)
        let cropArea = clearAreaFromControlPoints()
        cropAreaView = UIView(frame: cropArea)
        cropAreaView.backgroundColor = UIColor.clear
        
        self.addSubview(shadeView)
        self.addSubview(cropAreaView)
        self.addSubview(topRightPoint)
        self.addSubview(bottomRightPoint)
        self.addSubview(topLeftPoint)
        self.addSubview(bottomLeftPoint)
        
        imageFrameInView = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        
        pointsArray = [topLeftPoint,bottomLeftPoint,bottomRightPoint,topRightPoint]
        shadeView.setCropArea(cropArea)
        
        initGesture()
    }
    func initGesture()
    {
        let dragRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CanvasCropView.handleDrag(_:)))
        
        
        self.forBaselineLayout().addGestureRecognizer(dragRecognizer)

    }
    
    func setCropAreaInView(_ area: CGRect) {
        let topLeft: CGPoint = area.origin
        let bottomLeft: CGPoint = CGPoint(x: topLeft.x, y: topLeft.y + area.size.height)
        let bottomRight: CGPoint = CGPoint(x: bottomLeft.x + area.size.width, y: bottomLeft.y)
        let topRight: CGPoint = CGPoint(x: topLeft.x + area.size.width, y: topLeft.y)
        topLeftPoint.center = topLeft
        bottomLeftPoint.center = bottomLeft
        bottomRightPoint.center = bottomRight
        topRightPoint.center = topRight
        
        let cropArea: CGRect = clearAreaFromControlPoints()
        cropAreaView = UIView(frame: cropArea)
        cropAreaView.isOpaque = false
        cropAreaView.backgroundColor = UIColor.clear

        shadeView.cropArea = area
        self.setNeedsDisplay()
    }
    
    func clearAreaFromControlPoints() -> CGRect {
        let width: CGFloat = topRightPoint.center.x - topLeftPoint.center.x
        let height: CGFloat = bottomRightPoint.center.y - topRightPoint.center.y
        let hole: CGRect = CGRect(x: topLeftPoint.center.x, y: topLeftPoint.center.y, width: width, height: height)
        return hole
    }
    
    func controllableAreaFromControlPoints() -> CGRect {
        let width: CGFloat = topRightPoint.center.x - topLeftPoint.center.x - controlPointSize
        let height: CGFloat = bottomRightPoint.center.y - topRightPoint.center.y - controlPointSize
        let hole: CGRect = CGRect(x: topLeftPoint.center.x + controlPointSize / 2, y: topLeftPoint.center.y + controlPointSize / 2, width: width, height: height)
        return hole
    }
    
    func boundingBoxForTopLeft(_ topLeft: CGPoint, bottomLeft: CGPoint, bottomRight: CGPoint, topRight: CGPoint) {
        var box: CGRect = CGRect(x: topLeft.x - controlPointSize / 2, y: topLeft.y - controlPointSize / 2, width: topRight.x - topLeft.x + controlPointSize, height: bottomRight.y - topRight.y + controlPointSize)
        if !square {
            box = imageFrameInView.intersection(box)
        }
        if imageFrameInView.contains(box) {
            bottomLeftPoint.center = CGPoint(x: box.origin.x + controlPointSize / 2, y: box.origin.y + box.size.height - controlPointSize / 2)
            bottomRightPoint.center = CGPoint(x: box.origin.x + box.size.width - controlPointSize / 2, y: box.origin.y + box.size.height - controlPointSize / 2)
            topLeftPoint.center = CGPoint(x: box.origin.x + controlPointSize / 2, y: box.origin.y + controlPointSize / 2)
            topRightPoint.center = CGPoint(x: box.origin.x + box.size.width - controlPointSize / 2, y: box.origin.y + controlPointSize / 2)
        }
    }
    
    func checkHit(_ point: CGPoint) -> UIView {
        var view: UIView = cropAreaView
        for i in 0 ..< pointsArray.count {
            let a = pow((point.x - view.center.x), 2)
            let b = pow((point.y - view.center.y), 2)
            let c = pow((point.x - pointsArray[i].center.x), 2)
            let d = pow((point.y - pointsArray[i].center.y), 2)
            if  sqrt(a + b) > sqrt(c+d) {
                view = pointsArray[i]
            }
        }
        return view
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let frame: CGRect = cropAreaView.frame.insetBy(dx: -30, dy: -30)
        return frame.contains(point) ? cropAreaView : nil
    }
    
    func handleDrag(_ recognizer: UIPanGestureRecognizer) {
        switch(recognizer.state)
        {
        case UIGestureRecognizerState.began:
            self.prepSingleTouchPan(recognizer)
            return
        case UIGestureRecognizerState.changed:
            self.beginCropBoxTransformForPoint(recognizer.location(in: self), atView: dragViewOne)
        case UIGestureRecognizerState.ended:
            return
        default:
            return
        }
    }
    
    
    func prepSingleTouchPan(_ recognizer: UIPanGestureRecognizer) {
        dragViewOne = self.checkHit(recognizer.location(in: self))
        dragPoint = DragPoint(dragStart: recognizer.location(in: self), topLeftCenter: topLeftPoint.center, bottomLeftCenter: bottomLeftPoint.center, bottomRightCenter: bottomRightPoint.center, topRightCenter: topRightPoint.center, clearAreaCenter: cropAreaView.center)
        
        
        
        
        
    }
    
    func deriveDisplacementFromDragLocation(_ dragLocation: CGPoint, draggedPoint: CGPoint, oppositePoint: CGPoint) -> CGSize {
        let dX: CGFloat = dragLocation.x - dragPoint.dragStart.x
        let dY: CGFloat = dragLocation.y - dragPoint.dragStart.y
        let tempDraggedPoint: CGPoint = CGPoint(x: draggedPoint.x + dX, y: draggedPoint.y + dY)
        let width: CGFloat = (tempDraggedPoint.x - oppositePoint.x)
        let height: CGFloat = (tempDraggedPoint.y - oppositePoint.y)
        let size: CGFloat = fabs(width) >= fabs(height) ? width : height
        let xDir: CGFloat = draggedPoint.x <= oppositePoint.x ? 1 : -1
        let yDir: CGFloat = draggedPoint.y <= oppositePoint.y ? 1 : -1
        var newX: CGFloat = 0
        var newY: CGFloat = 0
        if xDir >= 0 {
            if square {
                newX = oppositePoint.x - fabs(size)
            }
            else {
                newX = oppositePoint.x - fabs(width)
            }
        }
        else {
            if square {
                newX = oppositePoint.x + fabs(size)
            }
            else {
                newX = oppositePoint.x + fabs(width)
            }
        }
        if yDir >= 0 {
            if square {
                newY = oppositePoint.y - fabs(size)
            }
            else {
                newY = oppositePoint.y - fabs(height)
            }
        }
        else {
            if square {
                newY = oppositePoint.y + fabs(size)
            }
            else {
                newY = oppositePoint.y + fabs(height)
            }
        }
        let displacement: CGSize = CGSize(width: newX - draggedPoint.x, height: newY - draggedPoint.y)
        return displacement
    }
    
    func beginCropBoxTransformForPoint(_ location: CGPoint, atView view: UIView) {
        switch(view)
        {
        case topLeftPoint:
            self.handleDragTopLeft(location)
        case bottomLeftPoint:
            self.handleDragBottomLeft(location)
        case bottomRightPoint:
            self.handleDragBottomRight(location)
        case topRightPoint:
            self.handleDragTopRight(location)
        case cropAreaView:
            self.handleDragClearArea(location)
        default:
            return
        }
        
        var clearArea: CGRect = self.clearAreaFromControlPoints()
        cropAreaView.frame = clearArea
        clearArea.origin.y = clearArea.origin.y - imageFrameInView.origin.y
        clearArea.origin.x = clearArea.origin.x - imageFrameInView.origin.x
        self.shadeView.setCropArea(clearArea)
    }
    var imageScale:CGFloat = 1
    func handleDragTopLeft(_ dragLocation: CGPoint) {
        let disp: CGSize = self.deriveDisplacementFromDragLocation(dragLocation, draggedPoint: dragPoint.topLeftCenter, oppositePoint: dragPoint.bottomRightCenter)
        var topLeft: CGPoint = CGPoint(x: dragPoint.topLeftCenter.x + disp.width, y: dragPoint.topLeftCenter.y + disp.height)
        var topRight: CGPoint = CGPoint(x: dragPoint.topRightCenter.x, y: dragPoint.topLeftCenter.y + disp.height)
        var bottomLeft: CGPoint = CGPoint(x: dragPoint.bottomLeftCenter.x + disp.width, y: dragPoint.bottomLeftCenter.y)
        var width: CGFloat = topRight.x - topLeft.x
        var height: CGFloat = bottomLeft.y - topLeft.y
        width = width * imageScale
        height = height * imageScale
        let cropArea: CGRect = self.clearAreaFromControlPoints()
        if width >= IMAGE_MIN_WIDTH && height < IMAGE_MIN_HEIGHT {
            topLeft.y = cropArea.origin.y + (((cropArea.size.height * self.imageScale) - IMAGE_MIN_HEIGHT) / self.imageScale)
            topRight.y = topLeft.y
        }
        else {
            if width < IMAGE_MIN_WIDTH && height >= IMAGE_MIN_HEIGHT {
                topLeft.x = cropArea.origin.x + (((cropArea.size.width * self.imageScale) - IMAGE_MIN_WIDTH) / self.imageScale)
                bottomLeft.x = topLeft.x
            }
            else {
                if width < IMAGE_MIN_WIDTH && height < IMAGE_MIN_HEIGHT {
                    topLeft.x = cropArea.origin.x + (((cropArea.size.width * self.imageScale) - IMAGE_MIN_WIDTH) / self.imageScale)
                    topLeft.y = cropArea.origin.y + (((cropArea.size.height * self.imageScale) - IMAGE_MIN_HEIGHT) / self.imageScale)
                    topRight.y = topLeft.y
                    bottomLeft.x = topLeft.x
                }
            }
        }
        self.boundingBoxForTopLeft(topLeft, bottomLeft: bottomLeft, bottomRight: dragPoint.bottomRightCenter, topRight: topRight)
    }
    
    func handleDragBottomLeft(_ dragLocation: CGPoint) {
        let disp: CGSize = self.deriveDisplacementFromDragLocation(dragLocation, draggedPoint: dragPoint.bottomLeftCenter, oppositePoint: dragPoint.topRightCenter)
        var bottomLeft: CGPoint = CGPoint(x: dragPoint.bottomLeftCenter.x + disp.width, y: dragPoint.bottomLeftCenter.y + disp.height)
        var topLeft: CGPoint = CGPoint(x: dragPoint.topLeftCenter.x + disp.width, y: dragPoint.topLeftCenter.y)
        var bottomRight: CGPoint = CGPoint(x: dragPoint.bottomRightCenter.x, y: dragPoint.bottomRightCenter.y + disp.height)
        var width: CGFloat = bottomRight.x - bottomLeft.x
        var height: CGFloat = bottomLeft.y - topLeft.y
        width = width * self.imageScale
        height = height * self.imageScale
        let cropArea: CGRect = self.clearAreaFromControlPoints()
        if width >= IMAGE_MIN_WIDTH && height < IMAGE_MIN_HEIGHT {
            bottomLeft.y = cropArea.origin.y + (IMAGE_MIN_HEIGHT / self.imageScale)
            bottomRight.y = bottomLeft.y
        }
        else {
            if width < IMAGE_MIN_WIDTH && height >= IMAGE_MIN_HEIGHT {
                bottomLeft.x = cropArea.origin.x + (((cropArea.size.width * self.imageScale) - IMAGE_MIN_WIDTH) / self.imageScale)
                topLeft.x = bottomLeft.x
            }
            else {
                if width < IMAGE_MIN_WIDTH && height < IMAGE_MIN_HEIGHT {
                    bottomLeft.x = cropArea.origin.x + (((cropArea.size.width * self.imageScale) - IMAGE_MIN_WIDTH) / self.imageScale)
                    bottomLeft.y = cropArea.origin.y + (IMAGE_MIN_HEIGHT / self.imageScale)
                    topLeft.x = bottomLeft.x
                    bottomRight.y = bottomLeft.y
                }
            }
        }
        self.boundingBoxForTopLeft(topLeft, bottomLeft: bottomLeft, bottomRight: bottomRight, topRight: dragPoint.topRightCenter)
    }
    
    func handleDragBottomRight(_ dragLocation: CGPoint) {
        let disp: CGSize = self.deriveDisplacementFromDragLocation(dragLocation, draggedPoint: dragPoint.bottomRightCenter, oppositePoint: dragPoint.topLeftCenter)
        var bottomRight: CGPoint = CGPoint(x: dragPoint.bottomRightCenter.x + disp.width, y: dragPoint.bottomRightCenter.y + disp.height)
        var topRight: CGPoint = CGPoint(x: dragPoint.topRightCenter.x + disp.width, y: dragPoint.topRightCenter.y)
        var bottomLeft: CGPoint = CGPoint(x: dragPoint.bottomLeftCenter.x, y: dragPoint.bottomLeftCenter.y + disp.height)
        var width: CGFloat = bottomRight.x - bottomLeft.x
        var height: CGFloat = bottomRight.y - topRight.y
        width = width * self.imageScale
        height = height * self.imageScale
        let cropArea: CGRect = self.clearAreaFromControlPoints()
        if width >= IMAGE_MIN_WIDTH && height < IMAGE_MIN_HEIGHT {
            bottomRight.y = cropArea.origin.y + (IMAGE_MIN_HEIGHT / self.imageScale)
            bottomLeft.y = bottomRight.y
        }
        else {
            if width < IMAGE_MIN_WIDTH && height >= IMAGE_MIN_HEIGHT {
                bottomRight.x = cropArea.origin.x + (IMAGE_MIN_WIDTH / self.imageScale)
                topRight.x = bottomRight.x
            }
            else {
                if width < IMAGE_MIN_WIDTH && height < IMAGE_MIN_HEIGHT {
                    bottomRight.x = cropArea.origin.x + (IMAGE_MIN_WIDTH / self.imageScale)
                    bottomRight.y = cropArea.origin.y + (IMAGE_MIN_HEIGHT / self.imageScale)
                    topRight.x = bottomRight.x
                    bottomLeft.y = bottomRight.y
                }
            }
        }
        self.boundingBoxForTopLeft(dragPoint.topLeftCenter, bottomLeft: bottomLeft, bottomRight: bottomRight, topRight: topRight)
    }
    
    func handleDragTopRight(_ dragLocation: CGPoint) {
        let disp: CGSize = self.deriveDisplacementFromDragLocation(dragLocation, draggedPoint: dragPoint.topRightCenter, oppositePoint: dragPoint.bottomLeftCenter)
        var topRight: CGPoint = CGPoint(x: dragPoint.topRightCenter.x + disp.width, y: dragPoint.topRightCenter.y + disp.height)
        var topLeft: CGPoint = CGPoint(x: dragPoint.topLeftCenter.x, y: dragPoint.topLeftCenter.y + disp.height)
        var bottomRight: CGPoint = CGPoint(x: dragPoint.bottomRightCenter.x + disp.width, y: dragPoint.bottomRightCenter.y)
        var width: CGFloat = topRight.x - topLeft.x
        var height: CGFloat = bottomRight.y - topRight.y
        width = width * self.imageScale
        height = height * self.imageScale
        let cropArea: CGRect = self.clearAreaFromControlPoints()
        if width >= IMAGE_MIN_WIDTH && height < IMAGE_MIN_HEIGHT {
            topRight.y = cropArea.origin.y + (((cropArea.size.height * self.imageScale) - IMAGE_MIN_HEIGHT) / self.imageScale)
            topLeft.y = topRight.y
        }
        else {
            if width < IMAGE_MIN_WIDTH && height >= IMAGE_MIN_HEIGHT {
                topRight.x = cropArea.origin.x + (IMAGE_MIN_WIDTH / self.imageScale)
                bottomRight.x = topRight.x
            }
            else {
                if width < IMAGE_MIN_WIDTH && height < IMAGE_MIN_HEIGHT {
                    topRight.x = cropArea.origin.x + (IMAGE_MIN_WIDTH / self.imageScale)
                    topRight.y = cropArea.origin.y + (((cropArea.size.height * self.imageScale) - IMAGE_MIN_HEIGHT) / self.imageScale)
                    topLeft.y = topRight.y
                    bottomRight.x = topRight.x
                }
            }
        }
        self.boundingBoxForTopLeft(topLeft, bottomLeft: dragPoint.bottomLeftCenter, bottomRight: bottomRight, topRight: topRight)
    }
    
    func handleDragClearArea(_ dragLocation: CGPoint) {
        let dX: CGFloat = dragLocation.x - dragPoint.dragStart.x
        let dY: CGFloat = dragLocation.y - dragPoint.dragStart.y
        var newTopLeft: CGPoint = CGPoint(x: dragPoint.topLeftCenter.x + dX, y: dragPoint.topLeftCenter.y + dY)
        var newBottomLeft: CGPoint = CGPoint(x: dragPoint.bottomLeftCenter.x + dX, y: dragPoint.bottomLeftCenter.y + dY)
        var newBottomRight: CGPoint = CGPoint(x: dragPoint.bottomRightCenter.x + dX, y: dragPoint.bottomRightCenter.y + dY)
        var newTopRight: CGPoint = CGPoint(x: dragPoint.topRightCenter.x + dX, y: dragPoint.topRightCenter.y + dY)
        let clearAreaWidth: CGFloat = dragPoint.topRightCenter.x - dragPoint.topLeftCenter.x
        let clearAreaHeight: CGFloat = dragPoint.bottomLeftCenter.y - dragPoint.topLeftCenter.y
        let halfControlPointSize: CGFloat = controlPointSize / 2
        
        let minX: CGFloat = imageFrameInView.origin.x + halfControlPointSize
        let maxX: CGFloat = imageFrameInView.origin.x + imageFrameInView.size.width - halfControlPointSize
        let minY: CGFloat = imageFrameInView.origin.y + halfControlPointSize
        let maxY: CGFloat = imageFrameInView.origin.y + imageFrameInView.size.height - halfControlPointSize
        if newTopLeft.x < minX {
            newTopLeft.x = minX
            newBottomLeft.x = minX
            newTopRight.x = newTopLeft.x + clearAreaWidth
            newBottomRight.x = newTopRight.x
        }
        if newTopLeft.y < minY {
            newTopLeft.y = minY
            newTopRight.y = minY
            newBottomLeft.y = newTopLeft.y + clearAreaHeight
            newBottomRight.y = newBottomLeft.y
        }
        if newBottomRight.x > maxX {
            newBottomRight.x = maxX
            newTopRight.x = maxX
            newTopLeft.x = newBottomRight.x - clearAreaWidth
            newBottomLeft.x = newTopLeft.x
        }
        if newBottomRight.y > maxY {
            newBottomRight.y = maxY
            newBottomLeft.y = maxY
            newTopRight.y = newBottomRight.y - clearAreaHeight
            newTopLeft.y = newTopRight.y
        }
        topLeftPoint.center = newTopLeft
        bottomLeftPoint.center = newBottomLeft
        bottomRightPoint.center = newBottomRight
        topRightPoint.center = newTopRight
    }
}



