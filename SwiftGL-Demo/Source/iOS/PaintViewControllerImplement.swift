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
    
    
    
    //Apearance
    func drawNoteEditTextViewStyle()
    {
        
        noteEditTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        noteEditTextView.layer.borderWidth = 1
        noteEditTextView.layer.cornerRadius = 5
        noteEditTextView.clipsToBounds = true
        
    }
    
    func enterNoteMode()
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

        /*
        UIView.animateWithDuration(0.5, animations: {
            let transform = CATransform3DMakeScale(0.7, 0.7, 1)
            //transform = CATransform3DTranslate(transform,-512, -384, 0)
            self.paintView.layer.transform = transform
        })
        */
    }
    
    func showNoteEditView()
    {
        paintView.layer.position = CGPointZero
        paintView.layer.anchorPoint = CGPointZero
        
        //noteEditTextView.text = ""
        //noteEditTitleTextField.text = ""
        UIView.animateWithDuration(0.5, animations: {
            let transform = CATransform3DMakeScale(0.5, 0.5, 1)
            //transform = CATransform3DTranslate(transform,-512, -384, 0)
            self.paintView.layer.transform = transform
            
            //self.noteEditView.center.y = self.noteEditViewOriginCenter.y
            self.noteEditViewTopConstraint.constant = 0
            self.noteEditView.layoutIfNeeded()
            
        })
        
        noteEditTextView.becomeFirstResponder()
        
    }
    
    
    func hideNoteEditView()
    {
        UIView.animateWithDuration(0.5, animations: {
            let transform = CATransform3DMakeScale(1, 1, 1)
            //transform = CATransform3DTranslate(transform,-512, -384, 0)
            self.paintView.layer.transform = transform
            
            //self.noteEditView.center.y = self.noteEditViewOriginCenter.y
            self.noteEditViewTopConstraint.constant = -384
            self.noteEditView.layoutIfNeeded()
            
            
        })
    }
    
    
    
    //Save file
    func saveFile(fileName:String)
    {
        let img = GLContextBuffer.instance.contextImage()
        PaintRecorder.instance.saveArtwork(fileName,img:img)
        GLContextBuffer.instance.releaseImgBuffer()
        
    }
    func saveFileIOS9()
    {
        let saveAlertController = UIAlertController(title: "Save File", message: "type in the file name", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        var inputTextField: UITextField?
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
            self.saveFile(inputTextField!.text!)
        })
        
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
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