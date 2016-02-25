//
//  NoteButton.swift
//  SwiftGL
//
//  Created by jerry on 2016/2/15.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import UIKit
class NoteButton:UIButton {
    var note:Note!
    let btnWidth:CGFloat = 40
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRectMake(0,-8,btnWidth,40)
        setImage(UIImage(named: "chat-up"), forState: UIControlState.Normal)
        
        layer.cornerRadius = 0.25 * btnWidth
        backgroundColor = UIColor.whiteColor()
        tintColor = themeDarkColor
        
        
        layer.borderColor = UIColor.lightGrayColor().CGColor
        layer.borderWidth = 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPosition(position:CGFloat)
    {
        let offset:CGFloat = 10
        
        layer.transform = CATransform3DMakeTranslation(position - offset, 0, 0)
    }
    
    func selectStyle()
    {
        
    }
    func deSelectStyle()
    {
        UIView.animateWithDuration(1, animations: {
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.lightGrayColor().CGColor
        })

    }
}
