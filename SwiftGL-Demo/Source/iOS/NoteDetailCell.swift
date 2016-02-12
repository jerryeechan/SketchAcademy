//
//  NoteDetailCell.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/4.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//
import UIKit
import SwiftGL
class NoteDetailCell:UITableViewCell{
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var iconButton: UIButton!
    
    @IBOutlet weak var titleEditTextField: UITextField!
    
    
    
    var strokeID:Int!
    var isEditing:Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        textView.layer.cornerRadius = 2
        isEditing = false
        titleEditTextField.hidden = true
    }
    
    
    

    @IBAction func editButtonTouched(sender: UIButton) {
        let note = NoteManager.instance.getNoteAtStroke(strokeID)
        //enter editing mode
        if isEditing == false
        {
            
            textView.editable = true
            textView.layer.borderWidth = 1
            titleEditTextField.hidden = false
            titleEditTextField.text = note.title
            editButton.setImage(UIImage(named: "Pen-50"), forState: UIControlState.Normal)
        }
        else
        {
            textView.editable = false
            textView.layer.borderWidth = 0
            titleEditTextField.hidden = true
            NoteManager.instance.updateNote(strokeID, title: titleEditTextField.text!, description: textView.text)
            title.text = titleEditTextField.text!
            editButton.setImage(UIImage(named: "write"), forState: UIControlState.Normal)
        }
        isEditing = !isEditing
        
    }
    
}
