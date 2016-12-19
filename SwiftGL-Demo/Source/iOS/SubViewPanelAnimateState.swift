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
        self.view!.isHidden = true
    }
    
    enum AnimateDir{
        case x
        case y
    }
    var animateDir:AnimateDir!
    func registerPanMove(_ dir:AnimateDir)
    {
        animateDir = dir
        let viewPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        view!.addGestureRecognizer(viewPanGestureRecognizer)
        
    }
    
    func handlePan(_ sender:UIPanGestureRecognizer)
    {
        
        let delta = sender.translation(in: view)
        let vel = sender.velocity(in: view)
        
        switch sender.state
        {
        case UIGestureRecognizerState.changed:
            
            
            constraint.constant = delta.x
            if constraint.constant > 0
            {
                constraint.constant = 0
            }
        case .ended:
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
    
    func animateShow(_ dur:TimeInterval)
    {
        self.view!.isHidden = false
        animate(constraint,value: showValue,duration: dur,hidden: false)
    }
    
    func animateHide(_ dur:TimeInterval)
    {
        animate(constraint,value: hideValue,duration: dur,hidden: true)
    }
    
    func animate(_ constraint:NSLayoutConstraint,value:CGFloat,duration:TimeInterval,hidden:Bool = false)
    {
        
        UIView.setAnimationsEnabled(true)
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
            constraint.constant = value
            
            }, completion: {
            (value: Bool) in
                self.view!.isHidden = hidden
            }
        )
    }
    
}
