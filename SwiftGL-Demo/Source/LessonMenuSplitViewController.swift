//
//  LessonMenuSplitViewController.swift
//  SwiftGL
//
//  Created by jerry on 2016/4/29.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import UIKit
class LessonMenuSplitViewController: UISplitViewController{
    override func awakeFromNib() {
        maximumPrimaryColumnWidth = 683
        preferredPrimaryColumnWidthFraction = 0.4
    }
    
}
