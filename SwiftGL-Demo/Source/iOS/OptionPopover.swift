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
    @IBAction func optionButtonTouched(_ sender: UIBarButtonItem) {
        
        hideKeyBoard()
        let optionViewController = getViewController("option") as! OptionTableViewController
        
        optionViewController.modalPresentationStyle = .popover
        
        optionViewController.delegate = self
        
        let popover = optionViewController.popoverPresentationController
        popover?.barButtonItem  = sender
        popover?.permittedArrowDirections = .up
        popover?.delegate = self
        
        self.present(optionViewController, animated: true, completion: {})
 
    }
    @IBAction func noteOptionButtonTouched(_ sender: UIBarButtonItem) {
        hideKeyBoard()
        let noteOptionViewController = getViewController("noteOption") as! NoteOptionTableViewController
        
        noteOptionViewController.modalPresentationStyle = .popover
        
        noteOptionViewController.delegate = self
        
        
        let popover = noteOptionViewController.popoverPresentationController
        popover?.barButtonItem  = sender
        popover?.permittedArrowDirections = .up
        popover?.delegate = self
    
        self.present(noteOptionViewController, animated: true, completion: {})
        // popover?.delegate = self
        
    }
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
       //_ = popoverPresentationController.presentedViewController as! NoteOptionTableViewController
       
        
    }
    func noteOptionDrawRevisionTouched()
    {
        appState = .drawRevision
        enterDrawMode()

    }
}
