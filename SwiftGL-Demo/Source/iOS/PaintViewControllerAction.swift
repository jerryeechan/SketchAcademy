//
//  PaintViewControllerAction.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/5.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

extension PaintViewController:UITextFieldDelegate
{
    @IBAction func switchModeBtnTouched(sender: UIBarButtonItem) {
        switch(appState)
        {
        case .drawArtwork,.drawRevision:
            switchToDrawMode()
            switchModeButton.image = UIImage(contentsOfFile: "Brush-50")
        case .viewArtwork,.viewRevision:
            switchToViewMode()
            switchModeButton.image = UIImage(contentsOfFile: "view")
        default:
            break
        }
    }
    func switchToDrawMode()
    {
        switch(appState)
        {
        case .viewArtwork:
            appState = .drawArtwork
        case .viewRevision:
            appState = .drawRevision
        default:
            DLog("Wrong")
            
        }
        enterDrawMode()

    }
    func switchToViewMode()
    {
        switch(appState)
        {
        case .drawArtwork:
            appState = .viewArtwork
        case .drawRevision:
            appState = .viewRevision
        default:
            print("Error", terminator: "")
            
        }
        enterViewMode()

    }
    @IBAction func enterDrawModeButtonTouched(sender: UIBarButtonItem) {
        switchToDrawMode()
    }
    
    @IBAction func enterViewModeButtonTouched(sender: UIBarButtonItem) {
        switchToViewMode()
    }
    
    @IBAction func addNoteButtonTouched(sender: UIBarButtonItem) {
        let at = paintManager.getCurrentStrokeID()
        let note = newNote(at)
        noteTitleField.becomeFirstResponder()
        noteDetailView.animateShow(0.2)
        createNoteButton(note)
        
        selectedPath = NSIndexPath(forRow: NoteManager.instance.noteCount-1, inSection: 0)
        noteListTableView.reloadData()
        
    }

    @IBAction func reviseDoneButtonTouched(sender: UIBarButtonItem) {
        appState = .viewArtwork
        enterViewMode()
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
    
    @IBAction func undoButtonTouched(sender: UIBarButtonItem) {
        if appState == .drawArtwork
        {
            paintManager.undo()
        }
    }
    
    @IBAction func redoButtonTouched(sender: UIBarButtonItem) {
        if appState == .drawArtwork
        {
            paintManager.redo()

        }
    }
    func onStrokeProgressChanged(currentStrokeID:Int,totalStrokeCount:Int)
    {
        if currentStrokeID == 0
        {
            undoButton.enabled = false
        }
        else
        {
            undoButton.enabled = true
        }
        
        if currentStrokeID == totalStrokeCount-1
        {
            redoButton.enabled = false
        }
        else
        {
            redoButton.enabled = true
        }
        paintManager.currentReplayer.last_endIndex = currentStrokeID
        
    }
    
    @IBAction func dismissButtonTouched(sender: UIBarButtonItem) {
        switch(appState)
        {
        case .viewRevision:
            appState = .viewArtwork
            paintManager.playArtworkClip()
            dismissButton.image = UIImage(named: "Back-50")
        default:
            saveFileIOS9();
        }
        
        //presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        //dismissViewControllerAnimated(true, completion: nil)
        
    }
    func screenShotMethod() {
        //Create the UIImage
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageData:NSData = UIImagePNGRepresentation(image)!;
        let filePath = File.dirpath+"/screen.png"
        imageData.writeToFile(filePath, atomically: true)
        
        FileManager.instance.upload(filePath)
        //Save it to the camera roll
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    //Save file
    func saveFile(fileName:String)
    {
        let img = paintView.snapshot//paintView.paintBuffer.contextImage()
        
        paintManager.saveArtwork(fileName,img:scaleImage(img, scale: 0.2))
        //screenShotMethod()
        //GLContextBuffer.instance.releaseImgBuffer()
        
    }
    func saveFileIOS9()
    {
        switch PaintViewController.appMode {
        case .InstructionTutorial:
            //don't save when doing tutoriral practice
            self.navigationController?.popViewControllerAnimated(true)
        default:
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
    
}