//
//  PaintViewControllerTextEdit.swift
//  SwiftGL
//
//  Created by jerry on 2016/2/13.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//
extension PaintViewController:UITextViewDelegate
{
    func noteEditSetUp()
    {
        
        noteTitleField.editable = false
        noteTitleField.delegate = self
        //noteTitleField.addGestureRecognizer(doubleTapSingleTouchGestureRecognizer)
        noteTitleField.editTapRecognizer = doubleTapSingleTouchGestureRecognizer
        
        
        noteDescriptionTextView.editable = false
        noteDescriptionTextView.delegate = self
        noteDescriptionTextView.addGestureRecognizer(doubleTapSingleTouchGestureRecognizer)
        noteDescriptionTextView.editTapRecognizer = doubleTapSingleTouchGestureRecognizer
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onKeyBoardHide:", name:
            UIKeyboardWillHideNotification, object: nil)
    }
    func hideKeyBoard()
    {
        noteTitleField.resignFirstResponder()
        noteDescriptionTextView.resignFirstResponder()
    }
    func onKeyBoardHide(notification:NSNotification)
    {
        if appState == AppState.editNote
        {
            editNoteDone()
        }
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if let t = textField as? NoteTitleField
        {
            return t.editable
        }
        else
        {
            return true
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        editNoteDone()
        return true
    }
    
     func newNote(atStroke:Int)->Note
     {
        noteTitleField.text = ""
        noteDescriptionTextView.clear()
        let note = NoteManager.instance.addNote(atStroke,title: "", description: "")
        addNoteButton.enabled = false
        
        enterEditMode()
        
        return note
    }
    func editNote()
    {
        enterEditMode()
    }
    func deleteNote(at:Int)
    {
        hideKeyBoard()
        NoteManager.instance.deleteNoteAtStroke(at)
        
        selectedPath = nil
        noteListTableView.reloadData()
        
        onProgressValueChanged(replayProgressBar.progress)
        
    }
    private func enterEditMode()
    {
        appState = AppState.editNote
        noteDescriptionTextView.editable = true
        noteTitleField.editable = true
    }
    
    func editNoteDone()
    {
        if appState == .editNote
        {
            noteDescriptionTextView.editable = false
            noteTitleField.editable = false
            
            NoteManager.instance.updateNote(NoteManager.instance.selectedButtonIndex, title: noteTitleField.text!, description: noteDescriptionTextView.text)
            
            appState = lastAppState
            
        }
        
        
    }
}
