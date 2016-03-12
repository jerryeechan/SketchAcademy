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
    override func viewWillAppear(animated: Bool) {
        view.layer.cornerRadius = 0
    }
    
    @IBOutlet weak var enterRevisionModeButton: UITableViewCell!
    
    var action:NoteOptionAction = .none
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.cellForRowAtIndexPath(indexPath) ==
        enterRevisionModeButton
        {
            //delegate. 
            action = .drawRevision
            dismissViewControllerAnimated(true, completion: {})
            delegate.noteOptionDrawRevisionTouched()
        }
        
    }
}
