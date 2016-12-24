//
//  PaintViewControllerAction.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/5.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//
import GLFramework
extension PaintViewController:UITextFieldDelegate
{
    @IBAction func switchModeBtnTouched(_ sender: UIBarButtonItem) {
        switch(appState)
        {
        case .drawArtwork,.drawRevision:
            switchModeButton.image = UIImage(named: "view")
            switchToViewMode()
        case .viewArtwork,.viewRevision:
            switchModeButton.image = UIImage(named:"Brush-50")
            switchToDrawMode()
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
    @IBAction func enterDrawModeButtonTouched(_ sender: UIBarButtonItem) {
        switchToDrawMode()
    }
    
    @IBAction func enterViewModeButtonTouched(_ sender: UIBarButtonItem) {
        switchToViewMode()
    }
    
    @IBAction func addNoteButtonTouched(_ sender: UIBarButtonItem) {
        let at = paintManager.getCurrentStrokeID()
        let note = newNote(at)
        noteTitleField.becomeFirstResponder()
        noteDetailView.animateShow(0.2)
        createNoteButton(note)
        
        selectedPath = IndexPath(row: NoteManager.instance.noteCount-1, section: 0)
        noteListTableView.reloadData()
    }

    @IBAction func reviseDoneButtonTouched(_ sender: UIBarButtonItem) {
        switch appState {
        case AppState.drawRevision,AppState.viewRevision:
            appState = .viewArtwork
            enterViewMode()
        case AppState.selectStroke:
            playSeletingStrokes()
            
        default:
            break
        }
        
    }
    
    
    @IBAction func showToolViewButtonTouched(_ sender: UIButton) {
        toolViewState.animateShow(0.2)
    }
    @IBAction func hideToolViewButtonTouched(_ sender: UIBarButtonItem) {
        toolViewState.animateHide(0.2)
    }
    
    @IBAction func trashButtonTouched(_ sender: UIBarButtonItem) {
        paintManager.clear()
    }
    
    func checkUndoRedo(){
        let currentStrokeID = paintManager.artwork.currentClip.currentStrokeID
        let totalStrokeCount = paintManager.artwork.currentClip.strokes.count + paintManager.artwork.currentClip.redoStrokes.count
        
        if currentStrokeID == 0 && paintManager.artwork.currentClip.op.count == 0
        {
            undoButton.isEnabled = false
        }
        else
        {
            undoButton.isEnabled = true
        }
        
        if currentStrokeID == totalStrokeCount && paintManager.artwork.currentClip.redoOp.count == 0
        {
            redoButton.isEnabled = false
        }
        else
        {
            redoButton.isEnabled = true
        }
    }
    @IBAction func undoButtonTouched(_ sender: UIBarButtonItem) {
        if appState == .drawArtwork
        {
            paintManager.undo()
            checkUndoRedo()
        }
    }
    
    @IBAction func redoButtonTouched(_ sender: UIBarButtonItem) {
        if appState == .drawArtwork
        {
            paintManager.redo()
            checkUndoRedo()
        }
    }
    func onStrokeProgressChanged(_ currentStrokeID:Int,totalStrokeCount:Int)
    {
        checkUndoRedo()
        paintManager.currentReplayer.last_endIndex = currentStrokeID
        
    }
    
    @IBAction func dismissButtonTouched(_ sender: UIBarButtonItem) {
        PaintViewController.instance = nil
        if strokeSelecter.isSelectingClip
        {
            //strokeSelecter.exitSelectionMode()
            paintManager.artwork.loadMasterClip()
            paintManager.artwork.drawAll()
            paintView.display()
            strokeSelecter.isSelectingClip = false
            return
        }
        paintManager.currentReplayer.stopPlay()
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
    func share()
    {
       let acv = UIActivityViewController(activityItems: [FileManager.instance.imageFile.loadImg(fileName, attribute: "gif")], applicationActivities: nil)
        present(acv, animated: true, completion: nil)
    }
    func takeScreenShot() {
        //Create the UIImage
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageData:Data = UIImagePNGRepresentation(image!)!;
        let filePath = File.dirpath+"/screen.png"
        try? imageData.write(to: URL(fileURLWithPath: filePath), options: [.atomic])
        
        FileManager.instance.uploadFilePath(filePath)
        //Save it to the camera roll
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    //Save file
    func saveFile(_ fileName:String)
    {
        let img = paintView.snapshot//paintView.paintBuffer.contextImage()
        
        paintManager.saveArtwork(fileName,img:img)
        //exportGIF(fileName)
        //screenShotMethod()
        //GLContextBuffer.instance.releaseImgBuffer()
        
    }
    func saveFileIOS9()
    {
        switch PaintViewController.appMode {
        case .instructionTutorial:
            //don't save when doing tutoriral practice
            if((navigationController) != nil)
            {
                navigationController?.popViewController(animated: true)
            }
            else
            {
                presentingViewController?.dismiss(animated: true, completion: nil)
            }
        default:
            if fileName != nil
            {
                saveFile(fileName)
                if((navigationController) != nil)
                {
                    navigationController?.popViewController(animated: true)
                }
                else
                {
                    presentingViewController?.dismiss(animated: true, completion: nil)
                }
            }
            else
            {
                let saveAlertController = UIAlertController(title: "Save File", message: "type in the file name", preferredStyle: UIAlertControllerStyle.alert)
                
                
                
                var inputTextField: UITextField?
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) -> Void in
                    self.saveFile(inputTextField!.text!)
                    self.navigationController?.popViewController(animated: true)
                })
                
                
                
                let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                    self.navigationController?.popViewController(animated: true)
                }
                
                saveAlertController.addTextField{ (textField) -> Void in
                    inputTextField = textField
                    // Here you can configure the text field (eg: make it secure, add a placeholder, etc)
                }
                
                saveAlertController.addAction(ok)
                saveAlertController.addAction(cancel)
                
                present(saveAlertController, animated: true, completion: nil)
            }
        }
        
    }
    
}
