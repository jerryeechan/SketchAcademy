//
//  ArtworkMenuViewController.swift
//  SwiftGL
//
//  Created by jerry on 2015/12/2.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import UIKit
import GLFramework
class ArtworkMenuViewController: UIViewController,UICollectionViewDelegate{
    
    @IBOutlet weak var showView: UIView!
    weak var delegate:PaintViewController!
    
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    func numberOfSectionsInCollectionView(_ collectionView: UICollectionView) -> Int {
        return 1
    }
    
    weak var collectionView:UICollectionView?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.delaysContentTouches = false
        self.collectionView = collectionView
        return FileManager.instance.getFileCount()+1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        if((indexPath as NSIndexPath).row == 0)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyCollectionCell", for: indexPath)
            
            return cell
        }
        else if ((indexPath as NSIndexPath).row == 1)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tutorialCollectionCell", for: indexPath)
            
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artworkfilecell", for: indexPath) as! ArtworkCollectionViewCell
            
            //cell.backgroundColor = UIColor.blackColor()
            let fName = FileManager.instance.getFileName((indexPath as NSIndexPath).row-1)
            if fName != ".paw"
            {
                print(fName)
                cell.titleField.text = fName
                cell.actionButton.tag = (indexPath as NSIndexPath).row-1
                cell.imageView.image = FileManager.instance.loadImg(fName)
            }
            
            
            return cell
            // Configure the cell
        }
        
    }
    
    //select item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        PaintViewController.courseTitle = "creation"
        let paintViewController = getViewController("paintview") as! PaintViewController
        
        if((indexPath as NSIndexPath).row == 0)
        {
            //let cell = collectionView.cellForItemAtIndexPath(indexPath)
            PaintViewController.appMode = ApplicationMode.artWorkCreation
            self.navigationController?.pushViewController(paintViewController, animated: false)
            
        }
        else if (indexPath as NSIndexPath).row == 1
        {
            PaintViewController.appMode = ApplicationMode.createTutorial
            self.navigationController?.pushViewController(paintViewController, animated: false)
            
        }
        else
        {
            let fileName = FileManager.instance.getFileName((indexPath as NSIndexPath).row-1)
            paintViewController.fileName = fileName
            let cell = collectionView.cellForItem(at: indexPath) as! ArtworkCollectionViewCell
            PaintViewController.appMode = ApplicationMode.artWorkCreation
            //cell.imageView.alpha = 0.5
            let imageView = cell.imageView
            //the relative frame to window 
            //notice: use superview to convert the view
            let frame = imageView?.superview!.convert((imageView?.frame)!, to: nil)
            
            let top = UIView(frame: CGRect(origin: CGPoint(x:0,y: 0), size: view.frame.size))
            
            view.window?.addSubview(top)
            let newImage = UIImageView(image: imageView?.image)
            top.addSubview(newImage)
            newImage.frame = frame!//CGRect(origin: CGPoint(x:x,y: y), size: imageView.frame.size)
            //imageView.removeFromSuperview()
            //showView.addSubview(imageView)
            //imageView.frame = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 1366,height: 1024))
            
            //view.addSubview(imageView)
            
            //imageView.frame = CGRect(origin: CGPoint(x: x,y: y), size: imageView.frame.size)
            
            UIView.animate(withDuration: 0.5, animations: {
                newImage.frame = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 1366,height: 1024))
                }, completion: {(value:Bool) in
                top.removeFromSuperview()
                self.navigationController?.pushViewController(paintViewController, animated: false)
            })
            
            
            
        }
        
        //
        
        //self.collectionView(collectionView, didDeselectItemAtIndexPath: indexPath)
        
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if((indexPath as NSIndexPath).row<=1)
        {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.alpha = 0.5
        }
        else
        {
            let cell = collectionView.cellForItem(at: indexPath) as! ArtworkCollectionViewCell
            cell.imageView.alpha = 0.5
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if((indexPath as NSIndexPath).row<=1)
        {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.alpha = 1
        }
        else
        {
            let cell = collectionView.cellForItem(at: indexPath) as! ArtworkCollectionViewCell
            cell.imageView.alpha = 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if((indexPath as NSIndexPath).row<=1)
        {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.alpha = 1
        }
        else
        {
            let cell = collectionView.cellForItem(at: indexPath) as! ArtworkCollectionViewCell
            cell.imageView.alpha = 1
        }

    }
    
    @IBOutlet var artworkActionView: UIView!
    
    var selectedIndexPath:IndexPath!
    @IBAction func actionButtonTouched(_ sender: UIButton) {
        
        
        DLog("\(sender.superview)")
        DLog("\(sender.superview?.superview)")
        let cell = sender.superview?.superview as! ArtworkCollectionViewCell
        
        selectedIndexPath = collectionView?.indexPath(for: cell)
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        
        //selectIndex = sender.tag
        artworkActionView.frame = CGRect(x: 8, y: 8, width: artworkActionView.frame.width, height: artworkActionView.frame.height)
        //artworkActionView.frame.y = 8
        alertController.view.addSubview(artworkActionView)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(alert: UIAlertAction) in print("cancel", terminator: "")})
        
        //alertController.addAction(somethingAction)
        alertController.addAction(cancelAction)
        
        navigationController!.present(alertController, animated: true, completion:{})
    }
    
    @IBAction func copyButtonTouched(_ sender: UIButton) {
        let fileName = FileManager.instance.getFileName(selectedIndexPath.row-1)
        FileManager.instance.copyFile(fileName)
        FileManager.instance.searchFiles()
        navigationController?.dismiss(animated: true, completion: nil)
        self.collectionView?.reloadData()
        
        
    }
    //var selectIndex:Int!
    @IBAction func reviseButtonTouched(_ sender: UIButton) {
        
        let paintViewController = getViewController("paintview") as! PaintViewController
        let fileName = FileManager.instance.getFileName(selectedIndexPath.row-1)
        paintViewController.fileName = fileName
        //PaintViewController.appMode = ApplicationMode.instructionTutorial
        PaintViewController.appMode = ApplicationMode.practiceCalligraphy
        navigationController?.dismiss(animated: true, completion: nil)
        
        navigationController?.pushViewController(paintViewController, animated: true)

    }

    @IBAction func deleteButtonTouched(_ sender: UIButton) {
        
        
        
        let alertController = UIAlertController(title: "Delete", message: "Are you sure to delete?", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(alert: UIAlertAction) in print("cancel", terminator: "")})
        
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: {(alert: UIAlertAction) in print("delete", terminator: "")
            let fileName = FileManager.instance.getFileName(self.selectedIndexPath.row-1)
            FileManager.instance.deletePaintArtWork(fileName)
            
            self.collectionView?.performBatchUpdates({()in self.collectionView?.deleteItems(at: [self.selectedIndexPath])}, completion: nil)
        })

        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        //remove the action view
        navigationController?.dismiss(animated: true, completion: nil)
        
        
        navigationController!.present(alertController, animated: true, completion:{})
        
        
        
        
        
    }
    
    
    @IBOutlet weak var paintButton: UIButton!
    
    @IBOutlet weak var reviseButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paintButton.setImage(UIImage(named: "Brush-50"), for: UIControlState())
        paintButton.tintColor = UIColor.red
        
        /*
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        */
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        //self.navigationController?.navigationBar.tintColor = .themeColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        //self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
        collectionView!.reloadData()
    }

}


extension ArtworkMenuViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 1
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}
