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
        paintManager.masterReplayer.onProgressValueChanged = {[weak self](value) in
            self!.onProgressValueChanged(value)
            
        }
    }
    
    func onProgressValueChanged(progress:Float)
    {
        if appState == .viewArtwork
        {
            replayProgressBar.setProgress(progress, animated: false)
            
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
                
                noteDescriptionTextView.text = note.description
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


}
