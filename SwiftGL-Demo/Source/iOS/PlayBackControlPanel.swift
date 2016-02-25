//
//  PlayBackControlPanel.swift
//  SwiftGL
//
//  Created by jerry on 2016/2/13.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import Foundation
class PlayBackControlPanel:UIView {
    var enabled:Bool = true
    var UITimer:NSTimer!
    var counter:Int = 0
    override func awakeFromNib() {
        layer.cornerRadius = 10
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    func show()
    {
        animateShow(0.5)
        enabled = true
        UITimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("timeUp"), userInfo: nil, repeats: false)
        
    }
    func timeUp()
    {
        UITimer.invalidate()
        hide()
    }
    func hide()
    {
        animateHide(0.5)
        enabled = false
    }
    func toggle()
    {
        if enabled == true
        {
            hide()
        }
        else
        {
            show()
        }
    }
    func pause()
    {
        UITimer.invalidate()
    }
    func reactivate()
    {
        if UITimer != nil
        {
            UITimer.invalidate()
        }
        UITimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("timeUp"), userInfo: nil, repeats: false)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        reactivate()
        DLog("panel touched")
    }
}