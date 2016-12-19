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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    // cell num in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //self.collectionView = collectionView
        return 10
    }
    //get cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lessonCell", for: indexPath)
        
        return cell
    }
    
    //select cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lessonDetailVC = splitViewController?.viewControllers.last as!LessonMenuDetailViewController
        
    }
    @IBAction func exitLesson(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion:nil)
        print("exit")
    }
    
    
    @IBAction func startLessonButtonTouched(_ sender: UIButton) {
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
