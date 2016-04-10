//
//  MenuViewController.swift
//  SwiftGL
//
//  Created by jerry on 2015/11/16.
//  Copyright © 2015年 Jerry Chan. All rights reserved.
//

import Foundation
class LearnMenuViewController:UICollectionViewController{
    
    
    
    func createFaceGameViewController()->FaceGameViewController
    {
        return self.storyboard!.instantiateViewControllerWithIdentifier("facegame") as! FaceGameViewController
        
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = createFaceGameViewController()
        switch indexPath.row {
        case 0:
            vc.levelName = FaceGameViewController.FaceGameLevelName.AngryBird
        case 1:
            vc.levelName = FaceGameViewController.FaceGameLevelName.GreenMan
        case 2:
            vc.levelName = FaceGameViewController.FaceGameLevelName.Tumbler
        default:
            vc.levelName = FaceGameViewController.FaceGameLevelName.AngryBird
        }
        
         presentViewController(vc, animated: true, completion: nil)
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        return collectionView.dequeueReusableCellWithReuseIdentifier("\(indexPath.row)", forIndexPath: indexPath)
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    
    
    
    @IBAction func lesson3BtnTouched(sender: UIButton) {
        let vc = createFaceGameViewController()
        vc.levelName = FaceGameViewController.FaceGameLevelName.Tumbler
        presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func dismissBtnTouched(sender: UIBarButtonItem) {
        
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        
    }
}