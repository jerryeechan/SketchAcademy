//
//  ColorPicker.swift
//  SwiftColorPicker
//
//  This is the main entry point for the SwiftColorPicker control.
//  The UIView, in your app, that this class is attached to will dictate the dimensions of the ColorPicker.
//  Everything is created programmatically so there is no need to deal with Interface Builder to use this control.
//
//  Created by cstad on 12/10/14.
//

import UIKit

class ColorPicker: UIView {
    var crossHairView: CrossHairView!
    var colorView: ColorGradientView!
    var mainColorView: MainColorView!
    var circleHueColorView:AngleGradientBorderView!
    var selectedColorView: SelectedColorView!
    var onColorChange:((color:UIColor, finished:Bool)->Void)? = nil
    var color: UIColor!
    var hue: CGFloat = 1.0
    var saturation: CGFloat = 1.0
    var brightness: CGFloat = 1.0
    var percentSaturation: CGFloat = 1.0
    var percentBrightness: CGFloat = 1.0
    
    var smallestDim: CGFloat = 200.0
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        opaque = false
        backgroundColor = UIColor.clearColor()
        // Init the view with a black border
        // Set height and width based on what the dimensions of the view are
        if (self.frame.size.height > self.frame.size.width) {
//            smallestDim = self.frame.size.width
        } else {
//            smallestDim = self.frame.size.height
        }
        
        // Init with default color of red
        color = UIColor.redColor()
        // Call setup method to create the subviews needed for the control
        setup()
    }
    
    func setTheColor(color: UIColor) {
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        let ok: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (!ok) {
            print("ColorPicker: exception <The color provided to ColorPicker is not convertible to HSB>")
        }
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.color = color
        handleColorChange(color, changing: true)
        setup()
    }
    
    func setup() {
        // Remove all subviews
        let views = self.subviews
        for view in views {
            view.removeFromSuperview()
        }
        
        /*
        circleHueColorView = AngleGradientBorderView(frame: CGRect(x: 0, y: 0, width: smallestDim, height: smallestDim))
        circleHueColorView.backgroundColor = UIColor.clearColor()
        circleHueColorView.delegate = self
        self.addSubview(circleHueColorView)
        */
        
        // Init new ColorGradientView subview
//        colorView = ColorGradientView(frame: CGRect(x: smallestDim/4, y: smallestDim/4, width: smallestDim, height: smallestDim), color: UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0))

        colorView = ColorGradientView(frame: CGRect(x: 40, y: 0, width: smallestDim, height: smallestDim), color: UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0))
        
        // Add colorGradientView as a subview of this view
        
        self.addSubview(colorView)
        colorView.delegate = self
        //hueColorView = AngleGradientBorderView(frame: CGRect(x: 0,y: 0,width: 240,height: 240))
        //self.addSubview(hueColorView)
        
        
        // Init new CrossHairView subview
        //crossHairView = CrossHairView(frame: CGRect(x: 40, y: 0, width: smallestDim, height: smallestDim), color: UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0))
       
        //crossHairView.delegate = self
        // Add crossHairView as a subview of this view
        //self.addSubview(crossHairView)
        
        // Init new MainColorView subview
        mainColorView = MainColorView(frame: CGRect(x: 0, y: 0, width: 30, height: smallestDim        + 114.0), color: color)
        mainColorView.delegate = self
        self.addSubview(mainColorView)
        
        
        
        // Init new SelectedColorView subview
        //selectedColorView = SelectedColorView(frame: CGRect(x: 20, y: smallestDim - 20, width: smallestDim - 40, height: 20), color: color)
        // Add crossHairView as a subview of this view
        //self.addSubview(selectedColorView)
    }
    
    
    func mainColorSelected(color: UIColor, point: CGPoint) {
        
        var hue:CGFloat = 0
        var sat:CGFloat = 0
        var bri:CGFloat = 0
        var alpha:CGFloat = 0
        
        color.getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alpha)

        self.color = color
        self.hue = hue
        notifyViews(UIColor(hue: hue, saturation: percentSaturation, brightness: percentBrightness, alpha: 1.0))
    }
    
    
    
    func colorSaturationAndBrightnessSelected(point: CGPoint) {
        
        // Determine the brightness and saturation of the selected color based upon the selection coordinates and the dimensions of the container
        print(point)
        percentBrightness = point.x / (colorView.bounds.width)
        percentSaturation = 1 - (point.y / (colorView.bounds.height))
        print("br:\(percentBrightness)")
        print("sa:\(percentSaturation)")
        notifyViews(UIColor(hue: hue, saturation: percentSaturation, brightness: percentBrightness, alpha: 1.0))
    }
    
    func notifyViews(selectedColor: UIColor) {
        
        colorView.setColor(UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0))
        //crossHairView.setTheColor(selectedColor)
        //selectedColorView.setTheColor(selectedColor)
        handleColorChange(selectedColor, changing: true)
    }
    
    private func handleColorChange(color:UIColor, changing:Bool) {
        if color !== self.color {
            if let handler = onColorChange {
                handler(color: color, finished:!changing)
            }
            setNeedsDisplay()
        }
    }
}

func getNearByColor(color:UIColor)->[UIColor]
{
    var hue:CGFloat = 0
    var sat:CGFloat = 0
    var bri:CGFloat = 0
    var alpha:CGFloat = 0
    
    color.getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alpha)
    
    var nearbyColors:[UIColor] = []
    for var i = -0.2 ; i<=0.2; i += 0.2
    {
        for var j = -0.2 ; j <= 0.2; j += 0.2
        {
            let new_bri = bri + CGFloat(i)
            let new_sat = sat + CGFloat(j)
            nearbyColors.append(UIColor(hue: hue, saturation: new_sat, brightness: new_bri, alpha: 1))
        }
    }
    return nearbyColors
}
