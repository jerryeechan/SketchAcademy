//
//  EdgeGestureHandler.swift
//  SwiftGL
//
//  Created by jerry on 2015/8/26.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import UIKit

class SubViewAnimationGestureHandler:NSObject {
    weak var mainView:UIView!
    weak var paintView:UIView!
    
    //播放區域 play back panel
    weak var playBackPanel:UIView!
    weak var playBackPanelBottomConstraint: NSLayoutConstraint!
    var playBackPanelHideBottomY:CGFloat = 128
    var playBackPanelHeight:CGFloat = 128

    //工具列 tool view
    weak var toolView:UIView!
    weak var toolViewLeadingConstraint: NSLayoutConstraint!
    var toolViewHideLeadingX:CGFloat = -240
    var toolViewWidth:CGFloat = 240
    
    var isToolPanelLocked:Bool = false
    
    //註解欄位
    weak var noteListView:UIView!
    weak var noteListViewTrailingConstraint: NSLayoutConstraint!
    var noteListViewTrailingX:CGFloat = -240
    var noteListViewWidth:CGFloat = 240
    
    var toolViewState:SubViewPanelAnimateState!
    
    weak var pvController:PaintViewController!
    init(pvController:PaintViewController)
    {
        super.init()
        
        self.mainView = pvController.mainView
        self.paintView = pvController.paintView
        
        
        
        
        self.toolView = pvController.toolView
        self.toolViewLeadingConstraint = pvController.toolViewLeadingConstraint
        
        self.playBackPanel = pvController.playBackView
        self.playBackPanelBottomConstraint = pvController.playBackViewBottomConstraint
        
        
        self.noteListView = pvController.noteListView
        self.noteListViewTrailingConstraint = pvController.noteListViewTrailingConstraint
        
        
        self.pvController = pvController
        
        
        hidePlayBackView(0)
        //hideToolView(0)
        
        //playBackPanelBottomConstraint.constant = playBackPanelHideBottomY
        //toolViewLeadingConstraint.constant = toolViewHideLeadingX
        
        let toolViewPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SubViewAnimationGestureHandler.handlePan(_:)))
        toolView.addGestureRecognizer(toolViewPanGestureRecognizer)
        
        let leftEdgeGestureReconizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(SubViewAnimationGestureHandler.handleLeftEdgePan(_:)))
        leftEdgeGestureReconizer.edges = UIRectEdge.left
        mainView.addGestureRecognizer(leftEdgeGestureReconizer)
        
        let leftEdgeGestureReconizer2 = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(SubViewAnimationGestureHandler.handleLeftEdgePan(_:)))
        
        leftEdgeGestureReconizer2.edges = UIRectEdge.left
        
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
    
    
    
    func handlePan(_ sender:UIPanGestureRecognizer)
    {
        let delta = sender.translation(in: mainView)
        let vel = sender.velocity(in: mainView)
        switch sender.state
        {
        case UIGestureRecognizerState.changed:
            print("tool view pan", terminator: "")
            toolViewLeadingConstraint.constant = delta.x
            if toolViewLeadingConstraint.constant > 0
            {
                toolViewLeadingConstraint.constant = 0
            }
        case .ended:
            if vel.x < -100
            {
                print("hide", terminator: "")
                hideToolView(0.2)
            }
            else
            {
                print("show", terminator: "")
                showToolView(0.2)
            }
        default:
            break
        }
        toolView.layoutIfNeeded()
    }
        
    
    func handleLeftEdgePan(_ sender:UIScreenEdgePanGestureRecognizer)
    {
        if isToolPanelLocked
        {
            return
        }
        
        let delta = sender.translation(in: mainView)
        switch sender.state
        {
        //case UIGestureRecognizerState.Changed:
            
           // toolView.center = CGPointMake(toolView_center.x + delta.x, toolView_center.y)
        case .ended:
            
            if delta.x > 0
            {
                showToolView(0.2)
            }
            
        default:
            break
        }
        
    }
    var isToolViewHidden:Bool = false
    func showToolView(_ duration:TimeInterval)
    {
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.toolViewLeadingConstraint.constant = 0
            self.toolView.layoutIfNeeded()
            }, completion: {
                finished in
                self.isToolViewHidden = false
            }
        )
    }
    func hideToolView(_ duration:TimeInterval)
    {
        if isToolViewHidden == false
        {
            UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.toolViewLeadingConstraint.constant = self.toolViewHideLeadingX
                self.toolView.layoutIfNeeded()
                }, completion: {
                    finished in
                    self.isToolViewHidden = true
                }
            )
        }
        
    }
    
    
    
    func handleBottemEdgePan(_ sender:UIScreenEdgePanGestureRecognizer)
    {
        let delta = sender.translation(in: mainView)
        switch sender.state
        {
            //case UIGestureRecognizerState.Changed:
            
            // toolView.center = CGPointMake(toolView_center.x + delta.x, toolView_center.y)
        case .ended:
            
            if delta.y < 0
            {
                showPlayBackView(0.2)
            }
            
        default:
            break
        }
    }
    
    func handlePlayBackPanelPan(_ sender:UIPanGestureRecognizer)
    {
        let delta = sender.translation(in: mainView)
        let vel = sender.velocity(in: mainView)
        
        
        switch sender.state
        {
        case UIGestureRecognizerState.changed:
            
            
            playBackPanelBottomConstraint.constant = delta.y
            
            if playBackPanelBottomConstraint.constant <  -playBackPanelHeight
            {
                playBackPanelBottomConstraint.constant = -playBackPanelHeight
            }
            
        case .ended:
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
    
    func showPlayBackView(_ duration:TimeInterval)
    {
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.playBackPanelBottomConstraint.constant = 0
            }, completion: {
                finished in
                
            }
        )
    }
    
    func hidePlayBackView(_ duration:TimeInterval)
    {
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.playBackPanelBottomConstraint.constant = self.playBackPanelHideBottomY
            }, completion: {
                finished in
                
            }
        )
    }
    
}
