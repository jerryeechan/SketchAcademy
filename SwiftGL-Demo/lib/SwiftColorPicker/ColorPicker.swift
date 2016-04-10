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
    weak var colorView: ColorGradientView!
    weak var hueView: HueView!
    var selectedColorView: SelectedColorView!
    var onColorChange:((color:UIColor, finished:Bool)->Void)? = nil
    var color: UIColor!
    var hue: CGFloat = 1.0
    var saturation: CGFloat = 1.0
    var brightness: CGFloat = 1.0
    var percentSaturation: CGFloat = 1.0
    var percentBrightness: CGFloat = 1.0
    
    var smallestDim: CGFloat = 200.0
    
    override func awakeFromNib() {
        opaque = false
        backgroundColor = UIColor.clearColor()
        
        // Init with default color of red
        color = UIColor.redColor()
    }
    
    func setTheColor(color: UIColor) {
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        let ok: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (!ok) {
            DLog("ColorPicker: exception <The color provided to ColorPicker is not convertible to HSB>")
        }
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.percentSaturation = saturation
        self.percentBrightness = brightness
        DLog("\(color)")
        notifyViews(color,hue:hue)
    }
    
    func setup(hueView:HueView,colorGradientView:ColorGradientView) {
        // Remove all subviews
        self.hueView = hueView
        self.colorView = colorGradientView
        self.hueView.delegate = self
        self.colorView.delegate = self
        
        /*
        circleHueColorView = AngleGradientBorderView(frame: CGRect(x: 0, y: 0, width: smallestDim, height: smallestDim))
        circleHueColorView.backgroundColor = UIColor.clearColor()
        circleHueColorView.delegate = self
        self.addSubview(circleHueColorView)
        */
        
        // Init new ColorGradientView subview
//        colorView = ColorGradientView(frame: CGRect(x: smallestDim/4, y: smallestDim/4, width: smallestDim, height: smallestDim), color: UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0))

        //colorView = ColorGradientView(frame: CGRect(x: 40, y: 0, width: smallestDim, height: smallestDim), color: UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0))
        
        // Add colorGradientView as a subview of this view
        
        //self.addSubview(colorView)
        //colorView.delegate = self
        //hueColorView = AngleGradientBorderView(frame: CGRect(x: 0,y: 0,width: 240,height: 240))
        //self.addSubview(hueColorView)
        
        
        // Init new CrossHairView subview
        //crossHairView = CrossHairView(frame: CGRect(x: 40, y: 0, width: smallestDim, height: smallestDim), color: UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0))
       
        //crossHairView.delegate = self
        // Add crossHairView as a subview of this view
        //self.addSubview(crossHairView)
        
        // Init new MainColorView subview
        //mainColorView = MainColorView(frame: CGRect(x: 0, y: 0, width: 32, height: smallestDim + 118.0), color: color)
        //mainColorView.delegate = self
        //self.addSubview(mainColorView)
        
        
        
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
        notifyViews(UIColor(hue: hue, saturation: percentSaturation, brightness: percentBrightness, alpha: 1.0),hue:hue)
    }
    
    
    
    func colorSaturationAndBrightnessSelected(point: CGPoint)->UIColor {
        
        // Determine the brightness and saturation of the selected color based upon the selection coordinates and the dimensions of the container
        
        percentBrightness = 1 - (point.y / (colorView.bounds.height))
        percentSaturation = point.x / (colorView.bounds.width)
        print("br:\(percentBrightness)", terminator: "")
        print("sa:\(percentSaturation)", terminator: "")
        let color = UIColor(hue: hue, saturation: percentSaturation, brightness: percentBrightness, alpha: 1.0)
        
        
        notifyViews(color,hue:hue)
        return color
    }
    
    func notifyViews(selectedColor: UIColor,hue:CGFloat) {
        
        colorView.setColor(selectedColor,hue:hue)
        //crossHairView.setTheColor(selectedColor)
        //selectedColorView.setTheColor(selectedColor)
        handleColorChange(selectedColor, changing: true)
    }
    
    private func handleColorChange(color:UIColor, changing:Bool) {
        DLog("\(color) \(self.color)")
        
        if color != self.color {
            if let handler = onColorChange {
                handler(color: color, finished:!changing)
            }
            self.color = color
            //setNeedsDisplay()
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
    for var i = -1 ; i <= 1; i+=1
    {
        for var j = 1 ; j >= -1; j-=1
        {
            let new_bri = bri + CGFloat(i)*0.15
            let new_sat = sat + CGFloat(j)*0.15
            nearbyColors.append(UIColor(hue: hue, saturation: new_sat, brightness: new_bri, alpha: 1))
        }
    }
    return nearbyColors
}
