//
//  SelectedColorView.swift
//  SwiftColorPicker
//
//  Created by cstad on 12/21/14.
//

import UIKit

class SelectedColorView: UIView {
    var color: UIColor!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        
        layer.borderColor = UIColor.blackColor().CGColor
        layer.borderWidth = 1
        
        setTheColor(color);
    }
    
    func setTheColor(_color: UIColor) {
        self.color = _color
        
        setBackgroundColor()
    }
    
    func setBackgroundColor() {
        backgroundColor = color
    }
}
