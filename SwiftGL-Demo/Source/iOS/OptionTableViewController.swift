//
//  OptionTableViewController.swift
//  SwiftGL
//
//  Created by jerry on 2016/5/8.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

class OptionTableViewController: UITableViewController {
    
    @IBOutlet weak var shareGIFTableCell: UITableViewCell!
    @IBOutlet weak var enterSelectStrokeModeCell: UITableViewCell!
    weak var delegate:PaintViewController!
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch tableView.cellForRowAtIndexPath(indexPath)! {
        case shareGIFTableCell:
            dismissViewControllerAnimated(true, completion: {})
            delegate.exportGIF()
        case enterSelectStrokeModeCell:
            dismissViewControllerAnimated(true, completion: {})
            delegate.enterSelectStrokeMode()
        default:
            break
        }
            
        
    }
}
