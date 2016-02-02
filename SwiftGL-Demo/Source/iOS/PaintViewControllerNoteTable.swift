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
        if paintManager.artwork.revisionClips[note.value.strokeIndex] != nil
        {
            cell.iconButton.setImage(UIImage(named: "Pen-50.png"), forState: UIControlState.Normal)
        }
        else
        {
            cell.iconButton.setImage(UIImage(named: "bubble-chat"), forState: UIControlState.Normal)
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
        if paintManager.artwork.revisionClips[note.value.strokeIndex] != nil
        {
            cell.iconButton.setImage(UIImage(named: "Play-50"), forState: UIControlState.Normal)
        }
        else
        {
            cell.iconButton.setImage(UIImage(named: "bubble-chat"), forState: UIControlState.Normal)
        }
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
    
    

    
    func clickOnRow(indexPath:NSIndexPath)
    {
        if appState == .viewRevision
        {
            return
        }

        //什麼都還沒選
        if(selectedPath == nil)
        {
            selectRow(indexPath)
        }
            //選到自己, deselect
        else if(indexPath.row == selectedPath.row)
        {
            selectedPath = nil
            noteListTableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
            //選到別人, select and deselect
        else
        {
            selectRow(indexPath)
        }
    }
    
    func selectRow(indexPath:NSIndexPath)
    {
        print(appState)
        if appState == .viewRevision
        {
            return
        }
        let note = NoteManager.instance.getOrderedNote(indexPath.row)
        var paths:[NSIndexPath] = [indexPath]
        if(selectedPath != nil)
        {
            if selectedPath == indexPath
            {
                //select the same one, do nothing
                if isCellSelectedSentbySlider
                {
                    print("sent by slider")
                    isCellSelectedSentbySlider = false
                }
                return
            }
            
            //add the selectedPaht to deselect it
            paths.append(selectedPath)
            
        }
        
        selectedPath = indexPath
        noteListTableView.reloadRowsAtIndexPaths(paths, withRowAnimation: UITableViewRowAnimation.Automatic)
        
        if appState == .drawRevision
        {
            return
        }
        if isCellSelectedSentbySlider
        {
            print("sent by slider")
            isCellSelectedSentbySlider = false
        }
        else
        {
            paintManager.drawStrokeProgress(note.value.strokeIndex)
            progressSlider.value = Float(note.value.strokeIndex)/Float(paintManager.currentReplayer.clip.strokes.count)
            
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        clickOnRow(indexPath)
                
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
    
    @IBAction func playRevisionButtonTouched(sender: UIButton) {
        let cell = sender.superview?.superview as! NoteDetailCell
        
        appState = .viewRevision
        
        ///here
        paintManager.playRevisionClip(cell.strokeID)
        dismissButton.image = UIImage(named: "close-50")
        
    }
    
    @IBAction func editNoteCellButtonTouched(sender: UIButton) {
        let cell = sender.superview?.superview as! NoteDetailCell
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
    
    
    @IBAction func addNoteButtonTouched(sender: UIBarButtonItem) {
        let at = paintManager.getMasterStrokeID()
        let note = NoteManager.instance.getNoteAtStroke(at)

            NoteManager.instance.addNote(at,title: "註解1", description: "描述")
            selectedPath = NSIndexPath(forRow: NoteManager.instance.noteCount()-1, inSection: 0)
        noteListTableView.reloadData()
        
        //*TODO*
        //add button disable, check if note exist at
        
        //var btn:UIBarButtonItem!
        //btn.enabled = false
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
        
        if appState == .drawRevision
        {
            appState = .viewRevision
        }
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
            let at = paintManager.getMasterStrokeID()
            let note = NoteManager.instance.getNoteAtStroke(at)
            if  note != nil
            {
                note.value.strokeIndex
                //if the stroke index has been occupied
                NoteManager.instance.updateNote(note.value.strokeIndex, title: noteEditTitleTextField.text!, description: noteEditTextView.text)
            }
            else
            {
                NoteManager.instance.addNote(at,title: noteEditTitleTextField.text!, description: noteEditTextView.text)
                selectedPath = NSIndexPath(forRow: NoteManager.instance.noteCount()-1, inSection: 0)
                
            }
        }
        //###go here
        switch(paintMode)
        {
        case .Artwork:
            break
        case .Revision:
            appState = .viewRevision
            paintManager.playCurrentRevisionClip()
            dismissButton.image = UIImage(named: "close-50")
            
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
