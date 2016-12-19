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
    var is_editing:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 2
        isEditing = false
        titleEditTextField.isHidden = true
    }
    
    
    

    @IBAction func editButtonTouched(_ sender: UIButton) {
        let note = NoteManager.instance.getNoteAtStroke(strokeID)
        //enter editing mode
        if is_editing == false
        {
            
            textView.isEditable = true
            textView.layer.borderWidth = 1
            titleEditTextField.isHidden = false
            titleEditTextField.text = note?.title
            editButton.setImage(UIImage(named: "Pen-50"), for: UIControlState())
        }
        else
        {
            textView.isEditable = false
            textView.layer.borderWidth = 0
            titleEditTextField.isHidden = true
            NoteManager.instance.updateNote(strokeID, title: titleEditTextField.text!, description: textView.text)
            title.text = titleEditTextField.text!
            editButton.setImage(UIImage(named: "write"), for: UIControlState())
        }
        is_editing = !is_editing
        
    }
    
}
