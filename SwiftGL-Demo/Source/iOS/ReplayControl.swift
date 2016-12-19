//
//  PaintViewControllerReplayControl.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/5.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

extension PaintViewController
{
    @IBAction func PlayButtonTouched(_ sender: UIBarButtonItem) {
        
        
        paintManager.pauseToggle()
        
        if paintManager.currentReplayer.isPlaying
        {
            playbackControlPanel.reactivate()
        }
        else
        {
            playbackControlPanel.pause()
        }
        
        
    }
    @IBAction func fastForwardButtonTouched(_ sender: UIButton) {
        paintManager.doublePlayBackSpeed()
        doublePlayBackButton.setTitle("\(Int(paintManager.currentReplayer.timeScale))x", for: UIControlState())
        
        playbackControlPanel.reactivate()
    }
    @IBAction func RewindButtonTouched(_ sender: UIBarButtonItem) {
        paintManager.restart()
        playPauseButton.playing(true)
        playbackControlPanel.reactivate()
    }
    
    func replayControlSetup()
    {
        paintManager.currentReplayer.onProgressValueChanged = {[weak self](progressValue:Float,strokeID:Int) in
            self!.onProgressValueChanged(progressValue,strokeID: strokeID)
            
        }
        switch PaintViewController.appMode {
        case .instructionTutorial:
            tutorialLastStepButton.isEnabled = false
        default:
            tutorialControlPanel.isHidden = true
        }
        tutorialLastStepButton.isEnabled = false
    }
    
    func onProgressValueChanged(_ progress:Float,strokeID:Int)
    {
        if appState == .viewArtwork || appState == AppState.editNote
        {
            replayProgressBar.setProgress(progress, animated: false)
            paintView.display()
            disx = 0
            
            let currentStrokeID = paintManager.getCurrentStrokeID()
            
            if NoteManager.instance.getNoteAtStroke(currentStrokeID) == nil
            {
                //TODO
                //allow add button
                addNoteButton.isEnabled = true
            }
            else
            {
                addNoteButton.isEnabled = false
            }
            
            DLog("\(currentStrokeID)")
            let nearestNoteArrayIndex = NoteManager.instance.getFloorNoteIndexFromStrokeID(currentStrokeID)
            
            
            DLog("\(nearestNoteArrayIndex)")
            if nearestNoteArrayIndex != -1
            {
                noteDetailView.animateShow(0.2)
                isCellSelectedSentbySlider = true
                selectRow(IndexPath(row: nearestNoteArrayIndex, section: 0))
                let atStroke = NoteManager.instance.getSortedKeys()[nearestNoteArrayIndex]
                
                let note = NoteManager.instance.getNoteAtStroke(atStroke)
                
                noteTitleField.text = note?.title
                
                noteDescriptionTextView.changeText((note?.description)!)
                selectNoteButton(atStroke)
            }
            else
            {
                noteDetailView.animateHide(0.2)
                selectNoteButton(-1)
                if selectedPath != nil
                {
                    let indexPath = selectedPath
                    selectedPath = nil
                    noteListTableView.reloadRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
                }
                
            }
        }
    }
    
    
   
    

}
