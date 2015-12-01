//
//  AngleGradientBorderView.swift
//  AngleGradientBorderTutorial
//
//  Created by Ian Hirschfeld on 9/29/14.
//  Copyright (c) 2014 Ian Hirschfeld. All rights reserved.
//

import UIKit

class AngleGradientBorderView: UIView {
    
    weak var delegate:ColorPicker!
  // Constants
  let DefaultGradientBorderColors: [AnyObject] = [
    UIColor.redColor().CGColor,
    UIColor.yellowColor().CGColor,
    UIColor.greenColor().CGColor,
    UIColor.cyanColor().CGColor,
    UIColor.blueColor().CGColor,
    UIColor.magentaColor().CGColor,
    UIColor.redColor().CGColor, // Repeat the first color to make a smooth transition
  ]
  let DefaultGradientBorderWidth: CGFloat = 20

  // Set the UIView's layer class to be our AngleGradientBorderLayer
  override class func layerClass() -> AnyClass {
    return AngleGradientBorderLayer.self
  }

  // Initializer
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    setupGradientLayer()
    backgroundColor = UIColor.clearColor()
  }

  // Custom initializer
  init(frame: CGRect, borderColors gradientBorderColors: [AnyObject]? = nil, borderWidth gradientBorderWidth: CGFloat? = nil) {
    super.init(frame: frame)
    setupGradientLayer(borderColors: gradientBorderColors, borderWidth: gradientBorderWidth)
  }
    
    var isTouchDown = false
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let point = touch?.locationInView(self)
        
        let color = getColorFromPoint(point!)
        delegate.mainColorSelected(color, point: point!)
        isTouchDown = true
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let point = touch?.locationInView(self)
        let color = getColorFromPoint(point!)
        delegate.mainColorSelected(color, point: point!)
        
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isTouchDown = false
    }
  // Setup the attributes of this view's layer
  func setupGradientLayer(borderColors gradientBorderColors: [AnyObject]? = nil, borderWidth gradientBorderWidth: CGFloat? = nil) {
    // Grab this UIView's layer and cast it as AngleGradientBorderLayer
    let l: AngleGradientBorderLayer = self.layer as! AngleGradientBorderLayer

    // NOTE: Since our gradient layer is built as an image,
    // we need to scale it to match the display of the device.
    l.contentsScale = UIScreen.mainScreen().scale

    // Set the gradient colors
    if gradientBorderColors != nil {
      l.colors = gradientBorderColors!
    } else {
      l.colors = DefaultGradientBorderColors
    }

    // Set the border width of the gradient
    if gradientBorderWidth != nil {
      l.gradientBorderWidth = gradientBorderWidth!
    } else {
      l.gradientBorderWidth = DefaultGradientBorderWidth
    }
    
    
  }
  
}
