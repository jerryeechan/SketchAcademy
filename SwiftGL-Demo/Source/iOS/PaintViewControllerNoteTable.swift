//
//  PaintViewControllerNoteTableExtension.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/4.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

extension PaintViewController:UITableViewDelegate
{
    //tableViewStart
    func genNoteCell(tableView: UITableView,indexPath:NSIndexPath)->UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as! NoteTableCell
        let note = NoteManager.instance.getOrderedNote(indexPath.row)
        if PaintManager.instance.artwork.revisionClips[note.value.strokeIndex] != nil
        {
            cell.reviseButton.setImage(UIImage(named: "fountain-pen-head-1.png"), forState: UIControlState.Normal)
        }
        
        cell.titleLabel.text = note.title
        return cell
    }
    func genNoteDetailCell(tableView: UITableView,indexPath:NSIndexPath)->UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("NoteDetailCell", forIndexPath: indexPath) as! NoteDetailCell
        let note = NoteManager.instance.getOrderedNote(indexPath.row)
        cell.title.text = note.title
        cell.textView.text = note.description
        cell.strokeID = note.value.strokeIndex
        
        return cell
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(selectedPath == nil)
        {
            return genNoteCell(tableView, indexPath: indexPath)
        }
        else
        {
            if(indexPath.row == selectedPath.row)
            {
                return genNoteDetailCell(tableView, indexPath: indexPath)
            }
            else
            {
                return genNoteCell(tableView, indexPath: indexPath)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NoteManager.instance.noteCount()
    }
    
    
    func selectRow(indexPath:NSIndexPath)
    {
        let note = NoteManager.instance.getOrderedNote(indexPath.row)
        var paths:[NSIndexPath] = [indexPath]
        if(selectedPath != nil)
        {
            paths.append(selectedPath)
        }
        selectedPath = indexPath
        noteListTableView.reloadRowsAtIndexPaths(paths, withRowAnimation: UITableViewRowAnimation.Automatic)
        
        if isCellSelectedSentbySlider
        {
            print("sent by slider")
            isCellSelectedSentbySlider = false
        }
        else
        {
            PaintManager.instance.drawStrokeProgress(note.value.strokeIndex)
            progressSlider.value = Float(note.value.strokeIndex)/Float(PaintManager.instance.currentReplayer.clip.strokes.count)
            
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //什麼都還沒選
        if(selectedPath == nil)
        {
            selectRow(indexPath)
        }
        //選到自己, deselect
        else if(indexPath.row == selectedPath.row)
        {
            selectedPath = nil
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
        //選到別人, select and deselect
        else
        {
            selectRow(indexPath)
        }
                
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(selectedPath == nil)
        {
            return 44
        }
        else
        {
            if(indexPath.row == selectedPath.row)
            {
                return 240
            }
            else
            {
                return 44
            }
        }
        
    }
    
    @IBAction func editNoteCellButtonTouched(sender: UIButton) {
        let cell = sender.superview as! NoteDetailCell
        let note = NoteManager.instance.getNoteAtStroke(cell.strokeID)
        showNoteEditView()
        noteEditTitleTextField.text = note.title
        noteEditTextView.text = note.description
        NoteManager.instance.editingNoteIndex = cell.strokeID
        noteEditMode = .Edit
    }
    
    @IBAction func deleteNoteCellButtonTouched(sender: UIButton) {
        let cell = sender.superview?.superview as! NoteDetailCell
        NoteManager.instance.deleteNoteAtStroke(cell.strokeID)
        selectedPath = nil
        noteListTableView.reloadData()
    }
    
    
    
    
    func showNoteEditView()
    {
        paintView.layer.position = CGPointZero
        paintView.layer.anchorPoint = CGPointZero
        
        UIView.animateWithDuration(0.5, animations: {
            let transform = CATransform3DMakeScale(0.5, 0.5, 1)
            self.paintView.layer.transform = transform
            
            //self.noteEditView.center.y = self.noteEditViewOriginCenter.y
            //self.noteEditViewTopConstraint.constant = 0
            //self.noteEditView.layoutIfNeeded()
            
        })
        noteEditViewState.animateShow(0.5)
        noteEditTitleTextField.becomeFirstResponder()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onKeyBoardHide:", name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func hideNoteEditView()
    {
        UIView.animateWithDuration(0.5, animations: {
            let transform = CATransform3DMakeScale(1, 1, 1)
            //transform = CATransform3DTranslate(transform,-512, -384, 0)
            self.paintView.layer.transform = transform
            
            //self.noteEditView.center.y = self.noteEditViewOriginCenter.y
            self.noteEditViewTopConstraint.constant = -384
            self.noteEditView.layoutIfNeeded()
            
        })
    }

    @IBAction func noteEditViewCompleteButtonTouched(sender: AnyObject) {
        hideNoteEditView()
        
        switch(noteEditMode)
        {
        case NoteEditMode.Edit:
            NoteManager.instance.updateOrderedNote(selectedPath.row, title: noteEditTitleTextField.text!,description: noteEditTextView.text)
        case NoteEditMode.New:
            print("New Note")
            let at = PaintManager.instance.getCurrentStrokeID()
            NoteManager.instance.addNote(at,title: noteEditTitleTextField.text!, description: noteEditTextView.text
            )
        }
        //###go here
        switch(paintMode)
        {
        case .Artwork:
            break
        case .Revision:
            PaintManager.instance.playCurrentRevisionClip()
            break
            
        }
        
        noteListTableView.reloadData()
        view.endEditing(true)
    }
    
    @IBAction func noteEditViewCancelButtonTouched(sender: UIBarButtonItem) {
        hideNoteEditView()
        view.endEditing(true)
    }

    
    
    
}
