//
//  ColorLayer.swift
//  SwiftColorPicker
//      Simple class to initialize a new gradient layer using the color provided upon initialization
//
//  Created by cstad on 12/3/14.
//

import UIKit

class ColorLayer {
    let layer: CAGradientLayer!
    let layerLeft: UIColor = UIColor.white
    let layerRight: UIColor!
    
    init(color: UIColor!,hue:CGFloat) {
        var temp:CGFloat = 0,satu:CGFloat = 0,bright:CGFloat = 0,alpha:CGFloat = 0
        
        color.getHue(&temp, saturation: &satu, brightness: &bright, alpha: &alpha)
        
        
        layerRight = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
        layer = CAGradientLayer()
        layer.colors = [layerLeft.cgColor, layerRight.cgColor]
        layer.locations = [0.0, 1.0]
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
    }
}
