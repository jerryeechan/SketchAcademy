//
//  NoteTextView.swift
//  SwiftGL
//
//  Created by jerry on 2016/2/10.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import Foundation
class NoteTextView:UIVisualEffectView{
    override func awakeFromNib() {
        for view in subviews
        {
            view.layer.cornerRadius = 5
        }
    }
    
}