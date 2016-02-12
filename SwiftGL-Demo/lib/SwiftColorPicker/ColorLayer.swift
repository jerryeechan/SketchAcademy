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
    let layerLeft: UIColor = UIColor.whiteColor()
    let layerRight: UIColor!
    init(color: UIColor!) {
        layerRight = color
        layer = CAGradientLayer()
        layer.colors = [layerLeft.CGColor, layerRight.CGColor]
        layer.locations = [0.0, 1.0]
        layer.startPoint = CGPointMake(0.0, 0.5)
        layer.endPoint = CGPointMake(1.0, 0.5)
    }
}
