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
        PaintManager.instance.pauseToggle()
        
    }
    
    @IBAction func fastForwardButtonTouched(sender: UIBarButtonItem) {
        PaintManager.instance.doublePlayBackSpeed()
    }
    
    
    @IBAction func RewindButtonTouched(sender: UIBarButtonItem) {
        PaintManager.instance.restart()
    }
    
    @IBAction func artworkProgressSliderDragged(sender: UISlider) {
        
        if PaintManager.instance.drawProgress(sender.value) == true //success draw
        {
            currentProgressValue = sender.value
            
            let index = NoteManager.instance.getNoteIndexFromStrokeID(PaintManager.instance.getCurrentStrokeID())
            
            print("note index\(index)");
            if index != -1
            {
                isCellSelectedSentbySlider = true
                
                noteListTableView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.None)
                tableView(noteListTableView, didSelectRowAtIndexPath: NSIndexPath(forRow: index, inSection: 0))
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
