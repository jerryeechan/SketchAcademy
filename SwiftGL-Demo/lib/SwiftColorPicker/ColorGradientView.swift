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
    
    init(frame: CGRect, color: UIColor!) {
        super.init(frame: frame)
        setColor(color)
        knob = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        knob.layer.cornerRadius = 15
        knob.layer.borderColor = UIColor.lightGrayColor().CGColor
        knob.backgroundColor = UIColor.whiteColor()
        addSubview(knob)
    }
    var isTouchDown = false;
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        point = touch!.locationInView(self)
        delegate?.colorSaturationAndBrightnessSelected(point)
        isTouchDown = true
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(isTouchDown)
        {
            let touch = touches.first
            point = touch!.locationInView(self)
            delegate?.colorSaturationAndBrightnessSelected(point);
            //UIView.animateWithDuration(<#T##duration: NSTimeInterval##NSTimeInterval#>, animations: <#T##() -> Void#>)
            knob.layer.transform = CATransform3DMakeTranslation(0, point.y, 0)
             //= CATransform3DTranslate(knob.layer.transform, 0 , point.y, <#T##tz: CGFloat##CGFloat#>)
        }
        
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isTouchDown = false
    }
    func setColor(_color: UIColor!) {
        // Set member color to the new UIColor coming in
        colorLayer = ColorLayer(color: _color)
        // Set colorView sublayers to nil to remove any existing sublayers
        layer.sublayers = nil;
        // Use the size and position of this views frame to create a new frame for the color.colorLayer
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
}

