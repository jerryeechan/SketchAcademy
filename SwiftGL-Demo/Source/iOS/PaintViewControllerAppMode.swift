//
//  PaintViewControllerImplement.swift
//  SwiftGL
//
//  Created by jerry on 2015/9/25.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import Foundation
import UIKit


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
    func enterViewMode()
    {
        playBackViewState.animateShow(0.2)
        toolViewState.animateHide(0.2)
        toolViewState.isLocked = true
        noteListViewState.animateShow(0.2)
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
        paintManager.currentReplayer.setProgressSliderAtCurrentStroke()
        
        /*
        switch(paintMode)
        {
        case .Artwork:
            appState = .viewArtwork
            
            
            //paintManager.artworkDrawModeSwitchToViewMode()
        case .Revision:
            appState = .viewArtwork
            viewModeToolBarSetUp()
            
            //paintManager.revisionDrawModeSwitchToViewMode()
        }*/
    }
    
    func viewArtwork()
    {
        
    }
    func viewRevision()
    {
        
    }
    
    func enterDrawMode()
    {
        playBackViewState.animateHide(0.2)
        noteListViewState.animateHide(0.2)
        toolViewState.isLocked = false
        switch(appState)
        {
        case .drawArtwork:
            artworkDrawModeToolBarSetUp()
            paintManager.artworkDrawModeSetUp()
        case .drawRevision:
            revisionDrawModeToolBarSetUp()
            paintManager.revisionDrawModeSetUp()
        default:
            print("Error")
        }

        
    }
    func removeToolBarButton(button:UIBarButtonItem)->Int!
    {
        let index = toolBarItems.indexOf(button)
        if(index != nil)
        {
            toolBarItems.removeAtIndex(index!)
        }
        return index

    }
    func addToolBarButton(button:UIBarButtonItem,atIndex:Int)
    {
        let index = toolBarItems.indexOf(button)
        if(index == nil)
        {
            toolBarItems.insert(button, atIndex: atIndex)
        }
        
    }
    func viewModeToolBarSetUp()
    {
        let index = removeToolBarButton(enterViewModeButton)
        
        
        switch(paintMode)
        {
        case .Artwork:
            addToolBarButton(enterDrawModeButton, atIndex: index)
            addToolBarButton(addNoteButton, atIndex: index)
        case .Revision:
            removeToolBarButton(reviseDoneButton)
            removeToolBarButton(enterDrawModeButton)
            addToolBarButton(addNoteButton, atIndex: toolBarItems.count)
            break
            
        }
        
        
        
        mainToolBar.setItems(toolBarItems, animated: true)
        showToolButton.hidden = true

    }
    func artworkDrawModeToolBarSetUp()
    {
        removeToolBarButton(reviseDoneButton)
        removeToolBarButton(addNoteButton)
        removeToolBarButton(enterDrawModeButton)
        addToolBarButton(enterViewModeButton, atIndex: toolBarItems.count)
        mainToolBar.setItems(toolBarItems, animated: true)
        showToolButton.hidden = false
    }
    
    func revisionDrawModeToolBarSetUp()
    {
        //reviseDoneButton.enabled = true
        addToolBarButton(reviseDoneButton, atIndex: toolBarItems.count)
        removeToolBarButton(addNoteButton)
        
        //toolBarItems.insert(<#T##newElement: Element##Element#>, atIndex: index)
        mainToolBar.setItems(toolBarItems, animated: true)
        showToolButton.hidden = false
    }
    
    
    
    
    
    //Save file
    func saveFile(fileName:String)
    {
        let img = GLContextBuffer.instance.contextImage()
        paintManager.saveArtwork(fileName,img:img)
        
        GLContextBuffer.instance.releaseImgBuffer()
        
    }
    func saveFileIOS9()
    {
        if fileName != nil
        {
            saveFile(fileName)
            self.navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            let saveAlertController = UIAlertController(title: "Save File", message: "type in the file name", preferredStyle: UIAlertControllerStyle.Alert)
            
            
            
            var inputTextField: UITextField?
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self.saveFile(inputTextField!.text!)
                self.navigationController?.popViewControllerAnimated(true)
            })
            
            
            
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
            }
            
            saveAlertController.addTextFieldWithConfigurationHandler{ (textField) -> Void in
                inputTextField = textField
                // Here you can configure the text field (eg: make it secure, add a placeholder, etc)
            }
            
            saveAlertController.addAction(ok)
            saveAlertController.addAction(cancel)
            
            presentViewController(saveAlertController, animated: true, completion: nil)
        }
        
        
        
    }

}