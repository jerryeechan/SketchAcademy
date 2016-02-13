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
        noteDescriptionTextView.editable = false
        noteTitleField.editable = false
        noteTitleField.delegate = self
        noteDescriptionTextView.delegate = self
        noteDescriptionTextView.addGestureRecognizer(doubleTapSingleTouchGestureRecognizer)
        noteDescriptionTextView.editTapRecognizer = doubleTapSingleTouchGestureRecognizer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onKeyBoardHide:", name:
            UIKeyboardWillHideNotification, object: nil)
    }
    func onKeyBoardHide(notification:NSNotification)
    {
        editNoteDone()
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
    
     func newNote(atStroke:Int){
        
        noteTitleField.text = ""
        noteDescriptionTextView.clear()
        NoteManager.instance.addNote(atStroke,title: "", description: "")
        
        enterEditMode()
    }
    func editNote(atStroke:Int)
    {
        enterEditMode()
    }
    private func enterEditMode()
    {
        appState = AppState.editNote
        modeText.title = "編輯註解"
        noteDescriptionTextView.editable = true
        noteTitleField.editable = true
    }
    
    func editNoteDone()
    {
        if appState == .editNote
        {
            noteTitleField.resignFirstResponder()
            noteDescriptionTextView.resignFirstResponder()
            noteDescriptionTextView.editable = false
            noteTitleField.editable = false
            
            NoteManager.instance.updateNote(paintManager.getMasterStrokeID(), title: noteTitleField.text!, description: noteDescriptionTextView.text)
            DLog("\(appState) \(lastAppState)")
            appState = lastAppState
        }
        
        
    }
}
