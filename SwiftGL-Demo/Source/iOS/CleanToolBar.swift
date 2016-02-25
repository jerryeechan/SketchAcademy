 //
//  CleanToolBar.swift
//  SwiftGL
//
//  Created by jerry on 2016/2/13.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import Foundation
 class CleanToolBar: UIToolbar {
    override func awakeFromNib() {
        clipsToBounds = true
    }
 }
 