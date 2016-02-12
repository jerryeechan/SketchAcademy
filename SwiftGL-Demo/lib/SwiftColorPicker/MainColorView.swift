//
//  MainColorView.swift
//  SwiftColorPicker
//
//  Created by cstad on 12/15/14.
//

import UIKit

class MainColorView: UIView {
    var color: UIColor!
    var point: CGPoint!
    var knob:UIView!

    weak var delegate: ColorPicker?
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)

        backgroundColor = UIColor.clearColor()
        
        let colorLayer = CAGradientLayer()
        colorLayer.colors = [
            UIColor(hue: 0.0, saturation: 1.0, brightness: 1.0, alpha: 1.0).CGColor,
            UIColor(hue: 0.1, saturation: 1.0, brightness: 1.0, alpha: 1.0).CGColor,
            UIColor(hue: 0.2, saturation: 1.0, brightness: 1.0, alpha: 1.0).CGColor,
            UIColor(hue: 0.3, saturation: 1.0, brightness: 1.0, alpha: 1.0).CGColor,
            UIColor(hue: 0.4, saturation: 1.0, brightness: 1.0, alpha: 1.0).CGColor,
            UIColor(hue: 0.5, saturation: 1.0, brightness: 1.0, alpha: 1.0).CGColor,
            UIColor(hue: 0.6, saturation: 1.0, brightness: 1.0, alpha: 1.0).CGColor,
            UIColor(hue: 0.7, saturation: 1.0, brightness: 1.0, alpha: 1.0).CGColor,
            UIColor(hue: 0.8, saturation: 1.0, brightness: 1.0, alpha: 1.0).CGColor,
            UIColor(hue: 0.9, saturation: 1.0, brightness: 1.0, alpha: 1.0).CGColor
        ]
        
        colorLayer.locations = [0.05, 0.15, 0.25, 0.35, 0.45, 0.55, 0.65, 0.75, 0.85, 0.95]
        colorLayer.frame = frame
        // Insert the colorLayer into this views layer as a sublayer
        self.layer.insertSublayer(colorLayer, below: layer)
        
        self.color = color
        
        point = getPointFromColor(color)
        
        knob = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        knob.layer.cornerRadius = 16
        knob.layer.borderWidth = 1
        knob.layer.borderColor = UIColor.whiteColor().CGColor
        knob.backgroundColor = UIColor.whiteColor()
        knob.layer.shadowColor = UIColor.blackColor().CGColor
//        knob.layer.shadowOffset = CGSize(width: 0, height: -3)
        addSubview(knob)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Set reference to the location of the touch in member point
        let  touch = touches.first
        point = touch!.locationInView(self)
        point.x = 15
        point.y = getYCoordinate(point.y)
        // Notify delegate of the new new color selection
        let color = getColorFromPoint(point)
        delegate?.mainColorSelected(color, point: point)
        // Update display when possible
        UIView.animateWithDuration(0.5, animations: {
            self.knob.layer.transform = CATransform3DMakeTranslation(0, self.point.y, 0)
            self.knob.backgroundColor = color
        })
        
        setNeedsDisplay()
        
    }
    
    

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Set reference to the location of the touchesMoved in member point
        let  touch = touches.first
        point = touch!.locationInView(self)
        point.x = 16
        point.y = getYCoordinate(point.y)
        // Notify delegate of the new new color selection
        delegate?.mainColorSelected(getColorFromPoint(point), point: point)
        // Update display when possible
        knob.layer.transform = CATransform3DMakeTranslation(0, point.y-16, 0)
        setNeedsDisplay()
    }
    
    func getYCoordinate(coord: CGFloat) -> CGFloat {
        if (coord < 11) {
            return 11
        }
        if (coord > frame.size.height - 11) {
            return frame.size.height - 11
        }
        return coord
    }
    
     override func drawRect(rect: CGRect) {
        if (point != nil) {
            let context = UIGraphicsGetCurrentContext()
            // Drawing properties:
            // Set line width to 1
            CGContextSetLineWidth(context, 1)
            // Set color to black
            CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)

            // Draw selector
            CGContextBeginPath(context)
            CGContextMoveToPoint(context, 1, getYCoordinate(point.y) - 4)
            CGContextAddLineToPoint(context, 9, getYCoordinate(point.y))
            CGContextAddLineToPoint(context, 1, getYCoordinate(point.y) + 4)
            CGContextStrokePath(context)
            CGContextBeginPath(context)
            CGContextMoveToPoint(context, 29, getYCoordinate(point.y) - 4)
            CGContextAddLineToPoint(context, 21, getYCoordinate(point.y))
            CGContextAddLineToPoint(context, 29, getYCoordinate(point.y) + 4)
            CGContextStrokePath(context)
        }
    }
    // Determine crosshair coordinates from a color
    func getPointFromColor(color: UIColor) -> CGPoint {
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        let ok: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (!ok) {
            print("ColorPicker: exception <The color provided to ColorPicker is not convertible to HSB>")
        }
        return CGPoint(x: 15, y: frame.height - (hue * frame.height))
    }
    // Thanks to mbanasiewicz for this method
    // https://gist.github.com/mbanasiewicz/940677042f5f293caf57
    }