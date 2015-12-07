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
        
        
        //PaintReplayer.instance.reloadArtwork()
        mode = AppMode.browsing
        
        playBackViewState.animateShow(0.2)
        toolViewState.animateHide(0.2)
        toolViewState.isLocked = true
        noteListViewState.animateShow(0.2)
        //subViewAnimationGestureHandler.showPlayBackView(0.2)
        //subViewAnimationGestureHandler.hideToolView(0.2)
        //subViewAnimationGestureHandler.isToolPanelLocked = true
        progressSlider.value = 1
        
        print("----enter View Mode----")
        viewModeToolBarSetUp()
        PaintManager.instance.switchToViewMode()
        
        
        /*
        UIView.animateWithDuration(0.5, animations: {
            let transform = CATransform3DMakeScale(0.7, 0.7, 1)
            //transform = CATransform3DTranslate(transform,-512, -384, 0)
            self.paintView.layer.transform = transform
        })
        */
    }
    func enterDrawMode()
    {
        mode = AppMode.drawing
        playBackViewState.animateHide(0.2)
        noteListViewState.animateHide(0.2)
        toolViewState.isLocked = false
        switch(paintMode)
        {
        case .Artwork:
            artworkDrawModeToolBarSetUp()
            PaintManager.instance.artworkDrawModeSetUp()
            
        case .Revision:
            revisionDrawModeToolBarSetUp()
            PaintManager.instance.revisionDrawModeSetUp()
            
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
        case .Revision:
            removeToolBarButton(reviseDoneButton)
            removeToolBarButton(enterDrawModeButton)
            break
            
        }
        
        addToolBarButton(addNoteButton, atIndex: index)
        
        mainToolBar.setItems(toolBarItems, animated: true)

    }
    func artworkDrawModeToolBarSetUp()
    {
        removeToolBarButton(reviseDoneButton)
        removeToolBarButton(addNoteButton)
        removeToolBarButton(enterDrawModeButton)
        addToolBarButton(enterViewModeButton, atIndex: toolBarItems.count)
        mainToolBar.setItems(toolBarItems, animated: true)
    }
    
    func revisionDrawModeToolBarSetUp()
    {
        //reviseDoneButton.enabled = true
        addToolBarButton(reviseDoneButton, atIndex: toolBarItems.count)
        removeToolBarButton(addNoteButton)
        
        //toolBarItems.insert(<#T##newElement: Element##Element#>, atIndex: index)
        mainToolBar.setItems(toolBarItems, animated: true)
    }
    
    
    
    
    
    //Save file
    func saveFile(fileName:String)
    {
        let img = GLContextBuffer.instance.contextImage()
        PaintManager.instance.saveArtwork(fileName,img:img)
        
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