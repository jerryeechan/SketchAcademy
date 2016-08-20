//
//  OptionTableViewController.swift
//  SwiftGL
//
//  Created by jerry on 2016/5/8.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

class OptionTableViewController: UITableViewController {
    
    @IBOutlet weak var visualizeDataCell: UITableViewCell!
    @IBOutlet weak var shareGIFTableCell: UITableViewCell!
    @IBOutlet weak var enterSelectStrokeModeCell: UITableViewCell!
    weak var delegate:PaintViewController!
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        dismissViewControllerAnimated(true, completion: {})
        
        switch tableView.cellForRowAtIndexPath(indexPath)! {
        case shareGIFTableCell:
            delegate.exportGIF()
        case enterSelectStrokeModeCell:
            delegate.enterSelectStrokeMode()
        case visualizeDataCell:
            let visualizationController = getViewController("visualizeView") as! VisualizationViewController
            visualizationController.delegate = delegate
            delegate.navigationController?.pushViewController(visualizationController, animated: true)
        default:
            break
        }
            
        
    }
}
