//
//  DrawView.swift
//  SwiftColorPicker
//
//  Created by cstad on 12/09/14.
//

import UIKit

class CrossHairView: UIView {
    var point: CGPoint!
    var circleRadius: CGFloat = 10.0
    var color: UIColor!
    
    weak var delegate: ColorPicker?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    init(frame: CGRect, color: UIColor!) {
        super.init(frame: frame)
        // Set this views backgroundColor to clear to ensure that the color gradient underneath it is visible
        backgroundColor = UIColor.clearColor()
        // Call setColor passing it the color that this view was init with
        setTheColor(color);
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        circleRadius = 20.0
        // Set reference to the location of the touch in member point
        let touch = touches.first
        point = touch!.locationInView(self)
        print(point)
        
        // Notify delegate of the new new color selection
        delegate?.colorSaturationAndBrightnessSelected(point)
        // Update display when possible
        setNeedsDisplay()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Set reference to the location of the touchesMoved in member point
        let touch = touches.first
        point = touch!.locationInView(self)
        // Notify delegate of the new new color selection
        delegate?.colorSaturationAndBrightnessSelected(point)
        // Update display when possible
        //self.layer.backgroundColor =
        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        circleRadius = 10.0
        // Set reference to the location of the touch in member point
        let touch = touches.first
        point = touch!.locationInView(self)
        // Notify delegate of the new new color selection
        delegate?.colorSaturationAndBrightnessSelected(point)
        // Update display when possible
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        if (point != nil) {
            let context = UIGraphicsGetCurrentContext()
            // Drawing properties:
            // Set line width to 1
            /*
            CGContextSetLineWidth(context, 1)
            // Set color to black
            CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
            
            // Draw black horizontal crosshair line
            CGContextBeginPath(context)
            CGContextMoveToPoint(context, 0, getCoordinate(point.y) - 20)
            CGContextAddLineToPoint(context, (self.bounds.width - 20), getCoordinate(point.y) - 20)
            CGContextStrokePath(context)
            // Draw black vertical crosshair line
            CGContextBeginPath(context)
            CGContextMoveToPoint(context, getCoordinate(point.x) - 20, 0)
            CGContextAddLineToPoint(context, getCoordinate(point.x) - 20, (self.bounds.height - 20))
            CGContextStrokePath(context)
            
            // Set color to white
            CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
            
            // Draw white horizontal crosshair line
            CGContextBeginPath(context)
            CGContextMoveToPoint(context, 0, getCoordinate(point.y) - 19)
            CGContextAddLineToPoint(context, (self.bounds.width - 20), getCoordinate(point.y) - 19)
            CGContextStrokePath(context)
            // Draw white vertical crosshair line
            CGContextBeginPath(context)
            CGContextMoveToPoint(context, getCoordinate(point.x) - 19, 0)
            CGContextAddLineToPoint(context, getCoordinate(point.x) - 19, (self.bounds.height - 20))
            CGContextStrokePath(context)
            */
            
            
            // Set color to black
            CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
            
            // Draw selected color circle
            // Set the coordinates for the circle origin
            let p = CGPoint(x: point.x , y: point.y)
            print(p)
            
            let rect = CGRect(origin: p, size: CGSize(width: circleRadius * 2, height: circleRadius * 2))
            // Add a circle to the previously defined rect
            CGContextAddEllipseInRect(context, rect)
            // Fill with color
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextFillEllipseInRect(context, rect)
            // Add the rect to the drawing context
            CGContextAddRect(context, rect)
            
            
        }
    }
    
    func setTheColor(color: UIColor!) {
        // Set member color to the new UIColor coming in
        self.color = color
        // Set point by inferring it from the color by calling getPointFromColor()
        point = getPointFromColor(self.color)
        // Update display when possible
        self.layer.backgroundColor = color.CGColor
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 2
        //setNeedsDisplay()
    }
    
    func getCoordinate(coord: CGFloat) -> CGFloat {
        if (coord < 0) {
            return 0
        }
        if (coord > frame.height) {
            
            return frame.height
        }
        return coord
    }
    // Determine crosshair coordinates from a color
    func getPointFromColor(color: UIColor) -> CGPoint {
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        let ok: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (!ok) {
            print("ColorPicker: exception <The color provided to ColorPicker is not convertible to HSB>")
        }
        return CGPoint(x: brightness * frame.height, y: frame.height - (saturation * frame.height))
    }
}
