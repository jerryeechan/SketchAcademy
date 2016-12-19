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
        
        
        noteDescriptionTextView.isEditable = false
        noteDescriptionTextView.delegate = self
        noteDescriptionTextView.addGestureRecognizer(doubleTapSingleTouchGestureRecognizer)
        noteDescriptionTextView.editTapRecognizer = doubleTapSingleTouchGestureRecognizer
        
        NotificationCenter.default.addObserver(self, selector: #selector(PaintViewController.onKeyBoardHide(_:)), name:
            NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func hideKeyBoard()
    {
        noteTitleField.resignFirstResponder()
        noteDescriptionTextView.resignFirstResponder()
    }
    func onKeyBoardHide(_ notification:Notification)
    {
        if appState == AppState.editNote
        {
            editNoteDone()
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let t = textField as? NoteTitleField
        {
            return t.editable
        }
        else
        {
            return true
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        editNoteDone()
        return true
    }
    
     func newNote(_ atStroke:Int)->Note
     {
        noteTitleField.text = ""
        noteDescriptionTextView.clear()
        let note = NoteManager.instance.addNote(atStroke,title: "", description: "")
        addNoteButton.isEnabled = false
        
        enterEditMode()
        
        return note
    }
    func editNote()
    {
        enterEditMode()
    }
    func deleteNote(_ at:Int)
    {
        hideKeyBoard()
        NoteManager.instance.deleteNoteAtStroke(at)
        
        selectedPath = nil
        noteListTableView.reloadData()
        
        onProgressValueChanged(replayProgressBar.progress,strokeID: at)
        
    }
    fileprivate func enterEditMode()
    {
        appState = AppState.editNote
        noteDescriptionTextView.isEditable = true
        noteTitleField.editable = true
    }
    
    func editNoteDone()
    {
        if appState == .editNote
        {
            noteDescriptionTextView.isEditable = false
            noteTitleField.editable = false
            
            NoteManager.instance.updateNote(NoteManager.instance.selectedButtonIndex, title: noteTitleField.text!, description: noteDescriptionTextView.text)
            
            appState = lastAppState
            
        }
        
        
    }
}
