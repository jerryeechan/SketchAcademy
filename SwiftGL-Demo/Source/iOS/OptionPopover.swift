//
//  NoteOption.swift
//  SwiftGL
//
//  Created by jerry on 2016/2/19.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//
//註解選項按鈕 handler
extension PaintViewController:UIPopoverPresentationControllerDelegate
{
    @IBAction func optionButtonTouched(sender: UIBarButtonItem) {
        
        hideKeyBoard()
        let optionViewController = getViewController("option") as! OptionTableViewController
        
        optionViewController.modalPresentationStyle = .Popover
        
        optionViewController.delegate = self
        
        let popover = optionViewController.popoverPresentationController
        popover?.barButtonItem  = sender
        popover?.permittedArrowDirections = .Up
        popover?.delegate = self
        
        self.presentViewController(optionViewController, animated: true, completion: {})
 
    }
    @IBAction func noteOptionButtonTouched(sender: UIBarButtonItem) {
        hideKeyBoard()
        let noteOptionViewController = getViewController("noteOption") as! NoteOptionTableViewController
        
        noteOptionViewController.modalPresentationStyle = .Popover
        
        noteOptionViewController.delegate = self
        
        
        let popover = noteOptionViewController.popoverPresentationController
        popover?.barButtonItem  = sender
        popover?.permittedArrowDirections = .Up
        popover?.delegate = self
    
        self.presentViewController(noteOptionViewController, animated: true, completion: {})
        // popover?.delegate = self
        
    }
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
       //_ = popoverPresentationController.presentedViewController as! NoteOptionTableViewController
       
        
    }
    func noteOptionDrawRevisionTouched()
    {
        appState = .drawRevision
        enterDrawMode()

    }
}
