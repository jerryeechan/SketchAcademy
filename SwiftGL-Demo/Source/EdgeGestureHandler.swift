//
//  EdgeGestureHandler.swift
//  SwiftGL
//
//  Created by jerry on 2015/8/26.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import UIKit

class EdgeGestureHandler:NSObject {
    var mainView:UIView!
    
    var paintView:UIView!
    
    
    //播放區域 play back panel
    var playBackPanel:UIView!
    var playBackPanelBottomConstraint: NSLayoutConstraint!
    var playBackPanelHideBottomY:CGFloat = 128
    var playBackPanelHeight:CGFloat = 128
    
    //工具列 tool view
    var toolView:UIView!
    var toolViewLeadingConstraint: NSLayoutConstraint!
    var toolViewHideLeadingX:CGFloat = -240
    var toolViewWidth:CGFloat = 240
    
    var isToolPanelLocked:Bool = false
    weak var pvController:PaintViewController!
    init(pvController:PaintViewController)
    {
        super.init()
        
        self.mainView = pvController.mainView
        self.paintView = pvController.paintView
        self.toolView = pvController.toolView
        self.playBackPanel = pvController.playBackView
        toolViewLeadingConstraint = pvController.toolViewLeadingConstraint
        playBackPanelBottomConstraint = pvController.playBackViewBottomConstraint
        self.pvController = pvController
        
        
        hidePlayBackView(0)
        hideToolView(0)
        //playBackPanelBottomConstraint.constant = playBackPanelHideBottomY
        //toolViewLeadingConstraint.constant = toolViewHideLeadingX
        
        let toolViewPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        toolView.addGestureRecognizer(toolViewPanGestureRecognizer)
        
        let leftEdgeGestureReconizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handleLeftEdgePan:")
        leftEdgeGestureReconizer.edges = UIRectEdge.Left
        mainView.addGestureRecognizer(leftEdgeGestureReconizer)
        
        let leftEdgeGestureReconizer2 = UIScreenEdgePanGestureRecognizer(target: self, action: "handleLeftEdgePan:")
        
        leftEdgeGestureReconizer2.edges = UIRectEdge.Left
        
        paintView.addGestureRecognizer(leftEdgeGestureReconizer2)
        
        
        /*
        let bottomEdgeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handleBottemEdgePan:")
        bottomEdgeGestureRecognizer.edges = UIRectEdge.Bottom
        mainView.addGestureRecognizer(bottomEdgeGestureRecognizer)
        
        
        //playback panel
        let playBackPanelPanRecognizer = UIPanGestureRecognizer(target: self, action: "handlePlayBackPanelPan:")
        playBackPanel.addGestureRecognizer(playBackPanelPanRecognizer)
        
        */
    }
    
    
    func handlePan(sender:UIPanGestureRecognizer)
    {
        let delta = sender.translationInView(mainView)
        let vel = sender.velocityInView(mainView)
        switch sender.state
        {
        case UIGestureRecognizerState.Changed:
            print("tool view pan")
            toolViewLeadingConstraint.constant = delta.x
            if toolViewLeadingConstraint.constant > 0
            {
                toolViewLeadingConstraint.constant = 0
            }
        case .Ended:
            if vel.x < -100
            {
                print("hide")
                hideToolView(0.2)
            }
            else
            {
                print("show")
                showToolView(0.2)
            }
        default:
            break
        }
        toolView.layoutIfNeeded()
    }
        
    
    func handleLeftEdgePan(sender:UIScreenEdgePanGestureRecognizer)
    {
        if isToolPanelLocked
        {
            return
        }
        
        let delta = sender.translationInView(mainView)
        switch sender.state
        {
        //case UIGestureRecognizerState.Changed:
            
           // toolView.center = CGPointMake(toolView_center.x + delta.x, toolView_center.y)
        case .Ended:
            
            if delta.x > 0
            {
                showToolView(0.2)
            }
            
        default:
            break
        }
        
    }
    var isToolViewHidden:Bool = false
    func showToolView(duration:NSTimeInterval)
    {
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.toolViewLeadingConstraint.constant = 0
            self.toolView.layoutIfNeeded()
            }, completion: {
                finished in
                self.isToolViewHidden = false
            }
        )
    }
    func hideToolView(duration:NSTimeInterval)
    {
        if isToolViewHidden == false
        {
            UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.toolViewLeadingConstraint.constant = self.toolViewHideLeadingX
                self.toolView.layoutIfNeeded()
                }, completion: {
                    finished in
                    self.isToolViewHidden = true
                }
            )
        }
        
    }
    
    func handleBottemEdgePan(sender:UIScreenEdgePanGestureRecognizer)
    {
        let delta = sender.translationInView(mainView)
        switch sender.state
        {
            //case UIGestureRecognizerState.Changed:
            
            // toolView.center = CGPointMake(toolView_center.x + delta.x, toolView_center.y)
        case .Ended:
            
            if delta.y < 0
            {
                showPlayBackView(0.2)
            }
            
        default:
            break
        }
    }
    
    func handlePlayBackPanelPan(sender:UIPanGestureRecognizer)
    {
        let delta = sender.translationInView(mainView)
        let vel = sender.velocityInView(mainView)
        
        
        switch sender.state
        {
        case UIGestureRecognizerState.Changed:
            
            
            playBackPanelBottomConstraint.constant = delta.y
            
            if playBackPanelBottomConstraint.constant <  -playBackPanelHeight
            {
                playBackPanelBottomConstraint.constant = -playBackPanelHeight
            }
            
        case .Ended:
            if vel.y > 10
            {
                hidePlayBackView(0.2)
            }
            else
            {
                showPlayBackView(0.2)
            }
        default:
            break
        }
        
    }
    
    func showPlayBackView(duration:NSTimeInterval)
    {
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.playBackPanelBottomConstraint.constant = 0
            }, completion: {
                finished in
                
            }
        )
    }
    
    func hidePlayBackView(duration:NSTimeInterval)
    {
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.playBackPanelBottomConstraint.constant = self.playBackPanelHideBottomY
            }, completion: {
                finished in
                
            }
        )
    }
    
}