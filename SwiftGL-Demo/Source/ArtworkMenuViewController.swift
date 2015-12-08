//
//  ArtworkMenuViewController.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/2.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import UIKit
class ArtworkMenuViewController: UIViewController,UICollectionViewDelegate{
    
    weak var delegate:PaintViewController!
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    weak var collectionView:UICollectionView?
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.delaysContentTouches = false
        self.collectionView = collectionView
        return FileManager.instance.getFileCount()+1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        
        if(indexPath.row == 0)
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("emptyCollectionCell", forIndexPath: indexPath)
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.lightGrayColor().CGColor
            
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("artworkfilecell", forIndexPath: indexPath) as! ArtworkCollectionViewCell
            
            //cell.backgroundColor = UIColor.blackColor()
            let fName = FileManager.instance.getFileName(indexPath.row-1)
            cell.actionButton.tag = indexPath.row-1
            cell.imageView.image = FileManager.instance.loadImg(fName)
            return cell
            // Configure the cell
        }
        
        
        
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let paintViewController = getViewController("paintview") as! PaintViewController
        
        if(indexPath.row == 0)
        {
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell?.backgroundColor = UIColor.lightGrayColor()
        }
        else
        {
            let fileName = FileManager.instance.getFileName(indexPath.row-1)
            paintViewController.fileName = fileName
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ArtworkCollectionViewCell
            cell.imageView.alpha = 0.5
        }
        
        //paintViewController.paintMode = .Revision
        navigationController?.pushViewController(paintViewController, animated: true)
        
        self.collectionView(collectionView, didDeselectItemAtIndexPath: indexPath)
        
        
        
        
    }
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row==0)
        {
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell?.backgroundColor = UIColor.lightGrayColor()
        }
        else
        {
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ArtworkCollectionViewCell
            cell.imageView.alpha = 0.5
        }
        
    }
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row==0)
        {
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell?.backgroundColor = UIColor.whiteColor()
        }
        else
        {
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ArtworkCollectionViewCell
            cell.imageView.alpha = 1
        }
    }
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row==0)
        {
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell?.backgroundColor = UIColor.whiteColor()
        }
        else
        {
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ArtworkCollectionViewCell
            cell.imageView.alpha = 1
        }

    }
    
    @IBOutlet var artworkActionView: UIView!
    
    var selectedIndexPath:NSIndexPath!
    @IBAction func actionButtonTouched(sender: UIButton) {
        
        let cell = sender.superview?.superview as! UICollectionViewCell
        
        selectedIndexPath = collectionView?.indexPathForCell(cell)
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        
        //selectIndex = sender.tag
        artworkActionView.frame = CGRectMake(8, 8, artworkActionView.frame.width, artworkActionView.frame.height)
        //artworkActionView.frame.y = 8
        alertController.view.addSubview(artworkActionView)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        //alertController.addAction(somethingAction)
        alertController.addAction(cancelAction)
        
        navigationController!.presentViewController(alertController, animated: true, completion:{})
    }
    
    //var selectIndex:Int!
    @IBAction func reviseButtonTouched(sender: UIButton) {
        
        let paintViewController = getViewController("paintview") as! PaintViewController
        let fileName = FileManager.instance.getFileName(selectedIndexPath.row-1)
        paintViewController.fileName = fileName
        paintViewController.paintMode = .Revision
        
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
        navigationController?.pushViewController(paintViewController, animated: true)

    }
    @IBAction func deleteButtonTouched(sender: UIButton) {
        
        
        
        let alertController = UIAlertController(title: "Delete", message: "Are you sure to delete?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: {(alert: UIAlertAction!) in print("delete")
            let fileName = FileManager.instance.getFileName(self.selectedIndexPath.row-1)
            FileManager.instance.deletePaintArtWork(fileName)
            
            self.collectionView?.performBatchUpdates({()in self.collectionView?.deleteItemsAtIndexPaths([self.selectedIndexPath])}, completion: nil)
        })

        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        //remove the action view
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
        
        navigationController!.presentViewController(alertController, animated: true, completion:{})
        
        
        
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
        collectionView!.reloadData()
    }

}


extension ArtworkMenuViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // 1
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        /*
        flickr.searchFlickrForTerm(textField.text) {
            results, error in
            
            //2
            activityIndicator.removeFromSuperview()
            if error != nil {
                println("Error searching : \(error)")
            }
            
            if results != nil {
                //3
                println("Found \(results!.searchResults.count) matching \(results!.searchTerm)")
                self.searches.insert(results!, atIndex: 0)
                
                //4
                self.collectionView?.reloadData()
            }
        }*/
        
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}