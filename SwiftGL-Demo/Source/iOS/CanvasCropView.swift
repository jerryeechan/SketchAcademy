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

func SquareCGRectAtCenter(centerX:CGFloat,  centerY:CGFloat,  size:CGFloat)->CGRect {
     let x = centerX - size / 2.0;
     let y = centerY - size / 2.0;
    return CGRectMake(x, y, size, size);
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
        let centerInView:CGPoint = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
        let initialClearAreaSize = self.frame.size.width / 10;
        
        topLeftPoint = ControlPointView(frame: SquareCGRectAtCenter(centerInView.x - initialClearAreaSize, centerY: centerInView.y - initialClearAreaSize, size:controlPointSize))
        
        bottomLeftPoint = ControlPointView(frame: SquareCGRectAtCenter(centerInView.x - initialClearAreaSize, centerY: centerInView.y + initialClearAreaSize, size:controlPointSize))
        
        bottomRightPoint = ControlPointView(frame: SquareCGRectAtCenter(centerInView.x + initialClearAreaSize, centerY: centerInView.y + initialClearAreaSize, size:controlPointSize))
        
        topRightPoint = ControlPointView(frame: SquareCGRectAtCenter(centerInView.x + initialClearAreaSize, centerY: centerInView.y - initialClearAreaSize, size:controlPointSize))
        
        
        
        shadeView = ShadeView(frame: self.bounds)
        let cropArea = clearAreaFromControlPoints()
        cropAreaView = UIView(frame: cropArea)
        cropAreaView.backgroundColor = UIColor.clearColor()
        
        self.addSubview(shadeView)
        self.addSubview(cropAreaView)
        self.addSubview(topRightPoint)
        self.addSubview(bottomRightPoint)
        self.addSubview(topLeftPoint)
        self.addSubview(bottomLeftPoint)
        
        imageFrameInView = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        
        pointsArray = [topLeftPoint,bottomLeftPoint,bottomRightPoint,topRightPoint]
        shadeView.setCropArea(cropArea)
        
        initGesture()
    }
    func initGesture()
    {
        let dragRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handleDrag:")
        
        
        self.viewForBaselineLayout().addGestureRecognizer(dragRecognizer)

    }
    
    func setCropAreaInView(area: CGRect) {
        let topLeft: CGPoint = area.origin
        let bottomLeft: CGPoint = CGPointMake(topLeft.x, topLeft.y + area.size.height)
        let bottomRight: CGPoint = CGPointMake(bottomLeft.x + area.size.width, bottomLeft.y)
        let topRight: CGPoint = CGPointMake(topLeft.x + area.size.width, topLeft.y)
        topLeftPoint.center = topLeft
        bottomLeftPoint.center = bottomLeft
        bottomRightPoint.center = bottomRight
        topRightPoint.center = topRight
        
        let cropArea: CGRect = clearAreaFromControlPoints()
        cropAreaView = UIView(frame: cropArea)
        cropAreaView.opaque = false
        cropAreaView.backgroundColor = UIColor.clearColor()

        shadeView.cropArea = area
        self.setNeedsDisplay()
    }
    
    func clearAreaFromControlPoints() -> CGRect {
        let width: CGFloat = topRightPoint.center.x - topLeftPoint.center.x
        let height: CGFloat = bottomRightPoint.center.y - topRightPoint.center.y
        let hole: CGRect = CGRectMake(topLeftPoint.center.x, topLeftPoint.center.y, width, height)
        return hole
    }
    
    func controllableAreaFromControlPoints() -> CGRect {
        let width: CGFloat = topRightPoint.center.x - topLeftPoint.center.x - controlPointSize
        let height: CGFloat = bottomRightPoint.center.y - topRightPoint.center.y - controlPointSize
        let hole: CGRect = CGRectMake(topLeftPoint.center.x + controlPointSize / 2, topLeftPoint.center.y + controlPointSize / 2, width, height)
        return hole
    }
    
    func boundingBoxForTopLeft(topLeft: CGPoint, bottomLeft: CGPoint, bottomRight: CGPoint, topRight: CGPoint) {
        var box: CGRect = CGRectMake(topLeft.x - controlPointSize / 2, topLeft.y - controlPointSize / 2, topRight.x - topLeft.x + controlPointSize, bottomRight.y - topRight.y + controlPointSize)
        if !square {
            box = CGRectIntersection(imageFrameInView, box)
        }
        if CGRectContainsRect(imageFrameInView, box) {
            bottomLeftPoint.center = CGPointMake(box.origin.x + controlPointSize / 2, box.origin.y + box.size.height - controlPointSize / 2)
            bottomRightPoint.center = CGPointMake(box.origin.x + box.size.width - controlPointSize / 2, box.origin.y + box.size.height - controlPointSize / 2)
            topLeftPoint.center = CGPointMake(box.origin.x + controlPointSize / 2, box.origin.y + controlPointSize / 2)
            topRightPoint.center = CGPointMake(box.origin.x + box.size.width - controlPointSize / 2, box.origin.y + controlPointSize / 2)
        }
    }
    
    func checkHit(point: CGPoint) -> UIView {
        var view: UIView = cropAreaView
        for var i = 0; i < pointsArray.count; i++ {
            if sqrt(pow((point.x - view.center.x), 2) + pow((point.y - view.center.y), 2)) > sqrt(pow((point.x - pointsArray[i].center.x), 2) + pow((point.y - pointsArray[i].center.y), 2)) {
                view = pointsArray[i]
            }
        }
        return view
    }
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let frame: CGRect = CGRectInset(cropAreaView.frame, -30, -30)
        return CGRectContainsPoint(frame, point) ? cropAreaView : nil
    }
    
    func handleDrag(recognizer: UIPanGestureRecognizer) {
        switch(recognizer.state)
        {
        case UIGestureRecognizerState.Began:
            self.prepSingleTouchPan(recognizer)
            return
        case UIGestureRecognizerState.Changed:
            self.beginCropBoxTransformForPoint(recognizer.locationInView(self), atView: dragViewOne)
        case UIGestureRecognizerState.Ended:
            return
        default:
            return
        }
    }
    
    
    func prepSingleTouchPan(recognizer: UIPanGestureRecognizer) {
        dragViewOne = self.checkHit(recognizer.locationInView(self))
        dragPoint = DragPoint(dragStart: recognizer.locationInView(self), topLeftCenter: topLeftPoint.center, bottomLeftCenter: bottomLeftPoint.center, bottomRightCenter: bottomRightPoint.center, topRightCenter: topRightPoint.center, clearAreaCenter: cropAreaView.center)
        
        
        
        
        
    }
    
    func deriveDisplacementFromDragLocation(dragLocation: CGPoint, draggedPoint: CGPoint, oppositePoint: CGPoint) -> CGSize {
        let dX: CGFloat = dragLocation.x - dragPoint.dragStart.x
        let dY: CGFloat = dragLocation.y - dragPoint.dragStart.y
        let tempDraggedPoint: CGPoint = CGPointMake(draggedPoint.x + dX, draggedPoint.y + dY)
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
        let displacement: CGSize = CGSizeMake(newX - draggedPoint.x, newY - draggedPoint.y)
        return displacement
    }
    
    func beginCropBoxTransformForPoint(location: CGPoint, atView view: UIView) {
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
    func handleDragTopLeft(dragLocation: CGPoint) {
        let disp: CGSize = self.deriveDisplacementFromDragLocation(dragLocation, draggedPoint: dragPoint.topLeftCenter, oppositePoint: dragPoint.bottomRightCenter)
        var topLeft: CGPoint = CGPointMake(dragPoint.topLeftCenter.x + disp.width, dragPoint.topLeftCenter.y + disp.height)
        var topRight: CGPoint = CGPointMake(dragPoint.topRightCenter.x, dragPoint.topLeftCenter.y + disp.height)
        var bottomLeft: CGPoint = CGPointMake(dragPoint.bottomLeftCenter.x + disp.width, dragPoint.bottomLeftCenter.y)
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
    
    func handleDragBottomLeft(dragLocation: CGPoint) {
        let disp: CGSize = self.deriveDisplacementFromDragLocation(dragLocation, draggedPoint: dragPoint.bottomLeftCenter, oppositePoint: dragPoint.topRightCenter)
        var bottomLeft: CGPoint = CGPointMake(dragPoint.bottomLeftCenter.x + disp.width, dragPoint.bottomLeftCenter.y + disp.height)
        var topLeft: CGPoint = CGPointMake(dragPoint.topLeftCenter.x + disp.width, dragPoint.topLeftCenter.y)
        var bottomRight: CGPoint = CGPointMake(dragPoint.bottomRightCenter.x, dragPoint.bottomRightCenter.y + disp.height)
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
    
    func handleDragBottomRight(dragLocation: CGPoint) {
        let disp: CGSize = self.deriveDisplacementFromDragLocation(dragLocation, draggedPoint: dragPoint.bottomRightCenter, oppositePoint: dragPoint.topLeftCenter)
        var bottomRight: CGPoint = CGPointMake(dragPoint.bottomRightCenter.x + disp.width, dragPoint.bottomRightCenter.y + disp.height)
        var topRight: CGPoint = CGPointMake(dragPoint.topRightCenter.x + disp.width, dragPoint.topRightCenter.y)
        var bottomLeft: CGPoint = CGPointMake(dragPoint.bottomLeftCenter.x, dragPoint.bottomLeftCenter.y + disp.height)
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
    
    func handleDragTopRight(dragLocation: CGPoint) {
        let disp: CGSize = self.deriveDisplacementFromDragLocation(dragLocation, draggedPoint: dragPoint.topRightCenter, oppositePoint: dragPoint.bottomLeftCenter)
        var topRight: CGPoint = CGPointMake(dragPoint.topRightCenter.x + disp.width, dragPoint.topRightCenter.y + disp.height)
        var topLeft: CGPoint = CGPointMake(dragPoint.topLeftCenter.x, dragPoint.topLeftCenter.y + disp.height)
        var bottomRight: CGPoint = CGPointMake(dragPoint.bottomRightCenter.x + disp.width, dragPoint.bottomRightCenter.y)
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
    
    func handleDragClearArea(dragLocation: CGPoint) {
        let dX: CGFloat = dragLocation.x - dragPoint.dragStart.x
        let dY: CGFloat = dragLocation.y - dragPoint.dragStart.y
        var newTopLeft: CGPoint = CGPointMake(dragPoint.topLeftCenter.x + dX, dragPoint.topLeftCenter.y + dY)
        var newBottomLeft: CGPoint = CGPointMake(dragPoint.bottomLeftCenter.x + dX, dragPoint.bottomLeftCenter.y + dY)
        var newBottomRight: CGPoint = CGPointMake(dragPoint.bottomRightCenter.x + dX, dragPoint.bottomRightCenter.y + dY)
        var newTopRight: CGPoint = CGPointMake(dragPoint.topRightCenter.x + dX, dragPoint.topRightCenter.y + dY)
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



