//
//  NoteProgress.swift
//  SwiftGL
//
//  Created by jerry on 2016/2/8.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import Foundation
extension PaintViewController
{
    
    func noteProgressButtonSetUp()
    {
        let notes = NoteManager.instance.getNoteArray()
        for note in notes
        {
            createNoteButton(note)
        }
    }
    
    func createNoteButton(note:Note)
    {
        let noteButton = NoteButton(type: UIButtonType.System)
        
        noteButton.addTarget(self, action: Selector("noteButtonTouchUpInside:"), forControlEvents: UIControlEvents.TouchUpInside)
        noteButton.note = note
        noteButton.tag = note.value.strokeIndex
        
        updateNoteButton(noteButton)
        
        //add to noteButtonView
        noteButtonView.addSubview(noteButton)
        noteButtonView.setNeedsDisplay()
        NoteManager.instance.addNoteButton(noteButton, note: note)
    }
    
    func selectNoteButton(atStroke:Int)
    {
        let lastIndex = NoteManager.instance.selectedButtonIndex
        
        if lastIndex != nil
        {
            //selected does not change, don't do anything
            if lastIndex == atStroke
            {
                return
            }
            
            //deselect last Button
            let lastButton = NoteManager.instance.getNoteButton(lastIndex)
            lastButton.deSelectStyle()
        }

        let selectedButton = NoteManager.instance.getNoteButton(atStroke)
        //select current Button
        if selectedButton != nil{
            UIView.animateWithDuration(1, animations: {
                selectedButton.layer.borderWidth = 4
                selectedButton.layer.borderColor = themeLightColor.CGColor
            })
            NoteManager.instance.selectedButtonIndex = atStroke
        }
        else
        {
            NoteManager.instance.selectedButtonIndex = nil
        }
        
    }
    func noteButtonTouchUpInside(sender: UIButton!)
    {
        paintManager.drawStrokeProgress(sender.tag)
    }
    func updateAllNoteButton()
    {
        for button in NoteManager.instance.noteButtonDict.values
        {
            updateNoteButton(button)
        }
    }
    func updateNoteButton(noteButton:NoteButton)
    {
        let percentage = CGFloat(noteButton.note.value.strokeIndex)/CGFloat(paintManager.currentReplayer.strokeCount())
        
        noteButton.setPosition(floor(percentage * viewWidth))
    }
        
}
