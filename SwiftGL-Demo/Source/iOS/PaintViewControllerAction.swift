//
//  PaintViewControllerAction.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/5.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

extension PaintViewController
{
    @IBAction func modeSwitcherValueChanged(sender: UISwitch) {
        if sender.on
        {
            
        }
        else
        {
            enterDrawMode()
        }
    }
    
    @IBAction func enterDrawModeButtonTouched(sender: UIBarButtonItem) {
        
        switch(paintMode)
        {
        case .Artwork:
            
            appState = .drawArtwork
        case .Revision:
            
            appState = .drawRevision
        }
        enterDrawMode()
    }
    
    @IBAction func enterViewModeButtonTouched(sender: UIBarButtonItem) {
        switch(appState)
        {
        case .drawArtwork:
            appState = .viewArtwork
        case .drawRevision:
            appState = .viewRevision
        default:
            print("Error")
            
        }
        enterViewMode()
    }
    
    
    
    @IBAction func noteEditButtonTouched(sender: UIBarButtonItem) {
        switch(paintMode)
        {
        case .Artwork:
            showNoteEditView()
            noteEditTextView.text = ""
            noteEditTitleTextField.text = ""
            noteEditMode = .New
        case .Revision:
            enterDrawMode()
        }
        
    }
    
    func onKeyBoardHide(notification:NSNotification)
    {
        hideNoteEditView()
    }
    
    
    
    @IBAction func reviseDoneButtonTouched(sender: UIBarButtonItem) {
        enterViewMode()
        showNoteEditView()

    }
    
    
    @IBAction func showToolViewButtonTouched(sender: UIButton) {
        toolViewState.animateShow(0.2)
    }
    @IBAction func hideToolViewButtonTouched(sender: UIBarButtonItem) {
        toolViewState.animateHide(0.2)
    }
    
    @IBAction func trashButtonTouched(sender: UIBarButtonItem) {
        paintManager.clear()
    }
    
    @IBAction func dismissButtonTouched(sender: UIBarButtonItem) {
        saveFileIOS9();
        //presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        //dismissViewControllerAnimated(true, completion: nil)
        
    }
}
