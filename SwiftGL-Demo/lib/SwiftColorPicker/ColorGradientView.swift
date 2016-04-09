//
//  ColorGradientView.swift
//  SwiftColorPicker
//
//  Created by cstad on 12/10/14.
//

import UIKit

class ColorGradientView: UIView {
    var colorLayer: ColorLayer!
    weak var delegate: ColorPicker?
    var point:CGPoint!
    var knob:UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    let knobWidth:CGFloat = 30
    var hasLayouted = false
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !hasLayouted
        {
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.8
            
            knob = UIView(frame: CGRect(x: 0, y: 0, width: knobWidth, height: knobWidth))
            knob.layer.cornerRadius = knobWidth/2
            knob.layer.borderColor = UIColor.whiteColor().CGColor
            knob.layer.borderWidth = 1
            knob.backgroundColor = UIColor.whiteColor()
            knob.layer.shadowOffset = CGSize(width: 0, height: 2)
            knob.layer.shadowOpacity = 0.8
            hasLayouted = true
            
            addSubview(knob)
            initLayer()
        }

        
    }
    
    init(frame: CGRect, color: UIColor!) {
        super.init(frame: frame)
        //setColor(color)
        
    }

    
    var isTouchDown = false;
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        DLog("touched")
        let touch = touches.first
        let point = touch!.locationInView(self)
        _ = delegate?.colorSaturationAndBrightnessSelected(point)
        isTouchDown = true
        
        //let dis = point-(touch?.previousLocationInView(self))!
        
        UIView.animateWithDuration(0.2, animations: {
            self.knob.center = point+CGPoint(x: 0,y: -20)
            self.knob.layer.transform = CATransform3DMakeScale(2, 2, 1)
        })
        
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(isTouchDown)
        {
            let touch = touches.first
            point = touch!.locationInView(self)
            point.x = getLimitXCoordinate(point.x)
            point.y = getLimitYCoordinate(point.y)
            _ = delegate?.colorSaturationAndBrightnessSelected(point);
            self.knob.center = point+CGPoint(x: 0,y: -20)
        }
        
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isTouchDown = false
        let touch = touches.first
        var point = touch!.locationInView(self)
        point.x = getLimitXCoordinate(point.x)
        point.y = getLimitYCoordinate(point.y)
        UIView.animateWithDuration(0.5, animations: {
            self.knob.center = point
            self.knob.layer.transform = CATransform3DIdentity
        })
        
    }
    func initLayer()
    {
        colorLayer = ColorLayer(color: UIColor.redColor(),hue:0)
        colorLayer.layer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width)
        // Insert the color.colorLayer into this views layer as a sublayer
        layer.insertSublayer(colorLayer.layer, atIndex: 0)
        // Init new CAGradientLayer to be used as the grayScale overlay
        let grayScaleLayer = CAGradientLayer()
        // Set the grayScaleLayer colors to black and clear
        grayScaleLayer.colors = [UIColor.clearColor().CGColor,UIColor.blackColor().CGColor]
        // Display gradient left to right
        grayScaleLayer.startPoint = CGPointMake(0.5, 0.0)
        grayScaleLayer.endPoint = CGPointMake(0.5, 1.0)
        // Use the size and position of this views frame to create a new frame for the grayScaleLayer
        grayScaleLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.width)
        // Insert the grayScaleLayer into this views layer as a sublayer
        self.layer.insertSublayer(grayScaleLayer, atIndex: 1)
    }
    func setColor(_color: UIColor!,hue:CGFloat) {
        // Set member color to the new UIColor coming in
        
        colorLayer.layer.removeFromSuperlayer()
        
        colorLayer = ColorLayer(color: _color,hue:hue)
        // Set colorView sublayers to nil to remove any existing sublayers
        //layer.sublayers = nil;
        // Use the size and position of this views frame to create a new frame for the color.colorLayer
        colorLayer.layer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width)
        // Insert the color.colorLayer into this views layer as a sublayer
        layer.insertSublayer(colorLayer.layer, atIndex: 0)
        knob.backgroundColor = _color
        // Init new CAGradientLayer to be used as the grayScale overlay
        
    }
}

public func - (a: CGPoint, b: CGPoint) ->CGPoint {return CGPoint(x: a.x-b.x, y: a.y-b.y)}