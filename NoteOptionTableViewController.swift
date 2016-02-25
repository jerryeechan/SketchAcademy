//
//  NoteOptionTableViewController.swift
//  SwiftGL
//
//  Created by jerry on 2016/2/19.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//
import UIKit
class NoteOptionTableViewController: UITableViewController {
    weak var delegate:PaintViewController!
    override func viewWillAppear(animated: Bool) {
        view.layer.cornerRadius = 0
    }
    
    @IBOutlet weak var enterRevisionModeButton: UITableViewCell!
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.cellForRowAtIndexPath(indexPath) ==
        enterRevisionModeButton
        {
            //delegate. 
            dismissViewControllerAnimated(true, completion: {})
        }
        
    }
}
