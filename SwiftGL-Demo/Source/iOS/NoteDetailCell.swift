//
//  NoteDetailCell.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/4.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//
import UIKit
class NoteDetailCell:UITableViewCell{
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var iconButton: UIButton!
    
    var strokeID:Int!
    override func awakeFromNib() {
        
    }
}
