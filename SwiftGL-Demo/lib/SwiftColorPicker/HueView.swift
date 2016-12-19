//
//  MainColorView.swift
//  SwiftColorPicker
//
//  Created by cstad on 12/15/14.
//

import UIKit
extension UIView
{
    func getLimitXCoordinate(_ coord:CGFloat)->CGFloat
    {
        if coord < 0
        {
            return 0
        }
        else if coord > frame.width
        {
            return frame.width
        }
        return coord
    }
    func getLimitYCoordinate(_ coord:CGFloat)->CGFloat
    {
        if coord < 0
        {
            return 0
        }
        else if coord > frame.height
        {
            return frame.height
        }
        return coord
    }
}
class HueView: UIView {
    var color: UIColor!
    var point: CGPoint!
    var knob:UIView!

    weak var delegate: ColorPicker?
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        
        
        

    }
    
    var width:CGFloat!
    var width_2:CGFloat!
    var hasLayouted = false
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !hasLayouted
        {
            backgroundColor = UIColor.clear
            
            width = frame.height
            width_2 = width*0.5
            let colorLayer = CAGradientLayer()
            colorLayer.colors = [
                UIColor(hue: 0.0, saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor,
                UIColor(hue: 0.1, saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor,
                UIColor(hue: 0.2, saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor,
                UIColor(hue: 0.3, saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor,
                UIColor(hue: 0.4, saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor,
                UIColor(hue: 0.5, saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor,
                UIColor(hue: 0.6, saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor,
                UIColor(hue: 0.7, saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor,
                UIColor(hue: 0.8, saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor,
                UIColor(hue: 0.9, saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor,
                UIColor(hue: 1.0, saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor
            ]
            
            //colorLayer.locations = [0.05, 0.15, 0.25, 0.35, 0.45, 0.55, 0.65, 0.75, 0.85, 0.95]
            colorLayer.locations = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.75, 0.8, 0.9,1.0]
            
            colorLayer.startPoint = CGPoint(x: 0, y: 0.5)
            colorLayer.endPoint = CGPoint(x: 1, y: 0.5)
            colorLayer.frame = frame
            colorLayer.frame.origin = CGPoint.zero
            
            // Insert the colorLayer into this views layer as a sublayer
            self.layer.insertSublayer(colorLayer, below: layer)
            self.color = UIColor.black
            
            point = getPointFromColor(color)
            
            knob = UIView(frame: CGRect(x: -3, y: -2, width: 6, height: width+4))
            knob.layer.cornerRadius = 3
            knob.layer.borderWidth = 1
            knob.layer.borderColor = UIColor.lightGray.cgColor
            knob.backgroundColor = UIColor.white
            knob.layer.shadowColor = UIColor.black.cgColor
            //        knob.layer.shadowOffset = CGSize(width: 0, height: -3)
            
            
            hasLayouted = true
            addSubview(knob)
            
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.8
            
        }
        
    }
    override func awakeFromNib() {
            }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Set reference to the location of the touch in member point
        let  touch = touches.first
        
        moveKnob(touch!,duration: 0.5)
        /*
        point = touch!.locationInView(self)
        point.x = getLimitXCoordinate(point.x)
        point.y = width_2
        DLog("\(point)")
        // Notify delegate of the new new color selection
        let color = getColorFromPoint(point)
        delegate?.mainColorSelected(color, point: point)
        // Update display when possible
        UIView.animateWithDuration(0.5, animations: {
            self.knob.layer.transform = CATransform3DMakeTranslation(self.point.x-self.width_2, 0, 0)
            self.knob.backgroundColor = color
        })
*/
        
    }
    
    

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Set reference to the location of the touchesMoved in member point
        let  touch = touches.first
        moveKnob(touch!,duration: 0.1)
    }
    func moveKnob(_ touch:UITouch,duration:TimeInterval)
    {
        point = touch.location(in: self)
        point.x = getLimitXCoordinate(point.x)
        point.y = width_2
        // Notify delegate of the new new color selection
        let color = getColorFromPoint(point)
        delegate?.mainColorSelected(color, point: point)
        UIView.animate(withDuration: duration, animations: {
            self.knob.layer.transform = CATransform3DMakeTranslation(self.point.x, 0, 0)
        })
    }
    func getColorFromPoint(_ point: CGPoint) -> UIColor {
        return UIColor(hue: point.x/frame.width, saturation: 1, brightness: 1, alpha: 1)
    }
     override func draw(_ rect: CGRect) {
        /*
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
*/
    }
    // Determine crosshair coordinates from a color
    func getPointFromColor(_ color: UIColor) -> CGPoint {
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        let ok: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (!ok) {
            print("ColorPicker: exception <The color provided to ColorPicker is not convertible to HSB>", terminator: "")
        }
        return CGPoint(x: 15, y: frame.height - (hue * frame.height))
    }
    // Thanks to mbanasiewicz for this method
    // https://gist.github.com/mbanasiewicz/940677042f5f293caf57
}
