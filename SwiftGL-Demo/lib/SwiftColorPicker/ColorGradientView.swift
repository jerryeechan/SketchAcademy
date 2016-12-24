//
//  ColorGradientView.swift
//  SwiftColorPicker
//
//  Created by cstad on 12/10/14.
//
import UIKit
import CGUtility
public class ColorGradientView: UIView {
    var colorLayer: ColorLayer!
    weak var delegate: ColorPicker?
    var point:CGPoint!
    var knob:UIView!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    let knobWidth:CGFloat = 30
    var hasLayouted = false
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if !hasLayouted
        {
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.8
            
            knob = UIView(frame: CGRect(x: 0, y: 0, width: knobWidth, height: knobWidth))
            knob.layer.cornerRadius = knobWidth/2
            knob.layer.borderColor = UIColor.white.cgColor
            knob.layer.borderWidth = 1
            knob.backgroundColor = UIColor.white
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
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = touch!.location(in: self)
        _ = delegate?.colorSaturationAndBrightnessSelected(point)
        isTouchDown = true
        
        //let dis = point-(touch?.previousLocationInView(self))!
        
        UIView.animate(withDuration: 0.2, animations: {
            self.knob.center = point+CGPoint(x: 0,y: -20)
            self.knob.layer.transform = CATransform3DMakeScale(2, 2, 1)
        })
        
    }
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(isTouchDown)
        {
            let touch = touches.first
            point = touch!.location(in: self)
            point.x = getLimitXCoordinate(point.x)
            point.y = getLimitYCoordinate(point.y)
            _ = delegate?.colorSaturationAndBrightnessSelected(point);
            self.knob.center = point+CGPoint(x: 0,y: -20)
        }
        
    }
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchDown = false
        let touch = touches.first
        var point = touch!.location(in: self)
        point.x = getLimitXCoordinate(point.x)
        point.y = getLimitYCoordinate(point.y)
        UIView.animate(withDuration: 0.5, animations: {
            self.knob.center = point
            self.knob.layer.transform = CATransform3DIdentity
        })
        
    }
    override public func draw(_ rect: CGRect) {

        //drawCoreGraphic()
        
    }
    
    
    
    func initLayer()
    {
        
        //drawCoreGraphic()
        colorLayer = ColorLayer(color: UIColor.red,hue:0)
        colorLayer.layer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width)
        // Insert the color.colorLayer into this views layer as a sublayer
        layer.insertSublayer(colorLayer.layer, at: 0)
        // Init new CAGradientLayer to be used as the grayScale overlay
        
        
        
        
        let grayScaleLayer = CAGradientLayer()
        // Set the grayScaleLayer colors to black and clear
        grayScaleLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        // Display gradient left to right
        grayScaleLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        grayScaleLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        // Use the size and position of this views frame to create a new frame for the grayScaleLayer
        grayScaleLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.width)
        // Insert the grayScaleLayer into this views layer as a sublayer
        self.layer.insertSublayer(grayScaleLayer, at: 1)
        setNeedsDisplay()
    }
    public func setColor(_ _color: UIColor!,hue:CGFloat) {
        // Set member color to the new UIColor coming in
        
        colorLayer.layer.removeFromSuperlayer()
        
        colorLayer = ColorLayer(color: _color,hue:hue)
        // Set colorView sublayers to nil to remove any existing sublayers
        //layer.sublayers = nil;
        // Use the size and position of this views frame to create a new frame for the color.colorLayer
        colorLayer.layer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width)
        // Insert the color.colorLayer into this views layer as a sublayer
        layer.insertSublayer(colorLayer.layer, at: 0)
        
        knob.backgroundColor = _color
        // Init new CAGradientLayer to be used as the grayScale overlay
        
    }
}

public func - (a: CGPoint, b: CGPoint) ->CGPoint {return CGPoint(x: a.x-b.x, y: a.y-b.y)}
