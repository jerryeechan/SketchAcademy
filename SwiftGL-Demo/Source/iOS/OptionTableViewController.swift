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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismiss(animated: true, completion: {})
        
        switch tableView.cellForRow(at: indexPath)! {
        case shareGIFTableCell:
            delegate.exportGIF()
        case enterSelectStrokeModeCell:
            delegate.enterSelectStrokeMode()
        case visualizeDataCell:
            /*
            let visualizationController = getViewController("visualizeView") as! VisualizationViewController
            visualizationController.delete = delegate
            delegate.navigationController?.pushViewController(visualizationController, animated: true)
 */
            break
        default:
            break
        }
            
        
    }
}
