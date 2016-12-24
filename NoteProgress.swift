//
//  NoteProgress.swift
//  SwiftGL
//
//  Created by jerry on 2016/2/8.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import Foundation
import GLFramework
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
    
    func createNoteButton(_ note:SANote)
    {
        let noteButton = NoteButton(type: UIButtonType.system)
        
        noteButton.addTarget(self, action: #selector(PaintViewController.noteButtonTouchUpInside(_:)), for: UIControlEvents.touchUpInside)
        noteButton.note = note
        noteButton.tag = note.value.strokeIndex
        
        updateNoteButton(noteButton)
        
        //add to noteButtonView
        noteButtonView.addSubview(noteButton)
        noteButtonView.setNeedsDisplay()
        NoteManager.instance.addNoteButton(noteButton, note: note)
        selectNoteButton(note.value.strokeIndex)
    }
    
    func selectNoteButton(_ atStroke:Int)
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
            let lastButton = NoteManager.instance.getNoteButton(lastIndex!)
            lastButton?.deSelectStyle()
        }

        let selectedButton = NoteManager.instance.getNoteButton(atStroke)
        //select current Button
        if selectedButton != nil{
            UIView.animate(withDuration: 1, animations: {
                selectedButton?.layer.borderWidth = 4
                selectedButton?.layer.borderColor = themeLightColor.cgColor
            })
            NoteManager.instance.selectedButtonIndex = atStroke
        }
        else
        {
            NoteManager.instance.selectedButtonIndex = nil
        }
        
    }
    func noteButtonTouchUpInside(_ sender: UIButton!)
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
    func updateNoteButton(_ noteButton:NoteButton)
    {
        let percentage = CGFloat(noteButton.note.value.strokeIndex)/CGFloat(paintManager.currentReplayer.strokeCount())
        
        noteButton.setPosition(floor(percentage * viewWidth))
    }
        
}
