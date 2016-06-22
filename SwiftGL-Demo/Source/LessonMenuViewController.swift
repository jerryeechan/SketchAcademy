//
//  LessonMenuViewController.swift
//  SwiftGL
//
//  Created by jerry on 2016/4/28.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import UIKit
class LessonMenuViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource
{
    /*
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
     
    }*/
    
    //number of section
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    // cell num in section
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //self.collectionView = collectionView
        return 10
    }
    //get cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("lessonCell", forIndexPath: indexPath)
        
        return cell
    }
    
    //select cell
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let lessonDetailVC = splitViewController?.viewControllers.last as!LessonMenuDetailViewController
        
    }
    @IBAction func exitLesson(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion:nil)
        print("exit")
    }
    
    
    @IBAction func startLessonButtonTouched(sender: UIButton) {
        print("...")
        /*
        PaintViewController.courseTitle = "upsidedown"
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let rootViewController =
        appdelegate.window?.rootViewController
        
        print(rootViewController)
        rootViewController?.showViewController(getViewController("paintView"), sender: nil)
 */
    }

}
