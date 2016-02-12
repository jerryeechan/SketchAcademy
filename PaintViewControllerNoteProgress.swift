//
//  PaintViewControllerNoteProgress.swift
//  SwiftGL
//
//  Created by jerry on 2016/2/8.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import Foundation
extension PaintViewController
{
    func setUpNoteProgressButton()
    {
        themeDarkColor = uIntColor(36, green: 53, blue: 62, alpha: 255)
        
        themeLightColor = uIntColor(244, green: 149, blue: 40, alpha: 255)
        
        let notes = NoteManager.instance.getNoteArray()
        for note in notes
        {
            addNoteButton(note)
        }
        
    }
    func addNoteButton(note:Note)
    {
        let btnWidth:CGFloat = 40
        let noteButton = NoteProgressButton(type: UIButtonType.System)
        //44
        noteButton.frame  = CGRectMake(0,-8,btnWidth,40)
        
        noteButton.setImage(UIImage(named: "chat-up"), forState: UIControlState.Normal)
        
        
        noteButton.layer.cornerRadius = 0.25 * btnWidth
        noteButton.backgroundColor = UIColor.whiteColor()
        noteButton.tintColor = themeDarkColor
        DLog("\(themeDarkColor)")
        
        noteButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        noteButton.layer.borderWidth = 1
        
        updateNoteButton(noteButton, note: note)
        
        noteButton.addTarget(self, action: Selector("noteButtonTouchUpInside:"), forControlEvents: UIControlEvents.TouchUpInside)
        noteButton.tag = note.value.strokeIndex
        
        //add to noteButtonView
        noteButtonView.addSubview(noteButton)
        noteButtonView.setNeedsDisplay()
        NoteManager.instance.addNoteButton(noteButton, note: note)
    }
    func noteButtonTouchUpInside(sender: UIButton!)
    {
        let selected = NoteManager.instance.selectedIndex
        if selected != nil
        {
            let lastButton = NoteManager.instance.getNoteButton(selected)
            UIView.animateWithDuration(1, animations: {
                lastButton.layer.borderWidth = 1
                lastButton.layer.borderColor = UIColor.lightGrayColor().CGColor
            })
            
        }
        
        let note = NoteManager.instance.getNoteAtStroke(sender.tag)
        UIView.animateWithDuration(1, animations: {
            sender.layer.borderWidth = 4
            sender.layer.borderColor = self.themeLightColor.CGColor
        })
        NoteManager.instance.selectedIndex = sender.tag
        
        paintManager.drawStrokeProgress(note.value.strokeIndex)
    }
    
    func updateNoteButton(noteButton:UIButton,note:Note)
    {
        let offset:CGFloat = 10
        let percentage = CGFloat(note.value.strokeIndex)/CGFloat(paintManager.masterReplayer.strokeCount())
        noteButton.layer.transform = CATransform3DMakeTranslation(floor(percentage * viewWidth) - offset, 0, 0)
        
    }
    func updateNoteButtons()
    {
        let notes = NoteManager.instance.getNoteArray()
        for note in notes
        {
            let noteButton = NoteManager.instance.getNoteButton(note.value.strokeIndex)
            
            //new note, create the button
            if noteButton == nil
            {
                addNoteButton(note)
            }
            else
            {
                updateNoteButton(noteButton, note: note)
            }
            
        }
    }
        
}
