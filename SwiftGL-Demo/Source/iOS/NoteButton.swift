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
        self.frame = CGRect(x: 0,y: -8,width: btnWidth,height: 40)
        setImage(UIImage(named: "chat-up"), for: UIControlState())
        
        layer.cornerRadius = 0.25 * btnWidth
        backgroundColor = UIColor.white
        tintColor = themeDarkColor
        
        
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPosition(_ position:CGFloat)
    {
        let offset:CGFloat = 10
        
        layer.transform  = CATransform3DMakeTranslation(position - offset, 0, 0)
    }
    
    func selectStyle()
    {
        
    }
    func deSelectStyle()
    {
        UIView.animate(withDuration: 1, animations: {
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.lightGray.cgColor
        })

    }
}
