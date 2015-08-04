//
//  SaveFileDialogViewController.swift
//  SwiftGL
//
//  Created by jerry on 2015/6/12.
//  Copyright (c) 2015年 Scott Bennett. All rights reserved.
//

import UIKit

class SaveFileDialogViewController: UIViewController{
    override func viewDidLoad() {
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        
        modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
    }
}
