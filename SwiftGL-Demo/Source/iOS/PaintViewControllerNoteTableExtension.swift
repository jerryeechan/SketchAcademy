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
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(selectedPath == nil)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as! NoteTableCell
            let note = NoteManager.instance.getOrderedNote(indexPath.row)
            
            cell.titleLabel.text = note.title
            return cell

        }
        else
        {
            if(indexPath.row == selectedPath.row)
            {
                print("detail cell")
                let cell = tableView.dequeueReusableCellWithIdentifier("NoteDetailCell", forIndexPath: indexPath) as! NoteDetailCell
                let note = NoteManager.instance.getOrderedNote(indexPath.row)
                cell.title.text = note.title
                cell.textView.text = note.description
                cell.strokeID = note.value.strokeIndex
                
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as! NoteTableCell
                let note = NoteManager.instance.getOrderedNote(indexPath.row)
                
                cell.titleLabel.text = note.title
                return cell
            }
        }
        
        
        
        //cell.editButton.addTarget(self, action: "editButtonTouched:", forControlEvents: .TouchUpInside)
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NoteManager.instance.noteCount()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(selectedPath == nil)
        {
            let note = NoteManager.instance.getOrderedNote(indexPath.row)
            var paths:[NSIndexPath] = [indexPath]
            if(selectedPath != nil)
            {
                paths.append(selectedPath)
            }
            
            tableView.reloadRowsAtIndexPaths(paths, withRowAnimation: UITableViewRowAnimation.Automatic)
            
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
            selectedPath = indexPath
        }
        else if(indexPath.row == selectedPath.row)
        {
            selectedPath = nil
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
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
        let cell = sender.superview as! NoteDetailCell
        NoteManager.instance.deleteNoteAtStroke(cell.strokeID)
        selectedPath = nil
        noteListTableView.reloadData()
    }
    
    
    
    
    func showNoteEditView()
    {
        paintView.layer.position = CGPointZero
        paintView.layer.anchorPoint = CGPointZero
        
        //noteEditTextView.text = ""
        //noteEditTitleTextField.text = ""
        UIView.animateWithDuration(0.5, animations: {
            let transform = CATransform3DMakeScale(0.5, 0.5, 1)
            self.paintView.layer.transform = transform
            
            //self.noteEditView.center.y = self.noteEditViewOriginCenter.y
            //self.noteEditViewTopConstraint.constant = 0
            //self.noteEditView.layoutIfNeeded()
            
        })
        noteEditViewState.animateShow(0.5)
        noteEditTextView.becomeFirstResponder()
        
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
            let at = PaintManager.instance.getCurrentStrokeID()
            NoteManager.instance.addNote(at,title: noteEditTitleTextField.text!, description: noteEditTextView.text
            )
        }
        noteListTableView.reloadData()
        view.endEditing(true)
    }
    
    @IBAction func noteEditViewCancelButtonTouched(sender: UIBarButtonItem) {
        hideNoteEditView()
        view.endEditing(true)
    }

    
    
    
}
