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
            
            currentProgressValue = sender.value
            
            if appState == .viewArtwork
            {
                let index = NoteManager.instance.getNoteIndexFromStrokeID(paintManager.getCurrentStrokeID())
                
                print("note index\(index)");
                if index != -1
                {
                    isCellSelectedSentbySlider = true
                    
                    
                    
                    //let cell = noteListTableView.cellForRowAtIndexPath(selectedPath)
                    
                    
                    //noteListTableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.None)
                    selectRow(NSIndexPath(forRow: index, inSection: 0))
                    //tableView(noteListTableView, didSelectRowAtIndexPath: NSIndexPath(forRow: index, inSection: 0))
                }
                else
                {
                    //print("wtf")
                    //noteListTableView.deselectRowAtIndexPath(NSIndexPath(forRow: NoteManager.instance.selectedNoteIndex, inSection: 0), animated: true)
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
