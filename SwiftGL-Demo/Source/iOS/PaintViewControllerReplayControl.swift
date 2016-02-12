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
        if paintManager.currentReplayer.isPlaying == true
        {
            playPauseButton.image = pauseImage
        }
        else
        {
            playPauseButton.image = playImage
        }
        
    }
    
    @IBAction func fastForwardButtonTouched(sender: UIBarButtonItem) {
        paintManager.doublePlayBackSpeed()
        
        doublePlayBackButton.title = "\(Int(paintManager.currentReplayer.timeScale))x"
    }
    
    
    @IBAction func RewindButtonTouched(sender: UIBarButtonItem) {
        paintManager.restart()
    }
    
    @IBAction func artworkProgressSliderDragged(sender: UISlider) {
        
        if paintManager.drawProgress(sender.value) == true //success draw
        {
            if appState == .viewArtwork
            {
                let currentStrokeID = paintManager.getCurrentStrokeID()
                /*
                if NoteManager.instance.getOrderedNote(currentStrokeID) == nil
                {
                    //TODO
                    //allow add button
                }
                */
                let index = NoteManager.instance.getNoteIndexFromStrokeID(currentStrokeID)
                
                //print("note index\(index)");
                if index != -1
                {
                    isCellSelectedSentbySlider = true
                    selectRow(NSIndexPath(forRow: index, inSection: 0))
                    //tableView(noteListTableView, didSelectRowAtIndexPath: NSIndexPath(forRow: index, inSection: 0))
                }
                else
                {
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

    
}
