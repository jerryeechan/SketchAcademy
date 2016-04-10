//
//  ArtworkMenuViewController.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/2.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import UIKit
class ArtworkMenuViewController: UIViewController,UICollectionViewDelegate{
    
    @IBOutlet weak var showView: UIView!
    weak var delegate:PaintViewController!
    
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
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
            
            return cell
        }
        else if (indexPath.row == 1)
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("tutorialCollectionCell", forIndexPath: indexPath)
            
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("artworkfilecell", forIndexPath: indexPath) as! ArtworkCollectionViewCell
            
            //cell.backgroundColor = UIColor.blackColor()
            let fName = FileManager.instance.getFileName(indexPath.row-1)
            if fName != ".paw"
            {
                print(fName)
                cell.titleField.text = fName
                cell.actionButton.tag = indexPath.row-1
                cell.imageView.image = FileManager.instance.loadImg(fName)
            }
            
            
            return cell
            // Configure the cell
        }
        
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let paintViewController = getViewController("paintview") as! PaintViewController
        
        if(indexPath.row == 0)
        {
            //let cell = collectionView.cellForItemAtIndexPath(indexPath)
            PaintViewController.appMode = ApplicationMode.ArtWorkCreation
            self.navigationController?.pushViewController(paintViewController, animated: false)
            
        }
        else if indexPath.row == 1
        {
            PaintViewController.appMode = ApplicationMode.CreateTutorial
            self.navigationController?.pushViewController(paintViewController, animated: false)
            
        }
        else
        {
            let fileName = FileManager.instance.getFileName(indexPath.row-1)
            paintViewController.fileName = fileName
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ArtworkCollectionViewCell
            PaintViewController.appMode = ApplicationMode.ArtWorkCreation
            //cell.imageView.alpha = 0.5
            let imageView = cell.imageView
            //the relative frame to window 
            //notice: use superview to convert the view
            let frame = imageView.superview!.convertRect(imageView.frame, toView: nil)
            
            let top = UIView(frame: CGRect(origin: CGPoint(x:0,y: 0), size: view.frame.size))
            
            view.window?.addSubview(top)
            let newImage = UIImageView(image: imageView.image)
            top.addSubview(newImage)
            newImage.frame = frame//CGRect(origin: CGPoint(x:x,y: y), size: imageView.frame.size)
            //imageView.removeFromSuperview()
            //showView.addSubview(imageView)
            //imageView.frame = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 1366,height: 1024))
            
            //view.addSubview(imageView)
            
            //imageView.frame = CGRect(origin: CGPoint(x: x,y: y), size: imageView.frame.size)
            
            UIView.animateWithDuration(0.5, animations: {
                newImage.frame = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 1366,height: 1024))
                }, completion: {(value:Bool) in
                top.removeFromSuperview()
                self.navigationController?.pushViewController(paintViewController, animated: false)
            })
            
            
            
        }
        
        //
        
        //self.collectionView(collectionView, didDeselectItemAtIndexPath: indexPath)
        
        
        
        
    }
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row<=1)
        {
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell?.alpha = 0.5
        }
        else
        {
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ArtworkCollectionViewCell
            cell.imageView.alpha = 0.5
        }
        
    }
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row<=1)
        {
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell?.alpha = 1
        }
        else
        {
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ArtworkCollectionViewCell
            cell.imageView.alpha = 1
        }
    }
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row<=1)
        {
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell?.alpha = 1
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
        
        
        DLog("\(sender.superview)")
        DLog("\(sender.superview?.superview)")
        let cell = sender.superview?.superview as! ArtworkCollectionViewCell
        
        selectedIndexPath = collectionView?.indexPathForCell(cell)
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        
        //selectIndex = sender.tag
        artworkActionView.frame = CGRectMake(8, 8, artworkActionView.frame.width, artworkActionView.frame.height)
        //artworkActionView.frame.y = 8
        alertController.view.addSubview(artworkActionView)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(alert: UIAlertAction) in print("cancel", terminator: "")})
        
        //alertController.addAction(somethingAction)
        alertController.addAction(cancelAction)
        
        navigationController!.presentViewController(alertController, animated: true, completion:{})
    }
    
    @IBAction func copyButtonTouched(sender: UIButton) {
        let fileName = FileManager.instance.getFileName(selectedIndexPath.row-1)
        FileManager.instance.copyFile(fileName)
        FileManager.instance.searchFiles()
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
        self.collectionView?.reloadData()
        
        
    }
    //var selectIndex:Int!
    @IBAction func reviseButtonTouched(sender: UIButton) {
        
        let paintViewController = getViewController("paintview") as! PaintViewController
        let fileName = FileManager.instance.getFileName(selectedIndexPath.row-1)
        paintViewController.fileName = fileName
        PaintViewController.appMode = ApplicationMode.InstructionTutorial
        
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
        navigationController?.pushViewController(paintViewController, animated: true)

    }
    @IBAction func deleteButtonTouched(sender: UIButton) {
        
        
        
        let alertController = UIAlertController(title: "Delete", message: "Are you sure to delete?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(alert: UIAlertAction) in print("cancel", terminator: "")})
        
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: {(alert: UIAlertAction) in print("delete", terminator: "")
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
    
    
    @IBOutlet weak var paintButton: UIButton!
    
    @IBOutlet weak var reviseButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paintButton.setImage(UIImage(named: "Brush-50"), forState: UIControlState.Normal)
        paintButton.tintColor = UIColor.redColor()
        
        /*
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        */
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        //self.navigationController?.navigationBar.tintColor = .themeColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

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
        
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}