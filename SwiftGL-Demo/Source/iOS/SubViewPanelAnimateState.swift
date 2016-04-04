//
//  SubViewPanelState.swift
//  SwiftGL
//
//  Created by jerry on 2015/9/12.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import UIKit
class SubViewPanelAnimateState {
    
    var hideValue:CGFloat!
    var showValue:CGFloat!
    weak var constraint:NSLayoutConstraint!
    weak var view:UIView?
    var isLocked:Bool = false
    
    init(view:UIView,constraint:NSLayoutConstraint,hideValue:CGFloat,showValue:CGFloat)
    {
        self.hideValue = hideValue
        self.showValue = showValue
        self.constraint = constraint
        self.view = view
        self.view!.hidden = true
    }
    
    enum AnimateDir{
        case X
        case Y
    }
    var animateDir:AnimateDir!
    func registerPanMove(dir:AnimateDir)
    {
        animateDir = dir
        let viewPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        view!.addGestureRecognizer(viewPanGestureRecognizer)
        
    }
    
    func handlePan(sender:UIPanGestureRecognizer)
    {
        
        let delta = sender.translationInView(view)
        let vel = sender.velocityInView(view)
        
        switch sender.state
        {
        case UIGestureRecognizerState.Changed:
            
            
            constraint.constant = delta.x
            if constraint.constant > 0
            {
                constraint.constant = 0
            }
        case .Ended:
            if vel.x < -100
            {
                print("hide", terminator: "")
                animateHide(0.2)
            }
            else
            {
                print("show", terminator: "")
                animateShow(0.2)
            }
        default:
            break
        }
        view!.layoutIfNeeded()
    }
    
    func xPan()
    {
        
    }
    
    func animateShow(dur:NSTimeInterval)
    {
        self.view!.hidden = false
        animate(constraint,value: showValue,duration: dur,hidden: false)
    }
    
    func animateHide(dur:NSTimeInterval)
    {
        animate(constraint,value: hideValue,duration: dur,hidden: true)
    }
    
    func animate(constraint:NSLayoutConstraint,value:CGFloat,duration:NSTimeInterval,hidden:Bool = false)
    {
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            constraint.constant = value
            
            }, completion: {
            (value: Bool) in
                self.view!.hidden = hidden
            }
        )
    }
    
}
