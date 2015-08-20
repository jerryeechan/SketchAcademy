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
    let layerTop: UIColor!
    let layerBottom: UIColor = UIColor.whiteColor()
    
    init(color: UIColor!) {
        layerTop = color
        layer = CAGradientLayer()
        layer.colors = [layerTop.CGColor, layerBottom.CGColor]
        layer.locations = [0.0, 1.0]
    }
}
