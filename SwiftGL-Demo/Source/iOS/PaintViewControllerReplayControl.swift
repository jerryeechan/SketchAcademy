//
//  PaintViewControllerReplayControl.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/5.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

extension PaintViewController
{
    @IBAction func PlayButtonTouched(sender: UIBarButtonItem) {
        PaintManager.instance.pauseToggle()
        
    }
    
    @IBAction func fastForwardButtonTouched(sender: UIBarButtonItem) {
        PaintManager.instance.doublePlayBackSpeed()
    }
    
    
    @IBAction func RewindButtonTouched(sender: UIBarButtonItem) {
        PaintManager.instance.restart()
    }
    
    
    
}
