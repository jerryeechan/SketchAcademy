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
    var toolView:UIView!
    var paintView:UIView!
    
    var toolView_center:CGPoint!
    
    var playBackPanel:UIView!
    var playBackPanel_center:CGPoint!
    
    var isToolPanelLocked:Bool = false
    var pvController:PaintViewController!
    init(pvController:PaintViewController)
    {
        super.init()
        print("init edge")
        
        self.mainView = pvController.mainView
        self.paintView = pvController.paintView
        self.toolView = pvController.toolView
        self.playBackPanel = pvController.playBackView
        playBackPanel_center = playBackPanel.center
        toolView_center = toolView.center
        //pvController =
        //hideToolView()
        self.toolView.center.x = self.toolView_center.x - self.toolView.frame.width
        
        //hidePlayBackView()
        self.playBackPanel.center.y = self.playBackPanel_center.y + self.playBackPanel.frame.height
        
        
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
            
            toolView.center.x = toolView_center.x + delta.x
            if toolView.center.x > toolView_center.x
            {
                toolView.center.x = toolView_center.x
            }
        case .Ended:
            if vel.x < -100
            {
                hideToolView()
            }
            else
            {
                showToolView()
            }
        default:
            break
        }
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
                showToolView()
            }
            
        default:
            break
        }
    }
    var isToolViewHidden:Bool = false
    func showToolView()
    {
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.toolView.center.x = self.toolView_center.x
                }, completion: {
                    finished in
                    self.isToolViewHidden = false
                }
            )
    }
    func hideToolView()
    {
        if isToolViewHidden == false
        {
            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.toolView.center.x = self.toolView_center.x - self.toolView.frame.width
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
                showPlayBackView()
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
            
            print(playBackPanel.center.y)
            
            playBackPanel.center.y = playBackPanel_center.y + delta.y
            
            if playBackPanel.center.y < playBackPanel_center.y
            {
                playBackPanel.center.y = playBackPanel_center.y
            }
            
        case .Ended:
            if vel.y > 100
            {
                hidePlayBackView()
            }
            else
            {
                showPlayBackView()
            }
        default:
            break
        }
        
    }
    
    func showPlayBackView()
    {
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.playBackPanel.center.y = self.playBackPanel_center.y
            }, completion: {
                finished in
                
            }
        )
    }
    
    func hidePlayBackView()
    {
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.playBackPanel.center.y = self.playBackPanel_center.y + self.playBackPanel.frame.height
            }, completion: {
                finished in
                
            }
        )
    }
    
}