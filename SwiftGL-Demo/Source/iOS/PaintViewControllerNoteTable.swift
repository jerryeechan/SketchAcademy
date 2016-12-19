//
//  PaintViewControllerNoteTableExtension.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/4.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

extension PaintViewController:UITableViewDelegate,UITableViewDataSource
{
    
    
    //tableViewStart
    func genNoteCell(_ tableView: UITableView,indexPath:IndexPath)->UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableCell
        let note = NoteManager.instance.getOrderedNote((indexPath as NSIndexPath).row)
        
        if paintManager.artwork.revisionClips[(note?.value.strokeIndex)!] != nil
        {
            cell.iconButton.setImage(UIImage(named: "Pen-50.png"), for: UIControlState())
        }
        else
        {
            cell.iconButton.setImage(UIImage(named: "bubble-chat"), for: UIControlState())
        }
        cell.titleLabel.text = note?.title
        return cell
    }
    func genNoteDetailCell(_ tableView: UITableView,indexPath:IndexPath)->UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteDetailCell", for: indexPath) as! NoteDetailCell
        
        let note = NoteManager.instance.getOrderedNote((indexPath as NSIndexPath).row)
        cell.title.text = note?.title
        cell.textView.text = note?.description
        cell.strokeID = note?.value.strokeIndex
        if paintManager.artwork.revisionClips[(note?.value.strokeIndex)!] != nil
        {
            cell.iconButton.setImage(UIImage(named: "Play-50"), for: UIControlState())
        }
        else
        {
            cell.iconButton.setImage(UIImage(named: "bubble-chat"), for: UIControlState())
        }
        return cell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if(selectedPath == nil)
        {
            return genNoteCell(tableView, indexPath: indexPath)
        }
        else
        {
            if((indexPath as NSIndexPath).row == selectedPath.row)
            {
                return genNoteDetailCell(tableView, indexPath: indexPath)
            }
            else
            {
                return genNoteCell(tableView, indexPath: indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NoteManager.instance.noteCount
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (selectedPath != nil)
        {
           if indexPath == selectedPath
           {
            return true
            }
        }
        
        return false
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete)
        {
            let cell = tableView.cellForRow(at: indexPath) as! NoteDetailCell
            deleteNote(cell.strokeID)
            /*
            NoteManager.instance.deleteNoteAtStroke(cell.strokeID)
            selectedPath = nil
            noteListTableView.reloadData()
            */
        }
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func clickOnRow(_ indexPath:IndexPath)
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
        else if((indexPath as NSIndexPath).row == selectedPath.row)
        {
            selectedPath = nil
            noteListTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
            //選到別人, select and deselect
        else
        {
            selectRow(indexPath)
        }
    }
    
    func selectRow(_ indexPath:IndexPath)
    {
        if appState == .viewRevision
        {
            return
        }
        let note = NoteManager.instance.getOrderedNote((indexPath as NSIndexPath).row)
        var paths:[IndexPath] = [indexPath]
        if(selectedPath != nil)
        {
            if selectedPath == indexPath
            {
                //select the same one, do nothing
                if isCellSelectedSentbySlider
                {
                    isCellSelectedSentbySlider = false
                }
                return
            }
            
            //add the selectedPaht to deselect it
            paths.append(selectedPath)
            
        }
        
        selectedPath = indexPath
        noteListTableView.reloadRows(at: paths, with: UITableViewRowAnimation.automatic)
        
        if appState == .drawRevision
        {
            return
        }
        if isCellSelectedSentbySlider
        {
            print("sent by slider", terminator: "")
            isCellSelectedSentbySlider = false
        }
        else
        {
            paintManager.drawStrokeProgress((note?.value.strokeIndex)!)
            //progressSlider.value = Float(note.value.strokeIndex)/Float(paintManager.currentReplayer.clip.strokes.count)
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickOnRow(indexPath)
                
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(selectedPath == nil)
        {
            return 44
        }
        else
        {
            if((indexPath as NSIndexPath).row == selectedPath.row)
            {
                return 240
            }
            else
            {
                return 44
            }
        }
        
    }
    
    @IBAction func playRevisionButtonTouched(_ sender: UIButton) {
        let cell = sender.superview?.superview as! NoteDetailCell
        
        appState = .viewRevision
        
        ///here
        paintManager.playRevisionClip(cell.strokeID)
        dismissButton.image = UIImage(named: "close-50")
        
    }
    
    @IBAction func editNoteCellButtonTouched(_ sender: UIButton) {
        let cell = sender.superview?.superview as! NoteDetailCell
        let note = NoteManager.instance.getNoteAtStroke(cell.strokeID)
        /*
        showNoteEditView()
        noteEditTitleTextField.text = note.title
        noteEditTextView.text = note.description
        */
        NoteManager.instance.editingNoteIndex = cell.strokeID
        noteEditMode = .edit
    }
    
    @IBAction func deleteNoteCellButtonTouched(_ sender: UIButton) {
       
    }
    
    
    
    
    
    func showNoteEditView()
    {
        paintView.layer.position = CGPoint.zero
        paintView.layer.anchorPoint = CGPoint.zero
        
        UIView.animate(withDuration: 0.5, animations: {
            let transform = CATransform3DMakeScale(0.5, 0.5, 1)
            self.paintView.layer.transform = transform
            
            //self.noteEditView.center.y = self.noteEditViewOriginCenter.y
            //self.noteEditViewTopConstraint.constant = 0
            //self.noteEditView.layoutIfNeeded()
            
        })
        noteEditViewState.animateShow(0.5)
        noteEditTitleTextField.becomeFirstResponder()
        
        
        if appState == .drawRevision
        {
            appState = .viewRevision
        }
    }
    
    
    func hideNoteEditView()
    {
        UIView.animate(withDuration: 0.5, animations: {
            let transform = CATransform3DMakeScale(1, 1, 1)
            //transform = CATransform3DTranslate(transform,-512, -384, 0)
            self.paintView.layer.transform = transform
            
            //self.noteEditView.center.y = self.noteEditViewOriginCenter.y
            self.noteEditViewTopConstraint.constant = -384
            self.noteEditView.layoutIfNeeded()
            
        })
    }

    @IBAction func noteEditViewCompleteButtonTouched(_ sender: AnyObject) {
        hideNoteEditView()
        
        switch(noteEditMode)
        {
        case NoteEditMode.edit:
            NoteManager.instance.updateOrderedNote(selectedPath.row, title: noteEditTitleTextField.text!,description: noteEditTextView.text)
        case NoteEditMode.new:
            print("New Note", terminator: "")
            let at = paintManager.getCurrentStrokeID()
            let note = NoteManager.instance.getNoteAtStroke(at)
            if  note != nil
            {
                note?.value.strokeIndex
                //if the stroke index has been occupied
                NoteManager.instance.updateNote((note?.value.strokeIndex)!, title: noteEditTitleTextField.text!, description: noteEditTextView.text)
            }
            else
            {
                NoteManager.instance.addNote(at,title: noteEditTitleTextField.text!, description: noteEditTextView.text)
                selectedPath = IndexPath(row: NoteManager.instance.noteCount-1, section: 0)
                
            }
        }
        //###go here
        /*
        switch(paintMode)
        {
        case .Artwork:
            break
        case .Revision:
            appState = .viewRevision
            paintManager.playCurrentRevisionClip()
            dismissButton.image = UIImage(named: "close-50")
            
            break
            
        }*/
        
        noteListTableView.reloadData()
        view.endEditing(true)
    }
    
    @IBAction func noteEditViewCancelButtonTouched(_ sender: UIBarButtonItem) {
        hideNoteEditView()
        view.endEditing(true)
    }

    
    
    
}
