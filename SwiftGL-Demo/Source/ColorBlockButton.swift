//
//  ColorBlockButton.swift
//  SwiftGL
//
//  Created by jerry on 2016/4/21.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

class ColorBlockButton: UIButton {
    override func awakeFromNib() {
        layer.cornerRadius = frame.size.width/2
    }
}
