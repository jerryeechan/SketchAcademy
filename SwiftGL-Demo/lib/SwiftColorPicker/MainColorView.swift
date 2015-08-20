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
    
    var delegate: ColorPicker?
    
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
        colorLayer.frame = CGRect(x: 10, y: 10, width: 10, height: self.frame.size.height - 20)
        // Insert the colorLayer into this views layer as a sublayer
        self.layer.insertSublayer(colorLayer, below: layer)
        
        self.color = color
        
        point = getPointFromColor(color)
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
        delegate?.mainColorSelected(getColorFromPoint(point), point: point)
        // Update display when possible
        setNeedsDisplay()
        
    }
    
    

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Set reference to the location of the touchesMoved in member point
        let  touch = touches.first
        point = touch!.locationInView(self)
        point.x = 15
        point.y = getYCoordinate(point.y)
        // Notify delegate of the new new color selection
        delegate?.mainColorSelected(getColorFromPoint(point), point: point)
        // Update display when possible
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
    func getColorFromPoint(point:CGPoint) -> UIColor {
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()!
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
        
        var pixelData:[UInt8] = [0, 0, 0, 0]
        
        let context = CGBitmapContextCreate(&pixelData, 1, 1, 8, 4, colorSpace, bitmapInfo.rawValue)
        CGContextTranslateCTM(context, -point.x, -point.y);
        self.layer.renderInContext(context!)
        
        let red:CGFloat = CGFloat(pixelData[0])/CGFloat(255.0)
        let green:CGFloat = CGFloat(pixelData[1])/CGFloat(255.0)
        let blue:CGFloat = CGFloat(pixelData[2])/CGFloat(255.0)
        let alpha:CGFloat = CGFloat(pixelData[3])/CGFloat(255.0)
        
        let color:UIColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
}