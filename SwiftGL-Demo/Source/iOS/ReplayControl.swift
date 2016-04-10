//
//  PaintViewControllerReplayControl.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/5.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

extension PaintViewController
{
    @IBAction func PlayButtonTouched(sender: UIBarButtonItem) {
        
        
        paintManager.pauseToggle()
        
        playPauseButton.playing(paintManager.currentReplayer.isPlaying)
        if paintManager.currentReplayer.isPlaying
        {
            playbackControlPanel.reactivate()
        }
        else
        {
            playbackControlPanel.pause()
        }
        
        
    }
    @IBAction func fastForwardButtonTouched(sender: UIButton) {
        paintManager.doublePlayBackSpeed()
        doublePlayBackButton.setTitle("\(Int(paintManager.currentReplayer.timeScale))x", forState: UIControlState.Normal)
        
        playbackControlPanel.reactivate()
    }
    @IBAction func RewindButtonTouched(sender: UIBarButtonItem) {
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
        case .InstructionTutorial:
            tutorialLastStepButton.enabled = false
        default:
            tutorialControlPanel.hidden = true
        }
        tutorialLastStepButton.enabled = false
    }
    
    func onProgressValueChanged(progress:Float,strokeID:Int)
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
                addNoteButton.enabled = true
            }
            else
            {
                addNoteButton.enabled = false
            }
            
            DLog("\(currentStrokeID)")
            let nearestNoteArrayIndex = NoteManager.instance.getFloorNoteIndexFromStrokeID(currentStrokeID)
            
            
            DLog("\(nearestNoteArrayIndex)")
            if nearestNoteArrayIndex != -1
            {
                noteDetailView.animateShow(0.2)
                isCellSelectedSentbySlider = true
                selectRow(NSIndexPath(forRow: nearestNoteArrayIndex, inSection: 0))
                let atStroke = NoteManager.instance.getSortedKeys()[nearestNoteArrayIndex]
                
                let note = NoteManager.instance.getNoteAtStroke(atStroke)
                
                noteTitleField.text = note.title
                
                noteDescriptionTextView.changeText(note.description)
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
                    noteListTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
                
            }
        }
    }
    
    
    //tutorail replay
    @IBAction func tutorialNextStepBtnTouched(sender: UIBarButtonItem) {
        if !paintManager.tutorialNextStep()
        {
            tutorialNextStepButton.enabled = false
        }
        tutorialLastStepButton.enabled = true
        setTutorialStepContent()
    }
    @IBAction func tutorialLastStepBtnTouched(sender: UIBarButtonItem) {
        if !paintManager.tutorialLastStep()
        {
            tutorialLastStepButton.enabled = false
        }
        tutorialNextStepButton.enabled = true
        setTutorialStepContent()
        
    }
    func setTutorialStepContent()
    {
        let note = paintManager.tutorialArtwork.currentNote
        tutorialDescriptionTextView.text = note.description
        tutorialTitleLabel.text = note.title
    }
    @IBAction func tutorialPlayPauseTouched(sender: PlayPauseButton) {
    }
    
    @IBAction func tutorialReplayBtnTouched(sender: UIBarButtonItem) {
    }

    

}
