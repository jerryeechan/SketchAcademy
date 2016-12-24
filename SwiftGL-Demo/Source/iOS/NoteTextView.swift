//
//  NoteTextView.swift
//  SwiftGL
//
//  Created by jerry on 2016/2/10.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import Foundation
public class NoteTextView:UIVisualEffectView{
    public override func awakeFromNib() {
        for view in subviews
        {
            view.layer.cornerRadius = 5
        }
    }
    
}
