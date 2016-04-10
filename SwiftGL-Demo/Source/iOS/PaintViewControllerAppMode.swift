//
//  PaintViewControllerImplement.swift
//  SwiftGL
//
//  Created by jerry on 2015/9/25.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import Foundation
import UIKit
extension UIView
{
    func animateHide(duration:NSTimeInterval)
    {
        UIView.animateWithDuration(duration, animations: {
            self.alpha = 0
            }, completion: {finished in
                self.hidden = true
        })
    }
    func animateShow(duration:NSTimeInterval)
    {
        self.hidden = false
        UIView.animateWithDuration(duration, animations: {
            self.alpha = 1
        })
    }
}

func snapShotFromView(view:UIView)->UIImage
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0)
    view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img
}
extension PaintViewController
{
    
}
extension PaintViewController
{
    func enterViewMode()
    {
        mainToolBar.barTintColor = themeLightColor
        mainToolBar.tintColor = themeDarkColor
        singlePanGestureRecognizer.cancelsTouchesInView = true
        canvasBGView.addGestureRecognizer(singlePanGestureRecognizer)
        paintView.removeGestureRecognizer(singlePanGestureRecognizer)
        
        toolViewState.animateHide(0.2)
        toolViewState.isLocked = true
        //noteListViewState.animateShow(0.2)
        replayProgressBar.animateShow(0.2)
        
        playbackControlPanel.show()
        
        
        print("----enter View Mode----")
        viewModeToolBarSetUp()
        switch(appState)
        {
        case .viewArtwork:
            paintManager.playArtworkClip()
        case .viewRevision:
            paintManager.playCurrentRevisionClip()
        default:
            break
        }
        //replayProgressBar.setProgress(paintManager.currentReplayer.playProgress, animated: false)
        
        updateAllNoteButton()
        //paintManager.currentReplayer.handleProgressValueChanged()
        onProgressValueChanged(paintManager.currentReplayer.playProgress,strokeID: paintManager.getCurrentStrokeID())
        
        noteButtonView.animateShow(0.2)
    }
    func enterDrawMode()
    {
        mainToolBar.barTintColor = themeDarkColor
        mainToolBar.tintColor = themeLightColor
        paintView.addGestureRecognizer(singlePanGestureRecognizer)
        canvasBGView.removeGestureRecognizer(singlePanGestureRecognizer)
        noteListViewState.animateHide(0.2)
        toolViewState.isLocked = false
        replayProgressBar.animateHide(0.2)
        playbackControlPanel.animateHide(0)
        noteDetailView.animateHide(0.2)
        
        //paintManager.masterReplayer.drawAll()
        paintView.paintBuffer.paintToolManager.usePen()
        singlePanGestureRecognizer.cancelsTouchesInView = false
        switch(appState)
        {
        case .drawArtwork:
            artworkDrawModeToolBarSetUp()
            paintManager.artworkDrawModeSetUp()
        case .drawRevision:
            revisionDrawModeToolBarSetUp()
            paintManager.revisionDrawModeSetUp()
        default:
            print("Error", terminator: "")
        }
        noteButtonView.animateHide(0.2)
    }
    func viewArtwork()
    {
        
    }
    func viewRevision()
    {
        
    }
    
    
    

}