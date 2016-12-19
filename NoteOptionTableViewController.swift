//
//  NoteOptionTableViewController.swift
//  SwiftGL
//
//  Created by jerry on 2016/2/19.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//
import UIKit
enum NoteOptionAction{
    case drawRevision
    case none
}
class NoteOptionTableViewController: UITableViewController {
    weak var delegate:PaintViewController!
    override func viewWillAppear(_ animated: Bool) {
        view.layer.cornerRadius = 0
    }
    
    @IBOutlet weak var enterRevisionModeButton: UITableViewCell!
    
    var action:NoteOptionAction = .none
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) ==
        enterRevisionModeButton
        {
            //delegate. 
            action = .drawRevision
            dismiss(animated: true, completion: {})
            delegate.noteOptionDrawRevisionTouched()
        }
        
    }
}
